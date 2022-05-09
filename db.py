import psycopg2
import psycopg2.extras

import os
import click
from flask import current_app, g
from flask.cli import with_appcontext


def get_db_conn():
    if 'db_conn' not in g:
        g.db_conn = psycopg2.connect(
            dbname=current_app.config['DATABASE'],
            user=current_app.config['USER'],
            password=current_app.config['PASSWORD'],
        )

    return g.db_conn


def get_db_cursor():
    return get_db_conn().cursor(cursor_factory=psycopg2.extras.DictCursor)


def close_cursor(cursor):
    cursor.close()
    get_db_conn().commit()


def close_db(e=None):
    db_conn = g.pop('db_conn', None)

    if db_conn is not None:
        db_conn.close()


def init_db():
    cur = get_db_cursor()

    with open(os.path.join(os.path.dirname(__file__), 'db_scripts/schema.sql'), 'rb') as f:
        _data_sql = f.read().decode('utf8')
        cur.execute(_data_sql)
        close_cursor(cur)


def init_app(app):
    app.teardown_appcontext(close_db)