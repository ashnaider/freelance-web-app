from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import get_db_cursor, close_cursor

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
    if g.user:
        flash(f"Welcome back, {g.user['first_name'].capitalize()}!", 'success')
        return render_template('freelancer/index.html')
    return redirect(url_for('auth.login'))


def get_freelancer(user_id):
    cur = get_db_cursor()
    cur.execute(
        'SELECT * FROM freelancer AS f INNER JOIN users AS u ON f.user_id = u.id WHERE user_id = %s',
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


@freelancer.route('/edit', methods=['GET', 'POST'])
def edit():
    if request.method == 'POST':

        first_name = request.form['first_name'].lower()
        last_name = request.form['last_name'].lower()
        resume_link = request.form['resume_link']
        specialization = request.form['specialization']

        cur = get_db_cursor()
        info = None

        if first_name and last_name:
            cur.execute(
                """
                UPDATE freelancer SET 
                first_name = %s, last_name = %s 
                WHERE id = %s;
                """,
                (first_name, last_name, g.user['id']))
        else:
            info = 'Fill out first and last name!'
            return render_template('freelancer/profile.html')

        if resume_link:
            cur.execute(
                """
                UPDATE freelancer SET 
                resume_link = %s
                WHERE id = %s;
                """,
                (resume_link, g.user['id']))

        if specialization:
            cur.execute(
                """
                UPDATE freelancer SET 
                specialization = %s
                WHERE id = %s;
                """,
                (specialization, g.user['id']))

        close_cursor(cur)

        g.user = get_freelancer(g.user['id'])

    if g.user is None:
        return '<p>Nothing to edit, log in first</p>'
    return render_template('freelancer/profile.html')

