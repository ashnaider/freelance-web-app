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
    cursor = get_db_cursor()
    cursor.execute(
        "SELECT * FROM new_job INNER JOIN customer c on new_job.customer_id = c.id"
    )
    jobs = cursor.fetchall()
    close_cursor(cursor)

    for job in jobs:
        job['price'] = psql_money_to_dec(job['price'])

    return render_template('jobs.html', jobs=jobs)


def count_job_applications(job_id):
    cursor = get_db_cursor()
    cursor.execute(
        "SELECT COUNT(*) FROM application WHERE job_id = (%s);",
        (job_id,)
    )
    job = cursor.fetchone()
    close_cursor(cursor)

    if job:
        return job[0]
    return 0


@jobs.route('/<int:job_id>')
def get_job(job_id):
    cursor = get_db_cursor()
    cursor.execute(
        "SELECT * FROM new_job INNER JOIN customer c on new_job.customer_id = c.id WHERE new_job.id = (%s)",
        (job_id,)
    )
    job = cursor.fetchone()
    close_cursor(cursor)

    job_compliment = {}

    if job:
        job_compliment['job_apps'] = count_job_applications(job['id'])
        job['price'] = psql_money_to_dec(job['price'])
        return render_template('concrete_job.html', job=job, job_compliment=job_compliment)

    return redirect(url_for('jobs.get_jobs'))

