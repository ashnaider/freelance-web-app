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


