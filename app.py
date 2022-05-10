import os

from flask import Flask, render_template

from auth import auth
from freelancer.home import freelancer
from customer.home import customer

from jobs import get_jobs


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
        DATABASE='freelancer-db',
        USER='postgres',
        PASSWORD='postgres',
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
        jobs_template = get_jobs()
        return render_template('index.html', jobs_template=jobs_template)


    app.register_blueprint(auth)
    app.register_blueprint(freelancer)
    app.register_blueprint(customer)


    # from freelancer.auth import freelancer_auth
    # app.register_blueprint(freelancer_auth)
    #
    # from customer.auth import customer_auth
    # app.register_blueprint(customer_auth)
    #
    # from freelancer.home import freelancer
    # app.register_blueprint(freelancer)

    return app
