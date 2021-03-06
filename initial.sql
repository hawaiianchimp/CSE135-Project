DROP TABLE users_total;
DROP TABLE products_total;
DROP TABLE states_total;
DROP TABLE users_products_total;
DROP TABLE users_categories_total;
DROP TABLE states_products_total;
DROP TABLE states_categories_total;


CREATE TABLE users_total (
	name    TEXT NOT NULL,
	uid		INTEGER REFERENCES users (id),	
	total	INTEGER NOT NULL
);
CREATE TABLE products_total (
	name    TEXT NOT NULL,
	pid		INTEGER REFERENCES products (id),	
	total	INTEGER NOT NULL
);
CREATE TABLE states_total (
	state	TEXT NOT NULL,
	total	INTEGER NOT NULL
);
CREATE TABLE users_products_total (
	uid		INTEGER REFERENCES users (id),
	pid		INTEGER REFERENCES products (id),
	total	INTEGER NOT NULL
);

CREATE TABLE users_categories_total (
	name    TEXT NOT NULL,
	uid		INTEGER REFERENCES users (id),
	cid		INTEGER REFERENCES categories (id),
	total	INTEGER NOT NULL
);
CREATE TABLE states_products_total (
	state 	TEXT NOT NULL,
	pid		INTEGER REFERENCES products (id),
	total	INTEGER NOT NULL
);
CREATE TABLE states_categories_total (
	state 	TEXT NOT NULL,
	cid		INTEGER REFERENCES categories (id),
	total	INTEGER NOT NULL
);


INSERT INTO users_total
SELECT u.name, u.id, SUM(s.quantity*s.price)
FROM sales s, users u 
WHERE s.uid = u.id
GROUP BY u.name, u.id;

INSERT INTO states_total 
SELECT st.name, SUM(s.quantity*s.price) 
FROM sales s, states st, users u
WHERE st.name = u.state
AND u.id = s.uid 
GROUP BY st.name;

INSERT INTO users_products_total 
SELECT uid, pid, SUM(quantity*price) 
FROM sales 
GROUP BY pid, uid;

INSERT INTO products_total 
SELECT p.name, p.id, SUM(s.quantity*s.price) 
FROM sales s,products p
WHERE s.pid = p.id
GROUP BY p.name, p.id;

INSERT INTO users_categories_total 
SELECT u.name, s.uid, c.id, SUM(s.quantity*s.price) 
FROM sales s, categories c, products p, users u 
WHERE  c.id = p.cid
AND s.pid = p.id
AND s.uid = u.id
GROUP BY u.name, s.uid, c.id;

INSERT INTO states_products_total
SELECT u.state, p.pid, SUM(p.total)
FROM users_products_total p JOIN users u
ON p.uid = u.id
GROUP BY u.state, p.pid

INSERT INTO states_categories_total
SELECT u.state, pc.cid, SUM(pc.total)
FROM users u JOIN users_categories_total pc
ON pc.uid = u.id
GROUP BY u.state, pc.cid