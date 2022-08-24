create role guest_user with password 'guest' login;
create role customer_user with password 'customer' login;
create role freelancer_user with password 'freelancer' login;
create role admin_user with password 'admin' login;

grant connect on database "freelancer-db"
    to guest_user, customer_user, freelancer_user, admin_user;

grant usage on schema public
    to guest_user, customer_user, freelancer_user, admin_user;


revoke all on table
    users,
    customer,
    freelancer,
    new_job,
    application
from guest_user, freelancer_user, customer_user, admin_user;


--- Guest
--- Tables ---
GRANT SELECT, INSERT ON users TO guest_user;
GRANT SELECT ON new_job TO guest_user;
GRANT SELECT ON application TO guest_user;
GRANT SELECT, INSERT ON customer TO guest_user;
GRANT SELECT, INSERT ON freelancer TO guest_user;
--- Sequences ---
GRANT ALL ON SEQUENCE users_id_seq TO guest_user;
GRANT ALL ON SEQUENCE customer_id_seq TO guest_user;
GRANT ALL ON SEQUENCE freelancer_id_seq TO guest_user;


--- Admin
--- Tables ---
GRANT SELECT, INSERT, UPDATE, DELETE ON users TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON new_job TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON application TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON freelancer TO admin_user;


--- Freelancer
GRANT SELECT, UPDATE ON freelancer TO freelancer_user;
GRANT SELECT ON users TO freelancer_user;
GRANT SELECT ON customer TO freelancer_user;
GRANT SELECT, UPDATE ON new_job TO freelancer_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON application TO freelancer_user;
-- --- Sequences ---
GRANT ALL ON SEQUENCE application_id_seq TO freelancer_user;


--- Customer
-- --- Tables ---
GRANT SELECT, UPDATE ON customer TO customer_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON new_job TO customer_user;
GRANT SELECT, DELETE, UPDATE ON application TO customer_user;
GRANT SELECT ON users TO customer_user;
GRANT SELECT, UPDATE ON freelancer TO customer_user;
--- Sequences ---
GRANT USAGE, SELECT ON SEQUENCE new_job_id_seq TO customer_user;










