from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import *

from forms import FreelancerProfileForm, JobApplication
from jobs import *

from utils import *

freelancer = Blueprint(
    'freelancer',
    __name__,
    url_prefix='/freelancer',
    template_folder='templates'
)


@freelancer.route('/')
@freelancer.route('/index')
@freelancer.route('/home')
def index():
    if g.user:
        jobs_template = get_jobs_template()
        flash(f"Welcome back, {g.user['first_name'].capitalize()}!", 'success')
        return render_template('freelancer/index.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


def get_freelancer(user_id):
    cursor = get_db_cursor()
    print(g.user['role'])
    cursor.execute(
        """
        select * from get_freelancer(user_id_p := %s);
        """,
        (user_id,)
    )
    user = cursor.fetchone()
    close_cursor(cursor)
    close_db()
    return user


@freelancer.before_request
def load_logged_in_user():
    if 'cursor' in g:
        close_cursor(g.cursor)
    close_db()

    user_id = session.get('user_id')
    if user_id is None:
        g.user = None
    else:
        g.user = {'role': 'freelancer'}
        g.user = get_freelancer(user_id)
        g.cursor = get_db_cursor()


# @freelancer.route('/search', methods=['GET'])
# def search():
#     try:
#         g.cursor.execute(
#             'SELECT * FROM new_job INNER JOIN customer AS c on new_job.customer_id = c.id'
#         )
#         new_jobs = g.cursor.fetchall()
#     except Exception as exc:
#         pass
#
#     print("new_jobs: ", new_jobs)
#     return render_template('freelancer/jobs.html', jobs=new_jobs)


@freelancer.route('/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    if g.user:
        form = FreelancerProfileForm()

        if form.validate_on_submit():
            first_name = form.first_name.data.lower()
            last_name = form.last_name.data.lower()
            resume_link = form.resume_link.data
            specialization = form.specialization.data

            try:
                g.cursor.execute(
                    """
                    select * from edit_freelancer(fr_id_p := %s,
                                                  first_name_p := %s,
                                                  last_name_p := %s,
                                                  resume_link_p := %s,
                                                  specialization_p := %s);
                    """,
                    (g.user['freelancer_id'], first_name, last_name, resume_link, specialization)
                )
                g.db_conn.commit()
            except Exception as e:
                flash(str(e), 'danger')
            else:
                load_logged_in_user()

        return render_template('freelancer/profile.html', form=form, profile=g.user)

    return redirect(url_for('auth.login'))


def is_application_exist(job_id, fr_id):
    g.cursor.execute(
        """
        SELECT * FROM is_application_exist(%s, %s);
        """,
        (job_id, fr_id)
    )
    exist = g.cursor.fetchone()['is_application_exist']
    return exist


def get_application(job_id, fr_id):
    g.cursor.execute(
        """
        SELECT * FROM get_application( job_id_p := %s, fr_id_p := %s) ;
        """,
        (job_id, fr_id)
    )
    application = g.cursor.fetchone()
    if application:
        application['price'] = psql_money_to_dec(application['price'])

    return application


@freelancer.route('/apply_job/<int:job_id>', methods=['GET', 'POST'])
def apply_job(job_id):
    if g.user:
        form = JobApplication()
        fr_id = g.user['freelancer_id']

        job_template = get_job_template(job_id)
        load_logged_in_user()
        application = get_application(job_id, fr_id)

        if request.method == 'POST':
            if request.form['submit'] == 'Remove application' and application:
                try:
                    g.cursor.execute(
                        """
                        select * from remove_job_application_by_freelancer(%s, %s) ;
                        """,
                        (job_id, fr_id)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(crop_psql_error(str(e)), 'danger')

            application = None

            if request.form['submit'] == 'Apply':
                description = form.description.data
                price = float(form.price.data)

                try:
                    g.cursor.execute(
                        """
                        select * from apply_for_job_by_freelancer(%s, %s, %s, %s) ;
                        """,
                        (job_id, fr_id, price, description)
                    )
                    g.db_conn.commit()
                    print("After insertion into application")
                except Exception as e:
                    print(str(e))
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    application = get_application(job_id, fr_id)
                    load_logged_in_user()
                    job_template = get_job_template(job_id)

        return render_template('freelancer/job_application.html',
                               job_template=job_template,
                               form=form,
                               application=application)

    return redirect(url_for('freelancer.home'))


def get_applied_jobs_template(fr_id):
    g.cursor.execute(
        """
        SELECT * FROM get_applied_jobs(%s);
        """,
        (fr_id,)
    )
    jobs = g.cursor.fetchall()

    for job in jobs:
        job['price'] = psql_money_to_dec(job['price'])

    return render_template('freelancer/jobs.html', jobs=jobs)


@freelancer.route('/applications', methods=['GET'])
def get_applied_jobs():
    if g.user:
        jobs_template = get_applied_jobs_template(g.user['freelancer_id'])
        return render_template('freelancer/applications.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


def get_job_freelancer_is_working_on(fr_id):
    g.cursor.execute(
        """
        SELECT * FROM get_job_freelancer_working_on(%s) ;
        """,
        (fr_id,)
    )
    curr_job = g.cursor.fetchone()
    if curr_job:
        curr_job['job_price'] = psql_money_to_dec(curr_job['job_price'])
        curr_job['app_price'] = psql_money_to_dec(curr_job['app_price'])

    return curr_job


@freelancer.route('/curr_job_in_progress', methods=['GET', 'POST'])
def get_curr_job_in_progress():
    if g.user:
        curr_job = get_job_freelancer_is_working_on(g.user['freelancer_id'])

        if request.method == 'POST':

            if request.form['submit'] == 'Start job':
                try:
                    g.cursor.execute(
                        """
                        select * from start_doing_job_by_freelancer(%s) ;
                        """,
                        (g.user['freelancer_id'],)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    print(str(e))
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    flash("You started doing this job!", 'success')

            elif request.form['submit'] == 'Finish job':
                try:
                    print("before finish_doung_job_by_freelancer execution")
                    g.cursor.execute(
                        """
                        select * from finish_doing_job_by_freelancer(%s);
                        """,
                        (g.user['freelancer_id'],)
                    )
                    print("after exec")
                    g.db_conn.commit()
                    print("after commit")
                except Exception as e:
                    print(f"Exception: {str(e)}")
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    flash(f"Congrats! You finished this job!", 'success')
                    curr_job['job_status'] = 'finished'
                    return render_template('freelancer/job_in_progress.html', curr_job=curr_job)

            elif request.form['submit'] == 'Leave job':
                try:
                    print("try to leave job")
                    g.cursor.execute(
                        """
                        select * from leave_job_by_freelancer(%s);
                        """,
                        (g.user['freelancer_id'],)
                    )
                    g.db_conn.commit()
                    print("job leaved. ok.")
                    attempts_to_leave_left = g.cursor.fetchone()
                except Exception as e:
                    print(str(e))
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    flash(f"You leaved this job. You can leave {attempts_to_leave_left[0]} times before get blocked!",
                          'warning')
                    curr_job['job_status'] = 'unfinished'
                    return render_template('freelancer/job_in_progress.html', curr_job=curr_job)

            curr_job = get_job_freelancer_is_working_on(g.user['freelancer_id'])

        return render_template('freelancer/job_in_progress.html', curr_job=curr_job)
    return redirect(url_for('auth.login'))


def get_freelancer_unfinished_jobs(fr_id):
    g.cursor.execute(
        """
        select * from get_freelancer_unfinished_jobs(%s);
        """,
        (fr_id,)
    )
    unfinished_jobs = g.cursor.fetchall()

    for job in unfinished_jobs:
        job['job_price'] = psql_money_to_dec(job['job_price'])
        job['app_price'] = psql_money_to_dec(job['app_price'])
    return unfinished_jobs


@freelancer.route('/unfinished_jobs')
def get_unfinished_jobs():
    if g.user:
        unfinished_jobs = get_freelancer_unfinished_jobs(g.user['freelancer_id'])
        return render_template('freelancer/jobs_unfinished.html', jobs=unfinished_jobs)
    return redirect(url_for('auth.login'))


def get_freelancer_finished_jobs(fr_id):
    g.cursor.execute(
        """
        select * from get_freelancer_finished_jobs(%s);
        """,
        (fr_id,)
    )
    finished_jobs = g.cursor.fetchall()

    for job in finished_jobs:
        job['job_price'] = psql_money_to_dec(job['job_price'])
        job['app_price'] = psql_money_to_dec(job['app_price'])
    return finished_jobs


@freelancer.route('/finished_jobs')
def get_finished_jobs():
    if g.user:
        finished_jobs = get_freelancer_finished_jobs(g.user['freelancer_id'])
        return render_template('freelancer/jobs_finished.html', jobs=finished_jobs)
    return redirect(url_for('auth.login'))



@freelancer.route('/explore_unfinished_job/<int:job_id>')
def explore_unfinished_job(job_id):
    if g.user:
        unfinished_job_template = get_unfinished_job_template(job_id)
        return render_template('freelancer/job_unfinished.html', job_template=unfinished_job_template)
    return redirect(url_for('auth.login'))


@freelancer.route('/explore_finished_job/<int:job_id>')
def explore_finished_job(job_id):
    if g.user:
        finished_job_template = get_finished_job_template(job_id)
        return render_template('freelancer/job_finished.html', job_template=finished_job_template)
    return redirect(url_for('auth.login'))