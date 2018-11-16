--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accesses (
    id bigint NOT NULL,
    accessible_type character varying NOT NULL,
    accessible_id integer NOT NULL,
    user_id integer,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: accesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -

ALTER SEQUENCE accesses_id_seq OWNED BY accesses.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    tag_type_id bigint NOT NULL,
    recipe_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: child_tags; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW child_tags AS
 SELECT tags.id,
    tags.name,
    tags.description,
    tags.tag_type_id,
    tags.recipe_id,
    tags.created_at,
    tags.updated_at
   FROM tags;


--
-- Name: grandchild_tags; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW grandchild_tags AS
 SELECT tags.id,
    tags.name,
    tags.description,
    tags.tag_type_id,
    tags.recipe_id,
    tags.created_at,
    tags.updated_at
   FROM tags;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE recipes (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    instructions text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recipes_id_seq OWNED BY recipes.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--
CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tag_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tag_attributes (
    id bigint NOT NULL,
    tag_attributable_id integer NOT NULL,
    tag_attributable_type character varying NOT NULL,
    property character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tag_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tag_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_attributes_id_seq OWNED BY tag_attributes.id;


--
-- Name: tag_selections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tag_selections (
    id bigint NOT NULL,
    tag_id bigint NOT NULL,
    taggable_type character varying NOT NULL,
    taggable_id integer NOT NULL,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tag_selections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--
CREATE SEQUENCE tag_selections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_selections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_selections_id_seq OWNED BY tag_selections.id;


--
-- Name: tag_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tag_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tag_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tag_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_types_id_seq OWNED BY tag_types.id;


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_roles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    username character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: accesses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accesses ALTER COLUMN id SET DEFAULT nextval('accesses_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes ALTER COLUMN id SET DEFAULT nextval('recipes_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: tag_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_attributes ALTER COLUMN id SET DEFAULT nextval('tag_attributes_id_seq'::regclass);


--
-- Name: tag_selections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_selections ALTER COLUMN id SET DEFAULT nextval('tag_selections_id_seq'::regclass);


--
-- Name: tag_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_types ALTER COLUMN id SET DEFAULT nextval('tag_types_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: accesses accesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accesses
    ADD CONSTRAINT accesses_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tag_attributes tag_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_attributes
    ADD CONSTRAINT tag_attributes_pkey PRIMARY KEY (id);


--
-- Name: tag_selections tag_selections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE ONLY tag_selections
    ADD CONSTRAINT tag_selections_pkey PRIMARY KEY (id);


--
-- Name: tag_types tag_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_types
    ADD CONSTRAINT tag_types_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accesses_on_accessible_id_and_accessible_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accesses_on_accessible_id_and_accessible_type ON accesses USING btree (accessible_id, accessible_type);


--
-- Name: index_accesses_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accesses_on_user_id ON accesses USING btree (user_id);


--
-- Name: index_recipes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_name ON recipes USING btree (name);


--
-- Name: index_tag_attributes_on_attributable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_attributes_on_attributable ON tag_attributes USING btree (tag_attributable_id, tag_attributable_type);
--
-- Name: index_tag_selections_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_selections_on_tag_id ON tag_selections USING btree (tag_id);


--
-- Name: index_tag_selections_on_taggable_id_and_taggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_selections_on_taggable_id_and_taggable_type ON tag_selections USING btree (taggable_id, taggable_type);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_tags_on_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_recipe_id ON tags USING btree (recipe_id);


--
-- Name: index_tags_on_tag_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_tag_type_id ON tags USING btree (tag_type_id);


--
-- Name: index_user_roles_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_roles_on_role_id ON user_roles USING btree (role_id);


--
-- Name: index_user_roles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_roles_on_user_id ON user_roles USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);

--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- PostgreSQL database dump complete
--
INSERT INTO schema_migrations (version) VALUES ('20180726230603');

INSERT INTO schema_migrations (version) VALUES ('20180726230727');

INSERT INTO schema_migrations (version) VALUES ('20180726231918');

INSERT INTO schema_migrations (version) VALUES ('20180726234418');

INSERT INTO schema_migrations (version) VALUES ('20180726234813');

INSERT INTO schema_migrations (version) VALUES ('20180726234938');

INSERT INTO schema_migrations (version) VALUES ('20180726235212');

INSERT INTO schema_migrations (version) VALUES ('20180726235520');

INSERT INTO schema_migrations (version) VALUES ('20180726235950');

INSERT INTO schema_migrations (version) VALUES ('20181112133338');
