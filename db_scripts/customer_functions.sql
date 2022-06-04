DROP FUNCTION IF EXISTS GET_JOB_PERFORMER(cust_id_p integer, job_id_p integer);

DROP FUNCTION IF EXISTS GET_CUSTOMER_NEW_JOBS(cust_id integer);
DROP FUNCTION IF EXISTS GET_CUSTOMER_IN_PROGRESS_JOBS(cust_id integer);
DROP FUNCTION IF EXISTS GET_CUSTOMER_DONE_JOBS(cust_id integer);

DROP FUNCTION IF EXISTS GET_ACTIVE_CUSTOMER_APPLICATIONS(cust_id integer);
DROP FUNCTION IF EXISTS GET_ALL_CUSTOMER_APPLICATIONS(cust_id_p integer);

DROP FUNCTION IF EXISTS GET_CUSTOMER_JOB(cust_id_p integer, job_id_p integer);
DROP FUNCTION IF EXISTS GET_CUSTOMER_JOBS(cust_id integer);

DROP TYPE IF EXISTS CUSTOMER_APPLICATION;


CREATE OR REPLACE FUNCTION GET_CUSTOMER_JOBS(cust_id integer) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        return query
        select j.id, j.status, c.id, u.email, c.first_name, c.last_name, c.organisation_name,
               j.posted, j.started, j.finished,
               j.header_ as job_header,
               j.description, j.price, j.is_hourly_rate,
               j.application_id, COUNT_JOB_APPLICATIONS(j.id) as applications_count
        from new_job as j
            inner join customer as c on c.id = j.customer_id
            inner join users as u on c.user_id = u.id
        where j.customer_id = cust_id
        order by j.posted desc ;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_CUSTOMER_JOB(cust_id_p integer, job_id_p integer) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        return query
        select * from GET_CUSTOMER_JOBS(cust_id_p) as jobs
        where jobs.job_id = job_id_p;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_CUSTOMER_NEW_JOBS(cust_id integer) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        return query
        select * from GET_CUSTOMER_JOBS(cust_id) as jobs where jobs.job_status = 'new';
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_CUSTOMER_IN_PROGRESS_JOBS(cust_id integer) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        return query
        select * from GET_CUSTOMER_JOBS(cust_id) as jobs where jobs.job_status = 'in progress';
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_CUSTOMER_DONE_JOBS(cust_id integer) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        return query
        select * from GET_CUSTOMER_JOBS(cust_id) as jobs where jobs.job_status = 'done';
    END;
$$ LANGUAGE plpgsql;


CREATE TYPE CUSTOMER_APPLICATION
AS (app_id integer, app_description varchar(450), app_time timestamp, app_price money,
    job_id integer, job_status project_status,
    job_header varchar(250), job_description varchar(650), job_price money,
    cust_f_name name_domain, cust_l_name name_domain, cust_id integer, cust_blocked boolean,
    fr_f_name name_domain, fr_l_name name_domain, fr_id integer, fr_email email_domain, fr_blocked boolean);


CREATE OR REPLACE FUNCTION GET_ALL_CUSTOMER_APPLICATIONS(cust_id_p integer)
RETURNS SETOF CUSTOMER_APPLICATION
AS $$
    BEGIN
        return query
        select
            app.id, app.description, app.date_time, app.price,
            j.id, j.status, j.header_, j.description, j.price,
            c.first_name, c.last_name, c.id, c.is_blocked,
            f.first_name, f.last_name, f.id, u.email, f.is_blocked
        from application as app
            inner join new_job as j on app.job_id = j.id
            inner join customer as c on j.customer_id = c.id
            inner join freelancer as f on app.freelancer_id = f.id
            inner join users as u on f.user_id = u.id
        where c.id = cust_id_p
        order by app.date_time desc;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_ACTIVE_CUSTOMER_APPLICATIONS(cust_id_p integer)
RETURNS SETOF CUSTOMER_APPLICATION
AS $$
    BEGIN
        return query
        select * from GET_ALL_CUSTOMER_APPLICATIONS(cust_id_p) as apps
        where apps.job_status = 'new' and apps.cust_blocked = false and apps.fr_blocked = false;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_JOB_PERFORMER(cust_id_p integer, job_id_p integer)
RETURNS SETOF CUSTOMER_APPLICATION
AS $$
    BEGIN
        return query
        select * from GET_ALL_CUSTOMER_APPLICATIONS(cust_id_p) where job_id = job_id_p;
    END;
$$ LANGUAGE plpgsql;


