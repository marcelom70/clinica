--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE pgg_superadmins;
ALTER ROLE pgg_superadmins WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:FWSXKg7Rz5It/kkTmlSw/g==$qu6dJCfFqKIaYB2Q2YIqgP2A+8iM0nuQhXVzwbWQ0zw=:uerqKh4qPf75rRd+SYAS+ECS3Pe6X1FrZJa2EwqA+Hg=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:B7qAAPKFafNpQ9NkCsDuYQ==$PoogIxOWH1q8STvryXFrx0Ic9v3uu0FocFVFAuNjg1c=:Z/tOfRwEDzTIm1spjrKpLVNMELjXSPgnlW6ikXJ3xlw=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.2 (Debian 17.2-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "clinica_medica_dev" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.2 (Debian 17.2-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: clinica_medica_dev; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE clinica_medica_dev WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE clinica_medica_dev OWNER TO postgres;

\connect clinica_medica_dev

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ai_analysis_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_analysis_requests (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    medical_record_id integer,
    request_type character varying(50) NOT NULL,
    input_data text NOT NULL,
    results text,
    status character varying(20) DEFAULT 'pending'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ai_analysis_requests OWNER TO postgres;

--
-- Name: ai_analysis_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ai_analysis_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ai_analysis_requests_id_seq OWNER TO postgres;

--
-- Name: ai_analysis_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ai_analysis_requests_id_seq OWNED BY public.ai_analysis_requests.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    appointment_date timestamp with time zone NOT NULL,
    reason text NOT NULL,
    status character varying(20) DEFAULT 'scheduled'::character varying NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_id_seq OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: digitized_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.digitized_documents (
    id integer NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    patient_id integer,
    original_filename character varying(255) NOT NULL,
    storage_path text NOT NULL,
    document_type character varying(50) NOT NULL,
    processing_status character varying(20) DEFAULT 'pending'::character varying,
    ocr_data jsonb,
    processed_data jsonb,
    medical_record_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.digitized_documents OWNER TO postgres;

--
-- Name: digitized_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.digitized_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.digitized_documents_id_seq OWNER TO postgres;

--
-- Name: digitized_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.digitized_documents_id_seq OWNED BY public.digitized_documents.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    specialization character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.doctors OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.doctors_id_seq OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: health_insurance_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.health_insurance_plans (
    id integer NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    contact_info text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.health_insurance_plans OWNER TO postgres;

--
-- Name: health_insurance_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.health_insurance_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.health_insurance_plans_id_seq OWNER TO postgres;

--
-- Name: health_insurance_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.health_insurance_plans_id_seq OWNED BY public.health_insurance_plans.id;


--
-- Name: medical_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_records (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    appointment_id integer,
    diagnosis text NOT NULL,
    treatment text NOT NULL,
    prescription text,
    notes text,
    record_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.medical_records OWNER TO postgres;

--
-- Name: medical_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medical_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.medical_records_id_seq OWNER TO postgres;

--
-- Name: medical_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medical_records_id_seq OWNED BY public.medical_records.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    date_of_birth date NOT NULL,
    gender character varying(10) NOT NULL,
    email character varying(100),
    phone character varying(20) NOT NULL,
    address text,
    insurance_info text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.patients OWNER TO postgres;

--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patients_id_seq OWNER TO postgres;

--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    role character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'doctor'::character varying, 'patient'::character varying, 'staff'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: ai_analysis_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_analysis_requests ALTER COLUMN id SET DEFAULT nextval('public.ai_analysis_requests_id_seq'::regclass);


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: digitized_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.digitized_documents ALTER COLUMN id SET DEFAULT nextval('public.digitized_documents_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: health_insurance_plans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_insurance_plans ALTER COLUMN id SET DEFAULT nextval('public.health_insurance_plans_id_seq'::regclass);


--
-- Name: medical_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_records ALTER COLUMN id SET DEFAULT nextval('public.medical_records_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);


--
-- Data for Name: ai_analysis_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ai_analysis_requests (id, patient_id, medical_record_id, request_type, input_data, results, status, created_at, updated_at) FROM stdin;
1	86	82		Ultrassonografia transvaginal solicitada para investigação de dismenorreia secundária. A paciente relata dor pélvica intensa durante o período menstrual, acompanhada de aumento do fluxo, náuseas e fadiga, com histórico de piora progressiva nos últimos 6 meses.	\n{\n  "results": "Hypothetical Results:\\nUterus: in anteverted position, of normal volume.\\n\\nEndometria: with thickness compatible with the phase of the menstrual cycle.\\n\\nOvaries: preserved dimensions, without evidence of functional cysts.\\n\\nRelevant findings: presence of small hypoechoic formations in the posterior region of the myometrium, compatible with adenomyosis.\\n\\nConclusion: Findings suggestive of adenomyosis, which may justify secondary dysmenorrhea. Clinical correlation and complementary evaluation with magnetic resonance imaging are suggested, if necessary.\\n\\n💊 Suggested treatment and prescription (example for prescription):\\nAnalgesic: Ibuprofen 600mg, 1 tablet every 8 hours during the menstrual period.\\n\\nCombined oral contraceptive (progesterone/estrogen), continuous use to suppress menstruation.\\n\\nReassessment in 3 months.\\n\\n🗒️ Additional notes (notes field):\\nPatient advised on the probable diagnosis and therapeutic options. Informed about the side effects of hormonal treatment and the importance of regular follow-up. Reinforced the use of analgesics only as needed. Complementary laboratory tests were requested for hormonal evaluation and blood count."\n}\n	pending	2025-04-20 23:39:54.820719	2025-04-20 23:39:54.820719
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (id, patient_id, doctor_id, appointment_date, reason, status, notes, created_at, updated_at) FROM stdin;
1	38	1	2025-03-31 07:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:55:09.402068+00	2025-04-19 17:39:49.736205+00
2	17	2	2025-03-14 18:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:55:09.405015+00	2025-04-19 17:39:49.736205+00
3	4	8	2025-04-02 21:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:56:24.377135+00	2025-04-19 17:39:49.736205+00
4	21	9	2025-03-08 02:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:56:28.012917+00	2025-04-19 17:39:49.736205+00
5	15	10	2025-03-29 17:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:56:31.306775+00	2025-04-19 17:39:49.736205+00
6	100	1	2025-03-04 05:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:56:33.897757+00	2025-04-19 17:39:49.736205+00
7	84	2	2025-04-24 11:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:56:37.185104+00	2025-04-19 17:39:49.736205+00
8	36	3	2025-03-14 13:00:00+00	orthopedics	completed	torção recente no tornozelo direito, com inchaço.	2025-04-19 14:56:40.235053+00	2025-04-19 17:39:49.736205+00
9	70	4	2025-04-17 17:00:00+00	dermatology	completed	manchas vermelhas que coçam na pele.	2025-04-19 14:56:42.962847+00	2025-04-19 17:39:49.736205+00
10	91	5	2025-03-29 01:00:00+00	neurology	completed	dores de cabeça constantes e visão turva ocasional.	2025-04-19 14:56:45.568947+00	2025-04-19 17:39:49.736205+00
11	94	6	2025-03-20 06:00:00+00	pediatrics	completed	febre leve e tosse seca há 2 dias.	2025-04-19 14:56:48.166327+00	2025-04-19 17:39:49.736205+00
12	90	7	2025-03-07 12:00:00+00	psychiatry	completed	ansiedade generalizada e dificuldade para dormir.	2025-04-19 14:56:50.730834+00	2025-04-19 17:39:49.736205+00
13	3	8	2025-04-26 15:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:56:53.274314+00	2025-04-19 17:39:49.736205+00
14	4	9	2025-03-05 13:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:56:55.770348+00	2025-04-19 17:39:49.736205+00
15	62	10	2025-03-22 00:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:56:58.426512+00	2025-04-19 17:39:49.736205+00
16	15	1	2025-04-08 17:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:57:00.994316+00	2025-04-19 17:39:49.736205+00
17	40	2	2025-03-17 05:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:57:03.553698+00	2025-04-19 17:39:49.736205+00
59	80	4	2025-04-05 14:00:00+00	dermatology	completed	manchas vermelhas que coçam na pele.	2025-04-19 14:57:14.804191+00	2025-04-19 17:39:49.736205+00
18	87	3	2025-04-03 14:00:00+00	orthopedics	completed	torção recente no tornozelo direito, com inchaço.	2025-04-19 14:57:06.153382+00	2025-04-19 17:39:49.736205+00
19	61	4	2025-03-11 05:00:00+00	dermatology	completed	manchas vermelhas que coçam na pele.	2025-04-19 14:57:08.865475+00	2025-04-19 17:39:49.736205+00
20	43	5	2025-03-11 07:00:00+00	neurology	completed	dores de cabeça constantes e visão turva ocasional.	2025-04-19 14:57:14.729494+00	2025-04-19 17:39:49.736205+00
21	48	6	2025-04-13 22:00:00+00	pediatrics	completed	febre leve e tosse seca há 2 dias.	2025-04-19 14:57:14.731226+00	2025-04-19 17:39:49.736205+00
22	27	7	2025-03-19 15:00:00+00	psychiatry	completed	ansiedade generalizada e dificuldade para dormir.	2025-04-19 14:57:14.733627+00	2025-04-19 17:39:49.736205+00
23	45	8	2025-04-25 12:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:57:14.73485+00	2025-04-19 17:39:49.736205+00
24	14	9	2025-04-13 19:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:57:14.737176+00	2025-04-19 17:39:49.736205+00
25	74	10	2025-03-24 13:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:57:14.738292+00	2025-04-19 17:39:49.736205+00
26	65	1	2025-04-08 23:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:57:14.740626+00	2025-04-19 17:39:49.736205+00
27	19	2	2025-04-16 20:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:57:14.741988+00	2025-04-19 17:39:49.736205+00
28	12	3	2025-04-06 02:00:00+00	orthopedics	completed	torção recente no tornozelo direito, com inchaço.	2025-04-19 14:57:14.744519+00	2025-04-19 17:39:49.736205+00
29	44	4	2025-03-28 01:00:00+00	dermatology	completed	manchas vermelhas que coçam na pele.	2025-04-19 14:57:14.745748+00	2025-04-19 17:39:49.736205+00
30	79	5	2025-04-26 17:00:00+00	neurology	completed	dores de cabeça constantes e visão turva ocasional.	2025-04-19 14:57:14.748563+00	2025-04-19 17:39:49.736205+00
31	75	6	2025-03-18 21:00:00+00	pediatrics	completed	febre leve e tosse seca há 2 dias.	2025-04-19 14:57:14.749769+00	2025-04-19 17:39:49.736205+00
32	51	7	2025-04-02 22:00:00+00	psychiatry	completed	ansiedade generalizada e dificuldade para dormir.	2025-04-19 14:57:14.752728+00	2025-04-19 17:39:49.736205+00
33	32	8	2025-03-20 18:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:57:14.754358+00	2025-04-19 17:39:49.736205+00
34	25	9	2025-04-10 18:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:57:14.757353+00	2025-04-19 17:39:49.736205+00
35	88	10	2025-04-25 03:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:57:14.759167+00	2025-04-19 17:39:49.736205+00
36	46	1	2025-04-02 02:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:57:14.762151+00	2025-04-19 17:39:49.736205+00
37	18	2	2025-04-11 08:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:57:14.763639+00	2025-04-19 17:39:49.736205+00
38	89	3	2025-04-22 05:00:00+00	orthopedics	completed	torção recente no tornozelo direito, com inchaço.	2025-04-19 14:57:14.76629+00	2025-04-19 17:39:49.736205+00
39	18	4	2025-03-23 10:00:00+00	dermatology	completed	manchas vermelhas que coçam na pele.	2025-04-19 14:57:14.767714+00	2025-04-19 17:39:49.736205+00
40	88	5	2025-04-12 07:00:00+00	neurology	completed	dores de cabeça constantes e visão turva ocasional.	2025-04-19 14:57:14.769927+00	2025-04-19 17:39:49.736205+00
41	39	6	2025-04-02 01:00:00+00	pediatrics	completed	febre leve e tosse seca há 2 dias.	2025-04-19 14:57:14.771096+00	2025-04-19 17:39:49.736205+00
42	71	7	2025-04-08 03:00:00+00	psychiatry	completed	ansiedade generalizada e dificuldade para dormir.	2025-04-19 14:57:14.77364+00	2025-04-19 17:39:49.736205+00
43	59	8	2025-04-24 14:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:57:14.774732+00	2025-04-19 17:39:49.736205+00
44	40	9	2025-04-27 08:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:57:14.777108+00	2025-04-19 17:39:49.736205+00
45	2	10	2025-04-02 18:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:57:14.778209+00	2025-04-19 17:39:49.736205+00
46	42	1	2025-04-29 13:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:57:14.780546+00	2025-04-19 17:39:49.736205+00
47	62	2	2025-04-10 15:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:57:14.781718+00	2025-04-19 17:39:49.736205+00
48	24	3	2025-03-08 19:00:00+00	orthopedics	completed	torção recente no tornozelo direito, com inchaço.	2025-04-19 14:57:14.784078+00	2025-04-19 17:39:49.736205+00
49	50	4	2025-04-14 09:00:00+00	dermatology	completed	manchas vermelhas que coçam na pele.	2025-04-19 14:57:14.785187+00	2025-04-19 17:39:49.736205+00
50	29	5	2025-03-21 13:00:00+00	neurology	completed	dores de cabeça constantes e visão turva ocasional.	2025-04-19 14:57:14.787384+00	2025-04-19 17:39:49.736205+00
51	30	6	2025-04-16 08:00:00+00	pediatrics	completed	febre leve e tosse seca há 2 dias.	2025-04-19 14:57:14.790757+00	2025-04-19 17:39:49.736205+00
52	34	7	2025-03-13 18:00:00+00	psychiatry	completed	ansiedade generalizada e dificuldade para dormir.	2025-04-19 14:57:14.793464+00	2025-04-19 17:39:49.736205+00
53	85	8	2025-04-15 11:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:57:14.794719+00	2025-04-19 17:39:49.736205+00
54	80	9	2025-03-10 07:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:57:14.797158+00	2025-04-19 17:39:49.736205+00
55	85	10	2025-04-18 17:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:57:14.798128+00	2025-04-19 17:39:49.736205+00
56	83	1	2025-04-17 07:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:57:14.800204+00	2025-04-19 17:39:49.736205+00
57	72	2	2025-03-29 09:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:57:14.801112+00	2025-04-19 17:39:49.736205+00
58	64	3	2025-03-29 07:00:00+00	orthopedics	completed	torção recente no tornozelo direito, com inchaço.	2025-04-19 14:57:14.803244+00	2025-04-19 17:39:49.736205+00
60	36	5	2025-03-03 11:00:00+00	neurology	completed	dores de cabeça constantes e visão turva ocasional.	2025-04-19 14:57:14.806625+00	2025-04-19 17:39:49.736205+00
61	73	6	2025-04-11 23:00:00+00	pediatrics	completed	febre leve e tosse seca há 2 dias.	2025-04-19 14:57:14.80788+00	2025-04-19 17:39:49.736205+00
62	46	7	2025-04-10 01:00:00+00	psychiatry	completed	ansiedade generalizada e dificuldade para dormir.	2025-04-19 14:57:14.810369+00	2025-04-19 17:39:49.736205+00
63	73	8	2025-03-18 18:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:57:14.811415+00	2025-04-19 17:39:49.736205+00
64	13	9	2025-04-18 06:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:57:14.813479+00	2025-04-19 17:39:49.736205+00
65	42	10	2025-04-17 15:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:57:14.814362+00	2025-04-19 17:39:49.736205+00
66	91	1	2025-03-03 07:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:57:14.81642+00	2025-04-19 17:39:49.736205+00
67	2	2	2025-03-28 11:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:57:14.817451+00	2025-04-19 17:39:49.736205+00
68	37	3	2025-03-03 00:00:00+00	orthopedics	completed	torção recente no tornozelo direito, com inchaço.	2025-04-19 14:57:14.819598+00	2025-04-19 17:39:49.736205+00
69	30	4	2025-03-08 05:00:00+00	dermatology	completed	manchas vermelhas que coçam na pele.	2025-04-19 14:57:14.820569+00	2025-04-19 17:39:49.736205+00
70	34	5	2025-03-05 04:00:00+00	neurology	completed	dores de cabeça constantes e visão turva ocasional.	2025-04-19 14:57:14.822789+00	2025-04-19 17:39:49.736205+00
71	62	6	2025-03-21 12:00:00+00	pediatrics	completed	febre leve e tosse seca há 2 dias.	2025-04-19 14:57:14.823858+00	2025-04-19 17:39:49.736205+00
72	99	7	2025-03-10 15:00:00+00	psychiatry	completed	ansiedade generalizada e dificuldade para dormir.	2025-04-19 14:57:14.826195+00	2025-04-19 17:39:49.736205+00
73	10	8	2025-04-09 09:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:57:14.827356+00	2025-04-19 17:39:49.736205+00
74	95	9	2025-04-10 21:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:57:14.829588+00	2025-04-19 17:39:49.736205+00
75	43	10	2025-03-07 22:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:57:14.830653+00	2025-04-19 17:39:49.736205+00
76	47	1	2025-04-12 11:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:57:14.832839+00	2025-04-19 17:39:49.736205+00
77	99	2	2025-04-24 10:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:57:14.833974+00	2025-04-19 17:39:49.736205+00
78	79	3	2025-04-13 05:00:00+00	orthopedics	completed	torção recente no tornozelo direito, com inchaço.	2025-04-19 14:57:14.836295+00	2025-04-19 17:39:49.736205+00
79	94	4	2025-03-26 14:00:00+00	dermatology	completed	manchas vermelhas que coçam na pele.	2025-04-19 14:57:14.837377+00	2025-04-19 17:39:49.736205+00
80	33	5	2025-03-25 19:00:00+00	neurology	completed	dores de cabeça constantes e visão turva ocasional.	2025-04-19 14:57:14.839772+00	2025-04-19 17:39:49.736205+00
81	9	6	2025-04-15 00:00:00+00	pediatrics	completed	febre leve e tosse seca há 2 dias.	2025-04-19 14:57:14.840864+00	2025-04-19 17:39:49.736205+00
82	43	7	2025-03-27 09:00:00+00	psychiatry	completed	ansiedade generalizada e dificuldade para dormir.	2025-04-19 14:57:14.84354+00	2025-04-19 17:39:49.736205+00
83	97	8	2025-03-03 22:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:57:14.844951+00	2025-04-19 17:39:49.736205+00
84	25	9	2025-03-13 19:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:57:14.847434+00	2025-04-19 17:39:49.736205+00
85	80	10	2025-03-21 11:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:57:14.848742+00	2025-04-19 17:39:49.736205+00
86	21	1	2025-03-08 17:00:00+00	gynecology	completed	dor pélvica persistente e suspeita de endometriose.	2025-04-19 14:57:14.851505+00	2025-04-19 17:39:49.736205+00
87	86	2	2025-03-28 11:00:00+00	cardiology	completed	pressão alta pela manhã e histórico familiar de problemas cardíacos.	2025-04-19 14:57:14.852778+00	2025-04-19 17:39:49.736205+00
88	50	3	2025-04-15 11:00:00+00	orthopedics	completed	torção recente no tornozelo direito, com inchaço.	2025-04-19 14:57:14.855172+00	2025-04-19 17:39:49.736205+00
89	77	4	2025-04-29 16:00:00+00	dermatology	completed	manchas vermelhas que coçam na pele.	2025-04-19 14:57:14.856846+00	2025-04-19 17:39:49.736205+00
90	89	5	2025-03-04 06:00:00+00	neurology	completed	dores de cabeça constantes e visão turva ocasional.	2025-04-19 14:57:14.859782+00	2025-04-19 17:39:49.736205+00
91	95	6	2025-03-03 12:00:00+00	pediatrics	completed	febre leve e tosse seca há 2 dias.	2025-04-19 14:57:14.861445+00	2025-04-19 17:39:49.736205+00
92	83	7	2025-03-04 09:00:00+00	psychiatry	completed	ansiedade generalizada e dificuldade para dormir.	2025-04-19 14:57:14.864022+00	2025-04-19 17:39:49.736205+00
93	57	8	2025-04-19 05:00:00+00	gastroenterology	completed	azia frequente após refeições pesadas.	2025-04-19 14:57:14.865494+00	2025-04-19 17:39:49.736205+00
94	40	9	2025-04-10 16:00:00+00	urology	completed	dor ao urinar e aumento na frequência urinária.	2025-04-19 14:57:14.867951+00	2025-04-19 17:39:49.736205+00
95	16	10	2025-04-04 20:00:00+00	endocrinology	completed	cansaço extremo e ganho de peso repentino.	2025-04-19 14:57:14.869195+00	2025-04-19 17:39:49.736205+00
\.


--
-- Data for Name: digitized_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.digitized_documents (id, uuid, patient_id, original_filename, storage_path, document_type, processing_status, ocr_data, processed_data, medical_record_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors (id, name, specialization, email, phone, created_at, updated_at) FROM stdin;
1	Esther Barros	Ginecologia	bruna41@yahoo.com.br	+55 21 1379-7283	2025-04-19 14:54:21.915884+00	2025-04-19 14:54:21.915884+00
3	Diego Vieira	Ortopedia	almeidadaniel@nunes.com	+55 21 9987-7346	2025-04-19 14:54:21.920434+00	2025-04-19 14:54:21.920434+00
4	Isis Porto	Dermatologia	ramosbernardo@hotmail.com	(071) 9730 5848	2025-04-19 14:54:21.922888+00	2025-04-19 14:54:21.922888+00
5	Ana Lívia Vieira	Pediatria	oaragao@uol.com.br	(011) 3410 6243	2025-04-19 14:54:21.924638+00	2025-04-19 14:54:21.924638+00
6	Davi Rocha	Neurologia	joao-felipe85@bol.com.br	81 1264-0310	2025-04-19 14:54:21.927141+00	2025-04-19 14:54:21.927141+00
7	Lívia Barros	Psiquiatria	zsilva@rodrigues.br	(021) 3777-6217	2025-04-19 14:54:21.928336+00	2025-04-19 14:54:21.928336+00
8	Thomas Barros	Endocrinologia	raqueldias@yahoo.com.br	61 0841-1263	2025-04-19 14:54:21.931006+00	2025-04-19 14:54:21.931006+00
9	Letícia Souza	Urologia	scastro@gmail.com	0300-512-2520	2025-04-19 14:54:21.93224+00	2025-04-19 14:54:21.93224+00
10	Breno Melo	Oftalmologia	yurifarias@uol.com.br	(031) 2477 3151	2025-04-19 14:54:21.934747+00	2025-04-19 14:54:21.934747+00
2	Mariana Correia	Cardiologia	joaquimsales@mendes.org	+55 (051) 5239 6725	2025-04-19 14:54:21.919206+00	2025-04-19 15:19:38.241392+00
\.


--
-- Data for Name: health_insurance_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.health_insurance_plans (id, uuid, name, code, contact_info, created_at, updated_at) FROM stdin;
1	16c6531c-0f7a-42c5-b264-3d1a3a7ceda8	Bradesco	804		2025-04-19 16:53:20.47394+00	2025-04-19 16:53:20.47394+00
2	31428c49-b0e0-4733-b66b-4eecb8717838	Unimed	591		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
3	b31a08a4-12a0-4d15-b96e-f10e2262bed5	Sul America	199		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
4	a854903d-5a59-46aa-89b5-bcadd815c91f	Omint	373		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
5	408dcfff-f88d-4737-bbbc-46eb449b7f80	Amil	114		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
6	b443028e-4d04-48c8-b946-c566f8303db7	Porto Seguro	834		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
7	25be3b28-ccc2-48e0-8f4b-87313360afaa	NotreDame	117		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
8	cc76d6da-f240-45a0-9951-69a2d92beee2	Prevent Senior	492		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
9	6d543c5a-5052-4aac-bbdb-83570779a3f2	MedSenior	930		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
10	05e836a1-2a0d-45f4-bedf-ffb40c54e54c	Golden Cross	561		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
11	29562d3a-2e21-497f-8000-5f87b4de4eea	Alice	928		2025-04-19 16:54:19.92938+00	2025-04-19 16:54:19.92938+00
\.


--
-- Data for Name: medical_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medical_records (id, patient_id, doctor_id, appointment_id, diagnosis, treatment, prescription, notes, record_date, created_at, updated_at) FROM stdin;
1	39	1	1	Hipertensão arterial	Sessões de acupuntura	Fluoxetina 20mg/dia	Recomendado evitar atividades físicas intensas.	2024-05-30 20:33:02+00	2025-04-19 17:35:13.162152+00	2025-04-19 17:35:13.162152+00
2	72	10	2	Dor lombar	Acompanhamento mensal	Salbutamol spray 2x/dia	Necessário agendar retorno em 30 dias.	2025-02-19 20:33:02+00	2025-04-19 17:35:23.745254+00	2025-04-19 17:35:23.745254+00
3	49	8	3	Dismenorreia	Hidratação oral e repouso	Desloratadina 5mg/dia	Relatou efeitos colaterais leves.	2025-02-06 20:33:02+00	2025-04-19 17:35:23.7485+00	2025-04-19 17:35:23.7485+00
4	33	7	4	Alergia sazonal	Fisioterapia	Salbutamol spray 2x/dia	Queixa-se de dor frequente ao final do dia.	2024-12-05 20:33:02+00	2025-04-19 17:35:23.750326+00	2025-04-19 17:35:23.750326+00
5	33	7	5	Asma leve	Dieta controlada	Salbutamol spray 2x/dia	Paciente relata melhora parcial dos sintomas.	2025-04-11 20:33:02+00	2025-04-19 17:35:23.752943+00	2025-04-19 17:35:23.752943+00
6	73	6	6	Gastrite	Fisioterapia	Dipirona 500mg se febre	Relatou efeitos colaterais leves.	2025-04-13 20:33:02+00	2025-04-19 17:35:23.754424+00	2025-04-19 17:35:23.754424+00
7	82	3	7	Cefaleia tensional	Redução do estresse	Dipirona 500mg se febre	Segue dieta conforme orientação.	2024-08-23 20:33:02+00	2025-04-19 17:35:23.756976+00	2025-04-19 17:35:23.756976+00
8	1	10	8	Dismenorreia	Dieta controlada	Salbutamol spray 2x/dia	Necessário agendar retorno em 30 dias.	2024-06-09 20:33:02+00	2025-04-19 17:35:23.758335+00	2025-04-19 17:35:23.758335+00
9	47	7	9	Alergia sazonal	Psicoterapia	Losartana 50mg 1x/dia	Primeira consulta após diagnóstico.	2024-07-06 20:33:02+00	2025-04-19 17:35:23.760981+00	2025-04-19 17:35:23.760981+00
10	71	9	10	Hipertensão arterial	Fisioterapia	Desloratadina 5mg/dia	Relatou efeitos colaterais leves.	2024-05-13 20:33:02+00	2025-04-19 17:35:23.762259+00	2025-04-19 17:35:23.762259+00
11	49	9	11	Infecção urinária	Fisioterapia	Desloratadina 5mg/dia	Instruído sobre importância do tratamento contínuo.	2024-06-14 20:33:02+00	2025-04-19 17:35:23.764838+00	2025-04-19 17:35:23.764838+00
12	91	6	12	Cefaleia tensional	Uso de broncodilatadores	Salbutamol spray 2x/dia	Recomendado evitar atividades físicas intensas.	2024-08-21 20:33:02+00	2025-04-19 17:35:23.766262+00	2025-04-19 17:35:23.766262+00
13	50	9	13	Diabetes tipo 2	Redução do estresse	Losartana 50mg 1x/dia	Primeira consulta após diagnóstico.	2024-07-19 20:33:02+00	2025-04-19 17:35:23.768704+00	2025-04-19 17:35:23.768704+00
14	86	6	14	Asma leve	Hidratação oral e repouso	Losartana 50mg 1x/dia	Necessário agendar retorno em 30 dias.	2024-05-02 20:33:02+00	2025-04-19 17:35:23.769946+00	2025-04-19 17:35:23.769946+00
15	16	10	15	Dismenorreia	Aplicação de calor local	Desloratadina 5mg/dia	Paciente orientado a manter hidratação.	2025-02-16 20:33:02+00	2025-04-19 17:35:23.772279+00	2025-04-19 17:35:23.772279+00
16	79	1	16	Gastrite	Reposição hormonal	Omeprazol 20mg antes do café	Queixa-se de dor frequente ao final do dia.	2024-09-06 20:33:02+00	2025-04-19 17:35:23.773368+00	2025-04-19 17:35:23.773368+00
17	16	5	17	Infecção urinária	Fisioterapia	Salbutamol spray 2x/dia	Instruído sobre importância do tratamento contínuo.	2024-09-01 20:33:02+00	2025-04-19 17:35:23.775696+00	2025-04-19 17:35:23.775696+00
18	96	4	18	Asma leve	Uso de broncodilatadores	Metformina 500mg 2x/dia	Segue dieta conforme orientação.	2024-08-27 20:33:02+00	2025-04-19 17:35:23.777067+00	2025-04-19 17:35:23.777067+00
19	67	3	19	Dismenorreia	Hidratação oral e repouso	Paracetamol 750mg se dor	Queixa-se de dor frequente ao final do dia.	2024-05-20 20:33:02+00	2025-04-19 17:35:23.779648+00	2025-04-19 17:35:23.779648+00
20	85	8	20	Asma leve	Sessões de acupuntura	Desloratadina 5mg/dia	Instruído sobre importância do tratamento contínuo.	2025-04-18 20:33:02+00	2025-04-19 17:35:23.781204+00	2025-04-19 17:35:23.781204+00
21	26	9	21	Hipertensão arterial	Uso de broncodilatadores	Salbutamol spray 2x/dia	Primeira consulta após diagnóstico.	2024-12-25 20:33:02+00	2025-04-19 17:35:23.784064+00	2025-04-19 17:35:23.784064+00
22	75	5	22	Asma leve	Uso de broncodilatadores	Fluoxetina 20mg/dia	Segue dieta conforme orientação.	2024-10-18 20:33:02+00	2025-04-19 17:35:23.785787+00	2025-04-19 17:35:23.785787+00
23	57	5	23	Asma leve	Acompanhamento mensal	Anticoncepcional oral combinado	Relatou efeitos colaterais leves.	2024-04-25 20:33:02+00	2025-04-19 17:35:23.788395+00	2025-04-19 17:35:23.788395+00
24	46	9	24	Dismenorreia	Psicoterapia	Dipirona 500mg se febre	Primeira consulta após diagnóstico.	2024-06-30 20:33:02+00	2025-04-19 17:35:23.789634+00	2025-04-19 17:35:23.789634+00
25	33	9	25	Asma leve	Acompanhamento mensal	Omeprazol 20mg antes do café	Paciente relata melhora parcial dos sintomas.	2025-02-12 20:33:02+00	2025-04-19 17:35:23.792351+00	2025-04-19 17:35:23.792351+00
26	3	6	26	Infecção urinária	Fisioterapia	Losartana 50mg 1x/dia	Instruído sobre importância do tratamento contínuo.	2024-09-21 20:33:02+00	2025-04-19 17:35:23.794133+00	2025-04-19 17:35:23.794133+00
27	100	3	27	Diabetes tipo 2	Redução do estresse	Ibuprofeno 600mg se dor	Instruído sobre importância do tratamento contínuo.	2024-12-08 20:33:02+00	2025-04-19 17:35:23.79696+00	2025-04-19 17:35:23.79696+00
28	24	6	28	Cefaleia tensional	Hidratação oral e repouso	Dipirona 500mg se febre	Segue dieta conforme orientação.	2024-08-27 20:33:02+00	2025-04-19 17:35:23.79868+00	2025-04-19 17:35:23.79868+00
29	12	7	29	Dor lombar	Aplicação de calor local	Losartana 50mg 1x/dia	Relatou efeitos colaterais leves.	2025-02-25 20:33:02+00	2025-04-19 17:35:23.801774+00	2025-04-19 17:35:23.801774+00
30	60	1	30	Gastrite	Reposição hormonal	Anticoncepcional oral combinado	Relatou efeitos colaterais leves.	2024-07-06 20:33:02+00	2025-04-19 17:35:23.80357+00	2025-04-19 17:35:23.80357+00
31	86	6	31	Ansiedade generalizada	Aplicação de calor local	Ibuprofeno 600mg se dor	Primeira consulta após diagnóstico.	2024-12-03 20:33:02+00	2025-04-19 17:35:23.806265+00	2025-04-19 17:35:23.806265+00
32	78	1	32	Dismenorreia	Redução do estresse	Desloratadina 5mg/dia	Necessário agendar retorno em 30 dias.	2025-01-14 20:33:02+00	2025-04-19 17:35:23.807742+00	2025-04-19 17:35:23.807742+00
33	26	4	33	Diabetes tipo 2	Fisioterapia	Salbutamol spray 2x/dia	Necessário agendar retorno em 30 dias.	2025-01-23 20:33:02+00	2025-04-19 17:35:23.810563+00	2025-04-19 17:35:23.810563+00
34	24	3	34	Dismenorreia	Psicoterapia	Ibuprofeno 600mg se dor	Relatou efeitos colaterais leves.	2025-02-21 20:33:02+00	2025-04-19 17:35:23.812109+00	2025-04-19 17:35:23.812109+00
35	15	2	35	Gastrite	Redução do estresse	Salbutamol spray 2x/dia	Segue dieta conforme orientação.	2024-11-24 20:33:02+00	2025-04-19 17:35:23.814846+00	2025-04-19 17:35:23.814846+00
36	27	5	36	Cefaleia tensional	Psicoterapia	Metformina 500mg 2x/dia	Paciente orientado a manter hidratação.	2024-07-31 20:33:02+00	2025-04-19 17:35:23.816495+00	2025-04-19 17:35:23.816495+00
37	95	2	37	Infecção urinária	Aplicação de calor local	Omeprazol 20mg antes do café	Instruído sobre importância do tratamento contínuo.	2024-09-24 20:33:02+00	2025-04-19 17:35:23.819428+00	2025-04-19 17:35:23.819428+00
38	26	2	38	Hipertensão arterial	Redução do estresse	Paracetamol 750mg se dor	Recomendado evitar atividades físicas intensas.	2025-03-11 20:33:02+00	2025-04-19 17:35:23.82096+00	2025-04-19 17:35:23.82096+00
39	65	4	39	Infecção urinária	Sessões de acupuntura	Dipirona 500mg se febre	Necessário agendar retorno em 30 dias.	2024-07-22 20:33:02+00	2025-04-19 17:35:23.823742+00	2025-04-19 17:35:23.823742+00
40	87	3	40	Asma leve	Psicoterapia	Paracetamol 750mg se dor	Relatou efeitos colaterais leves.	2024-07-30 20:33:02+00	2025-04-19 17:35:23.825353+00	2025-04-19 17:35:23.825353+00
41	29	8	41	Infecção urinária	Hidratação oral e repouso	Metformina 500mg 2x/dia	Necessário agendar retorno em 30 dias.	2024-09-07 20:33:02+00	2025-04-19 17:35:23.828362+00	2025-04-19 17:35:23.828362+00
42	20	3	42	Alergia sazonal	Aplicação de calor local	Ibuprofeno 600mg se dor	Paciente relata melhora parcial dos sintomas.	2024-08-25 20:33:02+00	2025-04-19 17:35:23.829756+00	2025-04-19 17:35:23.829756+00
43	11	6	43	Infecção urinária	Hidratação oral e repouso	Anticoncepcional oral combinado	Paciente relata melhora parcial dos sintomas.	2025-02-04 20:33:02+00	2025-04-19 17:35:23.832612+00	2025-04-19 17:35:23.832612+00
44	16	9	44	Gastrite	Uso de broncodilatadores	Desloratadina 5mg/dia	Queixa-se de dor frequente ao final do dia.	2024-06-06 20:33:02+00	2025-04-19 17:35:23.834645+00	2025-04-19 17:35:23.834645+00
45	55	7	45	Asma leve	Acompanhamento mensal	Omeprazol 20mg antes do café	Primeira consulta após diagnóstico.	2025-03-12 20:33:02+00	2025-04-19 17:35:23.837188+00	2025-04-19 17:35:23.837188+00
46	72	7	46	Ansiedade generalizada	Redução do estresse	Paracetamol 750mg se dor	Necessário agendar retorno em 30 dias.	2024-08-13 20:33:02+00	2025-04-19 17:35:23.838673+00	2025-04-19 17:35:23.838673+00
47	75	9	47	Infecção urinária	Redução do estresse	Omeprazol 20mg antes do café	Recomendado evitar atividades físicas intensas.	2025-01-25 20:33:02+00	2025-04-19 17:35:23.841024+00	2025-04-19 17:35:23.841024+00
48	64	3	48	Gastrite	Dieta controlada	Fluoxetina 20mg/dia	Primeira consulta após diagnóstico.	2024-06-16 20:33:02+00	2025-04-19 17:35:23.842833+00	2025-04-19 17:35:23.842833+00
49	9	7	49	Hipertensão arterial	Acompanhamento mensal	Anticoncepcional oral combinado	Instruído sobre importância do tratamento contínuo.	2025-01-10 20:33:02+00	2025-04-19 17:35:23.84581+00	2025-04-19 17:35:23.84581+00
50	26	5	50	Hipertensão arterial	Reposição hormonal	Dipirona 500mg se febre	Paciente relata melhora parcial dos sintomas.	2024-06-07 20:33:02+00	2025-04-19 17:35:23.847292+00	2025-04-19 17:35:23.847292+00
51	21	7	51	Infecção urinária	Redução do estresse	Omeprazol 20mg antes do café	Instruído sobre importância do tratamento contínuo.	2024-05-23 20:33:02+00	2025-04-19 17:35:23.850157+00	2025-04-19 17:35:23.850157+00
52	88	3	52	Cefaleia tensional	Reposição hormonal	Fluoxetina 20mg/dia	Primeira consulta após diagnóstico.	2024-12-07 20:33:02+00	2025-04-19 17:35:23.851862+00	2025-04-19 17:35:23.851862+00
53	49	6	53	Dismenorreia	Psicoterapia	Paracetamol 750mg se dor	Necessário agendar retorno em 30 dias.	2024-07-30 20:33:02+00	2025-04-19 17:35:23.85447+00	2025-04-19 17:35:23.85447+00
54	3	7	54	Ansiedade generalizada	Redução do estresse	Omeprazol 20mg antes do café	Queixa-se de dor frequente ao final do dia.	2024-09-06 20:33:02+00	2025-04-19 17:35:23.855761+00	2025-04-19 17:35:23.855761+00
55	80	1	55	Dor lombar	Hidratação oral e repouso	Anticoncepcional oral combinado	Paciente demonstrou preocupação com os sintomas.	2024-08-12 20:33:02+00	2025-04-19 17:35:23.858207+00	2025-04-19 17:35:23.858207+00
56	37	1	56	Cefaleia tensional	Fisioterapia	Salbutamol spray 2x/dia	Queixa-se de dor frequente ao final do dia.	2024-06-05 20:33:02+00	2025-04-19 17:35:23.8596+00	2025-04-19 17:35:23.8596+00
57	39	1	57	Dismenorreia	Reposição hormonal	Salbutamol spray 2x/dia	Paciente relata melhora parcial dos sintomas.	2024-09-15 20:33:02+00	2025-04-19 17:35:23.86238+00	2025-04-19 17:35:23.86238+00
58	84	1	58	Hipertensão arterial	Dieta controlada	Dipirona 500mg se febre	Segue dieta conforme orientação.	2025-03-30 20:33:02+00	2025-04-19 17:35:23.863908+00	2025-04-19 17:35:23.863908+00
59	76	10	59	Gastrite	Redução do estresse	Paracetamol 750mg se dor	Paciente relata melhora parcial dos sintomas.	2025-03-03 20:33:02+00	2025-04-19 17:35:23.866635+00	2025-04-19 17:35:23.866635+00
60	88	8	60	Gastrite	Redução do estresse	Dipirona 500mg se febre	Paciente orientado a manter hidratação.	2025-02-05 20:33:02+00	2025-04-19 17:35:23.868144+00	2025-04-19 17:35:23.868144+00
61	77	2	61	Cefaleia tensional	Fisioterapia	Metformina 500mg 2x/dia	Paciente relata melhora parcial dos sintomas.	2024-12-23 20:33:02+00	2025-04-19 17:35:23.870767+00	2025-04-19 17:35:23.870767+00
62	87	8	62	Cefaleia tensional	Reposição hormonal	Omeprazol 20mg antes do café	Necessário agendar retorno em 30 dias.	2025-04-11 20:33:02+00	2025-04-19 17:35:23.872332+00	2025-04-19 17:35:23.872332+00
63	17	1	63	Cefaleia tensional	Reposição hormonal	Omeprazol 20mg antes do café	Recomendado evitar atividades físicas intensas.	2025-03-10 20:33:02+00	2025-04-19 17:35:23.874881+00	2025-04-19 17:35:23.874881+00
64	21	1	64	Infecção urinária	Reposição hormonal	Paracetamol 750mg se dor	Relatou efeitos colaterais leves.	2024-10-27 20:33:02+00	2025-04-19 17:35:23.876364+00	2025-04-19 17:35:23.876364+00
65	85	3	65	Ansiedade generalizada	Hidratação oral e repouso	Paracetamol 750mg se dor	Necessário agendar retorno em 30 dias.	2025-03-26 20:33:02+00	2025-04-19 17:35:23.879249+00	2025-04-19 17:35:23.879249+00
66	17	3	66	Cefaleia tensional	Acompanhamento mensal	Paracetamol 750mg se dor	Paciente demonstrou preocupação com os sintomas.	2024-04-24 20:33:02+00	2025-04-19 17:35:23.880823+00	2025-04-19 17:35:23.880823+00
67	56	3	67	Asma leve	Uso de broncodilatadores	Omeprazol 20mg antes do café	Relatou efeitos colaterais leves.	2024-08-10 20:33:02+00	2025-04-19 17:35:23.883669+00	2025-04-19 17:35:23.883669+00
68	68	1	68	Gastrite	Fisioterapia	Losartana 50mg 1x/dia	Paciente demonstrou preocupação com os sintomas.	2024-05-14 20:33:02+00	2025-04-19 17:35:23.885267+00	2025-04-19 17:35:23.885267+00
69	6	9	69	Cefaleia tensional	Redução do estresse	Salbutamol spray 2x/dia	Primeira consulta após diagnóstico.	2024-09-20 20:33:02+00	2025-04-19 17:35:23.887802+00	2025-04-19 17:35:23.887802+00
70	82	7	70	Gastrite	Fisioterapia	Desloratadina 5mg/dia	Segue dieta conforme orientação.	2024-08-23 20:33:02+00	2025-04-19 17:35:23.88913+00	2025-04-19 17:35:23.88913+00
71	98	5	71	Cefaleia tensional	Reposição hormonal	Anticoncepcional oral combinado	Queixa-se de dor frequente ao final do dia.	2025-02-18 20:33:02+00	2025-04-19 17:35:23.891471+00	2025-04-19 17:35:23.891471+00
72	53	7	72	Infecção urinária	Hidratação oral e repouso	Paracetamol 750mg se dor	Instruído sobre importância do tratamento contínuo.	2025-04-18 20:33:02+00	2025-04-19 17:35:23.892761+00	2025-04-19 17:35:23.892761+00
73	90	8	73	Ansiedade generalizada	Hidratação oral e repouso	Desloratadina 5mg/dia	Paciente orientado a manter hidratação.	2025-04-10 20:33:02+00	2025-04-19 17:35:23.895643+00	2025-04-19 17:35:23.895643+00
74	2	7	74	Asma leve	Psicoterapia	Metformina 500mg 2x/dia	Recomendado evitar atividades físicas intensas.	2025-01-13 20:33:02+00	2025-04-19 17:35:23.897311+00	2025-04-19 17:35:23.897311+00
75	20	6	75	Hipertensão arterial	Fisioterapia	Omeprazol 20mg antes do café	Paciente orientado a manter hidratação.	2024-08-15 20:33:02+00	2025-04-19 17:35:23.900093+00	2025-04-19 17:35:23.900093+00
76	42	4	76	Gastrite	Hidratação oral e repouso	Anticoncepcional oral combinado	Recomendado evitar atividades físicas intensas.	2024-06-01 20:33:02+00	2025-04-19 17:35:23.901743+00	2025-04-19 17:35:23.901743+00
77	11	1	77	Hipertensão arterial	Redução do estresse	Salbutamol spray 2x/dia	Instruído sobre importância do tratamento contínuo.	2025-02-21 20:33:02+00	2025-04-19 17:35:23.904435+00	2025-04-19 17:35:23.904435+00
78	15	5	78	Alergia sazonal	Redução do estresse	Omeprazol 20mg antes do café	Instruído sobre importância do tratamento contínuo.	2025-01-21 20:33:02+00	2025-04-19 17:35:23.906019+00	2025-04-19 17:35:23.906019+00
79	94	1	79	Dor lombar	Sessões de acupuntura	Fluoxetina 20mg/dia	Recomendado evitar atividades físicas intensas.	2024-07-05 20:33:02+00	2025-04-19 17:35:23.908618+00	2025-04-19 17:35:23.908618+00
80	28	5	80	Dismenorreia	Dieta controlada	Dipirona 500mg se febre	Queixa-se de dor frequente ao final do dia.	2024-05-25 20:33:02+00	2025-04-19 17:35:23.910173+00	2025-04-19 17:35:23.910173+00
81	21	7	81	Gastrite	Hidratação oral e repouso	Desloratadina 5mg/dia	Paciente demonstrou preocupação com os sintomas.	2024-11-06 20:33:02+00	2025-04-19 17:35:23.913034+00	2025-04-19 17:35:23.913034+00
82	86	6	82	Dismenorreia	Redução do estresse	Ibuprofeno 600mg se dor	Recomendado evitar atividades físicas intensas.	2024-05-24 20:33:02+00	2025-04-19 17:35:23.914499+00	2025-04-19 17:35:23.914499+00
83	5	8	83	Hipertensão arterial	Sessões de acupuntura	Ibuprofeno 600mg se dor	Instruído sobre importância do tratamento contínuo.	2024-05-05 20:33:02+00	2025-04-19 17:35:23.917317+00	2025-04-19 17:35:23.917317+00
84	85	9	84	Hipertensão arterial	Uso de broncodilatadores	Ibuprofeno 600mg se dor	Instruído sobre importância do tratamento contínuo.	2024-11-24 20:33:02+00	2025-04-19 17:35:23.919006+00	2025-04-19 17:35:23.919006+00
85	32	7	85	Asma leve	Acompanhamento mensal	Desloratadina 5mg/dia	Paciente orientado a manter hidratação.	2024-06-04 20:33:02+00	2025-04-19 17:35:23.921667+00	2025-04-19 17:35:23.921667+00
86	56	8	86	Dor lombar	Redução do estresse	Omeprazol 20mg antes do café	Instruído sobre importância do tratamento contínuo.	2024-12-17 20:33:02+00	2025-04-19 17:35:23.923343+00	2025-04-19 17:35:23.923343+00
87	77	10	87	Ansiedade generalizada	Dieta controlada	Omeprazol 20mg antes do café	Queixa-se de dor frequente ao final do dia.	2024-04-22 20:33:02+00	2025-04-19 17:35:23.925992+00	2025-04-19 17:35:23.925992+00
88	68	9	88	Dismenorreia	Acompanhamento mensal	Paracetamol 750mg se dor	Primeira consulta após diagnóstico.	2025-01-06 20:33:02+00	2025-04-19 17:35:23.927685+00	2025-04-19 17:35:23.927685+00
89	5	7	89	Alergia sazonal	Aplicação de calor local	Dipirona 500mg se febre	Segue dieta conforme orientação.	2024-08-21 20:33:02+00	2025-04-19 17:35:23.930362+00	2025-04-19 17:35:23.930362+00
90	13	6	90	Asma leve	Uso de broncodilatadores	Fluoxetina 20mg/dia	Relatou efeitos colaterais leves.	2025-01-17 20:33:02+00	2025-04-19 17:35:23.931879+00	2025-04-19 17:35:23.931879+00
91	61	1	91	Ansiedade generalizada	Uso de broncodilatadores	Dipirona 500mg se febre	Recomendado evitar atividades físicas intensas.	2024-05-16 20:33:02+00	2025-04-19 17:35:23.934668+00	2025-04-19 17:35:23.934668+00
92	91	8	92	Infecção urinária	Sessões de acupuntura	Anticoncepcional oral combinado	Necessário agendar retorno em 30 dias.	2025-01-13 20:33:02+00	2025-04-19 17:35:23.936268+00	2025-04-19 17:35:23.936268+00
93	99	7	93	Dor lombar	Dieta controlada	Anticoncepcional oral combinado	Recomendado evitar atividades físicas intensas.	2024-08-31 20:33:02+00	2025-04-19 17:35:23.938932+00	2025-04-19 17:35:23.938932+00
94	96	1	94	Hipertensão arterial	Reposição hormonal	Losartana 50mg 1x/dia	Relatou efeitos colaterais leves.	2024-07-31 20:33:02+00	2025-04-19 17:35:23.940258+00	2025-04-19 17:35:23.940258+00
95	99	6	95	Ansiedade generalizada	Uso de broncodilatadores	Salbutamol spray 2x/dia	Segue dieta conforme orientação.	2024-06-16 20:33:02+00	2025-04-19 17:35:23.942942+00	2025-04-19 17:35:23.942942+00
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (id, name, date_of_birth, gender, email, phone, address, insurance_info, created_at, updated_at) FROM stdin;
1	Maria Vitória Fernandes	1953-05-21	F	ianfogaca@monteiro.com	+55 31 7225-9303	Sítio Emanuel Gomes, 4, Conjunto Floramar, 35396-255 Barros de Gonçalves / AM	Almeida	2025-04-19 14:54:21.935902+00	2025-04-19 14:54:21.935902+00
2	Larissa Pires	2010-07-06	M	gduarte@yahoo.com.br	31 0140 0807	Favela de da Conceição, 17, Mariquinhas, 88681-520 Almeida / CE	Freitas	2025-04-19 14:54:21.938169+00	2025-04-19 14:54:21.938169+00
3	Luigi Ribeiro	2021-02-15	M	novaesolivia@silva.com	(041) 6813-3325	Conjunto Bruna Oliveira, 65, Santa Terezinha, 72382-458 Cunha de Mendes / DF	Rezende - EI	2025-04-19 14:54:21.939368+00	2025-04-19 14:54:21.939368+00
4	Olivia Rezende	1982-05-09	M	fariascaue@goncalves.br	(084) 8805 7564	Rua de Vieira, 11, Andiroba, 85450859 Pinto / MS	Castro S/A	2025-04-19 14:54:21.941583+00	2025-04-19 14:54:21.941583+00
5	Dr. Rodrigo da Costa	1962-11-02	M	fogacadiogo@bol.com.br	81 4232-7111	Morro Miguel Duarte, 637, Serra, 61793643 das Neves Grande / RR	Costela Castro S/A	2025-04-19 14:54:21.942569+00	2025-04-19 14:54:21.942569+00
6	João Miguel Castro	1988-10-18	F	murilo89@bol.com.br	41 9351-7060	Travessa de Ferreira, 15, Silveira, 80827746 Pereira do Campo / PB	Lima	2025-04-19 14:54:21.944861+00	2025-04-19 14:54:21.944861+00
7	Isaac Fernandes	1977-10-17	M	kjesus@monteiro.br	61 6464-5718	Fazenda de Vieira, 99, Bom Jesus, 95880-113 Souza / AL	Mendes da Rocha - EI	2025-04-19 14:54:21.946079+00	2025-04-19 14:54:21.946079+00
8	João Cunha	1992-12-20	F	samuel20@rocha.com	+55 (011) 4263 1778	Vale de Nunes, 71, Mangueiras, 88800008 da Conceição / AC	Farias	2025-04-19 14:54:21.948499+00	2025-04-19 14:54:21.948499+00
9	Dra. Bruna Pereira	1926-04-26	F	zalves@da.org	+55 71 4031 2338	Viaduto Porto, 9, Serra Do Curral, 12721504 Silva de Oliveira / AL	Araújo S.A.	2025-04-19 14:54:21.95012+00	2025-04-19 14:54:21.95012+00
10	Fernando Souza	1987-10-29	F	vitor54@lopes.com	(061) 0734 9982	Favela Almeida, 11, Vitoria, 43011-711 da Costa de Monteiro / RR	Pereira Novaes - ME	2025-04-19 14:54:21.952587+00	2025-04-19 14:54:21.952587+00
11	Melissa da Rosa	2006-09-15	M	da-luzfrancisco@carvalho.br	+55 51 4629 1366	Jardim de Ferreira, Santa Sofia, 07786-482 Teixeira de Moreira / RR	Silva	2025-04-19 14:54:21.953807+00	2025-04-19 14:54:21.953807+00
12	Samuel da Conceição	1984-12-07	M	rduarte@rezende.com	(061) 9216 9659	Jardim de da Luz, 9, Mineirão, 23334697 Ferreira / SP	Sales Ltda.	2025-04-19 14:54:21.956544+00	2025-04-19 14:54:21.956544+00
13	Helena Dias	1997-08-30	F	lorena74@farias.net	+55 81 6230-0990	Área Melissa Lima, 53, Vila Nova Cachoeirinha 3ª Seção, 07755-391 Cardoso Grande / ES	Farias Melo Ltda.	2025-04-19 14:54:21.958079+00	2025-04-19 14:54:21.958079+00
14	Arthur da Costa	1990-03-24	F	rdias@yahoo.com.br	+55 31 7669 0701	Passarela Ana Carolina Costa, 81, Piraja, 16618615 das Neves / MA	Cardoso	2025-04-19 14:54:21.960483+00	2025-04-19 14:54:21.960483+00
15	Marcelo Cavalcanti	2011-11-21	M	qcostela@gmail.com	51 4212 9555	Morro Milena Novaes, 6, Primeiro De Maio, 40663772 Nunes de da Luz / RN	da Cunha	2025-04-19 14:54:21.961628+00	2025-04-19 14:54:21.961628+00
16	Sra. Letícia Alves	1982-05-28	F	raulda-costa@ig.com.br	(031) 6001-3023	Travessa Campos, 80, Vila Maria, 19389749 Silveira do Oeste / AL	Pinto - ME	2025-04-19 14:54:21.964516+00	2025-04-19 14:54:21.964516+00
17	Vitor Silva	1967-09-02	F	luna45@das.org	+55 21 4453 5840	Favela Milena Gomes, 47, Beija Flor, 02887779 Nunes de Minas / MA	Teixeira - ME	2025-04-19 14:54:21.965857+00	2025-04-19 14:54:21.965857+00
18	Enzo Gabriel da Mota	2012-12-19	F	fernandesmaria-vitoria@gmail.com	+55 (041) 0239 6311	Trecho Anthony Rocha, Santa Maria, 02222-819 Almeida / AP	Moura Ltda.	2025-04-19 14:54:21.968544+00	2025-04-19 14:54:21.968544+00
19	Sophie Moreira	1989-02-23	F	alanada-rosa@ig.com.br	0900-354-8705	Núcleo Rodrigues, 26, Vila Independencia 2ª Seção, 42727-633 Duarte / BA	da Mota	2025-04-19 14:54:21.969808+00	2025-04-19 14:54:21.969808+00
20	Dra. Maysa Fernandes	1930-11-21	M	luiz-gustavo33@uol.com.br	+55 71 9608 2045	Quadra de Vieira, 624, Estrela Do Oriente, 08561562 Oliveira do Campo / PB	Gomes	2025-04-19 14:54:21.972497+00	2025-04-19 14:54:21.972497+00
21	Ana Vitória Mendes	1958-12-22	M	hviana@uol.com.br	71 0410 8395	Fazenda da Rocha, Milionario, 09303-594 Rezende de Moura / BA	Caldeira	2025-04-19 14:54:21.974182+00	2025-04-19 14:54:21.974182+00
22	Rafaela Melo	1957-11-10	F	sabrina45@cardoso.com	+55 61 1418-3845	Lago de Vieira, 84, São José, 71992-582 Martins / PA	Rezende	2025-04-19 14:54:21.976686+00	2025-04-19 14:54:21.976686+00
23	Emilly Farias	1977-07-09	M	diogomoreira@costela.com	+55 21 9527 3959	Viaduto de Peixoto, 96, São Vicente, 89262702 da Cruz / ES	Nunes	2025-04-19 14:54:21.97794+00	2025-04-19 14:54:21.97794+00
24	Joana Araújo	1958-06-12	M	goncalveskaique@cardoso.org	(051) 3828-7434	Via de Duarte, 87, São Sebastião, 27794-707 Duarte / PR	Cavalcanti	2025-04-19 14:54:21.980888+00	2025-04-19 14:54:21.980888+00
25	Renan Nunes	1960-06-23	M	mirellanovaes@mendes.com	+55 (011) 1261-2164	Travessa Bryan Almeida, 48, Vila Real 2ª Seção, 73450855 Pereira / PB	Sales Ltda.	2025-04-19 14:54:21.982584+00	2025-04-19 14:54:21.982584+00
26	Sra. Milena Moraes	1948-06-04	F	claramoura@da.com	+55 11 9500 3305	Vereda de Gonçalves, 4, Mariquinhas, 78540-204 da Cruz da Prata / PB	da Mata - EI	2025-04-19 14:54:21.985515+00	2025-04-19 14:54:21.985515+00
27	Dr. Theo Rodrigues	1964-04-27	F	joao-pedroda-rosa@silva.net	+55 (021) 9306-4642	Aeroporto de Cunha, 7, Inconfidência, 27537047 Fernandes de Caldeira / MT	Azevedo S.A.	2025-04-19 14:54:21.98738+00	2025-04-19 14:54:21.98738+00
28	Dr. Danilo Cunha	1958-07-21	M	fcarvalho@da.br	+55 61 8343 3996	Estrada da Cunha, 7, Barro Preto, 19598924 Pinto da Praia / ES	Pinto	2025-04-19 14:54:21.990933+00	2025-04-19 14:54:21.990933+00
29	João Pedro Pires	1986-10-15	M	joaquim43@sales.com	21 7790 8099	Viela de Alves, 15, Vila Maloca, 71917-139 Martins / RJ	Dias	2025-04-19 14:54:21.993742+00	2025-04-19 14:54:21.993742+00
30	Lívia da Luz	2003-11-06	F	carolinafarias@yahoo.com.br	84 2934-0741	Recanto Lorenzo Duarte, 97, Vila Aeroporto Jaraguá, 55304116 Dias de Costa / BA	Rocha	2025-04-19 14:54:21.995017+00	2025-04-19 14:54:21.995017+00
31	Srta. Sophia Campos	1938-09-22	F	goncalvesmaysa@monteiro.com	0900-101-2909	Conjunto Jesus, Jardim Alvorada, 25372205 Teixeira / BA	Pereira - ME	2025-04-19 14:54:21.997848+00	2025-04-19 14:54:21.997848+00
32	Giovanna Teixeira	1937-09-08	F	breno96@hotmail.com	0500 270 1780	Viela Freitas, Gameleira, 00813-414 Correia / ES	Alves	2025-04-19 14:54:21.99949+00	2025-04-19 14:54:21.99949+00
33	Beatriz Silva	1994-03-29	F	barbosaeduarda@pereira.br	(071) 2945-1994	Área Stephany Jesus, 404, Vila Cloris, 81417919 Ribeiro / PI	da Cunha	2025-04-19 14:54:22.00203+00	2025-04-19 14:54:22.00203+00
34	Erick Pereira	1979-07-09	M	moraesjuan@silva.com	0300 828 3691	Lago Leandro Pinto, 99, Centro, 96216137 da Cruz do Norte / DF	Cardoso	2025-04-19 14:54:22.003258+00	2025-04-19 14:54:22.003258+00
35	Emanuelly Azevedo	2008-11-30	M	ana-carolina95@vieira.br	+55 (021) 1128 6297	Aeroporto Maysa Martins, 53, Paquetá, 41201-883 Teixeira / MG	da Costa	2025-04-19 14:54:22.005823+00	2025-04-19 14:54:22.005823+00
36	Benício Dias	1952-01-27	M	moreiracaue@bol.com.br	0800 609 1142	Núcleo Caroline Pereira, 43, Biquinhas, 19482478 Dias da Serra / RN	da Rocha	2025-04-19 14:54:22.007611+00	2025-04-19 14:54:22.007611+00
37	Raul Ramos	1976-12-21	F	oliveirarafaela@bol.com.br	+55 (031) 1833-3956	Jardim de Peixoto, 14, Vila Santa Monica 2ª Seção, 85405-451 Costa Paulista / RS	Farias Farias e Filhos	2025-04-19 14:54:22.010165+00	2025-04-19 14:54:22.010165+00
38	Catarina Carvalho	1958-09-20	F	juliasales@barros.com	31 8686 1214	Condomínio Yuri da Cruz, 79, Santo Agostinho, 15364730 Cardoso Paulista / RO	Gonçalves	2025-04-19 14:54:22.011545+00	2025-04-19 14:54:22.011545+00
39	Mariana Sales	1946-02-18	F	davi-luiz28@pires.com	+55 (041) 4080 1886	Conjunto de Pereira, 6, Nova America, 85905-991 Lopes Grande / AL	Fernandes Silveira Ltda.	2025-04-19 14:54:22.01446+00	2025-04-19 14:54:22.01446+00
40	Alícia Ferreira	1973-02-27	M	joao-guilherme66@pires.com	11 9372 2134	Ladeira Moura, 54, Belvedere, 64716253 Jesus / BA	Martins	2025-04-19 14:54:22.016123+00	2025-04-19 14:54:22.016123+00
41	Luana Peixoto	1974-06-16	M	hazevedo@gmail.com	0800 722 4752	Viela de Porto, 16, Vila Nova Dos Milionarios, 75058279 da Cruz / AM	Ferreira Silveira e Filhos	2025-04-19 14:54:22.018743+00	2025-04-19 14:54:22.018743+00
42	Kevin da Rosa	1925-05-02	M	esther74@da.com	(071) 5488-5142	Trevo Pedro Henrique Campos, Santo André, 26254-729 da Rosa do Galho / GO	da Luz	2025-04-19 14:54:22.020085+00	2025-04-19 14:54:22.020085+00
43	João Gabriel Santos	2012-08-25	M	nunesfelipe@hotmail.com	+55 (071) 2892-1853	Travessa Anthony Barros, 104, Vila Trinta E Um De Março, 57702200 Monteiro das Flores / CE	Silveira	2025-04-19 14:54:22.022601+00	2025-04-19 14:54:22.022601+00
44	Dra. Isabella da Rocha	1978-07-06	M	augusto83@pires.com	(051) 7621 4240	Vereda da Rocha, Conjunto Bonsucesso, 52112332 Azevedo de Goiás / DF	Farias	2025-04-19 14:54:22.024769+00	2025-04-19 14:54:22.024769+00
45	Dr. Diego Moreira	2021-09-22	F	vsales@uol.com.br	51 7889 9674	Rodovia de Vieira, 96, Jardim Atlântico, 18676092 da Paz / PA	Caldeira Ltda.	2025-04-19 14:54:22.027677+00	2025-04-19 14:54:22.027677+00
46	Sra. Olivia Novaes	2023-05-24	M	da-costarebeca@da.org	+55 (071) 2486 1699	Viela Cardoso, 863, Maria Tereza, 70488225 Mendes / MS	Nogueira e Filhos	2025-04-19 14:54:22.029358+00	2025-04-19 14:54:22.029358+00
47	Elisa Barros	1990-04-29	F	yasminrodrigues@uol.com.br	0500-734-1688	Campo Sophia Souza, Nossa Senhora Aparecida, 24939-303 Alves / RR	Moraes S/A	2025-04-19 14:54:22.032294+00	2025-04-19 14:54:22.032294+00
48	Maria Vitória Freitas	1985-09-16	F	erick87@ig.com.br	11 0666-5855	Condomínio de Duarte, São Vicente, 90060256 Silveira / SE	Rodrigues	2025-04-19 14:54:22.034145+00	2025-04-19 14:54:22.034145+00
49	Maria Luiza Caldeira	1993-06-11	F	nsilveira@cunha.org	+55 31 8077-1112	Pátio de Ramos, 54, Bairro Das Indústrias Ii, 16632-066 Lopes da Prata / CE	Nunes Monteiro - ME	2025-04-19 14:54:22.036941+00	2025-04-19 14:54:22.036941+00
50	Rodrigo Aragão	1995-05-19	F	catarina48@uol.com.br	+55 (081) 2774 1964	Jardim Bruna da Mota, 31, Vila Calafate, 34248871 Sales / MS	Lopes	2025-04-19 14:54:22.038677+00	2025-04-19 14:54:22.038677+00
51	Igor Alves	1931-11-16	M	danilo11@ig.com.br	(031) 9680 0482	Vereda Emanuelly Viana, 36, Vila Nossa Senhora Do Rosário, 87834140 Barros / PR	Barbosa	2025-04-19 14:54:22.041855+00	2025-04-19 14:54:22.041855+00
52	Gabriela Freitas	1967-12-06	M	monteironicole@hotmail.com	51 0611 9109	Praia de Ribeiro, 84, Gutierrez, 67196625 da Rocha / PB	Cunha e Filhos	2025-04-19 14:54:22.043463+00	2025-04-19 14:54:22.043463+00
53	Catarina Gonçalves	1973-09-05	F	bruna27@cardoso.com	(021) 5133 9416	Sítio Barbosa, 46, Vila Novo São Lucas, 97477-287 Gonçalves / ES	Rezende S.A.	2025-04-19 14:54:22.046601+00	2025-04-19 14:54:22.046601+00
54	Srta. Ana Lívia Cunha	1988-09-08	F	vieiralucas@ig.com.br	71 5694 4353	Aeroporto Lopes, 952, Calafate, 24353-033 Rocha do Sul / AP	Lopes S/A	2025-04-19 14:54:22.049009+00	2025-04-19 14:54:22.049009+00
55	João Felipe da Costa	1971-03-12	F	thomas14@hotmail.com	+55 31 4959 8684	Quadra de Silva, Vila Paraíso, 10897-994 Gonçalves / MG	da Cunha	2025-04-19 14:54:22.05223+00	2025-04-19 14:54:22.05223+00
56	Cecília Cardoso	1962-01-13	F	faraujo@ig.com.br	+55 21 2299 7141	Chácara de Monteiro, 3, Senhor Dos Passos, 51628-320 Gonçalves de Silva / SE	Peixoto da Mata e Filhos	2025-04-19 14:54:22.054039+00	2025-04-19 14:54:22.054039+00
57	Júlia Ferreira	1929-04-03	M	ramosisabelly@lima.com	+55 51 2114 0202	Conjunto de Nascimento, 61, Sion, 51672-845 Porto / AL	Oliveira	2025-04-19 14:54:22.057282+00	2025-04-19 14:54:22.057282+00
58	Luiz Henrique Almeida	1985-02-10	F	rsouza@uol.com.br	(011) 6908 2170	Trevo de Nascimento, 90, Mangueiras, 58618-606 das Neves / RJ	Lima	2025-04-19 14:54:22.059157+00	2025-04-19 14:54:22.059157+00
59	Arthur Melo	2024-03-02	M	vcampos@yahoo.com.br	+55 (021) 1625 5290	Estrada Nogueira, 89, Primeiro De Maio, 01784107 Duarte de da Cruz / RS	Barbosa S.A.	2025-04-19 14:54:22.062049+00	2025-04-19 14:54:22.062049+00
60	Leandro Duarte	2024-01-27	M	nicolasaraujo@ig.com.br	0300-606-0900	Aeroporto Joana Silveira, 15, Santa Lúcia, 29866-919 Alves / MT	Nogueira	2025-04-19 14:54:22.063808+00	2025-04-19 14:54:22.063808+00
61	Nina Nogueira	1927-10-19	F	ceciliada-cunha@uol.com.br	(031) 3125-6585	Recanto Clarice das Neves, 42, Dona Clara, 41173-872 Lopes / PA	das Neves	2025-04-19 14:54:22.066689+00	2025-04-19 14:54:22.066689+00
62	Augusto Porto	1968-07-27	F	mendeslarissa@santos.br	0500 497 6102	Alameda da Cruz, 50, São Sebastião, 27196687 Mendes Verde / MT	Cardoso	2025-04-19 14:54:22.068021+00	2025-04-19 14:54:22.068021+00
63	Yuri da Rocha	2011-06-19	M	silvaclara@gomes.br	21 9012 7026	Viaduto de da Rocha, 296, São João Batista, 48207539 Pereira dos Dourados / SP	da Mata	2025-04-19 14:54:22.070512+00	2025-04-19 14:54:22.070512+00
64	Sr. Bryan Souza	1956-11-05	F	rochabenjamin@da.org	+55 41 5190 4240	Favela Marina Costa, 280, Nova Suíça, 00535-724 Melo de Nunes / PI	Moura da Cruz - EI	2025-04-19 14:54:22.071797+00	2025-04-19 14:54:22.071797+00
65	Ana Lívia Freitas	1959-01-05	F	da-costaelisa@cavalcanti.br	84 1755 6235	Condomínio Almeida, 80, Vila Petropolis, 79295814 Rocha / PA	Costa	2025-04-19 14:54:22.074548+00	2025-04-19 14:54:22.074548+00
66	Kamilly Caldeira	1992-08-23	M	marina15@yahoo.com.br	+55 11 8069 8468	Sítio da Cruz, 9, Caetano Furquim, 30224939 Lopes do Galho / RJ	Ramos - EI	2025-04-19 14:54:22.076127+00	2025-04-19 14:54:22.076127+00
67	Emanuelly Correia	2017-08-09	M	tvieira@pinto.br	0300 954 1031	Recanto de Moura, Vila Esplanada, 09436010 Pires / MT	Porto da Luz Ltda.	2025-04-19 14:54:22.078799+00	2025-04-19 14:54:22.078799+00
68	Raquel da Paz	1963-05-21	M	ana-liviacunha@ig.com.br	+55 41 6669 9685	Setor de Melo, 91, Solar Do Barreiro, 66548725 da Rocha de Barbosa / PA	Rocha Santos S.A.	2025-04-19 14:54:22.080329+00	2025-04-19 14:54:22.080329+00
69	Samuel Viana	2013-11-06	M	emillycosta@gmail.com	+55 21 2314 8039	Área Aragão, 225, Ribeiro De Abreu, 69010443 Dias / PE	Dias	2025-04-19 14:54:22.083243+00	2025-04-19 14:54:22.083243+00
70	Marcela Peixoto	2015-11-27	M	da-pazolivia@aragao.com	+55 84 0362 0545	Lagoa Costa, 993, Diamante, 22496774 Teixeira / RN	Lopes Vieira - ME	2025-04-19 14:54:22.084834+00	2025-04-19 14:54:22.084834+00
71	João Vitor Gomes	1998-07-16	F	alicia41@campos.org	+55 61 0296-2730	Vereda de Nogueira, 59, Frei Leopoldo, 79995640 da Paz / TO	da Cunha	2025-04-19 14:54:22.087685+00	2025-04-19 14:54:22.087685+00
72	Stephany Moraes	2022-03-11	F	tduarte@melo.com	+55 84 9340-2673	Lagoa Cauê Moraes, 4, Vila Canto Do Sabiá, 76694858 da Cruz da Mata / DF	Costela	2025-04-19 14:54:22.089115+00	2025-04-19 14:54:22.089115+00
73	Maria Sophia Lopes	2017-02-17	F	da-luzmaria-vitoria@santos.com	(061) 9049-8369	Trevo Ribeiro, 1, Santo Agostinho, 51739-131 Martins de Santos / AM	Jesus - EI	2025-04-19 14:54:22.091808+00	2025-04-19 14:54:22.091808+00
74	João Guilherme Farias	1999-09-08	F	wviana@uol.com.br	0800 177 3826	Travessa Fernando da Rocha, 61, Vitoria, 17325-614 Ramos / MT	Nogueira	2025-04-19 14:54:22.093353+00	2025-04-19 14:54:22.093353+00
75	João Lucas Castro	1987-07-16	F	mariamoreira@hotmail.com	+55 (061) 7552-0530	Conjunto Carvalho, 2, Lagoinha, 10816517 Melo das Pedras / MA	da Mota	2025-04-19 14:54:22.095983+00	2025-04-19 14:54:22.095983+00
76	Nicolas Peixoto	1946-08-16	F	ana-juliada-conceicao@da.br	0800-163-6844	Praia de da Cunha, 743, União, 41899360 Barbosa / CE	Santos S/A	2025-04-19 14:54:22.09726+00	2025-04-19 14:54:22.09726+00
77	Júlia Cardoso	1989-10-28	M	cteixeira@ig.com.br	(084) 4083-6949	Distrito Fogaça, 64, Flamengo, 52496618 Moura da Prata / MA	Barbosa	2025-04-19 14:54:22.100349+00	2025-04-19 14:54:22.100349+00
78	Breno Oliveira	1958-08-20	M	luiz-henriquemelo@hotmail.com	+55 (041) 5816 1402	Viela de da Conceição, 591, Camponesa 1ª Seção, 04208-133 Mendes / PA	Ferreira	2025-04-19 14:54:22.102121+00	2025-04-19 14:54:22.102121+00
79	Pietra Nascimento	2018-02-04	M	luiz-gustavo60@bol.com.br	21 6704-5160	Residencial Lara da Paz, 29, Nossa Senhora De Fátima, 07925-200 Moura do Amparo / AC	Carvalho Ltda.	2025-04-19 14:54:22.104874+00	2025-04-19 14:54:22.104874+00
80	Thomas Carvalho	1958-03-16	F	fernando05@alves.br	(051) 4590 8332	Distrito Nogueira, 716, Boa Vista, 42372629 Peixoto / PA	Peixoto Porto Ltda.	2025-04-19 14:54:22.106743+00	2025-04-19 14:54:22.106743+00
81	Maria Julia Peixoto	2016-07-16	M	caiogomes@uol.com.br	(071) 8337 2955	Lagoa Luiz Felipe Alves, 782, Vila Santa Monica 2ª Seção, 91598-703 Carvalho / PA	da Paz	2025-04-19 14:54:22.111457+00	2025-04-19 14:54:22.111457+00
82	Dr. Lucas Cardoso	1988-06-03	F	oliviacardoso@nascimento.com	+55 31 8260-0165	Esplanada Ana Júlia Alves, 71, Outro, 06943-728 Santos de Fernandes / SC	Lima Gonçalves - ME	2025-04-19 14:54:22.113277+00	2025-04-19 14:54:22.113277+00
83	Davi Santos	1976-06-29	F	diaslarissa@nascimento.br	81 7106-2234	Residencial Kamilly Lima, 19, Ápia, 74493-923 Dias / MA	Caldeira da Mota S.A.	2025-04-19 14:54:22.116244+00	2025-04-19 14:54:22.116244+00
84	Pedro Caldeira	1940-06-14	M	catarina14@ferreira.com	0800 064 3967	Conjunto de Nogueira, Camponesa 2ª Seção, 54587-939 Caldeira de Minas / PI	da Mota	2025-04-19 14:54:22.117684+00	2025-04-19 14:54:22.117684+00
85	Maitê Moura	2020-08-18	M	anthony32@ig.com.br	+55 51 6158 2814	Sítio Nogueira, 7, Ambrosina, 70376961 da Rocha / AP	da Cruz e Filhos	2025-04-19 14:54:22.120308+00	2025-04-19 14:54:22.120308+00
87	Pedro Miguel Mendes	2011-05-06	M	elisada-rocha@mendes.com	51 4885 0286	Viela Teixeira, 57, Vila Maloca, 37321-657 da Luz / MG	Teixeira Lopes Ltda.	2025-04-19 14:54:22.124989+00	2025-04-19 14:54:22.124989+00
88	Dr. Luiz Fernando Nunes	1977-06-18	M	nda-costa@uol.com.br	+55 (081) 5328-1834	Quadra de da Cruz, 13, Marilandia, 18581-510 da Cunha / TO	Rodrigues S/A	2025-04-19 14:54:22.126639+00	2025-04-19 14:54:22.126639+00
89	Gustavo Henrique Teixeira	1934-11-29	M	kribeiro@rocha.br	61 1898 0946	Ladeira Nicolas Souza, 498, Barão Homem De Melo 3ª Seção, 20126887 Silveira do Campo / CE	Pinto	2025-04-19 14:54:22.129052+00	2025-04-19 14:54:22.129052+00
90	Nicole Jesus	1963-07-29	F	arthurlima@gmail.com	0500-835-7800	Residencial de Lima, 970, Barão Homem De Melo 1ª Seção, 19460384 Viana / PB	Moreira e Filhos	2025-04-19 14:54:22.130637+00	2025-04-19 14:54:22.130637+00
91	Juliana Sales	2019-06-01	F	milena81@gmail.com	(081) 3054-4557	Loteamento Gonçalves, 75, Ribeiro De Abreu, 16855435 Costa / CE	Gonçalves	2025-04-19 14:54:22.133343+00	2025-04-19 14:54:22.133343+00
92	Sophia Campos	1962-09-19	M	caldeiraana@jesus.br	0500 641 7520	Parque de Nunes, 8, Boa Esperança, 73801-653 Nunes da Serra / GO	Pereira - ME	2025-04-19 14:54:22.134731+00	2025-04-19 14:54:22.134731+00
93	Emanuelly Carvalho	1975-10-21	M	sabrinarezende@gmail.com	(011) 8570 3502	Passarela de Silva, 9, Buraco Quente, 22383-693 Azevedo da Serra / RS	da Mata	2025-04-19 14:54:22.137182+00	2025-04-19 14:54:22.137182+00
94	Ryan Aragão	1960-06-18	F	stephanylima@das.com	+55 (061) 3603-9345	Vereda Monteiro, 24, Eymard, 33776-686 Silveira / CE	Rocha	2025-04-19 14:54:22.138479+00	2025-04-19 14:54:22.138479+00
95	Mirella Nunes	2003-10-03	F	yago90@da.com	(084) 3981-7079	Estrada Isis da Costa, 75, Jardim Felicidade, 22689991 da Luz / PB	Rodrigues Ltda.	2025-04-19 14:54:22.141412+00	2025-04-19 14:54:22.141412+00
96	Giovanna da Rosa	1977-05-07	M	brenofreitas@lopes.net	71 5166 6911	Quadra Ana Laura Vieira, 3, Taquaril, 10381-479 Correia da Praia / RS	Castro	2025-04-19 14:54:22.143115+00	2025-04-19 14:54:22.143115+00
97	Clarice Teixeira	1970-03-05	F	da-pazcaio@hotmail.com	84 4325 7905	Largo Nascimento, 971, Tupi B, 87458-810 da Costa / PE	Moura	2025-04-19 14:54:22.146027+00	2025-04-19 14:54:22.146027+00
98	Dr. Theo da Luz	2007-03-30	F	levi79@ig.com.br	+55 21 7317-8227	Condomínio da Luz, 11, Prado, 14833021 Martins / RJ	Cardoso	2025-04-19 14:54:22.148124+00	2025-04-19 14:54:22.148124+00
99	Enrico Rodrigues	1937-02-02	F	ecostela@ig.com.br	(031) 6629 7954	Avenida Lívia Santos, 4, Sagrada Família, 61232-484 Cunha / SE	Araújo	2025-04-19 14:54:22.151127+00	2025-04-19 14:54:22.151127+00
100	Luiz Miguel Fernandes	2004-12-28	F	caroline02@hotmail.com	+55 81 1503-6893	Recanto de Peixoto, 43, Vila Nossa Senhora Do Rosário, 61245468 Gonçalves do Campo / AM	Rodrigues das Neves S.A.	2025-04-19 14:54:22.152632+00	2025-04-19 14:54:22.152632+00
86	Clarice Telles de Queiroz	1983-12-21	F	souzagabriel@ig.com.br	11 9799 9259	Distrito Vicente Pires, 759, Novo Das Industrias, 80581-182 da Cunha / MT	Pires	2025-04-19 14:54:22.121854+00	2025-04-21 01:59:04.892229+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password_hash, first_name, last_name, role, created_at, updated_at) FROM stdin;
b165ab6f-1ac3-4221-9dac-d890f5801488	bruna41@yahoo.com.br		Esther 	Barros	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
948b8939-4270-4d44-85a2-b06678ff98fa	almeidadaniel@nunes.com		Diego 	Vieira	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
bd000d3f-ed62-462b-ad9e-f41d7cdb85b6	ramosbernardo@hotmail.com		Isis 	Porto	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
015b78d3-9273-4ba8-ac9c-15e8683d8458	oaragao@uol.com.br		Ana 	Lívia Vieira	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
eaf2acaf-d94e-47d8-8df7-7fe1ace3ece9	joao-felipe85@bol.com.br		Davi 	Rocha	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
a303c050-025a-4260-a15f-cdd29629079e	zsilva@rodrigues.br		Lívia 	Barros	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
6692da58-33ad-4fe9-b840-9112eff82d1a	raqueldias@yahoo.com.br		Thomas 	Barros	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
ee2f8c57-a027-4793-b50b-cf6d83f1ae44	scastro@gmail.com		Letícia 	Souza	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
0e6ccbb0-ad1f-41f7-846f-cdb972894861	yurifarias@uol.com.br		Breno 	Melo	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
b7a71bf7-46a6-4c86-9609-2bee2fe4fed9	joaquimsales@mendes.org		Mariana 	Correia	doctor	2025-04-19 16:10:20.580943+00	2025-04-19 16:10:20.580943+00
2baa48f6-4bbe-4230-881d-e8bb8bada829	celia.vieira@gmail.com		Celia	Vieira	staff	2025-04-19 16:12:58.799952+00	2025-04-19 16:12:58.799952+00
9f99b140-48b9-4d20-8a19-4c14a233c896	ricardo345@gmail.com		Ricardo	Beraldo	staff	2025-04-19 16:13:45.823172+00	2025-04-19 16:13:45.823172+00
ed24d0a2-ca44-4cc3-a420-ca95cd317faf	maria.do.socorro445@gmail.com		Maria	do Socorro	staff	2025-04-19 16:12:12.5865+00	2025-04-19 16:12:12.5865+00
\.


--
-- Name: ai_analysis_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ai_analysis_requests_id_seq', 1, true);


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_id_seq', 95, true);


--
-- Name: digitized_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.digitized_documents_id_seq', 1, false);


--
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_id_seq', 1, false);


--
-- Name: health_insurance_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.health_insurance_plans_id_seq', 11, true);


--
-- Name: medical_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medical_records_id_seq', 193, true);


--
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patients_id_seq', 100, true);


--
-- Name: ai_analysis_requests ai_analysis_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_analysis_requests
    ADD CONSTRAINT ai_analysis_requests_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_patient_id_doctor_id_appointment_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_patient_id_doctor_id_appointment_date_key UNIQUE (patient_id, doctor_id, appointment_date);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: digitized_documents digitized_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.digitized_documents
    ADD CONSTRAINT digitized_documents_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_email_key UNIQUE (email);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: health_insurance_plans health_insurance_plans_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_insurance_plans
    ADD CONSTRAINT health_insurance_plans_code_key UNIQUE (code);


--
-- Name: health_insurance_plans health_insurance_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_insurance_plans
    ADD CONSTRAINT health_insurance_plans_pkey PRIMARY KEY (id);


--
-- Name: medical_records medical_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_pkey PRIMARY KEY (id);


--
-- Name: patients patients_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_email_key UNIQUE (email);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_appointments_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointments_date ON public.appointments USING btree (appointment_date);


--
-- Name: idx_appointments_doctor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointments_doctor_id ON public.appointments USING btree (doctor_id);


--
-- Name: idx_appointments_patient_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointments_patient_id ON public.appointments USING btree (patient_id);


--
-- Name: idx_medical_records_doctor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_medical_records_doctor_id ON public.medical_records USING btree (doctor_id);


--
-- Name: idx_medical_records_patient_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_medical_records_patient_id ON public.medical_records USING btree (patient_id);


--
-- Name: appointments update_appointments_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_appointments_timestamp BEFORE UPDATE ON public.appointments FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: digitized_documents update_digitized_documents_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_digitized_documents_timestamp BEFORE UPDATE ON public.digitized_documents FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: doctors update_doctors_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_doctors_timestamp BEFORE UPDATE ON public.doctors FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: health_insurance_plans update_health_insurance_plans_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_health_insurance_plans_timestamp BEFORE UPDATE ON public.health_insurance_plans FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: medical_records update_medical_records_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_medical_records_timestamp BEFORE UPDATE ON public.medical_records FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: patients update_patients_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_patients_timestamp BEFORE UPDATE ON public.patients FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: ai_analysis_requests ai_analysis_requests_medical_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_analysis_requests
    ADD CONSTRAINT ai_analysis_requests_medical_record_id_fkey FOREIGN KEY (medical_record_id) REFERENCES public.medical_records(id) ON DELETE CASCADE;


--
-- Name: ai_analysis_requests ai_analysis_requests_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_analysis_requests
    ADD CONSTRAINT ai_analysis_requests_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: appointments appointments_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE;


--
-- Name: appointments appointments_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: digitized_documents digitized_documents_medical_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.digitized_documents
    ADD CONSTRAINT digitized_documents_medical_record_id_fkey FOREIGN KEY (medical_record_id) REFERENCES public.medical_records(id) ON DELETE SET NULL;


--
-- Name: digitized_documents digitized_documents_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.digitized_documents
    ADD CONSTRAINT digitized_documents_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: medical_records medical_records_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL;


--
-- Name: medical_records medical_records_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id) ON DELETE CASCADE;


--
-- Name: medical_records medical_records_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.2 (Debian 17.2-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "web_retail_dev" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.2 (Debian 17.2-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: web_retail_dev; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE web_retail_dev WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE web_retail_dev OWNER TO postgres;

\connect web_retail_dev

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: estoque; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estoque (
    id_estoque integer NOT NULL,
    id_lote integer NOT NULL,
    quantidade integer NOT NULL,
    codigo_barras character varying(50)
);


ALTER TABLE public.estoque OWNER TO postgres;

--
-- Name: estoque_id_estoque_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estoque_id_estoque_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.estoque_id_estoque_seq OWNER TO postgres;

--
-- Name: estoque_id_estoque_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estoque_id_estoque_seq OWNED BY public.estoque.id_estoque;


--
-- Name: lote; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lote (
    id_lote integer NOT NULL,
    id_produto integer NOT NULL,
    validade date NOT NULL,
    preco_unitario double precision NOT NULL,
    codigo character varying(50) NOT NULL
);


ALTER TABLE public.lote OWNER TO postgres;

--
-- Name: lote_id_lote_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lote_id_lote_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lote_id_lote_seq OWNER TO postgres;

--
-- Name: lote_id_lote_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lote_id_lote_seq OWNED BY public.lote.id_lote;


--
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
    id_produto integer NOT NULL,
    nome character varying(100) NOT NULL,
    descricao character varying(500),
    preco numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    id_secao integer NOT NULL
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- Name: produto_id_produto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produto_id_produto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produto_id_produto_seq OWNER TO postgres;

--
-- Name: produto_id_produto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_id_produto_seq OWNED BY public.produto.id_produto;


--
-- Name: secao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.secao (
    id_secao integer NOT NULL,
    nome character varying(100) NOT NULL,
    descricao character varying(500) NOT NULL
);


ALTER TABLE public.secao OWNER TO postgres;

--
-- Name: secao_id_secao_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.secao_id_secao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.secao_id_secao_seq OWNER TO postgres;

--
-- Name: secao_id_secao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.secao_id_secao_seq OWNED BY public.secao.id_secao;


--
-- Name: estoque id_estoque; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estoque ALTER COLUMN id_estoque SET DEFAULT nextval('public.estoque_id_estoque_seq'::regclass);


--
-- Name: lote id_lote; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lote ALTER COLUMN id_lote SET DEFAULT nextval('public.lote_id_lote_seq'::regclass);


--
-- Name: produto id_produto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto ALTER COLUMN id_produto SET DEFAULT nextval('public.produto_id_produto_seq'::regclass);


--
-- Name: secao id_secao; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.secao ALTER COLUMN id_secao SET DEFAULT nextval('public.secao_id_secao_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
31015f0ac284
\.


--
-- Data for Name: estoque; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estoque (id_estoque, id_lote, quantidade, codigo_barras) FROM stdin;
1	1	0	\N
2	2	0	\N
3	3	0	\N
\.


--
-- Data for Name: lote; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lote (id_lote, id_produto, validade, preco_unitario, codigo) FROM stdin;
1	1	2025-05-31	1.4	445566
2	1	2025-06-28	1.45	448899
3	2	2025-06-28	2.56	775599
\.


--
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto (id_produto, nome, descricao, preco, id_secao) FROM stdin;
1	Farinha láctea Nestlé	Farinha láctea Nestlé	0.00	1
2	Aveia Quacker	Aveia Quacker	0.00	1
\.


--
-- Data for Name: secao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.secao (id_secao, nome, descricao) FROM stdin;
5	Quitanda	Onde se encontram as verduras, legumes e frutas
7	Temperos	onde estão sal e especiarias
1	Farináceos	Seção onde se encontram as farinhas
2	Laticínios	Seção dos derivados de leite
3	Padaria	Seção dos pães e bolos
4	Açougue	Onde se encontram as carnes
6	Grãos	Seção onde estão os grãos
\.


--
-- Name: estoque_id_estoque_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estoque_id_estoque_seq', 3, true);


--
-- Name: lote_id_lote_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lote_id_lote_seq', 3, true);


--
-- Name: produto_id_produto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_id_produto_seq', 2, true);


--
-- Name: secao_id_secao_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.secao_id_secao_seq', 1, false);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: estoque estoque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estoque
    ADD CONSTRAINT estoque_pkey PRIMARY KEY (id_estoque);


--
-- Name: lote lote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lote
    ADD CONSTRAINT lote_pkey PRIMARY KEY (id_lote);


--
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id_produto);


--
-- Name: secao secao_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.secao
    ADD CONSTRAINT secao_nome_key UNIQUE (nome);


--
-- Name: secao secao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.secao
    ADD CONSTRAINT secao_pkey PRIMARY KEY (id_secao);


--
-- Name: estoque estoque_id_lote_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estoque
    ADD CONSTRAINT estoque_id_lote_fkey FOREIGN KEY (id_lote) REFERENCES public.lote(id_lote);


--
-- Name: lote lote_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lote
    ADD CONSTRAINT lote_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produto(id_produto);


--
-- Name: produto produto_id_secao_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_id_secao_fkey FOREIGN KEY (id_secao) REFERENCES public.secao(id_secao);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

