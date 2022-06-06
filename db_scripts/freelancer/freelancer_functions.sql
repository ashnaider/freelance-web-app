drop function if exists get_freelancer_finished_jobs(fr_id_p integer);
drop function if exists get_freelancer_unfinished_jobs(fr_id_p integer);
drop function if exists get_freelancer(user_id_p integer);
drop function if exists edit_freelancer(fr_id_p integer,
                                           first_name_p name_domain,
                                           last_name_p name_domain,
                                           resume_link_p varchar(250),
                                           specialization_p varchar(250));

drop function if exists delete_new_applications_of_freelancer(fr_id_p integer);
DROP FUNCTION IF EXISTS GET_JOB_FREELANCER_WORKING_ON(fr_id integer);
drop function if exists apply_for_job_by_freelancer(job_id_p integer,
                                                    fr_id_p integer,
                                                    price_p float,
                                                    description_p varchar(450));

drop function if exists remove_job_application_by_freelancer(job_id_p integer, fr_id_p integer);

drop function if exists start_doing_job_by_freelancer(fr_id_p integer);
drop function if exists finish_doing_job_by_freelancer(fr_id_p integer);
drop function if exists leave_job_by_freelancer(fr_id_p integer);


create or replace function get_freelancer(user_id_p integer)
returns table (freelancer_id integer,
               email email_domain,
               role user_role,
               first_name name_domain,
               last_name name_domain,
               resume_link varchar(250),
               specialization varchar(250),
               job_id_working_on integer,
               unfinished_jobs_count integer,
               is_blocked boolean)
as
$$
    begin
        return query
        select f.id, u.email, u.role,
               f.first_name, f.last_name,  f.resume_link, f.specialization,
               f.job_id_working_on, f.unfinished_jobs_count, f.is_blocked
        from freelancer as f inner join users as u on f.user_id = u.id where f.user_id = user_id_p;
    end;
$$ language plpgsql;


CREATE OR REPLACE FUNCTION GET_JOB_FREELANCER_WORKING_ON(fr_id integer)
    RETURNS TABLE
            (
                job_id          integer,
                job_header      varchar(250),
                job_description varchar(650),
                job_status      project_status,
                job_posted      timestamp,
                job_accepted    timestamp,
                job_started     timestamp,
                job_finished    timestamp,
                job_price       money,
                is_hourly_rate  boolean,
                app_id          integer,
                app_description varchar(450),
                app_price       money,
                cust_id         integer,
                cust_f_name     name_domain,
                cust_l_name     name_domain,
                cust_email      email_domain,
                cust_is_blocked boolean
            )
AS
$$
    DECLARE
        job_id_freelancer_working_on integer;
BEGIN
        select into job_id_freelancer_working_on job_id_working_on from freelancer where id = fr_id;
    return query
        select j.id,
               j.header_,
               j.description,
               j.status,
               j.posted,
               j.accepted,
               j.started,
               j.finished,
               j.price,
               j.is_hourly_rate,
               a.id,
               a.description,
               a.price,
               c.id,
               c.first_name,
               c.last_name,
               u.email,
               c.is_blocked
        from new_job as j
        inner join application a on j.application_id = a.id
        inner join customer c on j.customer_id = c.id
        inner join users u on c.user_id = u.id
        where j.id = job_id_freelancer_working_on;
END;
$$ LANGUAGE plpgsql;



create or replace function start_doing_job_by_freelancer(fr_id_p integer)
    returns integer
as
$$
declare
    curr_job_id_t integer;
begin
    select into curr_job_id_t job_id_working_on from freelancer where id = fr_id_p;

    if not curr_job_id_t is null and is_application_exist(curr_job_id_t, fr_id_p) then
        update freelancer set started_doing_job = true where id = fr_id_p;

        update new_job
        set status  = 'in progress',
            started = current_timestamp
        where id = curr_job_id_t;
    else
        raise exception E'Freelancer has no job to do!';
    end if;

    return 1;
end;
$$ language plpgsql;


create or replace function finish_doing_job_by_freelancer(fr_id_p integer)
    returns integer
as
$$
declare
    job_id_t integer;
begin
    select into job_id_t job_id_working_on from freelancer where id = fr_id_p;

    if job_id_t is null then
        return 0;
    end if;

    update freelancer set job_id_working_on = null, started_doing_job = false where id = fr_id_p;
    update new_job set status = 'done', finished = current_timestamp where id = job_id_t;

    return 1;
end;
$$ language plpgsql;


create or replace function apply_for_job_by_freelancer(job_id_p integer,
                                                       fr_id_p integer,
                                                       price_p float,
                                                       description_p varchar(450))
    returns integer
