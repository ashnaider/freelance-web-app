from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from wtforms import StringField, PasswordField, SubmitField, \
    BooleanField, TextAreaField, DateTimeField, FloatField, \
    DecimalField, DateField, BooleanField
from wtforms.widgets import TextArea
from wtforms.validators import DataRequired, Length, Email, EqualTo, ValidationError, Regexp
# from flask_login import current_user
# from flaskblog.models import User
from datetime import date
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

    price = DecimalField('Price', validators=[DataRequired()])

    # deadline = DateField('Deadline', format='%Y-%m-%d', validators=[DataRequired()])

    submit = SubmitField('Publish')

    # def validate_deadline(self, deadline):
    #     if deadline.data <= date.today():
    #         raise ValidationError('Deadline should be later that today\'s date')

    def validate_title(self, title):
        cursor = get_db_cursor()
        cursor.execute(
            'SELECT * FROM new_job as nj WHERE nj.header_ = (%s)',
            (title.data,)
        )
        record = cursor.fetchone()
        close_cursor(cursor)
        if record:
            raise ValidationError('Job with this header already exist.')



class FreelancerProfileForm(FlaskForm):
    email = StringField('Email')
    first_name = StringField('First name', validators=[DataRequired(), Length(min=2, max=50)])
    last_name = StringField('Last name', validators=[DataRequired(), Length(min=2, max=50)])

    resume_link = StringField('Resume link')
    specialization = StringField('Specialization', validators=[DataRequired(), Length(min=2, max=50)])

    submit = SubmitField('Update')


class CustomerProfileForm(FlaskForm):
    email = StringField('Email')
    first_name = StringField('First name', validators=[DataRequired(), Length(min=2, max=50)])
    last_name = StringField('Last name', validators=[DataRequired(), Length(min=2, max=50)])

    organisation_name = StringField('Organization name')

    submit = SubmitField('Update')


class JobApplication(FlaskForm):
    description = TextAreaField('Description', validators=[DataRequired()])
    price = DecimalField('Your price', validators=[DataRequired()])

    submit = SubmitField('Apply')
    cancel = SubmitField('Cancel application')

