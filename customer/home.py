from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import *
from datetime import date

from forms import NewJobForm, CustomerProfileForm
from jobs import *
# from .my_jobs import get_customers_jobs

from utils import *

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
        return render_template('customer/index.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


def get_customer(user_id):
    cur = get_db_cursor()
    cur.execute(
        'SELECT email, role, first_name, last_name, organisation_name, is_blocked, c.id as customer_id  '
        'FROM customer AS c INNER JOIN users AS u ON c.user_id = u.id WHERE user_id = %s',
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
            hourly_rate = True if request.form.get("hourly_rate") else False
            # deadline = form.deadline.data
            # deadline_str = str(deadline) + ' 12:00:00-00'
            customer_id = g.user['customer_id']
            print("In create job: ")
            try:
                g.cursor.execute(
                    "INSERT INTO new_job (customer_id, header_, description, price, is_hourly_rate) "
                    "VALUES (%s, %s, %s, %s, %s);",
                    (customer_id, header, description, price, hourly_rate),
                )
                g.db_conn.commit()
            except Exception as e:
                flash(e, 'danger')

            return redirect(url_for('customer.my_jobs'))

        return render_template('customer/create_job.html', form=form)

    close_cursor(g.cursor)
    close_db()
    return redirect(url_for('auth.login'))


def get_customer_jobs(cust_id):
    g.cursor.execute(
        """
        SELECT * FROM get_customer_jobs(%s); 
        """,
        (cust_id,)
    )
    jobs = g.cursor.fetchall()

    for job in jobs:
        job['price'] = psql_money_to_dec(job['price'])
    return render_template('jobs.html', jobs=jobs)


@customer.route('/my_jobs')
def my_jobs():
    if g.user:
        jobs_template = get_customer_jobs(g.user['customer_id'])
        return render_template('customer/index.html', jobs_template=jobs_template)
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
                        DELETE FROM new_job WHERE id = %s;
                        """,
                        (job_id,)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(str(e), 'danger')

                return redirect(url_for('customer.my_jobs'))

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
                        UPDATE new_job SET header_ = %s, description = %s, price = %s, is_hourly_rate = %s
                        WHERE id = %s ;
                        """,
                        (header, description, price, is_hourly_rate, job_id)
                    )
                    g.db_conn.commit()
                    print("After updating job")
                except Exception as e:
                    flash(str(e), 'danger')
                else:
                    flash('Job updated!', 'success')

        curr_job = get_job_data(job_id)
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
                    UPDATE customer SET
                    first_name = %s, last_name = %s, organisation_name = %s
                    WHERE id = %s;
                    """,
                    (first_name, last_name, organisation_name, g.user['customer_id'])
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
        SELECT * FROM get_customer_applications(%s) AS apps WHERE apps.job_id = %s ;
        """,
        (cust_id, job_id)
    )
    app_data = g.cursor.fetchall()

    for app in app_data:
        app['app_price'] = psql_money_to_dec(app['app_price'])
        app['job_price'] = psql_money_to_dec(app['job_price'])

    return app_data


@customer.route('/job/<int:job_id>')
def explore_job(job_id):
    if g.user:
        job_data = get_job_data(job_id)
        load_logged_in_user()
        if job_data:
            if job_data['customer_id'] == g.user['customer_id']:
                job_apps = get_job_applications_data(g.user['customer_id'], job_id)
                print("job_apps: ", job_apps)
                job_apps_template = render_template('customer/applications_template.html', applications=job_apps)
                return render_template('customer/concrete_job.html', job=job_data, applications_template=job_apps_template)
            else:
                return render_template('customer/concrete_job.html', job=job_data)

        return redirect(url_for('jobs.get_jobs'))

    return redirect(url_for('auth.login'))


def get_customer_applications_template(cust_id):
    g.cursor.execute(
        """
        SELECT * FROM get_customer_applications(%s);
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
        SELECT * FROM get_customer_applications(%s) AS apps WHERE apps.app_id = %s ;
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


@customer.route('/application/<int:app_id>', methods=['GET', 'SET'])
def concrete_application(app_id):
    if g.user:
        app_data = get_customer_app_data(g.user['customer_id'], app_id)
        app_template = render_template('customer/app_template.html', app=app_data)
        job_data = get_job_data(app_data['job_id'])
        return render_template('customer/app_concrete.html', app_template=app_template, job=job_data)
    return redirect('auth.login')
