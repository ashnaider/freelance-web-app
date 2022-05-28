from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from psycopg2.sql import SQL, Identifier
from werkzeug.security import check_password_hash, generate_password_hash

from forms import RegistrationForm, LoginForm

from db import get_db_conn, get_db_cursor, close_cursor
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

    for job in jobs:
        job['price'] = psql_money_to_dec(job['price'])

    return render_template('jobs.html', jobs=jobs)


def count_job_applications(job_id):
    cursor = get_db_cursor()
    cursor.execute(
        """
        SELECT * FROM count_job_applications(%s);
        """,
        (job_id,)
    )
    job = cursor.fetchone()
    close_cursor(cursor)

    return job[0]


def get_job_template(job_id):
    cursor = get_db_cursor()
    cursor.execute(
        """
        SELECT * FROM get_active_jobs() WHERE job_id = %s;
        """,
        (job_id,)
    )
    job = cursor.fetchone()
    close_cursor(cursor)

    if job:
        print(job['applications_count'])
        return render_template('job_template.html', job=job)

    return None


@jobs.route('/<int:job_id>', methods=['GET'])
def get_job(job_id):
    job_template = get_job_template(job_id)
    if job_template:
        return render_template('concrete_job.html', job_template=job_template)

    return redirect(url_for('jobs.get_jobs'))