grant all on function
    --- common function
    register_user(email_p email_domain,
                passwd_p varchar(255),
                role_p user_role,
                first_name_p name_domain,
                last_name_p name_domain),

    --- common functions
    get_user_by_id(user_id_p integer),
    get_user_by_email(user_email_p email_domain),
    get_done_job_full_info(job_id_p integer, job_status_p project_status),
    get_application(job_id_p integer, fr_id_p integer),
    get_max_leaved_jobs_by_freelancer(),
    IS_APPLICATION_EXIST(job_id_p integer, fr_id_p integer),
    COUNT_JOB_APPLICATIONS(job_id_p integer),
    GET_ALL_JOBS(),
    GET_ACTIVE_JOBS(),
    GET_NEWEST_JOBS(newest boolean),
    GET_MOST_EXPENSIVE_JOBS(most_expensive boolean),
    GET_MOST_POPULAR_JOBS(most_popular boolean),
    GET_APPLIED_JOBS(fr_id integer),
    GET_CUSTOMER_JOBS(cust_id integer),

    --- freelancer functions
    block_freelancer(fr_id_p integer),
    unblock_freelancer(fr_id_p integer),
    get_freelancer_finished_jobs(fr_id_p integer),
    get_freelancer_unfinished_jobs(fr_id_p integer),
    get_freelancer(user_id_p integer),
    edit_freelancer(fr_id_p integer,
                                               first_name_p name_domain,
                                               last_name_p name_domain,
                                               resume_link_p varchar(250),
                                               specialization_p varchar(250)),
    delete_new_applications_of_freelancer(fr_id_p integer),
    GET_JOB_FREELANCER_WORKING_ON(fr_id integer),
    apply_for_job_by_freelancer(job_id_p integer,
                                                        fr_id_p integer,
                                                        price_p float,
                                                        description_p varchar(450)),
    remove_job_application_by_freelancer(job_id_p integer, fr_id_p integer),
    start_doing_job_by_freelancer(fr_id_p integer),
    finish_doing_job_by_freelancer(fr_id_p integer),
    leave_job_by_freelancer(fr_id_p integer),
    count_freelancer_avg_app_price(fr_id_p integer),
    count_freelancer_total_money_earned(fr_id_p integer),
    count_freelancer_finished_jobs(fr_id_p integer),
    count_freelancer_unfinished_jobs(fr_id_p integer),
    count_freelancer_active_applications(fr_id_p integer),
    count_freelancer_attempts_to_leave(fr_id_p integer),
    get_blocked_freelancers_private_info(),
    get_active_freelancers_private_info(),
    get_freelancer_private_info(fr_id_p integer),
    get_freelancers_private_info(),

    --- Customer functions
    block_customer(cust_id_p integer),
    unblock_customer(cust_id_p integer),
    get_customer_unfinished_jobs(cust_id_p integer),
    get_customer_done_jobs(cust_id_p integer),
    get_customer_in_progress_jobs(cust_id_p integer),
    GET_CUSTOMER_NEW_JOBS(cust_id integer),
    get_customer_jobs_with_app_and_users(cust_id_p integer),
    get_max_leaved_jobs_by_customer(),
    delete_new_jobs_of_customer(cust_id_p integer),
    leave_job_by_customer(job_id_p integer),
    get_customer(user_id_p integer),
    create_job(cust_id_p integer,
                                          header_p varchar(250),
                                          description_p varchar(650),
                                          price_p float,
                                          is_hourly_rate_p boolean),
    update_job(job_id_p integer,
                                          header_p varchar(250),
                                          description_p varchar(650),
                                          price_p float,
                                          is_hourly_rate_p boolean),
    delete_job(job_id_p integer),
    edit_customer_profile(cust_id_p integer,
                                                     first_name_p name_domain,
                                                     last_name_p name_domain,
                                                     organisation_name_p varchar(150)),
    accept_application_for_job(app_id_p integer, job_id_p integer),
    GET_JOB_PERFORMER(cust_id_p integer, job_id_p integer),
    GET_NEW_APPLICATION(app_id_p integer),
    GET_ALL_NEW_APPLICATIONS(),
    GET_ACTIVE_CUSTOMER_APPLICATIONS(cust_id integer),
    GET_ALL_CUSTOMER_APPLICATIONS(cust_id_p integer),
    GET_CUSTOMER_JOB(cust_id_p integer, job_id_p integer),
    GET_CUSTOMER_JOBS(cust_id integer),
    get_blocked_customers_private_info(),
    get_active_customers_private_info(),
    get_customer_private_info(cust_id_p integer),
    get_customers_private_info(),
    count_customer_attempts_to_leave(cust_id_p integer),
    calculate_hourly_rate_project_total_price(finished_job_id integer),
    count_customer_total_money_spent(cust_id_p integer),
    count_customer_avg_job_price(cust_id_p integer),
    count_customer_unfinished_jobs(cust_id_p integer),
    count_customer_finished_jobs(cust_id_p integer),
    count_customer_in_progress_jobs(cust_id_p integer),
    count_customer_new_jobs(cust_id_p integer)

to public;

