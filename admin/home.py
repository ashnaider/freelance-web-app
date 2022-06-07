from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from db import *
from datetime import date

from forms import NewJobForm
from jobs import *
from utils import *

from freelancer.home import get_job_template

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


def get_new_applications_data():
    g.cursor.execute(
        'select * from get_all_new_applications();',
    )
    new_apps = g.cursor.fetchall()
    for app in new_apps:
        app['job_price'] = psql_money_to_dec(app['job_price'])
        app['app_price'] = psql_money_to_dec(app['app_price'])

    return new_apps

def get_new_application_data(app_id):
    g.cursor.execute(
        'select * from get_new_application(app_id_p := %s);',
        (app_id,)
    )
    app = g.cursor.fetchone()
    if app:
        app['job_price'] = psql_money_to_dec(app['job_price'])
        app['app_price'] = psql_money_to_dec(app['app_price'])

    return app


@admin.route('/applications')
def get_applications():
    if g.user:
        apps_data = get_new_applications_data()
        apps_template = render_template('admin/applications_template.html', applications=apps_data)
        return render_template('admin/new_applications.html', applications_template=apps_template)
    return redirect(url_for('auth.login'))


@admin.route('/explore_application/<int:app_id>', methods=['GET', 'POST'])
def explore_application(app_id):
    if g.user:
        app_data = get_new_application_data(app_id)
        if request.method == 'POST':
            if request.form['submit'] == 'Delete application':
                try:
                    g.cursor.execute(
                        """
                        select * from remove_job_application_by_freelancer(job_id_p := %s, fr_id_p := %s);
                        """,
                        (app_data['job_id'], app_data['fr_id'])
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    flash(f"Application {app_data['app_description'][:20]}... was deleted!", 'success')
                    return redirect(url_for('admin.get_applications'))

        return render_template('admin/job_application.html', application=app_data)

    return redirect(url_for('auth.login'))


@admin.route('/explore_job/<int:job_id>', methods=['GET', 'POST'])
def explore_job(job_id):
    if g.user:
        if request.method == 'POST':
            if request.form['submit'] == 'Delete job':
                try:
                    g.cursor.execute(
                        'select * from delete_job(job_id_p := %s);',
                        (job_id,)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    flash(f"Job was deleted!", 'success')
                    return redirect(url_for('admin.index'))

        job_template = get_job_template(job_id)
        return render_template('admin/explore_job.html', job_template=job_template)

    return redirect(url_for('auth.login'))


################ CUSTOMERS ###################

@admin.route('/active_customers/')
def get_active_customers():
    if g.user:
        customers_template = get_active_customers_template()
        return render_template('admin/customers.html', customers_template=customers_template)

    return redirect(url_for('auth.login'))


@admin.route('/blocked_customers/')
def get_blocked_customers():
    if g.user:
        customers_template = get_blocked_customers_template()
        return render_template('admin/customers.html', customers_template=customers_template)

    return redirect(url_for('auth.login'))


@admin.route('/explore_customer/<int:cust_id>', methods=['GET', 'POST'])
def explore_customer(cust_id):
    if g.user:
        if request.method == 'POST':
            if request.form['submit'] == 'Block customer':
                try:
                    g.cursor.execute(
                        'select * from block_customer(cust_id_p := %s);',
                        (cust_id,)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    flash(f"Customer was blocked!", 'success')

            elif request.form['submit'] == 'Unblock customer':
                try:
                    g.cursor.execute(
                        'select * from unblock_customer(cust_id_p := %s);',
                        (cust_id,)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    flash(f"Customer was unlocked!", 'success')

        customer_template = get_customer_template(cust_id)
        return render_template('admin/customer_concrete.html', customer_template=customer_template)

    return redirect(url_for('auth.login'))


################ FREELANCERS ###################

@admin.route('/active_freelancers/')
def get_active_freelancers():
    if g.user:
        freelancers_template = get_active_freelancers_template()
        return render_template('admin/freelancers.html', freelancers_template=freelancers_template)

    return redirect(url_for('auth.login'))


@admin.route('/blocked_freelancers/')
def get_blocked_freelancers():
    if g.user:
        freelancers_template = get_blocked_freelancers_template()
        return render_template('admin/freelancers.html', freelancers_template=freelancers_template)

    return redirect(url_for('auth.login'))


@admin.route('/explore_freelancer/<int:fr_id>', methods=['GET', 'POST'])
def explore_freelancer(fr_id):
    if g.user:
        if request.method == 'POST':
            if request.form['submit'] == 'Block freelancer':
                try:
                    g.cursor.execute(
                        'select * from block_freelancer(fr_id_p := %s);',
                        (fr_id,)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    flash(f"Freelancer was blocked!", 'success')

            elif request.form['submit'] == 'Unblock freelancer':
                try:
                    g.cursor.execute(
                        'select * from unblock_freelancer(fr_id_p := %s);',
                        (fr_id,)
                    )
                    g.db_conn.commit()
                except Exception as e:
                    flash(crop_psql_error(str(e)), 'danger')
                else:
                    flash(f"Freelancer was unlocked!", 'success')

        freelancer_template = get_freelancer_template(fr_id)
        return render_template('admin/freelancer_concrete.html', freelancer_template=freelancer_template)

    return redirect(url_for('auth.login'))