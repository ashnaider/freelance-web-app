drop function if exists get_customer(user_id_p integer);

drop function if exists create_job(cust_id_p integer,
                                      header_p varchar(250),
                                      description_p varchar(650),
                                      price_p float,
                                      is_hourly_rate_p boolean);

drop function if exists update_job(job_id_p integer,
                                      header_p varchar(250),
                                      description_p varchar(650),
                                      price_p float,
                                      is_hourly_rate_p boolean);

drop function if exists delete_job(job_id_p integer);
drop function if exists edit_customer_profile(cust_id_p integer,
                                                 first_name_p name_domain,
                                                 last_name_p name_domain,
                                                 organisation_name_p varchar(150));

drop function if exists accept_application_for_job(app_id_p integer, job_id_p integer);

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
               j.posted, j.accepted, j.started, j.finished,
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
        select * from GET_CUSTOMER_JOBS(cust_id) as jobs
        where jobs.job_status = 'in progress' or jobs.job_status = 'accepted';
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


create or replace function accept_application_for_job(app_id_p integer, job_id_p integer)
returns integer
as $$
    begin
        update new_job set application_id = app_id_p, status = 'accepted', accepted = CURRENT_TIMESTAMP
        where new_job.id = job_id_p;

        update application set status = 'accepted' where id = app_id_p;

        return 1;
    end;
$$ language plpgsql;


create or replace function delete_other_applications_for_job(job_id_p integer)
returns integer
as $$
    declare
        job_app_id_t integer;
    begin
        select into job_app_id_t application_id from new_job where id = job_id_p;

        if job_app_id_t is null then
            raise exception 'Unable to delete other job applications, because job does not have accepted application';
        end if;

        delete from application where job_id = job_id_p and id <> job_app_id_t and status = 'new';

        return 1;
    end;
$$ language plpgsql;


create or replace function edit_customer_profile(cust_id_p integer,
                                                 first_name_p name_domain,
                                                 last_name_p name_domain,
                                                 organisation_name_p varchar(150))
returns integer
as $$
    begin
        update customer set first_name = first_name_p,
                            last_name = last_name_p,
                            organisation_name = organisation_name_p
        where id = cust_id_p;
        return 1;
    end;
$$ language plpgsql;


create or replace function delete_job(job_id_p integer)
returns integer
as $$
    begin
        delete from new_job where id = job_id_p;

        return 1;
    end;
$$ language plpgsql;


create or replace function update_job(job_id_p integer,
                                      header_p varchar(250),
                                      description_p varchar(650),
                                      price_p float,
                                      is_hourly_rate_p boolean)
returns integer
as $$
    begin
        update new_job set header_ = header_p,
                           description = description_p,
                           price = price_p::float8::numeric::money,
                           is_hourly_rate = is_hourly_rate_p
        where id = job_id_p ;

        return 1;
    end;
$$ language plpgsql;


create or replace function create_job(cust_id_p integer,
                                      header_p varchar(250),
                                      description_p varchar(650),
                                      price_p float,
                                      is_hourly_rate_p boolean)
returns integer
as $$
    begin
        insert into new_job (customer_id, header_, description, price, is_hourly_rate)
        values (cust_id_p, header_p, description_p, price_p::float8::numeric::money, is_hourly_rate_p);

        return 1;
    end;
$$ language plpgsql;


create or replace function get_customer(user_id_p integer)
returns table (customer_id integer,
               email email_domain,
               role user_role,
               first_name name_domain,
               last_name name_domain,
               organisation_name varchar(150),
               is_blocked boolean)
as $$
    begin
        return query
        select c.id as customer_id, u.email, u.role, c.first_name, c.last_name, c.organisation_name, c.is_blocked
        from customer as c inner join users as u on c.user_id = u.id where user_id = user_id_p;
    end;
$$ language plpgsql;