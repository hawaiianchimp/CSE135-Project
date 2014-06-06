CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    role        TEXT NOT NULL,
    age   	INTEGER NOT NULL,
    state  	TEXT NOT NULL
);

CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    cid         INTEGER REFERENCES categories (id) ON DELETE CASCADE,
    name        TEXT NOT NULL,
    SKU         TEXT NOT NULL UNIQUE,
    price       INTEGER NOT NULL
);

CREATE TABLE sales (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price		INTEGER NOT NULL
);

CREATE TABLE carts (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price 		INTEGER NOT NULL
);

CREATE TABLE states (
	state		TEXT PRIMARY KEY
);

DROP TABLE users_total;
CREATE TABLE users_total (
	name    TEXT NOT NULL,
	uid		INTEGER REFERENCES users (id),	
	total	INTEGER NOT NULL
);

INSERT INTO users_total
SELECT u.name, u.id, SUM(s.quantity*s.price)
FROM sales s, users u 
WHERE s.uid = u.id
GROUP BY u.name, u.id;

DROP TABLE products_total;
CREATE TABLE products_total (
	name    TEXT NOT NULL,
	pid		INTEGER REFERENCES products (id),	
	total	INTEGER NOT NULL
);

INSERT INTO products_total 
SELECT p.name, p.id, SUM(s.quantity*s.price) 
FROM sales s,products p
WHERE s.pid = p.id
GROUP BY p.name, p.id;

DROP TABLE states_total;
CREATE TABLE states_total (
	state	TEXT NOT NULL,
	total	INTEGER NOT NULL
);

INSERT INTO states_total 
SELECT st.name, SUM(s.quantity*s.price) 
FROM sales s, states st, users u
WHERE st.name = u.state
AND u.id = s.uid 
GROUP BY st.name;

DROP TABLE users_products_total;
CREATE TABLE users_products_total (
	uid		INTEGER REFERENCES users (id),
	pid		INTEGER REFERENCES products (id),
	total	INTEGER NOT NULL
);

INSERT INTO users_products_total SELECT uid, pid, SUM(quantity*price) FROM sales GROUP BY pid, uid;

DROP TABLE users_categories_total;
CREATE TABLE users_categories_total (
	name    TEXT NOT NULL,
	uid		INTEGER REFERENCES users (id),
	cid		INTEGER REFERENCES categories (id),
	total	INTEGER NOT NULL
);

INSERT INTO users_categories_total 
SELECT u.name, s.uid, c.id, SUM(s.quantity*s.price) 
FROM sales s, categories c, products p, users u 
WHERE  c.id = p.cid
AND s.pid = p.id
AND s.uid = u.id
GROUP BY u.name, s.uid, c.id;

DROP TABLE states_products_total;
CREATE TABLE states_products_total (
	state 	TEXT NOT NULL,
	pid		INTEGER REFERENCES products (id),
	total	INTEGER NOT NULL
);

INSERT INTO states_products_total 
SELECT st.name, p.id, SUM(s.quantity*s.price) 
FROM sales s, states st, products p, users u 
WHERE  st.name = u.state
AND s.pid = p.id
AND s.uid = u.id
GROUP BY st.name, p.id;

DROP TABLE states_categores_total;
CREATE TABLE states_categories_total (
	state 	TEXT NOT NULL,
	cid		INTEGER REFERENCES categories (id),
	total	INTEGER NOT NULL
);

INSERT INTO states_categories_total 
SELECT st.name, c.id, SUM(s.quantity*s.price) 
FROM sales s, states st, products p, users u, categories c 
WHERE  st.name = u.state
AND s.pid = p.id
AND s.uid = u.id
AND p.cid = c.id
GROUP BY st.name, c.id;

