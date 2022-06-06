from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from psycopg2.sql import SQL, Identifier
from werkzeug.security import check_password_hash, generate_password_hash

from forms import RegistrationForm, LoginForm

from db import *
from utils import *


jobs = Blueprint('jobs', __name__,
                 url_prefix='/jobs',
                 template_folder='templates')


@jobs.route('/')
def get_jobs():
    jobs_template = get_jobs_template()
    return render_template('index.html', jobs_template=jobs_template)


def get_jobs_template():
    cur = get_db_cursor()
    cur.execute(
        """
        SELECT * FROM get_newest_jobs();
        """
    )
    jobs = cur.fetchall()
    close_cursor(cur)
    close_db()

    for job in jobs:
        job['price'] = psql_money_to_dec(job['price'])

    return render_template('jobs.html', jobs=jobs)


def get_active_job_data(job_id):
    cur = get_db_cursor()
    cur.execute(
        """
        SELECT * FROM get_active_jobs() WHERE job_id = %s;
        """,
        (job_id,)
    )
    job = cur.fetchone()
    close_cursor(cur)
    close_db()

    if job:
        job['price'] = psql_money_to_dec(job['price'])

    return job


def get_job_data(job_id):
    cur = get_db_cursor()
    cur.execute(
        """
        SELECT * FROM get_all_jobs() WHERE job_id = %s;
        """,
        (job_id,)
    )
    job = cur.fetchone()
    close_cursor(cur)
    close_db()

    if job:
        job['price'] = psql_money_to_dec(job['price'])

    return job

def get_job_template(job_id):
    job = get_active_job_data(job_id)
    if job:
        return render_template('job_template.html', job=job)

    return None


@jobs.route('/<int:job_id>', methods=['GET'])
def get_job(job_id):
    job_template = get_job_template(job_id)
    if job_template:
        return render_template('concrete_job.html', job_template=job_template)

    return redirect(url_for('jobs.get_jobs'))


def get_finished_job_data(job_id):
    g.cursor.execute(
        """
        select * from get_done_job_full_info(job_id_p :=  %s, job_status_p := %s);
        """,
        (job_id, 'done')
    )
    finished_job = g.cursor.fetchone()

    if finished_job:
        finished_job['job_price'] = psql_money_to_dec(finished_job['job_price'])
        finished_job['app_price'] = psql_money_to_dec(finished_job['app_price'])

    return finished_job


def get_finished_job_template(job_id):
    finished_job_data = get_finished_job_data(job_id)
    return render_template('job_done_template.html', job=finished_job_data)


def get_unfinished_job_data(job_id):
    g.cursor.execute(
        """
        select * from get_done_job_full_info(job_id_p :=  %s, job_status_p := %s);
        """,
        (job_id, 'unfinished')
    )
    unfinished_job = g.cursor.fetchone()

    if unfinished_job:
        unfinished_job['job_price'] = psql_money_to_dec(unfinished_job['job_price'])
        unfinished_job['app_price'] = psql_money_to_dec(unfinished_job['app_price'])

    return unfinished_job


def get_unfinished_job_template(job_id):
    finished_job_data = get_finished_job_data(job_id)
    return render_template('job_done_template.html', job=finished_job_data)



