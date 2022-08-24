drop function if exists block_customer(cust_id_p integer);
drop function if exists unblock_customer(cust_id_p integer);
drop function if exists get_customer_unfinished_jobs(cust_id_p integer);
drop function if exists get_customer_done_jobs(cust_id_p integer);
drop function if exists get_customer_in_progress_jobs(cust_id_p integer);
DROP FUNCTION IF EXISTS GET_CUSTOMER_NEW_JOBS(cust_id integer);
drop function if exists get_customer_jobs_with_app_and_users(cust_id_p integer);

drop type if exists job_with_app_and_users;

drop function if exists get_max_leaved_jobs_by_customer();
drop function if exists delete_new_jobs_of_customer(cust_id_p integer);
drop function if exists leave_job_by_customer(job_id_p integer);
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


DROP FUNCTION IF EXISTS GET_NEW_APPLICATION(app_id_p integer);
DROP FUNCTION IF EXISTS GET_ALL_NEW_APPLICATIONS();
DROP FUNCTION IF EXISTS GET_ACTIVE_CUSTOMER_APPLICATIONS(cust_id integer);
DROP FUNCTION IF EXISTS GET_ALL_CUSTOMER_APPLICATIONS(cust_id_p integer);

DROP FUNCTION IF EXISTS GET_CUSTOMER_JOB(cust_id_p integer, job_id_p integer);
DROP FUNCTION IF EXISTS GET_CUSTOMER_JOBS(cust_id integer);

DROP TYPE IF EXISTS CUSTOMER_APPLICATION;

drop function if exists get_blocked_customers_private_info();
drop function if exists get_active_customers_private_info();
drop function if exists get_customer_private_info(cust_id_p integer);
drop function if exists get_customers_private_info();
drop function if exists count_customer_attempts_to_leave(cust_id_p integer);
drop function if exists calculate_hourly_rate_project_total_price(finished_job_id integer);
drop function if exists count_customer_total_money_spent(cust_id_p integer);
drop function if exists count_customer_avg_job_price(cust_id_p integer);
drop function if exists count_customer_unfinished_jobs(cust_id_p integer);
drop function if exists count_customer_finished_jobs(cust_id_p integer);
drop function if exists count_customer_in_progress_jobs(cust_id_p integer);
drop function if exists count_customer_new_jobs(cust_id_p integer);

DROP TYPE IF EXISTS customer_private_info;


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


create type job_with_app_and_users
as (
                job_id          integer,
                job_header      varchar(250),
                job_description varchar(650),
                job_status      project_status,
                job_posted      timestamp,
                job_accepted    timestamp,
                job_started     timestamp,
                job_finished    timestamp,
                job_price       money,
                job_is_blocked  boolean,
                is_hourly_rate  boolean,
                app_id          integer,
                app_description varchar(450),
                app_price       money,
                cust_id         integer,
                cust_f_name     name_domain,
                cust_l_name     name_domain,
                cust_email      email_domain,
                cust_is_blocked boolean,
                fr_id integer,
                fr_f_name name_domain,
                fr_l_name name_domain,
                fr_email email_domain,
                fr_id_blocked boolean
              );


create or replace function get_customer_jobs_with_app_and_users(cust_id_p integer)
returns setof job_with_app_and_users
as
$$
    begin
        return query
        select
        j.id, j.header_, j.description, j.status,
        j.posted, j.accepted, j.started, j.finished, j.price, j.is_blocked, j.is_hourly_rate,
        a.id, a.description, a.price, c.id, c.first_name, c.last_name, u.email, c.is_blocked,
        f.id, f.first_name, f.last_name, u2.email, f.is_blocked
        from application as a
        inner join new_job j on a.id = j.application_id
        inner join customer c on j.customer_id = c.id
        inner join freelancer f on a.freelancer_id = f.id
        inner join users u on c.user_id = u.id
        inner join users u2 on a.freelancer_id = u2.id
        where j.customer_id = cust_id_p;
    end;
$$ language plpgsql;


create or replace function get_customer_in_progress_jobs(cust_id_p integer)
returns setof job_with_app_and_users
as
$$
    begin
        return query
        select * from get_customer_jobs_with_app_and_users(cust_id_p)
        where job_status = 'accepted' or job_status = 'in progress'
        order by job_accepted;
    end;
$$ language plpgsql;

create or replace function get_customer_done_jobs(cust_id_p integer)
returns setof job_with_app_and_users
as
$$
    begin
        return query
        select * from get_customer_jobs_with_app_and_users(cust_id_p)
        where job_status = 'done'
        order by job_finished;
    end;
$$ language plpgsql;

create or replace function get_customer_unfinished_jobs(cust_id_p integer)
returns setof job_with_app_and_users
as
$$
    begin
        return query
        select * from get_customer_jobs_with_app_and_users(cust_id_p)
        where job_status = 'unfinished'
        order by job_accepted;
    end;
$$ language plpgsql;


