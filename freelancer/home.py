from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import *

from forms import FreelancerProfileForm, JobApplication
from jobs import get_jobs_template, get_job_template

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
    load_logged_in_user()
    jobs_template = get_jobs_template()
    if g.user:
        flash(f"Welcome back, {g.user['first_name'].capitalize()}!", 'success')
        return render_template('freelancer/index.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


def get_freelancer(user_id):
    cur = get_db_cursor('freelancer')
    cur.execute(
        'SELECT email, role, first_name, last_name,  resume_link, specialization, is_blocked, f.id as freelancer_id '
        'FROM freelancer AS f INNER JOIN users AS u ON f.user_id = u.id WHERE f.user_id = %s',
        (user_id,)
    )
    user = cur.fetchone()
    close_cursor(cur, 'freelancer')
    return user


@freelancer.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')
    close_db()
    get_db_conn(role='freelancer')
    if user_id is None:
        g.user = None
    else:
        g.user = get_freelancer(user_id)


@freelancer.route('/search', methods=['GET'])
def search():
    cur = get_db_cursor('freelancer')
    try:
        pass
        cur.execute(
            'SELECT * FROM new_job INNER JOIN customer AS c on new_job.customer_id = c.id'
        )
        new_jobs = cur.fetchall()
    except Exception as exc:
        pass
    finally:
        close_cursor(cur, 'freelancer')

    print("new_jobs: ", new_jobs)

    return render_template('freelancer/jobs.html', jobs=new_jobs)


@freelancer.route('/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    load_logged_in_user()
    if g.user:
        form = FreelancerProfileForm()

        if form.validate_on_submit():
            first_name = form.first_name.data.lower()
            last_name = form.last_name.data.lower()
            resume_link = form.resume_link.data
            specialization = form.specialization.data

            try:
                cur = get_db_cursor('freelancer')
                cur.execute(
                    """
                    UPDATE freelancer SET
                    first_name = %s, last_name = %s, resume_link = %s, specialization = %s
                    WHERE id = %s;
                    """,
                    (first_name, last_name, resume_link, specialization, g.user['freelancer_id'])
                )
                close_cursor(cur, 'freelancer')
            except Exception as e:
                flash(str(e), 'danger')
            else:
                load_logged_in_user()

        return render_template('freelancer/profile.html', form=form, profile=g.user)

    return redirect(url_for('auth.login'))


def is_application_exist(job_id, fr_id):
    cur = get_db_cursor('freelancer')
    cur.execute(
        """
        SELECT * FROM is_application_exist(%s, %s);
        """,
        (job_id, fr_id)
    )
    exist = cur.fetchone()['is_application_exist']
    close_cursor(cur, 'freelancer')
    return exist


def get_application(job_id, fr_id):
    cur = get_db_cursor('freelancer')
    cur.execute(
        """
        SELECT * FROM application WHERE job_id = %s and freelancer_id = %s ;
        """,
        (job_id, fr_id)
    )
    application = cur.fetchone()
    if application:
        application['price'] = psql_money_to_dec(application['price'])
    close_cursor(cur, 'freelancer')
    return application


@freelancer.route('/apply_job/<int:job_id>', methods=['GET', 'POST'])
def apply_job(job_id):
    load_logged_in_user()
    if g.user:
        form = JobApplication()
        fr_id = g.user['freelancer_id']

        job_template = get_job_template(job_id)
        application = get_application(job_id, fr_id)

        if request.method == 'POST':
            if request.form['submit'] == 'Cancel application' and application:
                try:
                    cur = get_db_cursor('freelancer')
                    cur.execute(
                        """
                        DELETE FROM application WHERE job_id = %s and freelancer_id = %s
                        """,
                        (job_id, fr_id)
                    )
                    close_cursor(cur, 'freelancer')
                except Exception as e:
                    flash(str(e), 'danger')

            application = None

            if request.form['submit'] == 'Apply':
                description = form.description.data
                price = float(form.price.data)

                try:
                    cur = get_db_cursor('freelancer')
                    cur.execute(
                        """
                        INSERT INTO application (price, description, freelancer_id, job_id)
                        VALUES (%s, %s, %s, %s);
                        """,
                        (price, description, fr_id, job_id)
                    )
                    print("After insertion into application")
                    close_cursor(cur, 'freelancer')
                except Exception as e:
                    flash(str(e), 'danger')
                else:
                    application = get_application(job_id, fr_id)
                    job_template = get_job_template(job_id)


        return render_template('freelancer/job_application.html',
                               job_template=job_template,
                               form=form,
                               application=application)

    return redirect(url_for('freelancer.home'))


def get_applied_jobs_template(fr_id):
    cur = get_db_cursor('freelancer')
    cur.execute(
        """
        SELECT * FROM get_applied_jobs(%s);
        """,
        (fr_id,)
    )
    jobs = cur.fetchall()
    close_cursor(cur, 'freelancer')
    close_db()

    for job in jobs:
        job['price'] = psql_money_to_dec(job['price'])

    return render_template('jobs.html', jobs=jobs, jobs_title="Applications: ")


@freelancer.route('/applications', methods=['GET'])
def get_applied_jobs():
    load_logged_in_user()
    if g.user:
        jobs_template = get_applied_jobs_template(g.user['freelancer_id'])
        return render_template('freelancer/applications.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))

