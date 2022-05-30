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