CREATE TYPE CUSTOMER_APPLICATION
AS (app_id integer, app_description varchar(450), app_time timestamp, app_price money,
    job_id integer, job_status project_status, job_is_blocked boolean,
    job_header varchar(250), job_description varchar(650), job_price money,
    cust_f_name name_domain, cust_l_name name_domain, cust_id integer, cust_email email_domain, cust_blocked boolean,
    fr_f_name name_domain, fr_l_name name_domain, fr_id integer, fr_email email_domain, fr_blocked boolean);


CREATE OR REPLACE FUNCTION GET_ALL_NEW_APPLICATIONS()
RETURNS SETOF CUSTOMER_APPLICATION
AS
$$
    begin
        return query
        select
            app.id, app.description, app.date_time, app.price,
            j.id, j.status, j.is_blocked, j.header_, j.description, j.price,
            c.first_name, c.last_name, c.id, u2.email, c.is_blocked,
            f.first_name, f.last_name, f.id, u.email, f.is_blocked
        from application as app
            inner join new_job as j on app.job_id = j.id
            inner join customer as c on j.customer_id = c.id
            inner join freelancer as f on app.freelancer_id = f.id
            inner join users as u on f.user_id = u.id
            inner join users as u2 on c.user_id = u2.id
        where app.status = 'new'
        order by app.date_time desc;
    end;
$$ language plpgsql;


CREATE OR REPLACE FUNCTION GET_NEW_APPLICATION(app_id_p integer)
RETURNS SETOF CUSTOMER_APPLICATION
AS
$$
    begin
        return query
        select * from get_all_new_applications()
        where app_id = app_id_p;

    end;
$$ language plpgsql;


CREATE OR REPLACE FUNCTION GET_ALL_CUSTOMER_APPLICATIONS(cust_id_p integer)
RETURNS SETOF CUSTOMER_APPLICATION
AS $$
    BEGIN
        return query
        select
            app.id, app.description, app.date_time, app.price,
            j.id, j.status, j.is_blocked, j.header_, j.description, j.price,
            c.first_name, c.last_name, c.id, u2.email, c.is_blocked,
            f.first_name, f.last_name, f.id, u.email, f.is_blocked
        from application as app
            inner join new_job as j on app.job_id = j.id
            inner join customer as c on j.customer_id = c.id
            inner join freelancer as f on app.freelancer_id = f.id
            inner join users as u on f.user_id = u.id
            inner join users as u2 on c.user_id = u2.id
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


create or replace function leave_job_by_customer(job_id_p integer)
returns integer
as
$$
    declare
        cust_id_t integer;
        leave_attempts_left integer;
        job_status_t project_status;
    begin
        select into cust_id_t customer_id from new_job where id = job_id_p;

        select into leave_attempts_left get_max_leaved_jobs_by_customer() - unfinished_jobs_count
        from customer
        where id = cust_id_t;

        select into job_status_t status from new_job where id = job_id_p;
--
        if (job_status_t = 'accepted') or (job_status_t = 'in progress') then
            --- Change job status ---
            update new_job set status = 'unfinished'
            where id = job_id_p;

            --- Freeing freelancer from this job ---
            update freelancer set job_id_working_on = null where job_id_working_on = job_id_p;

            --- Getting customer of this job ---
            select into cust_id_t customer_id from new_job where id = job_id_p;

            --- Increasing unfinished jobs counter by one ---
            update customer set unfinished_jobs_count = unfinished_jobs_count + 1 where id = cust_id_t;

            return leave_attempts_left - 1;
        end if;

        return leave_attempts_left;
    end;
$$ language plpgsql;


create or replace function delete_new_jobs_of_customer(cust_id_p integer)
returns integer
as
$$
    begin
        delete from new_job where customer_id = cust_id_p and status = 'new';

        return 1;
    end;
$$ language plpgsql;


create or replace function get_max_leaved_jobs_by_customer() returns integer
as $$
    begin
        return 2;
    end;
$$ language plpgsql;


create or replace function count_customer_new_jobs(cust_id_p integer)
returns integer
as
$$
    declare
        new_jobs_count integer;
    begin
        select into new_jobs_count count(*) from get_customer_new_jobs(cust_id := cust_id_p);

        return new_jobs_count;
    end;
$$ language plpgsql;


create or replace function count_customer_in_progress_jobs(cust_id_p integer)
returns integer
as
$$
    declare
        jobs_count integer;
    begin
        select into jobs_count count(*) from get_customer_in_progress_jobs(cust_id_p);
        return jobs_count;
    end;
$$ language plpgsql;


create or replace function count_customer_finished_jobs(cust_id_p integer)
returns integer
as
$$
    declare
        jobs_count integer;
    begin
        select into jobs_count count(*) from get_customer_done_jobs(cust_id_p);
        return jobs_count;
    end;
$$ language plpgsql;


create or replace function count_customer_unfinished_jobs(cust_id_p integer)
returns integer
as
$$
    declare
        jobs_count integer;
    begin
        select into jobs_count count(*) from get_customer_unfinished_jobs(cust_id_p);
        return jobs_count;
    end;
$$ language plpgsql;


