DROP TRIGGER IF EXISTS CHECK_IF_CUSTOMER_CAN_CREATE_NEW_JOB_F ON new_job;
DROP FUNCTION IF EXISTS CHECK_IF_CUSTOMER_CAN_CREATE_NEW_JOB_F();

DROP TRIGGER IF EXISTS DELETE_APPLICATIONS_WHEN_JOB_BLOCKED ON new_job;
DROP FUNCTION IF EXISTS DELETE_APPLICATIONS_WHEN_JOB_BLOCKED_F();

DROP TRIGGER IF EXISTS DELETE_APPLICATIONS_DEPENDING_ON_JOB ON new_job;
DROP FUNCTION IF EXISTS DELETE_APPLICATIONS_DEPENDING_ON_JOB_F();

DROP TRIGGER IF EXISTS UNBLOCK_CUSTOMER on customer;
DROP FUNCTION IF EXISTS UNBLOCK_CUSTOMER_F();

DROP TRIGGER IF EXISTS BLOCK_CUSTOMER_WHEN_MANY_UNFINISHED_JOBS on customer;
DROP FUNCTION IF EXISTS BLOCK_CUSTOMER_WHEN_MANY_UNFINISHED_JOBS_F();

drop trigger if exists DELETE_OTHER_APPLICATION_WHEN_THIS_ACCEPTED on application;
drop function if exists DELETE_OTHER_APPLICATION_WHEN_THIS_ACCEPTED_F();


CREATE OR REPLACE FUNCTION DELETE_OTHER_APPLICATION_WHEN_THIS_ACCEPTED_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
    DECLARE
    BEGIN
        if new.status = 'accepted' then
            --- Delete other applications on this job ---
            delete from application where job_id = new.job_id
                                      and id <> new.id
                                      and status = 'new';

            --- Delete freelancer's applications on other jobs ---
            delete from application where freelancer_id = new.freelancer_id
                                      and id <> new.id
                                      and status = 'new';

            update freelancer as f set job_id_working_on = new.job_id where f.id = new.freelancer_id;
        end if;

        return new;
    END
$$;

CREATE TRIGGER DELETE_OTHER_APPLICATION_WHEN_THIS_ACCEPTED
    BEFORE UPDATE OR INSERT ON application
    FOR EACH ROW
    EXECUTE PROCEDURE DELETE_OTHER_APPLICATION_WHEN_THIS_ACCEPTED_F();



CREATE OR REPLACE FUNCTION BLOCK_CUSTOMER_WHEN_MANY_UNFINISHED_JOBS_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
    BEGIN
        if new.unfinished_jobs_count >= get_max_leaved_jobs_by_freelancer() then
            new.is_blocked = true;
            update new_job set is_blocked = true where customer_id = new.id;
        end if;

        return new;
    END
$$;

CREATE TRIGGER BLOCK_CUSTOMER_WHEN_MANY_UNFINISHED_JOBS
    BEFORE UPDATE OR INSERT ON customer
    FOR EACH ROW
    EXECUTE PROCEDURE BLOCK_CUSTOMER_WHEN_MANY_UNFINISHED_JOBS_F();


CREATE OR REPLACE FUNCTION UNBLOCK_CUSTOMER_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
    BEGIN
        if new.is_blocked = false then
            update new_job set is_blocked = false where customer_id = new.id;
        end if;

        return new;
    END
$$;

CREATE TRIGGER UNBLOCK_CUSTOMER
    BEFORE UPDATE OR INSERT ON customer
    FOR EACH ROW
    EXECUTE PROCEDURE UNBLOCK_CUSTOMER_F();


CREATE OR REPLACE FUNCTION DELETE_APPLICATIONS_DEPENDING_ON_JOB_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
    BEGIN
        delete from application where job_id = old.id;
    END
$$;

CREATE TRIGGER DELETE_APPLICATIONS_DEPENDING_ON_JOB
    BEFORE DELETE ON new_job
    FOR EACH ROW
    EXECUTE PROCEDURE DELETE_APPLICATIONS_DEPENDING_ON_JOB_F();


CREATE OR REPLACE FUNCTION DELETE_APPLICATIONS_WHEN_JOB_BLOCKED_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
    BEGIN
        if new.is_blocked = true then
            delete from application where job_id = new.id;
        end if;

        return new;
    END
$$;

CREATE TRIGGER DELETE_APPLICATIONS_WHEN_JOB_BLOCKED
    BEFORE UPDATE ON new_job
    FOR EACH ROW
    EXECUTE PROCEDURE DELETE_APPLICATIONS_WHEN_JOB_BLOCKED_F();


CREATE OR REPLACE FUNCTION CHECK_IF_CUSTOMER_CAN_CREATE_NEW_JOB_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
    DECLARE
        customer_id_blocked_t boolean;
    BEGIN
        select into customer_id_blocked_t is_blocked from customer where id = new.customer_id;
        if customer_id_blocked_t then
            raise exception 'Unable to create new job. You are blocked!';
        end if;

        return new;
    END
$$;

CREATE TRIGGER CHECK_IF_CUSTOMER_CAN_CREATE_NEW_JOB_F
    BEFORE INSERT ON new_job
    FOR EACH ROW
    EXECUTE PROCEDURE CHECK_IF_CUSTOMER_CAN_CREATE_NEW_JOB_F();
