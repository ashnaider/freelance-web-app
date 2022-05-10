from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import get_db_cursor, close_cursor
from datetime import date

from forms import NewJobForm

from jobs import get_jobs
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
    jobs_template = get_jobs()
    flash(f"Welcome back, {g.user['first_name'].capitalize()}!", 'success')
    return render_template('customer/index.html', jobs_template=jobs_template)


def get_user(user_id):
    cur = get_db_cursor()
    cur.execute(
        'SELECT * FROM customer WHERE user_id = %s', (user_id,)
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
        g.user = get_user(user_id)
        g.user_logged_in = False


@customer.route('/create_job', methods=['GET', 'POST'])
def create_job():
    form = NewJobForm()
    if form.validate_on_submit():
        header = form.title.data
        description = form.description.data
        price = float(form.price.data)
        hourly_rate = True if request.form.get("hourly_rate") else False
        # deadline = form.deadline.data
        # deadline_str = str(deadline) + ' 12:00:00-00'
        customer_id = g.user['id']

        print("price: ", price)
        print("hourly rate: ", hourly_rate)
        print("user: ", g.user)
        print("user_id: ", g.user['user_id'])


        cursor = get_db_cursor()
        try:
            print("add new record in new_job table")
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


@customer.route('/my_jobs')
def my_jobs():
    if g.user:
        jobs_template = get_customers_jobs(g.user['id'])
        return render_template('customer/index.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


@customer.route('/logout')
def logout():
    session.clear()
    return redirect('index.html')
