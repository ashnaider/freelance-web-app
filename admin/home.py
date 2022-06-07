from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import *
from datetime import date

from forms import NewJobForm
from jobs import *
from utils import *

admin = Blueprint(
    'admin', __name__,
    url_prefix='/admin',
    template_folder='templates'
)

@admin.route('/')
@admin.route('/index')
@admin.route('/home')
def index():
    if g.user:
        print("curr_user role: ", g.user['role'])
        print("getting jobs template for admin")
        jobs_template = get_jobs_template()
        print("after getting jobs template for admin")
        flash(f"Welcome back, Admin!", 'success')
        return render_template('admin/index.html', jobs_template=jobs_template)
    return redirect(url_for('auth.login'))


def get_admin(user_id):
    cur = get_db_cursor()
    cur.execute(
        """
        select * from get_user_by_id(%s);
        """,
        (user_id,)
    )
    admin = cur.fetchone()
    print("admin: ", admin)
    print("admin id: ", admin['id'])
    close_cursor(cur)
    close_db()
    return admin


@admin.before_request
def load_logged_in_user():
    if 'cursor' in g:
        close_cursor(g.cursor)
    close_db()

    user_id = session.get('user_id')
    print('user_id: ', user_id)
    if user_id is None:
        g.user = None
    else:
        g.user = {'role': 'admin'}
        g.user = get_admin(user_id)
        g.cursor = get_db_cursor()
