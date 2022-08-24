--- Delete freelancer_user ---
ALTER DEFAULT PRIVILEGES FOR ROLE freelancer_user
   GRANT EXECUTE ON FUNCTIONS TO PUBLIC;

revoke usage on schema public from freelancer_user;

revoke execute on function public.get_active_jobs() from freelancer_user;
revoke execute on function public.get_freelancer(user_id_p integer) from freelancer_user;
revoke execute on function public.edit_freelancer(fr_id_p integer,
    first_name_p name_domain, last_name_p name_domain, resume_link_p varchar, specialization_p varchar)
    from freelancer_user;
revoke execute on function public.is_application_exist(job_id_p integer, fr_id_p integer) from freelancer_user;
revoke execute on function public.get_application(job_id_p integer, fr_id_p integer) from freelancer_user;
revoke execute on function public.apply_for_job_by_freelancer(job_id_p integer,
    fr_id_p integer,
    price_p float,
    description_p varchar(450)) from freelancer_user;
revoke execute on function public.remove_job_application_by_freelancer(job_id_p integer, fr_id_p integer) from freelancer_user;
revoke execute on function public.get_applied_jobs(fr_id integer) from freelancer_user;
revoke execute on function public.get_job_freelancer_working_on(fr_id integer) from freelancer_user;
revoke execute on function public.start_doing_job_by_freelancer(job_id_p integer, fr_id_p integer) from freelancer_user;
revoke execute on function public.finish_doing_job_by_freelancer(fr_id_p integer) from freelancer_user;
revoke execute on function public.leave_job_by_freelancer(fr_id_p integer) from freelancer_user;

revoke all on table users from freelancer_user;
revoke all on table freelancer from freelancer_user;
revoke all on table customer from freelancer_user;
revoke all on table application from freelancer_user;
revoke all on table new_job from freelancer_user;

revoke all on sequence new_job_id_seq from freelancer_user;
revoke all on sequence application_id_seq from freelancer_user;

DROP USER IF EXISTS freelancer_user;



--- Delete customer_user ---
ALTER DEFAULT PRIVILEGES FOR ROLE customer_user
   GRANT EXECUTE ON FUNCTIONS TO PUBLIC;

revoke usage on schema public from customer_user;
revoke all on table users from customer_user;
revoke all on table freelancer from customer_user;
revoke all on table customer from customer_user;
revoke all on table application from customer_user;
revoke all on table new_job from customer_user;
revoke all on sequence new_job_id_seq from customer_user;
DROP USER IF EXISTS customer_user;



--- Delete guest_user ---

revoke all on table users from guest_user;
revoke all on table freelancer from guest_user;
revoke all on table customer from guest_user;
revoke all on table application from guest_user;
revoke all on table new_job from guest_user;

revoke ALL ON SEQUENCE users_id_seq from guest_user;
revoke ALL ON SEQUENCE customer_id_seq from guest_user;
revoke ALL ON SEQUENCE freelancer_id_seq from guest_user;

revoke all on function get_active_jobs() from guest_user;

DROP USER IF EXISTS guest_user;


--- Delete admin_user ---

REVOKE ALL ON users FROM admin_user;
REVOKE ALL ON new_job FROM admin_user;
REVOKE ALL ON application FROM admin_user;
REVOKE ALL ON customer FROM admin_user;
REVOKE ALL ON freelancer FROM admin_user;


DROP USER IF EXISTS admin_user;

