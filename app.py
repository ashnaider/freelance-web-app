import os

from flask import Flask, render_template

from auth import auth
from freelancer.home import freelancer
from customer.home import customer
from jobs import jobs, get_jobs_template


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
        DATABASE='freelancer-db',

        ADMIN_USER='postgres',
        ADMIN_PASSWORD='postgres',

        FREELANCER_USER='freelancer_user',
        FREELANCER_PASSWORD='freelancer',

        CUSTOMER_USER='customer_user',
        CUSTOMER_PASSWORD='customer',

        GUEST_USER='guest_user',
        GUEST_PASSWORD='guest',
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    @app.route('/')
    @app.route('/index')
    def home():  # put application's code here
        jobs_template = get_jobs_template()
        return render_template('index.html', jobs_template=jobs_template)


    app.register_blueprint(auth)
    app.register_blueprint(freelancer)
    app.register_blueprint(customer)
    app.register_blueprint(jobs)

    return app
