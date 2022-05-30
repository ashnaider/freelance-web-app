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




CREATE OR REPLACE FUNCTION GET_CUSTOMER_APPLICATIONS(cust_id integer) RETURNS SETOF JOB_FULL_INFO
AS $$
    BEGIN
        return query
        select
            app.description, app.date_time, app.price,
            j.id, j.header_, j.description, j.price,
            c.first_name, c.last_name, c.id, c.user_id,
            f.first_name, f.last_name, f.id, f.user_id
        from application as app
            inner join new_job as j on app.job_id = j.id
            inner join customer c on j.customer_id = c.id
            inner join freelancer f on app.freelancer_id = f.id
        where c.id = cust_id
        order by app.date_time desc;
    END;
$$ LANGUAGE plpgsql;