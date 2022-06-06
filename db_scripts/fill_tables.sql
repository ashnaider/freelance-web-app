insert into users (email, passwd, role) values
    ('shnaider@gmail.com',
     'pbkdf2:sha256:260000$Xy8f3Gdyh68fKtTb$9d7044b13c649c217bbff9e33ef389faba3a67fc04943bf878401a08298450ba',
     'customer'),
    ('abasov@gmail.com',
     'pbkdf2:sha256:260000$Xy8f3Gdyh68fKtTb$9d7044b13c649c217bbff9e33ef389faba3a67fc04943bf878401a08298450ba',
     'freelancer');


insert into freelancer (user_id, first_name, last_name, resume_link, specialization)
values
(2, 'albert', 'abasov', 'link_5', 'Java Developer');


insert into customer (user_id, first_name, last_name, organisation_name)
values
(1, 'anton', 'shnaider', 'Space-X');

insert into new_job (customer_id, header_, description, price, is_hourly_rate)
values
(2, 'First job', 'description for first jobs', 400, false),
(2, 'Second job', 'description for second jobs', 4, true),
(2, 'Third job', 'description for third jobs', 200, false);

insert into application (date_time, price, description, freelancer_id, job_id)
values
(current_timestamp, 500, 'i am good at first job', 1, 4),
(current_timestamp, 8, 'I can do this fast.', 1, 5);









