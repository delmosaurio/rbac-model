CREATE TABLE "session" (
  "sid" varchar NOT NULL COLLATE "default",
  "sess" json NOT NULL,
  "expire" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;


CREATE OR REPLACE FUNCTION bit_xor(
  _value_a integer,
  _value_b integer
) 
RETURNS integer AS $$
BEGIN
  return _value_a # _value_b;
END;
$$ LANGUAGE plpgsql;



-- Procedure user_roles
CREATE OR REPLACE FUNCTION fn_user_roles(
  _user_id integer
) 
RETURNS TABLE (role_id bigint) AS $$
BEGIN
  RETURN QUERY
    select r.role_id from users u
      inner join profiles p on p.profile_id = u.profile_id_profiles
      inner join profiles_roles pr on pr.profile_id_profiles = p.profile_id
      inner join roles r on r.role_id = pr.role_id_roles
      where u.user_id = _user_id;

END;
$$ LANGUAGE plpgsql;



-- Procedure revoke_user
CREATE OR REPLACE FUNCTION fn_revoke_user_object(
  _user_id integer,
  _object_id integer,
  _access_grant integer,
  _access_deny integer
) 
RETURNS void AS $$
BEGIN
  IF EXISTS (select user_id_users from users_objects where user_id_users = _user_id and object_id_objects = _object_id)
  THEN
      update users_objects SET access_grant=_access_grant, access_deny=_access_deny
        where user_id_users = _user_id and object_id_objects = _object_id;
    ELSE
      insert into users_objects (user_id_users,object_id_objects,access_grant,access_deny)
        VALUES (_user_id,_object_id,CAST(_access_grant as smallint),CAST(_access_deny as smallint));
  END IF;
END;
$$ LANGUAGE plpgsql;



-- Procedure revoke_user
CREATE OR REPLACE FUNCTION fn_unlink_user_object(
  _user_id integer,
  _object_id integer
) 
RETURNS void AS $$
BEGIN
  delete from users_objects
  where user_id_users = _user_id and object_id_objects = _object_id;
END;
$$ LANGUAGE plpgsql;



-- Procedure revoke_role
CREATE OR REPLACE FUNCTION fn_revoke_role_object(
  _role_id integer,
  _object_id integer,
  _access_grant integer,
  _access_deny integer
) 
RETURNS void AS $$
BEGIN
  IF EXISTS (select role_id_roles from roles_objects where role_id_roles = _role_id and object_id_objects = _object_id)
  THEN
      update roles_objects SET access_grant=_access_grant, access_deny=_access_deny
        where role_id_roles = _role_id and object_id_objects = _object_id;
    ELSE
      insert into roles_objects (role_id_roles,object_id_objects,access_grant,access_deny)
        VALUES (_role_id,_object_id,CAST(_access_grant as smallint),CAST(_access_deny as smallint));
  END IF;
END;
$$ LANGUAGE plpgsql;



-- Procedure revoke_role
CREATE OR REPLACE FUNCTION fn_unlink_role_object(
  _role_id integer,
  _object_id integer
) 
RETURNS void AS $$
BEGIN
  delete from roles_objects
  where role_id_roles = _role_id and object_id_objects = _object_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_access(
  agrant integer,
  adeny integer
) 
RETURNS smallint AS $$
BEGIN
  return CAST((agrant & (32767 # adeny)) as smallint);
END;
$$ LANGUAGE plpgsql;



-- Procedure access_role_object
CREATE OR REPLACE FUNCTION fn_access_role_object(
  _role_id integer,
  _object_id integer
) 
RETURNS smallint AS $$
DECLARE
  access integer;
BEGIN
  select fn_access(bit_or(ro.access_grant), bit_or(ro.access_deny)) into access from roles_objects ro
  where object_id_objects = _object_id and role_id_roles in (
    select tbl.role_id from (
        select r.role_id from roles r
        where r.role_id = ro.role_id_roles
        union 
        select rr.roles_role_id from roles_roles rr
        where rr.role_id_roles = ro.role_id_roles
      ) as tbl where tbl.role_id = _role_id
  );

  return access;
END;
$$ LANGUAGE plpgsql;

-- Procedure fn_access_profile_object
CREATE OR REPLACE FUNCTION fn_access_profile_object(
  _profile_id integer,
  _object_id integer
) 
RETURNS smallint AS $$
DECLARE
  access integer;
  _role_id integer;
BEGIN
  
  select fn_access(bit_or(ro.access_grant), bit_or(ro.access_deny)) into access from roles_objects ro
  where object_id_objects = _object_id and role_id_roles in (
    select tbl.role_id from (
        select pr.role_id_roles as role_id from profiles_roles pr
        where pr.profile_id_profiles = _profile_id
        union 
        select rr.roles_role_id as role_id from roles_roles rr
        where rr.role_id_roles = ro.role_id_roles
      ) as tbl
  );

  return access;
END;
$$ LANGUAGE plpgsql;

-- Procedure access_user_object
CREATE OR REPLACE FUNCTION fn_access_user_object(
  _user_id integer,
  _object_id integer
) 
RETURNS smallint AS $$
DECLARE
  access integer;
BEGIN
    select fn_access(bit_or(ro.access_grant), bit_or(ro.access_deny)) into access from fn_user_roles(_user_id) fn
    inner join roles_objects ro on ro.role_id_roles = fn.role_id
    inner join objects o on o.object_id = ro.object_id_objects
    where o.object_id = _object_id
    group by o.object_id;

    return access;
END;
$$ LANGUAGE plpgsql;

-- Procedure fn_add_role_profile
CREATE OR REPLACE FUNCTION fn_add_role_profile(
  _role_id integer,
  _profile_id integer
) 
RETURNS void AS $$
BEGIN
  IF NOT EXISTS (select role_id_roles from profiles_roles where role_id_roles = _role_id and profile_id_profiles = _profile_id)
  THEN
      insert into profiles_roles (profile_id_profiles, role_id_roles)
        VALUES (_profile_id, _role_id);
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Procedure fn_add_role_profile
CREATE OR REPLACE FUNCTION fn_remove_role_profile(
  _role_id integer,
  _profile_id integer
) 
RETURNS void AS $$
BEGIN
  IF EXISTS (select role_id_roles from profiles_roles where role_id_roles = _role_id and profile_id_profiles = _profile_id)
  THEN
      DELETE FROM profiles_roles where role_id_roles = _role_id and profile_id_profiles = _profile_id;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- views
CREATE OR REPLACE VIEW v_users AS
  select * from profiles, users
    where profile_id = profile_id_profiles;

CREATE OR REPLACE VIEW v_profiles_roles AS
  select * from profiles, profiles_roles, roles
    where profile_id = profile_id_profiles and role_id = role_id_roles;

CREATE OR REPLACE VIEW v_user_objects as
  SELECT * FROM (select 
    u.user_id,
    o.*,
    (select public.fn_access_user_object(CAST(u.user_id as integer), CAST(o.object_id as integer))) as "access"
  from users u, objects o) as tbl WHERE "access" is not null;

CREATE OR REPLACE VIEW v_roles_objects as
  SELECT * FROM (select 
    r.role_id,
    o.*,
    (select public.fn_access_role_object(CAST(r.role_id as integer), CAST(o.object_id as integer))) as "access"
  from roles r, objects o) as tbl WHERE tbl.access is not null;