revoke execute on function
    --- common function
    register_user(email_p email_domain,
                passwd_p varchar(255),
                role_p user_role,
                first_name_p name_domain,
                last_name_p name_domain),

    --- common functions
    get_user_by_id(user_id_p integer),
    get_user_by_email(user_email_p email_domain),
    get_done_job_full_info(job_id_p integer, job_status_p project_status),
    get_application(job_id_p integer, fr_id_p integer),
    get_max_leaved_jobs_by_freelancer(),
    IS_APPLICATION_EXIST(job_id_p integer, fr_id_p integer),
    COUNT_JOB_APPLICATIONS(job_id_p integer),
    GET_ALL_JOBS(),
    GET_ACTIVE_JOBS(),
    GET_NEWEST_JOBS(newest boolean),
    GET_MOST_EXPENSIVE_JOBS(most_expensive boolean),
    GET_MOST_POPULAR_JOBS(most_popular boolean),
    GET_APPLIED_JOBS(fr_id integer),
    GET_CUSTOMER_JOBS(cust_id integer),

    --- freelancer functions
    block_freelancer(fr_id_p integer),
    unblock_freelancer(fr_id_p integer),
    get_freelancer_finished_jobs(fr_id_p integer),
    get_freelancer_unfinished_jobs(fr_id_p integer),
    get_freelancer(user_id_p integer),
    edit_freelancer(fr_id_p integer,
                                               first_name_p name_domain,
                                               last_name_p name_domain,
                                               resume_link_p varchar(250),
                                               specialization_p varchar(250)),
    delete_new_applications_of_freelancer(fr_id_p integer),
    GET_JOB_FREELANCER_WORKING_ON(fr_id integer),
    apply_for_job_by_freelancer(job_id_p integer,
                                                        fr_id_p integer,
                                                        price_p float,
                                                        description_p varchar(450)),
    remove_job_application_by_freelancer(job_id_p integer, fr_id_p integer),
    start_doing_job_by_freelancer(fr_id_p integer),
    finish_doing_job_by_freelancer(fr_id_p integer),
    leave_job_by_freelancer(fr_id_p integer),
    count_freelancer_avg_app_price(fr_id_p integer),
    count_freelancer_total_money_earned(fr_id_p integer),
    count_freelancer_finished_jobs(fr_id_p integer),
    count_freelancer_unfinished_jobs(fr_id_p integer),
    count_freelancer_active_applications(fr_id_p integer),
    count_freelancer_attempts_to_leave(fr_id_p integer),
    get_blocked_freelancers_private_info(),
    get_active_freelancers_private_info(),
    get_freelancer_private_info(fr_id_p integer),
    get_freelancers_private_info(),

    --- Customer functions
    block_customer(cust_id_p integer),
    unblock_customer(cust_id_p integer),
    get_customer_unfinished_jobs(cust_id_p integer),
    get_customer_done_jobs(cust_id_p integer),
    get_customer_in_progress_jobs(cust_id_p integer),
    GET_CUSTOMER_NEW_JOBS(cust_id integer),
    get_customer_jobs_with_app_and_users(cust_id_p integer),
    get_max_leaved_jobs_by_customer(),
    delete_new_jobs_of_customer(cust_id_p integer),
    leave_job_by_customer(job_id_p integer),
    get_customer(user_id_p integer),
    create_job(cust_id_p integer,
                                          header_p varchar(250),
                                          description_p varchar(650),
                                          price_p float,
                                          is_hourly_rate_p boolean),
    update_job(job_id_p integer,
                                          header_p varchar(250),
                                          description_p varchar(650),
                                          price_p float,
                                          is_hourly_rate_p boolean),
    delete_job(job_id_p integer),
    edit_customer_profile(cust_id_p integer,
                                                     first_name_p name_domain,
                                                     last_name_p name_domain,
                                                     organisation_name_p varchar(150)),
    accept_application_for_job(app_id_p integer, job_id_p integer),
    GET_JOB_PERFORMER(cust_id_p integer, job_id_p integer),
    GET_NEW_APPLICATION(app_id_p integer),
    GET_ALL_NEW_APPLICATIONS(),
    GET_ACTIVE_CUSTOMER_APPLICATIONS(cust_id integer),
    GET_ALL_CUSTOMER_APPLICATIONS(cust_id_p integer),
    GET_CUSTOMER_JOB(cust_id_p integer, job_id_p integer),
    GET_CUSTOMER_JOBS(cust_id integer),
    get_blocked_customers_private_info(),
    get_active_customers_private_info(),
    get_customer_private_info(cust_id_p integer),
    get_customers_private_info(),
    count_customer_attempts_to_leave(cust_id_p integer),
    calculate_hourly_rate_project_total_price(finished_job_id integer),
    count_customer_total_money_spent(cust_id_p integer),
    count_customer_avg_job_price(cust_id_p integer),
    count_customer_unfinished_jobs(cust_id_p integer),
    count_customer_finished_jobs(cust_id_p integer),
    count_customer_in_progress_jobs(cust_id_p integer),
    count_customer_new_jobs(cust_id_p integer)

from guest_user, freelancer_user, customer_user, admin_user;


revoke all on table
    users,
    customer,
    freelancer,
    new_job,
    application
from guest_user, freelancer_user, customer_user, admin_user;


alter function
    get_user_by_email(email_domain)
security definer set search_path = public;


alter function
register_user(email_p email_domain,
                passwd_p varchar(255),
                role_p user_role,
                first_name_p name_domain,
                last_name_p name_domain)
security definer set search_path = public;

alter function
GET_ACTIVE_JOBS()
security definer set search_path = public;

alter function
get_newest_jobs(boolean)
security definer set search_path = public;

alter function
    COUNT_JOB_APPLICATIONS(job_id_p integer)
security definer set search_path = public;

grant execute on function
    get_user_by_email(email_domain),
        register_user(email_p email_domain,
                passwd_p varchar(255),
                role_p user_role,
                first_name_p name_domain,
                last_name_p name_domain),
    GET_ACTIVE_JOBS(),
    get_newest_jobs(boolean),
    COUNT_JOB_APPLICATIONS(job_id_p integer)

to guest_user;


revoke execute on function
    get_user_by_email(email_domain),
        register_user(email_p email_domain,
                passwd_p varchar(255),
                role_p user_role,
                first_name_p name_domain,
                last_name_p name_domain),
    GET_ACTIVE_JOBS(),
    get_newest_jobs(boolean),
    COUNT_JOB_APPLICATIONS(job_id_p integer)

from guest_user;