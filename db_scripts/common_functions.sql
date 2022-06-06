drop function if exists get_done_job_full_info(job_id_p integer, job_status_p project_status);
drop function if exists get_application(job_id_p integer, fr_id_p integer);
drop function if exists get_max_leaved_jobs_by_freelancer();
DROP FUNCTION IF EXISTS IS_APPLICATION_EXIST(job_id_p integer, fr_id_p integer);
DROP FUNCTION IF EXISTS COUNT_JOB_APPLICATIONS(job_id_p integer);
DROP FUNCTION IF EXISTS GET_ALL_JOBS();
DROP FUNCTION IF EXISTS GET_ACTIVE_JOBS();
DROP FUNCTION IF EXISTS GET_NEWEST_JOBS(newest boolean);
DROP FUNCTION IF EXISTS GET_MOST_EXPENSIVE_JOBS(most_expensive boolean);
DROP FUNCTION IF EXISTS GET_MOST_POPULAR_JOBS(most_popular boolean);
DROP FUNCTION IF EXISTS GET_APPLIED_JOBS(fr_id integer);

DROP FUNCTION IF EXISTS GET_CUSTOMER_JOBS(cust_id integer);

DROP TYPE IF EXISTS JOB_FULL_INFO CASCADE ;


create or replace function get_max_leaved_jobs_by_freelancer() returns integer
as $$
    begin
        return 2;
    end;
$$ language plpgsql;


CREATE OR REPLACE FUNCTION IS_APPLICATION_EXIST(job_id_p integer, fr_id_p integer) RETURNS boolean
AS $$
    DECLARE
         app_count NUMERIC(1);
    BEGIN
        select count(*) into app_count
        from application as a inner join freelancer as f on f.id = a.freelancer_id
        where f.id = fr_id_p and a.job_id = job_id_p;

        if app_count = 1 then
            return true;
        else
            return false;
        end if;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION COUNT_JOB_APPLICATIONS(job_id_p integer) RETURNS integer
AS $$
    DECLARE
        applications_count integer;
    BEGIN
        select count(*) into applications_count from application as a where a.job_id = job_id_p;
        return applications_count;
    END;
$$ LANGUAGE plpgsql;



CREATE TYPE JOB_FULL_INFO
AS (job_id integer, job_status project_status,
    customer_id integer, email email_domain, first_name name_domain,
    last_name name_domain, organisation_name varchar(150),
    posted timestamp, accepted timestamp, started timestamp, finished timestamp,
    job_header varchar(250), description varchar(650),
    price money, is_hourly_rate boolean,
    application_id integer, applications_count integer);


CREATE OR REPLACE FUNCTION GET_ALL_JOBS() RETURNS SETOF JOB_FULL_INFO
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
            inner join users as u on c.user_id = u.id;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_ACTIVE_JOBS() RETURNS SETOF JOB_FULL_INFO
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
        where j.is_blocked = false and c.is_blocked = false and j.status = 'new';
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GET_NEWEST_JOBS(newest boolean default true) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        if newest then
            return query
            select * from GET_ACTIVE_JOBS() as j order by j.posted desc ;
        else
            return query
            select * from GET_ACTIVE_JOBS() as j order by j.posted asc ;
        end if;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION GET_MOST_EXPENSIVE_JOBS(most_expensive boolean default true) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        if most_expensive then
            return query
            select * from GET_ACTIVE_JOBS() as j order by j.price desc ;
        else
            return query
            select * from GET_ACTIVE_JOBS() as j order by j.price asc ;
        end if;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION GET_MOST_POPULAR_JOBS(most_popular boolean default true) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        if most_popular then
            return query
            select * from GET_ACTIVE_JOBS() as j order by j.applications_count desc ;
        else
            return query
            select * from GET_ACTIVE_JOBS() as j order by j.applications_count asc ;
        end if;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION GET_APPLIED_JOBS(fr_id integer) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        return query
        select j.job_id, j.job_status, j.customer_id, email, first_name, last_name, organisation_name,
        posted, accepted, started, finished, job_header, j.description, j.price, is_hourly_rate,
        j.application_id, applications_count
        from GET_ACTIVE_JOBS() as j inner join application as a on a.job_id = j.job_id
        where a.freelancer_id = fr_id;
    END;
$$ LANGUAGE plpgsql;


create or replace function get_application(job_id_p integer, fr_id_p integer)
returns setof application
as $$
    begin
        return query
        select * from application where job_id = job_id_p and freelancer_id = fr_id_p;
    end;
$$ language plpgsql;


create or replace function get_done_job_full_info(job_id_p integer, job_status_p project_status default 'done')
returns table (
    job_id integer,
    job_posted timestamp,
    job_accepted       timestamp,
    job_started        timestamp,
    job_finished       timestamp,
    job_header        varchar(250),
    job_description    varchar(650),
    job_price money,
    is_hourly_rate boolean,
    job_status project_status,
    app_id integer,
    app_description varchar(450),
    app_price money,
    app_status application_status,
    fr_id integer,
    fr_f_name name_domain,
    fr_l_name name_domain,
    fr_email email_domain,
    cust_id integer,
    cust_f_name name_domain,
    cust_l_name name_domain,
    cust_email email_domain)
as $$
    begin
        return query
        select
               j.id, j.posted, j.accepted, j.started, j.finished,
               j.header_, j.description, j.price, j.is_hourly_rate, j.status,
               a.id, a.description, a.price, a.status, f.id, f.first_name, f.last_name, uf.email,
               c.id, c.first_name, c.last_name, uc.email
        from new_job as j
        inner join application a on a.id = j.application_id
        inner join freelancer f on a.freelancer_id = f.id
        inner join customer c on j.customer_id = c.id
        inner join users uc on c.user_id = uc.id
        inner join users uf on f.user_id = uf.id
        where job_id_p = j.id and j.status = job_status_p;
    end;
$$ language plpgsql;