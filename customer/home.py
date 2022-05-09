from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import get_db_cursor, close_cursor

from forms import NewJobForm


customer = Blueprint(
    'customer', __name__,
    url_prefix='/customer',
    template_folder='templates'
)

@customer.route('/')
@customer.route('/index')
@customer.route('/home')
def index():
    return render_template('customer/index.html')


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


@customer.route('/create_job', methods=['GET', 'POST'])
def create_job():
    form = NewJobForm()
    if form.validate_on_submit():
        header = form.title.data
        description = form.description.data
        price = float(form.price.data)
        # hourly_rate = request.form["hourly_rate"]
        deadline = form.deadline.data


        print("price: ", price)
        # print("hourly rate: ", hourly_rate)
        print("deadline: ", deadline)

        cursor = get_db_cursor()
        # try:
        #     cursor.execute(
        #         "INSERT INTO users (email, passwd, role) VALUES (%s, %s, %s) RETURNING users.id",
        #         (email, hashed_password, role),
        #     )
        # except:
        #     pass

        # new_user_id = cursor.fetchone()[0]
        close_cursor(cursor)

    return render_template('customer/create_job.html', form=form)


@customer.route('/logout')
def logout():
    session.clear()
    return redirect('index.html')
