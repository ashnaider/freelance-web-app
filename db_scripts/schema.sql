drop trigger if exists CHECK_POSTED_NEW_JOB ON new_job;
drop function if exists CHECK_POSTED_NEW_JOB_F();

drop trigger if exists CHECK_POSTED_NEW_JOB_ON_UPDATE on new_job;
drop function if exists CHECK_POSTED_NEW_JOB_ON_UPDATE_F();

drop function if exists GetAuthorOfMessage;
drop table if exists technology_stack;
drop table if exists technology;

drop table if exists project_done;
drop table if exists job_complaint;
drop table if exists user_complaint;
drop type if exists complaint_type;

drop table if exists message_;

drop function if exists get_application(job_id_p integer, fr_id_p integer);

drop table if exists application;
drop table if exists new_job;

drop table if exists customer;
drop table if exists freelancer;
drop table if exists users;


drop domain if exists email_domain cascade;
drop domain if exists password_domain;
drop domain if exists name_domain cascade;
drop domain if exists login_domain;

drop type if exists project_status cascade;
drop type if exists user_role;
drop type if exists application_status;

create type application_status as enum ('new', 'accepted');
create type project_status as enum ('new', 'accepted', 'in progress', 'done', 'unfinished');
create type user_role as enum ('freelancer', 'customer', 'admin');


create domain email_domain as varchar(150)
    check (
        value ~* '^[a-z0-9._%-]+@[a-z0-9._%-]+\.[a-z]{2,4}'
        );

create domain password_domain as varchar(50)
    check (
        value ~ '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{8,}$'
        );

create domain name_domain as varchar(50)
    check (
        value ~ '^[a-z\-]{1,48}'
        );

create domain login_domain as varchar(50)
    check (
        value ~ '[a-z0-9]{5,48}'
        );


create table users
(
    id     serial       not null primary key,
    email  email_domain not null unique,
    passwd varchar(255) not null,
    role   user_role    not null
);

create table freelancer
(
    id                    serial not null primary key,
    user_id               int    not null references users (id) on delete cascade on update cascade,
    first_name            name_domain,
    last_name             name_domain,
    resume_link           varchar(250),
    specialization        varchar(250),
    unfinished_jobs_count integer default 0,
    job_id_working_on     integer,
    started_doing_job     boolean default false,
    is_blocked            boolean default false,

    unique (id, user_id)
);


-- create table technology
-- (
--     id        serial       not null primary key,
--     tech_name varchar(250) not NULL
-- );
--
--
-- create table technology_stack
-- (
--     technology_stack_id serial not null primary key,
--
--     freelancer_id       int    not null
--         references freelancer (id)
--             on delete cascade on update cascade,
--
--     technology_id       int    not null
--         references technology (id)
--             on delete cascade on update cascade,
--
--     unique (freelancer_id, technology_id)
-- );


create table customer
(
    id                serial not null primary key,
    user_id           int    not null references users (id) on delete cascade on update cascade,
    first_name        name_domain,
    last_name         name_domain,
    organisation_name varchar(150),
    unfinished_jobs_count integer default 0,
    is_blocked        boolean default false,

    unique (id, user_id)
);



create table new_job
(
    id             serial       not null primary key,
    customer_id    int          not null
        references customer (id)
            on delete restrict on update cascade,

    posted         timestamp    not null default CURRENT_TIMESTAMP,
    accepted       timestamp,
    started        timestamp,
    finished       timestamp,
-- 	deadline timestamp   not null check (deadline > CURRENT_TIMESTAMP),
    header_        varchar(250) not null,
    description    varchar(650) not null,
    price          money        not null check (price > 0::money),
    is_hourly_rate boolean               default false,
    status         project_status        default 'new',
    application_id integer,
    is_blocked     boolean               default false
);


create table application
(
    id            serial       not null primary key,
    date_time     timestamp    not null default CURRENT_TIMESTAMP,
-- 	deadline timestamp not null check (deadline > date_time),
    price         money        not null,
    description   varchar(450) not null,
    status        application_status    default 'new',

    freelancer_id int          not null
        references freelancer (id)
            on delete restrict on update cascade,

    job_id        int          not null
        references new_job (id)
            on delete restrict on update cascade,

    unique (freelancer_id, job_id)
);



CREATE OR REPLACE FUNCTION CHECK_POSTED_NEW_JOB_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    if NEW.posted < CURRENT_TIMESTAMP then
        raise EXCEPTION 'New job posted field must be greather of equal to time it was inserted!
                Error while inserting new job with header %s', NEW.header_;
    end if;
    return NEW;
END
$$;

CREATE TRIGGER CHECK_POSTED_NEW_JOB
    BEFORE INSERT
    ON new_job
    FOR EACH ROW
EXECUTE PROCEDURE CHECK_POSTED_NEW_JOB_F();


CREATE OR REPLACE FUNCTION CHECK_POSTED_NEW_JOB_ON_UPDATE_F() RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    if NEW.posted < OLD.posted then
        raise EXCEPTION 'New job posted field must be greather of equal to time it was inserted!
                Error while inserting new job with header %s', NEW.header_;
    end if;
    return NEW;
END
$$;

CREATE TRIGGER CHECK_POSTED_NEW_JOB_ON_UPDATE
    BEFORE UPDATE
    ON new_job
    FOR EACH ROW
EXECUTE PROCEDURE CHECK_POSTED_NEW_JOB_ON_UPDATE_F();


--
-- create type complaint_type as enum (
--     'inappropriate_content',
--     'fraud',
--     'illegal_actions',
--     'spam',
--     'other'
--     );
--
--
-- ---Freelancer's complaint on the new_job
-- create table job_complaint
-- (
--     id             serial         not null primary key,
--     date_time      timestamp      not null default CURRENT_TIMESTAMP,
--     complaint_type complaint_type not null,
--     description    varchar(550),
--
--     freelancer_id  int            not null
--         references freelancer (id)
--             on delete restrict on update cascade,
--
--     job_id         int            not null
--         references new_job (id)
--             on delete restrict on update cascade
-- );
--
--
-- ---Customer's complaint on freelancer,
-- -----or freelancer's complaint on customer
-- create table user_complaint
-- (
--     id               serial         not null primary key,
--     date_time        timestamp      not null default CURRENT_TIMESTAMP,
--     is_from_customer bool           not null,
--     complaint_type   complaint_type not null,
--     description      varchar(550),
--
--     customer_id      int            not null
--         references customer (id)
--             on delete restrict on update cascade,
--
--     freelancer_id    int            not null
--         references freelancer (id)
--             on delete restrict on update cascade
-- );
--
--
-- ---Message between customer and freelancer
-- ------both can write each other
-- create table message_
-- (
--     id               serial    not null primary key,
--     is_from_customer bool      not null,
--     date_time        timestamp not null default CURRENT_TIMESTAMP,
--     text_message     text      not null,
--
--     freelancer_id    int       not null
--         references freelancer (id)
--             on delete restrict on update cascade,
--
--     job_id           int       not null
--         references new_job (id)
--             on delete restrict on update cascade
-- );
--
--
-- create table project_done
-- (
--     id                serial       not null primary key,
--     date_start        timestamp    not null,
--     date_finish       timestamp    not null check (date_finish > date_start),
--
--     customer_review   varchar(350) not null,
--     freelancer_review varchar(350) not null,
--
--     freelancer_id     int          not null
--         references freelancer (id)
--             on delete restrict on update cascade,
--
--     job_id            int          not null
--         references new_job (id)
--             on delete restrict on update cascade
-- );