create or replace function calculate_hourly_rate_project_total_price(finished_job_id integer)
returns integer
as
$$
    declare
        app_price integer;
        is_hourly_rate_t boolean;
        job_finished_t boolean;
        job_duration_in_hours_t integer;
        final_price integer;
    begin
        --- Check if job done ---
        select into job_finished_t (status = 'done') from new_job where id = finished_job_id;
        if job_finished_t = false then
            return 0;
        end if;

        --- Get application price ---
        select into app_price app.price::numeric from application as app
            inner join new_job nj on app.id = nj.application_id where nj.id = finished_job_id;

        --- Check if job is hourly rate ---
        select into is_hourly_rate_t is_hourly_rate from new_job where id = finished_job_id;
        if is_hourly_rate_t = false then
            return app_price;
        end if;

        -- Count job duration in hours ---
        select into job_duration_in_hours_t (abs(extract(epoch from new_job.finished - new_job.started)/3600))
        from new_job where id = finished_job_id;

        --- Count job working hours ---
        select into job_duration_in_hours_t (job_duration_in_hours_t / 24 * 8 + job_duration_in_hours_t % 24 * 8);

        --- Calculating final job price ---
        select into final_price (job_duration_in_hours_t * app_price::numeric);

        if final_price = 0 then
            return app_price;
        end if;

        return final_price;
    end;
$$ language plpgsql;


create or replace function count_customer_total_money_spent(cust_id_p integer)
returns integer
as
$$
    declare
        money_spent_projects integer;
        money_spent_by_hours integer;
    begin
        select into money_spent_projects sum(app_price)::numeric
        from get_customer_done_jobs(cust_id_p)
        where is_hourly_rate = false;

        select into money_spent_by_hours sum(calculate_hourly_rate_project_total_price(job_id))
        from get_customer_done_jobs(cust_id_p)
        where is_hourly_rate = true;

        return money_spent_projects + money_spent_by_hours;
    end;
$$ language plpgsql;


create or replace function count_customer_avg_job_price(cust_id_p integer)
returns integer
as
$$
    declare
        avg_project_price integer;
        avg_per_hour_price integer;
    begin
--         select into avg_project_price avg(app_price::numeric)::numeric
--         from get_customer_done_jobs(cust_id_p)
--         where is_hourly_rate = false;
--
--         select into avg_per_hour_price avg(calculate_hourly_rate_project_total_price(job_id))::numeric
--         from get_customer_done_jobs(cust_id_p)
--         where is_hourly_rate = true;
--
--         return (avg_project_price + avg_per_hour_price) / 2;

        return count_customer_total_money_spent(cust_id_p) / count_customer_finished_jobs(cust_id_p);
    end;
$$ language plpgsql;


create or replace function count_customer_attempts_to_leave(cust_id_p integer)
returns integer
as
$$
    declare
         attempts_to_leave integer;
    begin
        select into attempts_to_leave get_max_leaved_jobs_by_customer() - unfinished_jobs_count
        from customer
        where id = cust_id_p;

        if attempts_to_leave < 0 then
            return 0;
        end if;

        return attempts_to_leave;
    end;
$$ language plpgsql;


create type customer_private_info as ( id integer,
                                       first_name name_domain,
                                       last_name name_domain,
                                       email email_domain,
                                       organisation_name varchar(150),
                                       is_blocked boolean,
                                       attempts_to_leave_before_get_blocked integer,
                                       new_jobs_count integer,
                                       in_progress_jobs_count integer,
                                       unfinished_jobs_count integer,
                                       finished_jobs_count integer,
                                       total_money_spent integer,
                                       avg_job_price integer);


create or replace function get_customers_private_info()
returns setof customer_private_info
as
$$
    begin
        return query
        select c.id, c.first_name, c.last_name, u.email, c.organisation_name, c.is_blocked,
               count_customer_attempts_to_leave(c.id),
               count_customer_new_jobs(c.id),
               count_customer_in_progress_jobs(c.id),
               count_customer_unfinished_jobs(c.id),
               count_customer_finished_jobs(c.id),
               count_customer_total_money_spent(c.id),
               count_customer_avg_job_price(c.id)
        from customer as c inner join users as u on c.user_id = u.id;
    end;
$$ language plpgsql;

create or replace function get_customer_private_info(cust_id_p integer)
returns setof customer_private_info
as
$$
    begin
        return query
        select * from get_customers_private_info() where id = cust_id_p;
    end;
$$ language plpgsql;



create or replace function get_active_customers_private_info()
returns setof customer_private_info
as
$$
    begin
        return query
        select * from get_customers_private_info()
        where is_blocked = false
        order by finished_jobs_count desc ;
    end;
$$ language plpgsql;



create or replace function get_blocked_customers_private_info()
returns setof customer_private_info
as
$$
    begin
        return query
        select * from get_customers_private_info()
        where is_blocked = true
        order by unfinished_jobs_count desc ;
    end;
$$ language plpgsql;


create or replace function unblock_customer(cust_id_p integer)
returns integer
as
$$
    begin
        update customer set is_blocked = false where id = cust_id_p;
        return 1;
    end;
$$ language plpgsql;


create or replace function block_customer(cust_id_p integer)
returns integer
as
$$
    begin
        update customer set is_blocked = true where id = cust_id_p;
        return 1;
    end;
$$ language plpgsql;