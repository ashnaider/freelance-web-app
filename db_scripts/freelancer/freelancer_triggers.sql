-- drop trigger if exists CHECK_IF_CAN_START_JOB on freelancer;
-- drop function if exists CHECK_IF_CAN_START_JOB_F();

drop trigger if exists CHECK_IF_FREELANCER_CAN_APPLY_FOR_JOB on application;
drop function if exists CHECK_IF_FREELANCER_CAN_APPLY_FOR_JOB_F();

drop trigger if exists BLOCK_FREELANCER_WHEN_MANY_UNFINISHED_JOBS on freelancer;
drop function if exists BLOCK_FREELANCER_WHEN_MANY_UNFINISHED_JOBS_F();

--
-- CREATE OR REPLACE FUNCTION CHECK_IF_CAN_START_JOB_F() RETURNS TRIGGER
--     LANGUAGE PLPGSQL
-- AS
-- $$
-- DECLARE
--     application_exist boolean;
--     job_exist boolean;
--     customer_blocked boolean;
--     job_blocked      boolean;
--     is_done_by_other boolean;
--     fr_email         email_domain;
-- BEGIN
--
--     if new.job_id_working_on is null then
--          return new;
--     end if;
--
--     if old.job_id_working_on = new.job_id_working_on then
--         raise exception
--             'You already doing(done) this job!';
--     end if;
--
--     if (not old.job_id_working_on is null) and (not new.job_id_working_on is null) then
--         raise exception
--             E'Unable to start doing this job. You should finish your current job first!';
--     end if;
--
--     select into application_exist (count(*) = 1) from application as app
--     where app.freelancer_id = new.id and app.job_id = new.job_id_working_on;
--
--     if not application_exist then
--         raise exception
--             E'Unable to start doing this job, because you didn\'t apply to this job!';
--     end if;
--
--     select into job_exist (count(*) = 1) from new_job as j where j.id = new.job_id_working_on;
--
--     if not job_exist then
--         raise exception
--             'Unable to start doing this job, because job does not exist!';
--     end if;
--
--     select into customer_blocked, job_blocked, is_done_by_other
--                 c.is_blocked, j.is_blocked, (j.status = 'in progress')
--     from customer as c inner join new_job as j on c.id = j.customer_id
--     where j.id = new.job_id_working_on;
--
--     select email into fr_email from users inner join freelancer on users.id = old.user_id;
--
--     if old.is_blocked then
--         raise exception
--             'Unable to start doing this job, because freelancer %s %s (e-mail: %s) is blocked!',
--             old.first_name, old.last_name, fr_email;
--     end if;
--     if customer_blocked then
--         raise exception
--             'Unable to start doing this job, because customer is blocked!';
--     end if;
--
--     if job_blocked then
--         raise exception 'Unable to start doing this job, because job is blocked!';
--     end if;
--
--     if is_done_by_other then
--         raise exception 'Unable to start doing this job, because job is done by other freelancer!';
--     end if;
--
--     return new;
-- END;
-- $$;
--
-- CREATE TRIGGER CHECK_IF_CAN_START_JOB
--     BEFORE UPDATE
--     ON freelancer
--     FOR EACH ROW
-- EXECUTE PROCEDURE CHECK_IF_CAN_START_JOB_F();



CREATE OR REPLACE FUNCTION CHECK_IF_FREELANCER_CAN_APPLY_FOR_JOB_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
    DECLARE
        freelancer_has_job boolean;
        app_exist boolean;
    BEGIN
        select into freelancer_has_job (not job_id_working_on is null) from freelancer where id = new.freelancer_id;

        if freelancer_has_job = true then
            raise exception 'You already have job. Finish it first, before applying to other jobs!';
        end if;

        select into app_exist (count(*) = 1) from application
        where freelancer_id = new.freelancer_id and job_id = new.job_id;

        if app_exist then
            raise exception 'You already applied for this job!';
        end if;

        return NEW;
    END
$$;

CREATE TRIGGER CHECK_IF_FREELANCER_CAN_APPLY_FOR_JOB
    BEFORE INSERT ON application
    FOR EACH ROW
    EXECUTE PROCEDURE CHECK_IF_FREELANCER_CAN_APPLY_FOR_JOB_F();



CREATE OR REPLACE FUNCTION BLOCK_FREELANCER_WHEN_MANY_UNFINISHED_JOBS_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
    BEGIN
        if new.unfinished_jobs_count >= get_max_leaved_jobs_by_freelancer() then
            new.is_blocked = true;
            perform delete_new_applications_of_freelancer(new.id);
        end if;

        return new;
    END
$$;

CREATE TRIGGER BLOCK_FREELANCER_WHEN_MANY_UNFINISHED_JOBS
    BEFORE UPDATE OR INSERT ON freelancer
    FOR EACH ROW
    EXECUTE PROCEDURE BLOCK_FREELANCER_WHEN_MANY_UNFINISHED_JOBS_F();




