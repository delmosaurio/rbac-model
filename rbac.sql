-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.8.2
-- PostgreSQL version: 9.5
-- Project Site: pgmodeler.com.br
-- Model Author: ---


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: rbac | type: DATABASE --
-- -- DROP DATABASE IF EXISTS rbac;
-- CREATE DATABASE rbac
-- ;
-- -- ddl-end --
-- 

-- object: public.users | type: TABLE --
-- DROP TABLE IF EXISTS public.users CASCADE;
CREATE TABLE public.users(
	user_id bigserial NOT NULL,
	username varchar(100) NOT NULL,
	password varchar(100) NOT NULL,
	profile_id_profiles integer NOT NULL,
	salt varchar NOT NULL,
	active bool NOT NULL,
	CONSTRAINT pk_users PRIMARY KEY (user_id),
	CONSTRAINT uq_users_username UNIQUE (username)

);
-- ddl-end --
ALTER TABLE public.users OWNER TO postgres;
-- ddl-end --

-- object: public.profiles | type: TABLE --
-- DROP TABLE IF EXISTS public.profiles CASCADE;
CREATE TABLE public.profiles(
	profile_id bigserial NOT NULL,
	profile_name varchar(100) NOT NULL,
	CONSTRAINT pk_profile PRIMARY KEY (profile_id),
	CONSTRAINT uq_profiles_profile_name UNIQUE (profile_name)

);
-- ddl-end --
ALTER TABLE public.profiles OWNER TO postgres;
-- ddl-end --

-- object: public.roles | type: TABLE --
-- DROP TABLE IF EXISTS public.roles CASCADE;
CREATE TABLE public.roles(
	role_id bigserial NOT NULL,
	role_name varchar(100) NOT NULL,
	CONSTRAINT pk_roles PRIMARY KEY (role_id),
	CONSTRAINT uq_roles_role_name UNIQUE (role_name)

);
-- ddl-end --
ALTER TABLE public.roles OWNER TO postgres;
-- ddl-end --

-- object: public.objects | type: TABLE --
-- DROP TABLE IF EXISTS public.objects CASCADE;
CREATE TABLE public.objects(
	object_id bigserial NOT NULL,
	object_name varchar(100) NOT NULL,
	CONSTRAINT pk_objects PRIMARY KEY (object_id),
	CONSTRAINT uq_objects_object_name UNIQUE (object_name)

);
-- ddl-end --
ALTER TABLE public.objects OWNER TO postgres;
-- ddl-end --

-- object: public.profiles_roles | type: TABLE --
-- DROP TABLE IF EXISTS public.profiles_roles CASCADE;
CREATE TABLE public.profiles_roles(
	profile_id_profiles integer NOT NULL,
	role_id_roles integer NOT NULL,
	CONSTRAINT pk_profiles_roles PRIMARY KEY (profile_id_profiles,role_id_roles)

);
-- ddl-end --
ALTER TABLE public.profiles_roles OWNER TO postgres;
-- ddl-end --

-- object: public.users_roles | type: TABLE --
-- DROP TABLE IF EXISTS public.users_roles CASCADE;
CREATE TABLE public.users_roles(
	user_id_users integer NOT NULL,
	role_id_roles integer NOT NULL,
	CONSTRAINT pk_users_roles PRIMARY KEY (user_id_users,role_id_roles)

);
-- ddl-end --
ALTER TABLE public.users_roles OWNER TO postgres;
-- ddl-end --

-- object: public.users_objects | type: TABLE --
-- DROP TABLE IF EXISTS public.users_objects CASCADE;
CREATE TABLE public.users_objects(
	user_id_users integer NOT NULL,
	object_id_objects integer NOT NULL,
	access_grant smallint NOT NULL,
	access_deny smallint NOT NULL,
	CONSTRAINT pk_users_objects PRIMARY KEY (user_id_users,object_id_objects)

);
-- ddl-end --
ALTER TABLE public.users_objects OWNER TO postgres;
-- ddl-end --

-- object: public.roles_objects | type: TABLE --
-- DROP TABLE IF EXISTS public.roles_objects CASCADE;
CREATE TABLE public.roles_objects(
	role_id_roles integer NOT NULL,
	object_id_objects integer NOT NULL,
	access_grant smallint NOT NULL,
	access_deny smallint NOT NULL,
	CONSTRAINT pk_roles_objects PRIMARY KEY (role_id_roles,object_id_objects)

);
-- ddl-end --
ALTER TABLE public.roles_objects OWNER TO postgres;
-- ddl-end --

