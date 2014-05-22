--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: carts; Type: TABLE; Schema: public; owner: -; Tablespace: 
--

CREATE TABLE carts (
    cart_id integer NOT NULL,
    uid integer NOT NULL,
    total double precision,
    "time" timestamp without time zone
);


--
-- Name: carts_cart_id_seq; Type: SEQUENCE; Schema: public; owner: -
--

CREATE SEQUENCE carts_cart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carts_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: -
--

ALTER SEQUENCE carts_cart_id_seq OWNED BY carts.cart_id;


--
-- Name: carts_products; Type: TABLE; Schema: public; owner: -; Tablespace: 
--

CREATE TABLE carts_products (
    cart_id integer,
    product_id integer
);


--
-- Name: categories; Type: TABLE; Schema: public; owner: -; Tablespace: 
--

CREATE TABLE categories (
    category_id integer NOT NULL,
    img_url text NOT NULL,
    name text NOT NULL,
    description text NOT NULL
);


--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; owner: -
--

CREATE SEQUENCE categories_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: -
--

ALTER SEQUENCE categories_category_id_seq OWNED BY categories.category_id;


--
-- Name: products; Type: TABLE; Schema: public; owner: -; Tablespace: 
--

CREATE TABLE products (
    product_id integer NOT NULL,
    img_url text,
    name text,
    sku text NOT NULL,
    price double precision,
    description text
);


--
-- Name: products_categories; Type: TABLE; Schema: public; owner: -; Tablespace: 
--

CREATE TABLE products_categories (
    category_id integer,
    product_id integer
);


--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; owner: -
--

CREATE SEQUENCE products_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: -
--

ALTER SEQUENCE products_product_id_seq OWNED BY products.product_id;


--
-- Name: users; Type: TABLE; Schema: public; owner: -; Tablespace: 
--

CREATE TABLE users (
    uid integer NOT NULL,
    name text,
    role text,
    state text,
    date time without time zone,
    age integer
);


--
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; owner: -
--

CREATE SEQUENCE users_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; owner: -
--

ALTER SEQUENCE users_uid_seq OWNED BY users.uid;


--
-- Name: cart_id; Type: DEFAULT; Schema: public; owner: -
--

ALTER TABLE ONLY carts ALTER COLUMN cart_id SET DEFAULT nextval('carts_cart_id_seq'::regclass);


--
-- Name: category_id; Type: DEFAULT; Schema: public; owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN category_id SET DEFAULT nextval('categories_category_id_seq'::regclass);


--
-- Name: product_id; Type: DEFAULT; Schema: public; owner: -
--

ALTER TABLE ONLY products ALTER COLUMN product_id SET DEFAULT nextval('products_product_id_seq'::regclass);


--
-- Name: uid; Type: DEFAULT; Schema: public; owner: -
--

ALTER TABLE ONLY users ALTER COLUMN uid SET DEFAULT nextval('users_uid_seq'::regclass);


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; owner: -
--

COPY carts (cart_id, uid, total, "time") FROM stdin;
1	22	\N	\N
2	23	\N	\N
3	23	\N	\N
4	1	\N	\N
5	2	\N	\N
6	3	\N	\N
7	4	\N	\N
8	5	\N	\N
9	9	\N	\N
10	11	\N	\N
11	17	\N	\N
12	24	\N	\N
13	24	\N	\N
14	25	\N	\N
15	25	\N	\N
16	26	\N	\N
17	27	\N	\N
\.


--
-- Name: carts_cart_id_seq; Type: SEQUENCE SET; Schema: public; owner: -
--

SELECT pg_catalog.setval('carts_cart_id_seq', 17, true);


--
-- Data for Name: carts_products; Type: TABLE DATA; Schema: public; owner: -
--

COPY carts_products (cart_id, product_id) FROM stdin;
11	7
11	7
11	7
11	7
11	7
11	7
11	7
11	7
11	7
11	7
11	7
11	7
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; owner: -
--

