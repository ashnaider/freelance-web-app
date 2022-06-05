revoke usage on schema public from freelancer_user;

DROP USER IF EXISTS freelancer_user;
DROP USER IF EXISTS customer_user;
DROP USER IF EXISTS guest_user;

-------------- Freelancer User --------------
CREATE USER freelancer_user WITH PASSWORD 'freelancer';
GRANT USAGE ON SCHEMA public TO freelancer_user;

--- Functions ---
ALTER FUNCTION public.start_doing_job_by_freelancer(job_id_p integer, fr_id_p integer)
SECURITY DEFINER SET search_path = public;

ALTER FUNCTION public.apply_for_job_by_freelancer(job_id_p integer,
                                                   fr_id_p integer,
                                                   price_p float,
                                                   description_p varchar(450))
SECURITY DEFINER SET search_path = public;

ALTER FUNCTION public.remove_job_application_by_freelancer(job_id_p integer, fr_id_p integer)
SECURITY DEFINER SET search_path = public;

alter function public.leave_job_by_freelancer(fr_id_p integer)
security definer set search_path = public;


--- Tables ---
GRANT SELECT, UPDATE, DELETE ON freelancer TO freelancer_user;
GRANT SELECT ON users TO freelancer_user;
GRANT SELECT ON customer TO freelancer_user;
GRANT SELECT ON new_job TO freelancer_user;
GRANT SELECT, INSERT, DELETE ON application TO freelancer_user;
--- Sequences ---
GRANT ALL ON SEQUENCE application_id_seq TO freelancer_user;


-------------- Customer User --------------
CREATE USER customer_user WITH PASSWORD 'customer';
--- Tables ---
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO customer_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON new_job TO customer_user;
GRANT DELETE ON application TO customer_user;
GRANT SELECT ON users TO customer_user;
GRANT SELECT ON application TO customer_user;
GRANT SELECT ON freelancer TO customer_user;
--- Sequences ---
GRANT USAGE, SELECT ON SEQUENCE new_job_id_seq TO customer_user;
--- Procedures ---
--- Functions ---
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





