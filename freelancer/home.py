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
    if g.user:
        jobs_template = get_jobs_template()
        flash(f"Welcome back, {g.user['first_name'].capitalize()}!", 'success')
        return render_template('freelancer/index.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


def get_freelancer(user_id):
    cursor = get_db_cursor()
    cursor.execute(
        'SELECT email, role, first_name, last_name,  resume_link, specialization, is_blocked, f.id as freelancer_id '
        'FROM freelancer AS f INNER JOIN users AS u ON f.user_id = u.id WHERE f.user_id = %s',
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


@freelancer.route('/search', methods=['GET'])
def search():
    try:
        g.cursor.execute(
            'SELECT * FROM new_job INNER JOIN customer AS c on new_job.customer_id = c.id'
        )
        new_jobs = g.cursor.fetchall()
    except Exception as exc:
        pass

    print("new_jobs: ", new_jobs)
    return render_template('freelancer/jobs.html', jobs=new_jobs)


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
                    UPDATE freelancer SET
                    first_name = %s, last_name = %s, resume_link = %s, specialization = %s
                    WHERE id = %s;
                    """,
                    (first_name, last_name, resume_link, specialization, g.user['freelancer_id'])
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
        SELECT * FROM application WHERE job_id = %s and freelancer_id = %s ;
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
            if request.form['submit'] == 'Cancel application' and application:
                try:
                    g.cursor.execute(
                        """
                        DELETE FROM application WHERE job_id = %s and freelancer_id = %s
                        """,
                        (job_id, fr_id)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(str(e), 'danger')

            application = None

            if request.form['submit'] == 'Apply':
                description = form.description.data
                price = float(form.price.data)

                try:
                    g.cursor.execute(
                        """
                        INSERT INTO application (price, description, freelancer_id, job_id)
                        VALUES (%s, %s, %s, %s);
                        """,
                        (price, description, fr_id, job_id)
                    )
                    g.db_conn.commit()
                    print("After insertion into application")
                except Exception as e:
                    flash(str(e), 'danger')
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

    return render_template('jobs.html', jobs=jobs, jobs_title="Applications: ")


@freelancer.route('/applications', methods=['GET'])
def get_applied_jobs():
    if g.user:
        jobs_template = get_applied_jobs_template(g.user['freelancer_id'])
        return render_template('freelancer/applications.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))

