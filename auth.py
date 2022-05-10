from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from psycopg2.sql import SQL, Identifier
from werkzeug.security import check_password_hash, generate_password_hash

from db import get_db_conn, get_db_cursor, close_cursor

from forms import RegistrationForm, LoginForm

from jobs import get_jobs

auth = Blueprint('auth', __name__,
                 url_prefix='/',
                 template_folder='templates')


@auth.route('/')
@auth.route('/home')
@auth.route('/index')
def home():
    print("HUI HOME?")
    jobs_template = get_jobs()
    return render_template('index.html', jobs_template=jobs_template)


@auth.route('/register', methods=['GET', 'POST'])
def register():
    form = RegistrationForm()
    if form.validate_on_submit():
        first_name = form.first_name.data.lower()
        last_name = form.last_name.data.lower()
        email = form.email.data
        hashed_password = generate_password_hash(form.password.data)
        role = request.form['role']

        cursor = get_db_cursor()
        try:
            cursor.execute(
                "INSERT INTO users (email, passwd, role) VALUES (%s, %s, %s) RETURNING users.id",
                (email, hashed_password, role),
            )
            new_user_id = cursor.fetchone()[0]

        except get_db_conn().IntegrityError:
            error = "Something went wrong during inserting new user to users table"
            flash(error)
        else:
            try:
                print("new user id: ", new_user_id)
                cursor.execute(
                    SQL("INSERT INTO {} (user_id, first_name, last_name) VALUES (%s, %s, %s)".format(role)),
                    (new_user_id, first_name, last_name)
                    )

            except Exception as e:
                error = "Something went wrong during inserting to role table"
                print("exception: ", e)
            else:
                flash('Your account has been created! You are now able to log in', 'success')
                return redirect(url_for("auth.login"))
            finally:
                close_cursor(cursor)

    return render_template('register.html', form=form)


@auth.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        email = form.email.data
        password = form.password.data
        cur = get_db_cursor()
        error = None
        cur.execute(
            'SELECT * FROM users WHERE email = %s', (email,)
        )
        user = cur.fetchone()

        if not check_password_hash(user['passwd'], password):
            error = 'Wrong password.'
            flash(error, 'danger')
        else:
            session.clear()
            session['user_id'] = user['id']
            if 'freelancer' == user['role']:
                return redirect(url_for('freelancer.index'))
            elif 'customer' == user['role']:
                return redirect(url_for('customer.index'))

    return render_template('login.html', form=form)


@auth.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('auth.home'))
