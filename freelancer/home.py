from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import get_db_cursor, close_cursor

from forms import FreelancerProfileForm, JobApplication
from jobs import get_jobs_template, get_job_template

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
    cur = get_db_cursor()
    cur.execute(
        'SELECT email, role, first_name, last_name,  resume_link, specialization, is_blocked, f.id as freelancer_id '
        'FROM freelancer AS f INNER JOIN users AS u ON f.user_id = u.id WHERE f.user_id = %s',
        (user_id,)
    )
    user = cur.fetchone()
    close_cursor(cur)
    return user


@freelancer.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')
    if user_id is None:
        g.user = None
    else:
        g.user = get_freelancer(user_id)


@freelancer.route('/search', methods=['GET'])
def search():
    cur = get_db_cursor()
    try:
        pass
        cur.execute(
            'SELECT * FROM new_job INNER JOIN customer AS c on new_job.customer_id = c.id'
        )
        new_jobs = cur.fetchall()
    except Exception as exc:
        pass
    finally:
        close_cursor(cur)

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
                cur = get_db_cursor()
                cur.execute(
                    """
                    UPDATE freelancer SET
                    first_name = %s, last_name = %s, resume_link = %s, specialization = %s
                    WHERE id = %s;
                    """,
                    (first_name, last_name, resume_link, specialization, g.user['freelancer_id'])
                )
                close_cursor(cur)
            except Exception as e:
                flash(str(e), 'danger')
            else:
                load_logged_in_user()

        return render_template('freelancer/profile.html', form=form, profile=g.user)

    return redirect(url_for('auth.login'))


@freelancer.route('/apply_job/<int:job_id>', methods=['GET', 'POST'])
def apply_job(job_id):
    load_logged_in_user()
    if g.user:
        form = JobApplication()

        if form.validate_on_submit():
            description = form.description.data
            price = form.price.data

            try:
                cur = get_db_cursor()
                cur.execute(
                    """
                    UPDATE freelancer SET
                    first_name = %s, last_name = %s, resume_link = %s, specialization = %s
                    WHERE id = %s;
                    """,
                    (first_name, last_name, resume_link, specialization, g.user['freelancer_id'])
                )
                close_cursor(cur)
            except Exception as e:
                flash(str(e), 'danger')
            else:
                load_logged_in_user()

        job_template = get_job_template(job_id)
        return render_template('freelancer/job_application.html', job_template=job_template, form=form)

    return redirect(url_for('freelancer.home'))