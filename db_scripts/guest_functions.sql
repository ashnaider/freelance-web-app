
drop function if exists register_user(email_p email_domain, passwd_p varchar(255), role_p user_role, first_name_p name_domain,
                                         last_name_p name_domain);


create or replace function register_user(email_p email_domain,
                                         passwd_p varchar(255),
                                         role_p user_role,
                                         first_name_p name_domain,
                                         last_name_p name_domain)
    returns integer
as
$$
declare
    new_user_id integer;
begin

    insert into users (email, passwd, role) values (email_p, passwd_p, role_p);
    select into new_user_id id from users where email = email_p;

    if role_p = 'customer' then
        insert into customer (user_id, first_name, last_name) values (new_user_id, first_name_p, last_name_p);
    end if;

    if role_p = 'freelancer' then
        insert into freelancer (user_id, first_name, last_name) values (new_user_id, first_name_p, last_name_p);
    end if;

    return new_user_id;
end;
$$ language plpgsql;
