from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import get_db_cursor, close_cursor
from datetime import date

from forms import NewJobForm, CustomerProfileForm

from jobs import get_jobs_template
from .my_jobs import get_customers_jobs

customer = Blueprint(
    'customer', __name__,
    url_prefix='/customer',
    template_folder='templates'
)

@customer.route('/')
@customer.route('/index')
@customer.route('/home')
def index():
    load_logged_in_user()
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
    return user


@customer.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')
    if user_id is None:
        g.user = None
    else:
        g.user = get_customer(user_id)


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
            customer_id = g.user['id']

            cursor = get_db_cursor()
            try:
                cursor.execute(
                    "INSERT INTO new_job (customer_id, header_, description, price, is_hourly_rate) "
                    "VALUES (%s, %s, %s, %s, %s);",
                    (customer_id, header, description, price, hourly_rate),
                )
            # new_user_id = cursor.fetchone()[0]
            except Exception as e:
                flash(e, 'danger')
            finally:
                close_cursor(cursor)

        return render_template('customer/create_job.html', form=form)

    return redirect(url_for('auth.login'))


@customer.route('/my_jobs')
def my_jobs():
    if g.user:
        jobs_template = get_customers_jobs(g.user['id'])
        return render_template('customer/index.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


@customer.route('/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    load_logged_in_user()
    if g.user:
        form = CustomerProfileForm()

        if form.validate_on_submit():
            first_name = form.first_name.data.lower()
            last_name = form.last_name.data.lower()
            organisation_name = form.organisation_name.data

            try:
                cur = get_db_cursor()
                cur.execute(
                    """
                    UPDATE customer SET
                    first_name = %s, last_name = %s, organisation_name = %s
                    WHERE id = %s;
                    """,
                    (first_name, last_name, organisation_name, g.user['customer_id'])
                )
                close_cursor(cur)
            except Exception as e:
                flash(str(e), 'danger')
            else:
                load_logged_in_user()

        return render_template('customer/profile.html', form=form, profile=g.user)

    return redirect(url_for('auth.login'))