as
$$
begin
    if price_p <= 0 then
        raise exception 'Unable to apply for job. Got negative price!';
    end if;

    insert into application (price, description, freelancer_id, job_id)
    values (price_p::float8::numeric::money, description_p, fr_id_p, job_id_p);

    return 1;
end;
$$ language plpgsql;


create or replace function remove_job_application_by_freelancer(job_id_p integer, fr_id_p integer)
    returns integer
as
$$
begin
    delete from application as app where app.job_id = job_id_p and app.freelancer_id = fr_id_p;

    return 1;
end;
$$ language plpgsql;


create or replace function leave_job_by_freelancer(fr_id_p integer)
    returns integer
as
$$
declare
    job_id_t            integer;
    job_status          project_status;
    leave_attempts_left integer;
begin

    select into leave_attempts_left get_max_leaved_jobs_by_freelancer() - unfinished_jobs_count
    from freelancer
    where id = fr_id_p;

    select into job_id_t job_id_working_on from freelancer as f where f.id = fr_id_p;

    if job_id_t is null then
        return leave_attempts_left;
    end if;

    select into job_status status from new_job as j where j.id = job_id_t;

    if job_status = 'accepted' or job_status = 'in progress' then

        update freelancer
        set job_id_working_on     = null,
            unfinished_jobs_count = (unfinished_jobs_count + 1)
        where id = fr_id_p;

        update new_job set status = 'unfinished' where id = job_id_t;
    else
        raise exception 'Freelancer is not working on this job!';
    end if;

    return leave_attempts_left - 1;
end;
$$ language plpgsql;


create or replace function delete_new_applications_of_freelancer(fr_id_p integer) returns integer
as
$$
begin
    delete from application where freelancer_id = fr_id_p and status = 'new';

    return 1;
end;
$$ language plpgsql;


create or replace function edit_freelancer(fr_id_p integer,
                                           first_name_p name_domain,
                                           last_name_p name_domain,
                                           resume_link_p varchar(250),
                                           specialization_p varchar(250))
    returns integer
as
$$
begin
    update freelancer
    set first_name     = first_name_p,
        last_name      = last_name_p,
        resume_link    = resume_link_p,
        specialization = specialization_p
    where id = fr_id_p;

    return 1;
end;
$$ language plpgsql;


create or replace function get_freelancer_unfinished_jobs(fr_id_p integer)
returns table (
                job_id          integer,
                job_header      varchar(250),
                job_description varchar(650),
                job_status      project_status,
                job_posted      timestamp,
                job_accepted    timestamp,
                job_started     timestamp,
                job_finished    timestamp,
                job_price       money,
                is_hourly_rate  boolean,
                app_id          integer,
                app_description varchar(450),
                app_price       money,
                cust_id         integer,
                cust_f_name     name_domain,
                cust_l_name     name_domain,
                cust_email      email_domain,
                cust_is_blocked boolean
              )
as
$$
    begin
        return query
        select
        j.id, j.header_, j.description, j.status, j.posted, j.accepted, j.started, j.finished, j.price, j.is_hourly_rate,
        a.id, a.description, a.price, c.id, c.first_name, c.last_name, u.email, c.is_blocked
        from application as a
        inner join new_job j on a.id = j.application_id
        inner join customer c on j.customer_id = c.id
        inner join users u on c.user_id = u.id
        where a.freelancer_id = fr_id_p and j.status = 'unfinished';
    end;
$$ language plpgsql;


create or replace function get_freelancer_finished_jobs(fr_id_p integer)
returns table (
                job_id          integer,
                job_header      varchar(250),
                job_description varchar(650),
                job_status      project_status,
                job_posted      timestamp,
                job_accepted    timestamp,
                job_started     timestamp,
                job_finished    timestamp,
                job_price       money,
                is_hourly_rate  boolean,
                app_id          integer,
                app_description varchar(450),
                app_price       money,
                cust_id         integer,
                cust_f_name     name_domain,
                cust_l_name     name_domain,
                cust_email      email_domain,
                cust_is_blocked boolean
              )
as
$$
    begin
        return query
        select
        j.id, j.header_, j.description, j.status, j.posted, j.accepted, j.started, j.finished, j.price, j.is_hourly_rate,
        a.id, a.description, a.price, c.id, c.first_name, c.last_name, u.email, c.is_blocked
        from application as a
        inner join new_job j on a.id = j.application_id
        inner join customer c on j.customer_id = c.id
        inner join users u on c.user_id = u.id
        where a.freelancer_id = fr_id_p and j.status = 'done';
    end;
$$ language plpgsql;
