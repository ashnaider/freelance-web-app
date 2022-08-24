from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import *
from datetime import date

from forms import NewJobForm, CustomerProfileForm
from jobs import *
# from .my_jobs import get_customers_jobs

from utils import *


SHOW_DB_CONNECTION = False


customer = Blueprint(
    'customer', __name__,
    url_prefix='/customer',
    template_folder='templates'
)

@customer.route('/')
@customer.route('/index')
@customer.route('/home')
def index():
    jobs_template = get_jobs_template()
    if g.user:
        flash(f"Welcome back, {g.user['first_name'].capitalize()}!", 'success')
        if g.user['is_blocked'] == True:
            flash(f"Warning, you are blocked!", 'warning')
        return render_template('customer/index.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


def get_customer(user_id):
    cur = get_db_cursor()
    cur.execute(
        """
        select * from get_customer(%s);
        """,
        (user_id,)
    )
    user = cur.fetchone()
    close_cursor(cur)
    close_db()
    return user


@customer.before_request
def load_logged_in_user():
    if 'cursor' in g:
        close_cursor(g.cursor)
    close_db()

    user_id = session.get('user_id')
    if user_id is None:
        g.user = None
    else:
        g.user = {'role': 'customer'}
        g.user = get_customer(user_id)
        g.cursor = get_db_cursor()


@customer.route('/create_job', methods=['GET', 'POST'])
def create_job():
    if g.user:
        form = NewJobForm()
        if form.validate_on_submit():
            header = form.title.data
            description = form.description.data
            price = float(form.price.data)
            is_hourly_rate = True if request.form.get("hourly_rate") else False
            # deadline = form.deadline.data
            # deadline_str = str(deadline) + ' 12:00:00-00'
            customer_id = g.user['customer_id']
            print("In create job: ")
            try:
                g.cursor.execute(
                    """
                    select * from create_job(cust_id_p := %s,
                                             header_p := %s,
                                             description_p := %s,
                                             price_p := %s,
                                             is_hourly_rate_p := %s );
                    """,
                    (customer_id, header, description, price, is_hourly_rate)
                )
                g.db_conn.commit()
                print("after job created")
            except Exception as e:
                flash(crop_psql_error(str(e)), 'danger')

            return redirect(url_for('customer.new_jobs'))

        return render_template('customer/create_job.html', form=form)

    close_cursor(g.cursor)
    close_db()
    return redirect(url_for('auth.login'))


def get_customer_new_jobs(cust_id):
    g.cursor.execute(
        """
        SELECT * FROM get_customer_new_jobs(%s);
        """,
        (cust_id,)
    )
    jobs = g.cursor.fetchall()

    for job in jobs:
        job['price'] = psql_money_to_dec(job['price'])
    return render_template('customer/jobs_new_template.html', jobs=jobs)


def get_customer_in_progress_jobs(cust_id):
    g.cursor.execute(
        """
        SELECT * FROM get_customer_in_progress_jobs(%s);
        """,
        (cust_id,)
    )
    jobs = g.cursor.fetchall()

    for job in jobs:
        job['job_price'] = psql_money_to_dec(job['job_price'])
        job['app_price'] = psql_money_to_dec(job['app_price'])

    return render_template('customer/jobs_in_progress_template.html', jobs=jobs)


def get_customer_done_jobs(cust_id):
    g.cursor.execute(
        """
        SELECT * FROM get_customer_done_jobs(%s);
        """,
        (cust_id,)
    )
    jobs = g.cursor.fetchall()

    for job in jobs:
        job['job_price'] = psql_money_to_dec(job['job_price'])
        job['app_price'] = psql_money_to_dec(job['app_price'])

    return render_template('customer/jobs_done_template.html', jobs=jobs, jobs_title='Finished jobs')


def get_customer_unfinished_jobs(cust_id):
    g.cursor.execute(
        """
        SELECT * FROM get_customer_unfinished_jobs(%s);
        """,
        (cust_id,)
    )

    # if SHOW_DB_CONNECTION:
    #     while True:
    #         pass

    jobs = g.cursor.fetchall()

    for job in jobs:
        job['job_price'] = psql_money_to_dec(job['job_price'])
        job['app_price'] = psql_money_to_dec(job['app_price'])

    return render_template('customer/jobs_unfinished_template.html', jobs=jobs, jobs_title='Unfinished jobs')


@customer.route('/new_jobs')
def new_jobs():
    if g.user:
        jobs_template = get_customer_new_jobs(g.user['customer_id'])
        return render_template('customer/my_jobs.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


@customer.route('/jobs_in_progress')
def in_progress_jobs():
    if g.user:
        jobs_template = get_customer_in_progress_jobs(g.user['customer_id'])
        return render_template('customer/my_jobs.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


@customer.route('/done_jobs')
def done_jobs():
    if g.user:
        jobs_template = get_customer_done_jobs(g.user['customer_id'])
        return render_template('customer/my_jobs.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


@customer.route('/unfinished_jobs')
def unfinished_jobs():
    if g.user:
        jobs_template = get_customer_unfinished_jobs(g.user['customer_id'])
        return render_template('customer/my_jobs.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


@customer.route('/edit_job/<int:job_id>', methods=['GET', 'POST'])
def edit_job(job_id):
    if g.user:
        form = NewJobForm()
        if request.method == 'POST':
            if request.form['submit'] == 'Delete':
                try:
                    g.cursor.execute(
                        """
                        select * from delete_job(%s);
                        """,
                        (job_id,)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(str(e), 'danger')

                return redirect(url_for('customer.new_jobs'))

            if request.form['submit'] == 'Edit':
                header = form.title.data
                description = form.description.data
                price = float(form.price.data)
                is_hourly_rate = True if request.form.get("is_hourly_rate") else False

                print("is hourly rate: ", is_hourly_rate)

                try:
                    print("Before updating job")
                    g.cursor.execute(
                        """
                        select * from update_job(job_id_p := %s,
                                                 header_p := %s,
                                                 description_p := %s,
                                                 price_p := %s,
                                                 is_hourly_rate_p := %s );
                        """,
                        (job_id, header,  description, price, is_hourly_rate)
                    )
                    g.db_conn.commit()
                    print("After updating job")
                except Exception as e:
                    flash(str(e), 'danger')
                else:
                    flash('Job updated!', 'success')

        curr_job = get_active_job_data(job_id)
        if curr_job['customer_id'] == g.user['customer_id']:
            return render_template('customer/edit_job.html', curr_job=curr_job, form=form)
        else:
            job_template = get_job_template(job_id)
            if job_template:
                return render_template('customer/foreign_job.html', job_template=job_template)

    close_cursor(g.cursor)
    close_db()
    return redirect(url_for('auth.login'))


@customer.route('/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    if g.user:
        form = CustomerProfileForm()

        if form.validate_on_submit():
            first_name = form.first_name.data.lower()
            last_name = form.last_name.data.lower()
            organisation_name = form.organisation_name.data

            try:
                g.cursor.execute(
                    """
                    select * from edit_customer_profile(cust_id_p :=  %s, 
                                                        first_name_p := %s, 
                                                        last_name_p := %s, 
                                                        organisation_name_p := %s);
                    """,
                    (g.user['customer_id'], first_name, last_name, organisation_name)
                )
                g.db_conn.commit()
            except Exception as e:
                flash(str(e), 'danger')
            else:
                load_logged_in_user()

        return render_template('customer/profile.html', form=form, profile=g.user)

    return redirect(url_for('auth.login'))


def get_job_applications_data(cust_id, job_id):
    g.cursor.execute(
        """
        SELECT * FROM get_active_customer_applications(%s) AS apps WHERE apps.job_id = %s ;
        """,
        (cust_id, job_id)
    )
    app_data = g.cursor.fetchall()

    for app in app_data:
        app['app_price'] = psql_money_to_dec(app['app_price'])
        app['job_price'] = psql_money_to_dec(app['job_price'])

    return app_data


def get_customer_job_data(cust_id, job_id):
    g.cursor.execute(
        """
        SELECT * FROM get_customer_job(%s, %s)
        """,
        (cust_id, job_id)
    )
    job = g.cursor.fetchone()

    if job:
        job['price'] = psql_money_to_dec(job['price'])
    return job


def get_job_performer_data(cust_id, job_id):
    g.cursor.execute(
        """
        SELECT * FROM get_job_performer(%s, %s);
        """,
        (cust_id, job_id)
    )
    performer_data = g.cursor.fetchone()

    if performer_data:
        performer_data['app_price'] = psql_money_to_dec(performer_data['app_price'])
        performer_data['job_price'] = psql_money_to_dec(performer_data['job_price'])

    return performer_data


def get_job_application(job_id, fr_id):
    g.cursor.execute(
        """
        SELECT * FROM get_application(job_id_p := %s, fr_id_p :=  %s);
        """,
        (job_id, fr_id)
    )
    application = g.cursor.fetchone()

    if application:
        application['price'] = psql_money_to_dec(application['price'])

    return application


@customer.route('/job/<int:job_id>', methods=['GET', 'POST'])
def explore_job(job_id):
    if g.user:
        job_data = get_job_data(job_id)
        load_logged_in_user()
        if job_data:
            if job_data['customer_id'] == g.user['customer_id']:
                status = job_data['job_status']
                if status == 'new':
                    job_apps = get_job_applications_data(g.user['customer_id'], job_id)
                    job_apps_template = render_template('customer/applications_template.html', applications=job_apps)
                    if g.user['is_blocked'] == True:
                        flash('Nobody can see this new job, because you are blocked.', 'warning')
                    return render_template('customer/concrete_job.html', job=job_data,
                                           applications_template=job_apps_template)

                elif status == 'in progress' or status == 'accepted':

                    if request.method == 'POST':
                        if request.form['submit'] == 'Stop job':
                            try:
                                print("before leave job by customer")
                                g.cursor.execute(
                                    """
                                    select * from leave_job_by_customer(job_id_p := %s);
                                    """,
                                    (job_id,)
                                )
                                print("after leave job by customer")
                                g.db_conn.commit()
                                attempts_to_leave_left = '???'
                                attempts_to_leave_left = g.cursor.fetchone()
                                attempts_to_leave_left = attempts_to_leave_left[0] if attempts_to_leave_left else '?'
                            except Exception as e:
                                flash(crop_psql_error(str(e)), 'danger')
                            else:
                                if attempts_to_leave_left == 0:
                                    flash('You have spent all your attempts to stop jobs. You are blocked now.', 'danger')
                                elif attempts_to_leave_left < 0:
                                    flash('You stopped this job. You are still blocked.')
                                else:
                                    flash(f'You stopped this job. Now you can stop jobs {attempts_to_leave_left} more times, before you get blocked.',
                                      'warning')

                    performer_data = get_job_performer_data(g.user['customer_id'], job_data['job_id'])
                    job_data['job_status'] = 'unfinished'
                    return render_template('customer/job_in_progress.html',
                                           job=job_data,
                                           performer_data=performer_data)

                elif status == 'done':
                    finished_job_template = get_finished_job_template(job_id)
                    return render_template('customer/job_finished.html', job_template=finished_job_template)

                elif status == 'unfinished':
                    unfinished_job_template = get_unfinished_job_template(job_id)
                    return render_template('customer/job_finished.html', job_template=unfinished_job_template)
            else:
                return render_template('customer/foreign_job.html',
                                       job_template=render_template('job_template.html', job=job_data))

        return redirect(url_for('customer.index'))

    return redirect(url_for('auth.login'))


def get_customer_applications_template(cust_id):
    g.cursor.execute(
        """
        SELECT * FROM get_active_customer_applications(%s);
        """,
        (cust_id,)
    )
    applications = g.cursor.fetchall()

    for app in applications:
        app['app_price'] = psql_money_to_dec(app['app_price'])
        app['job_price'] = psql_money_to_dec(app['job_price'])
    return render_template('customer/applications_template.html', applications=applications)


@customer.route('/applications')
def applications():
    if g.user:
        applications_template = get_customer_applications_template(g.user['customer_id'])
        return render_template('customer/applications.html', applications_template=applications_template)
    return redirect(url_for('auth.login'))


def get_customer_app_data(cust_id, app_id):
    g.cursor.execute(
        """
        SELECT * FROM get_active_customer_applications(%s) AS apps WHERE apps.app_id = %s ;
        """,
        (cust_id, app_id)
    )
    app_data = g.cursor.fetchone()

    if app_data:
        app_data['app_price'] = psql_money_to_dec(app_data['app_price'])
        app_data['job_price'] = psql_money_to_dec(app_data['job_price'])

    return app_data

def get_customer_app_template(cust_id, app_id):
    app_data = get_customer_app_data(cust_id, app_id)
    return render_template('customer/app_template.html', app=app_data)


@customer.route('/application/<int:app_id>', methods=['GET', 'POST'])
def concrete_application(app_id):
    if g.user:
        app_data = get_customer_app_data(g.user['customer_id'], app_id)
        job_id = app_data['job_id']

        if request.method == 'POST':
            if request.form['submit'] == 'Accept':
                g.cursor.execute(
                    """
                    select * from accept_application_for_job(%s, %s);
                    """,
                    (app_id, job_id)
                )
                g.db_conn.commit()

                return redirect(url_for('customer.explore_job', job_id=job_id))

        app_template = render_template('customer/app_template.html', app=app_data)
        job_data = get_active_job_data(job_id)
        return render_template('customer/app_concrete.html', app_template=app_template, job=job_data)
    return redirect('auth.login')


@customer.route('/view_profile')
def view_profile():
    if g.user:
        customer_template = get_customer_template(g.user['customer_id'])
        return render_template('customer/view_profile.html', customer_template=customer_template)
    return redirect(url_for('auth.login'))

