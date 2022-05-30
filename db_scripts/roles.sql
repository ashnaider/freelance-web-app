DROP USER IF EXISTS freelancer_user;
DROP USER IF EXISTS customer_user;
DROP USER IF EXISTS guest_user;

-------------- Freelancer User --------------
CREATE USER freelancer_user WITH PASSWORD 'freelancer';
--- Tables ---
GRANT SELECT, UPDATE, DELETE ON freelancer TO freelancer_user;
GRANT SELECT ON users TO freelancer_user;
GRANT SELECT ON customer TO freelancer_user;
GRANT SELECT ON new_job TO freelancer_user;
GRANT SELECT, INSERT, DELETE ON application TO freelancer_user;
--- Procedures ---
--- Sequences ---
GRANT ALL ON SEQUENCE application_id_seq TO freelancer_user;


-------------- Customer User --------------
CREATE USER customer_user WITH PASSWORD 'customer';
--- Tables ---
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO customer_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON new_job TO customer_user;
GRANT SELECT ON users TO customer_user;
GRANT SELECT ON application TO customer_user;
GRANT SELECT ON freelancer TO customer_user;
--- Sequences ---
GRANT USAGE, SELECT ON SEQUENCE new_job_id_seq TO customer_user;
--- Procedures ---



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