COPY categories (category_id, img_url, name, description) FROM stdin;
1	sports	Sports	Sports Equipment
2	clothes	Clothing	Clothes
3	default	Electronics	Electronic stuff
4	default	Popular	Popular Items
5	default	Shoes	Shoes for feet
6	default	Books	For reading
7	default	Party	Party favors, balloons and stuff
\.


--
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; owner: -
--

SELECT pg_catalog.setval('categories_category_id_seq', 7, true);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; owner: -
--

COPY products (product_id, img_url, name, sku, price, description) FROM stdin;
1	default	Baseball Helmet	123dsa	100	For protecting your head
7	baseball_bat	Baseball Bat	567123	100	For hitting balls
13	default	Golf Clubs	384hfg	200	For golfing
14	default	Football	foot099	13	for playing football
15	default	Soccer Ball	socc	17	For soccer
16	default	Cardigan	987123	45	Like a shirt
17	default	Jeggings	9823jkh	98	Like jeans and leggings
18	default	Hawaiian Shirt	123jhs	23	For those vacations
19	default	Baseball Hat	hatb	45	For games
\.


--
-- Data for Name: products_categories; Type: TABLE DATA; Schema: public; owner: -
--

COPY products_categories (category_id, product_id) FROM stdin;
1	7
1	13
1	14
1	15
2	16
2	17
2	18
1	19
\.


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; owner: -
--

SELECT pg_catalog.setval('products_product_id_seq', 19, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; owner: -
--

COPY users (uid, name, role, state, date, age) FROM stdin;
1	Sean	customer	CA	\N	\N
2	Justin	owner	CA	\N	24
3	Ned Flanders	customer	DE	\N	25
4	Bobby	customer	CA	\N	40
5	Shawn	owner	CA	\N	23
6	Paul	customer	CT	\N	45
7	Jason	owner	AL	\N	45
8	test	customer	GA	\N	12
9	owner	owner	CA	\N	21
10	ImSoCool	customer	AL	\N	123
11	owner	owner	AZ	\N	55
12	user1	owner	AL	\N	10
13	user2	customer	AL	\N	10
14	user3	owner	AL	\N	13
15	user4	owner	AL	\N	13
16	user5	customer	AL	\N	45
17	customer	customer	CO	\N	13
18	1234	owner	AL	\N	1234
19	testtest	owner	AL	\N	1234
20	Homer Simpson	customer	VA	\N	40
21	Bart Simpson	customer	VA	\N	9
22	Lisa Simpson	customer	CO	\N	8
23	customer	owner	AL	\N	21
25	bq	owner	AL	\N	123
24	mamavibes	owner	AL	\N	12
26	 	customer	AL	\N	123542
27	bill	customer	AL	\N	45
\.


--
-- Name: users_uid_seq; Type: SEQUENCE SET; Schema: public; owner: -
--

SELECT pg_catalog.setval('users_uid_seq', 27, true);


--
-- Name: carts_pkey; Type: CONSTRAINT; Schema: public; owner: -; Tablespace: 
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (cart_id);


--
-- Name: categories_name_key; Type: CONSTRAINT; Schema: public; owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (sku);


--
-- Name: products_product_id_key; Type: CONSTRAINT; Schema: public; owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_product_id_key UNIQUE (product_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: carts_products_cart_id_fkey; Type: FK CONSTRAINT; Schema: public; owner: -
--

ALTER TABLE ONLY carts_products
    ADD CONSTRAINT carts_products_cart_id_fkey FOREIGN KEY (cart_id) REFERENCES carts(cart_id);


--
-- Name: carts_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; owner: -
--

ALTER TABLE ONLY carts_products
    ADD CONSTRAINT carts_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(product_id);


--
-- Name: carts_uid_fkey; Type: FK CONSTRAINT; Schema: public; owner: -
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid);


--
-- Name: products_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; owner: -
--

ALTER TABLE ONLY products_categories
    ADD CONSTRAINT products_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES categories(category_id);


--
-- Name: products_categories_product_id_fkey; Type: FK CONSTRAINT; Schema: public; owner: -
--

ALTER TABLE ONLY products_categories
    ADD CONSTRAINT products_categories_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(product_id);


--
-- PostgreSQL database dump complete
--
