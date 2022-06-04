

CREATE OR REPLACE FUNCTION GET_JOB_FREELANCER_WORKING_ON(fr_id integer)
RETURNS TABLE (
    job_header varchar(250), job_description varchar(650), job_price money,

    )
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