-- object: public.roles_roles | type: TABLE --
-- DROP TABLE IF EXISTS public.roles_roles CASCADE;
CREATE TABLE public.roles_roles(
	role_id_roles integer NOT NULL,
	roles_role_id integer NOT NULL,
	CONSTRAINT fk_roles_roles PRIMARY KEY (roles_role_id,role_id_roles)

);
-- ddl-end --
ALTER TABLE public.roles_roles OWNER TO postgres;
-- ddl-end --

-- object: fk_users_profiles | type: CONSTRAINT --
-- ALTER TABLE public.users DROP CONSTRAINT IF EXISTS fk_users_profiles CASCADE;
ALTER TABLE public.users ADD CONSTRAINT fk_users_profiles FOREIGN KEY (profile_id_profiles)
REFERENCES public.profiles (profile_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_profiles_roles_profiles | type: CONSTRAINT --
-- ALTER TABLE public.profiles_roles DROP CONSTRAINT IF EXISTS fk_profiles_roles_profiles CASCADE;
ALTER TABLE public.profiles_roles ADD CONSTRAINT fk_profiles_roles_profiles FOREIGN KEY (profile_id_profiles)
REFERENCES public.profiles (profile_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_profiles_roles_roles | type: CONSTRAINT --
-- ALTER TABLE public.profiles_roles DROP CONSTRAINT IF EXISTS fk_profiles_roles_roles CASCADE;
ALTER TABLE public.profiles_roles ADD CONSTRAINT fk_profiles_roles_roles FOREIGN KEY (role_id_roles)
REFERENCES public.roles (role_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_users_roles_users | type: CONSTRAINT --
-- ALTER TABLE public.users_roles DROP CONSTRAINT IF EXISTS fk_users_roles_users CASCADE;
ALTER TABLE public.users_roles ADD CONSTRAINT fk_users_roles_users FOREIGN KEY (user_id_users)
REFERENCES public.users (user_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_users_roles_roles | type: CONSTRAINT --
-- ALTER TABLE public.users_roles DROP CONSTRAINT IF EXISTS fk_users_roles_roles CASCADE;
ALTER TABLE public.users_roles ADD CONSTRAINT fk_users_roles_roles FOREIGN KEY (role_id_roles)
REFERENCES public.roles (role_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_users_objects_users | type: CONSTRAINT --
-- ALTER TABLE public.users_objects DROP CONSTRAINT IF EXISTS fk_users_objects_users CASCADE;
ALTER TABLE public.users_objects ADD CONSTRAINT fk_users_objects_users FOREIGN KEY (user_id_users)
REFERENCES public.users (user_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_users_objects_objects | type: CONSTRAINT --
-- ALTER TABLE public.users_objects DROP CONSTRAINT IF EXISTS fk_users_objects_objects CASCADE;
ALTER TABLE public.users_objects ADD CONSTRAINT fk_users_objects_objects FOREIGN KEY (object_id_objects)
REFERENCES public.objects (object_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_roles_objects_roles | type: CONSTRAINT --
-- ALTER TABLE public.roles_objects DROP CONSTRAINT IF EXISTS fk_roles_objects_roles CASCADE;
ALTER TABLE public.roles_objects ADD CONSTRAINT fk_roles_objects_roles FOREIGN KEY (role_id_roles)
REFERENCES public.roles (role_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_roles_objects_objects | type: CONSTRAINT --
-- ALTER TABLE public.roles_objects DROP CONSTRAINT IF EXISTS fk_roles_objects_objects CASCADE;
ALTER TABLE public.roles_objects ADD CONSTRAINT fk_roles_objects_objects FOREIGN KEY (object_id_objects)
REFERENCES public.objects (object_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_role_id_roles_roles | type: CONSTRAINT --
-- ALTER TABLE public.roles_roles DROP CONSTRAINT IF EXISTS fk_role_id_roles_roles CASCADE;
ALTER TABLE public.roles_roles ADD CONSTRAINT fk_role_id_roles_roles FOREIGN KEY (role_id_roles)
REFERENCES public.roles (role_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_roles_role_id_roles | type: CONSTRAINT --
-- ALTER TABLE public.roles_roles DROP CONSTRAINT IF EXISTS fk_roles_role_id_roles CASCADE;
ALTER TABLE public.roles_roles ADD CONSTRAINT fk_roles_role_id_roles FOREIGN KEY (roles_role_id)
REFERENCES public.roles (role_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

