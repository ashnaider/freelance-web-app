DROP FUNCTION IF EXISTS GET_CUSTOMER_APPLICATIONS(cust_id integer);
DROP FUNCTION IF EXISTS GET_CUSTOMER_JOBS(cust_id integer);

CREATE OR REPLACE FUNCTION GET_CUSTOMER_JOBS(cust_id integer) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        return query
        select j.id, c.id, u.email, c.first_name, c.last_name, c.organisation_name, j.posted, j.header_ as job_header,
               j.description, j.price, j.is_hourly_rate, COUNT_JOB_APPLICATIONS(j.id) as applications_count
        from new_job as j
            inner join customer as c on c.id = j.customer_id
            inner join users as u on c.user_id = u.id
        where j.customer_id = cust_id
        order by j.posted desc ;
    END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION GET_CUSTOMER_APPLICATIONS(cust_id_p integer)
RETURNS TABLE (app_id integer, app_description varchar(450), app_time timestamp, app_price money,
            job_id integer, job_header varchar(255), job_description varchar(650), job_price money,
            cust_f_name name_domain, cust_l_name name_domain, cust_id integer,
            fr_f_name name_domain, fr_l_name name_domain, fr_id integer)
AS $$
    BEGIN
        return query
        select
            app.id, app.description as app_description, app.date_time as app_time, app.price as app_price,
            j.id as job_id, j.header_ as job_header, j.description as job_description, j.price as job_price,
            c.first_name as cust_f_name, c.last_name as cust_l_name, c.id as cust_id,
            f.first_name as fr_f_name, f.last_name as fr_l_name, f.id as fr_id
        from application as app
            inner join new_job as j on app.job_id = j.id
            inner join customer as c on j.customer_id = c.id
            inner join freelancer as f on app.freelancer_id = f.id
        where c.id = cust_id_p
        order by app.date_time desc;
    END;
$$ LANGUAGE plpgsql;


-- CREATE OR REPLACE FUNCTION GET_JOB_APPLICATIONS(job_id_p integer)
-- RETURNS TABLE (app_id integer, app_description varchar(450), app_time timestamp, app_price money,
--             job_id integer, job_header varchar(255), job_description varchar(650), job_price money,
--             cust_f_name name_domain, cust_l_name name_domain, cust_id integer,
--             fr_f_name name_domain, fr_l_name name_domain, fr_id integer)
-- AS $$
--     BEGIN
--         return query
--         select
--             app.id, app.description as app_description, app.date_time as app_time, app.price as app_price,
--             j.id as job_id, j.header_ as job_header, j.description as job_description, j.price as job_price,
--             c.first_name as cust_f_name, c.last_name as cust_l_name, c.id as cust_id,
--             f.first_name as fr_f_name, f.last_name as fr_l_name, f.id as fr_id
--         from application as app
--             inner join new_job as j on app.job_id = j.id
--             inner join customer as c on j.customer_id = c.id
--             inner join freelancer as f on app.freelancer_id = f.id
--         where c.id = cust_id_p
--         order by app.date_time desc;
--     END;
-- $$ LANGUAGE plpgsql;


