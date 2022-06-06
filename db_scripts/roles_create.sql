-------------- Freelancer User --------------
CREATE USER freelancer_user WITH PASSWORD 'freelancer';

revoke all on table users from freelancer_user;
revoke all on table freelancer from freelancer_user;
revoke all on table customer from freelancer_user;
revoke all on table application from freelancer_user;
revoke all on table new_job from freelancer_user;

grant usage on schema public to freelancer_user;

grant execute on function public.get_active_jobs() to freelancer_user;
grant execute on function public.get_freelancer(user_id_p integer) to freelancer_user;
grant execute on function public.edit_freelancer(fr_id_p integer,
    first_name_p name_domain, last_name_p name_domain, resume_link_p varchar, specialization_p varchar)
    to freelancer_user;
grant execute on function public.is_application_exist(job_id_p integer, fr_id_p integer) to freelancer_user;
grant execute on function public.get_application(job_id_p integer, fr_id_p integer) to freelancer_user;
grant execute on function public.apply_for_job_by_freelancer(job_id_p integer,
    fr_id_p integer,
    price_p float,
    description_p varchar(450)) to freelancer_user;
grant execute on function public.remove_job_application_by_freelancer(job_id_p integer, fr_id_p integer) to freelancer_user;
grant execute on function public.get_applied_jobs(fr_id integer) to freelancer_user;
grant execute on function public.get_job_freelancer_working_on(fr_id integer) to freelancer_user;
grant execute on function public.start_doing_job_by_freelancer(job_id_p integer, fr_id_p integer) to freelancer_user;
grant execute on function public.finish_doing_job_by_freelancer(fr_id_p integer) to freelancer_user;
grant execute on function public.leave_job_by_freelancer(fr_id_p integer) to freelancer_user;


--- Schema ---
-- GRANT USAGE ON SCHEMA public TO freelancer_user;

--- Common Functions ---
    alter function public.get_active_jobs()
    security definer set search_path = public;

--- Freelancer Functions ---
alter function public.get_freelancer(user_id_p integer)
    security definer set search_path = public;

alter function public.edit_freelancer(fr_id_p integer,
    first_name_p name_domain, last_name_p name_domain, resume_link_p varchar, specialization_p varchar)
    security definer set search_path = public;

alter function public.is_application_exist(job_id_p integer, fr_id_p integer)
    security definer set search_path = public;

alter function public.get_application(job_id_p integer, fr_id_p integer)
    security definer set search_path = public;

ALTER FUNCTION public.apply_for_job_by_freelancer(job_id_p integer,
    fr_id_p integer,
    price_p float,
    description_p varchar(450))
    SECURITY DEFINER SET search_path = public;

ALTER FUNCTION public.remove_job_application_by_freelancer(job_id_p integer, fr_id_p integer)
    SECURITY DEFINER SET search_path = public;

alter function public.get_applied_jobs(fr_id integer)
    security definer set search_path = public;

alter function public.get_job_freelancer_working_on(fr_id integer)
    security definer set search_path = public;


ALTER FUNCTION public.start_doing_job_by_freelancer(job_id_p integer, fr_id_p integer)
    SECURITY DEFINER SET search_path = public;

alter function public.finish_doing_job_by_freelancer(fr_id_p integer)
    security definer set search_path = public;

alter function public.leave_job_by_freelancer(fr_id_p integer)
    security definer set search_path = public;

-- --- Tables ---
GRANT SELECT, UPDATE, DELETE ON freelancer TO freelancer_user;
GRANT SELECT ON users TO freelancer_user;
GRANT SELECT ON customer TO freelancer_user;
GRANT SELECT, UPDATE ON new_job TO freelancer_user;
GRANT SELECT, INSERT, DELETE ON application TO freelancer_user;
-- --- Sequences ---
GRANT ALL ON SEQUENCE application_id_seq TO freelancer_user;


-------------- Customer User --------------

CREATE USER customer_user WITH PASSWORD 'customer';

revoke all on table users from customer_user;
revoke all on table freelancer from customer_user;
revoke all on table customer from customer_user;
revoke all on table application from customer_user;
revoke all on table new_job from customer_user;


ALTER DEFAULT PRIVILEGES FOR USER customer_user
    REVOKE EXECUTE ON FUNCTIONS FROM public;

revoke usage on schema public from freelancer_user;

revoke execute on function public.get_customer(user_id_p integer) from customer_user;


--- Functions ---

-- --- Tables ---
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO customer_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON new_job TO customer_user;
GRANT DELETE, UPDATE ON application TO customer_user;
GRANT SELECT ON users TO customer_user;
GRANT SELECT ON application TO customer_user;
GRANT SELECT, UPDATE ON freelancer TO customer_user;
--- Sequences ---
GRANT USAGE, SELECT ON SEQUENCE new_job_id_seq TO customer_user;
-- - Procedures ---
-- - Functions ---
GRANT TRIGGER ON application TO customer_user;


-------------- Guest User --------------
CREATE USER guest_user WITH PASSWORD 'guest';
--- Tables ---
GRANT SELECT, INSERT ON users TO guest_user;
GRANT SELECT ON new_job TO guest_user;
GRANT SELECT ON application TO guest_user;
GRANT SELECT, INSERT ON customer TO guest_user;
GRANT SELECT, INSERT ON freelancer TO guest_user;
--- Functions ---
GRANT ALL ON FUNCTION get_active_jobs() TO guest_user;
--- Sequences ---
GRANT ALL ON SEQUENCE users_id_seq TO guest_user;
GRANT ALL ON SEQUENCE customer_id_seq TO guest_user;
GRANT ALL ON SEQUENCE freelancer_id_seq TO guest_user;





