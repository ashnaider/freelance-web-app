from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from wtforms import StringField, PasswordField, SubmitField, \
    BooleanField, TextAreaField, DateTimeField, FloatField, \
    DecimalField, DateField, BooleanField
from wtforms.validators import DataRequired, Length, Email, EqualTo, ValidationError, Regexp
# from flask_login import current_user
# from flaskblog.models import User

import re

from db import get_db_cursor, close_cursor


class RegistrationForm(FlaskForm):
    first_name = StringField('First name',
                             validators=[DataRequired(), Length(min=2, max=30)])
    last_name = StringField('Last name',
                            validators=[DataRequired(), Length(min=2, max=30)])
    email = StringField('Email',
                        validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Sign Up')

    def validate_email(self, responce):
        email = responce.data
        cursor = get_db_cursor()
        cursor.execute(
            'SELECT * FROM users as u WHERE u.email = (%s)',
            (email,)
        )
        user = cursor.fetchone()
        close_cursor(cursor)
        if user:
            raise ValidationError('That e-mail is already in use.')


class LoginForm(FlaskForm):
    email = StringField('Email',
                        validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    remember = BooleanField('Remember Me')
    submit = SubmitField('Login')

    def validate_email(self, responce):
        email = responce.data
        cursor = get_db_cursor()
        cursor.execute(
            'SELECT * FROM users as u WHERE u.email = (%s)',
            (email,)
        )
        user = cursor.fetchone()
        close_cursor(cursor)
        if user is None:
            raise ValidationError('e-mail does not exist.')


class UpdateAccountForm(FlaskForm):
    username = StringField('Username',
                           validators=[DataRequired(), Length(min=2, max=20)])
    email = StringField('Email',
                        validators=[DataRequired(), Email()])
    picture = FileField('Update Profile Picture', validators=[FileAllowed(['jpg', 'png'])])
    submit = SubmitField('Update')

    def validate_username(self, username):
        pass
        # if username.data != current_user.username:
        #     user = User.query.filter_by(username=username.data).first()
        #     if user:
        #         raise ValidationError('That username is taken. Please choose a different one.')

    def validate_email(self, email):
        pass
        # if email.data != current_user.email:
        #     user = User.query.filter_by(email=email.data).first()
        #     if user:
        #         raise ValidationError('That email is taken. Please choose a different one.')


class RequestResetForm(FlaskForm):
    email = StringField('Email',
                        validators=[DataRequired(), Email()])
    submit = SubmitField('Request Password Reset')

    def validate_email(self, email):
        pass
        # user = User.query.filter_by(email=email.data).first()
        # if user is None:
        #     raise ValidationError('There is no account with that email. You must register first.')


class ResetPasswordForm(FlaskForm):
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password',
                                     validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Reset Password')



class NewJobForm(FlaskForm):
    title = StringField('Title', validators=[DataRequired()])
    description = TextAreaField('Description', validators=[DataRequired()])
    r = r'^[0-9]*(?:\.[0-9]{2})?$'
    money = re.compile('|'.join([
        r'^(\d*\.\d{1,2})$',  # e.g., $.50, .50, $1.50, $.5, .5
        r'^(\d+\.?)$',  # e.g., $5.
    ]))
    price = DecimalField('Price', validators=[
        DataRequired(),
        # Regexp(money, message="Wrong type for money"),
    ])

    deadline = DateField('Deadline', format='%Y-%m-%d', validators=[DataRequired()])

    submit = SubmitField('Publish')

    # def validate_price(self, responce):
    #     if float(responce.data) < 1000:
    #         raise ValidationError('HUI?')