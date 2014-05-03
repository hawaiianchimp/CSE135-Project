DROP TABLE carts CASCADE;
DROP TABLE carts_products CASCADE;
DROP TABLE categories CASCADE;
DROP TABLE products CASCADE;
DROP TABLE products_categories CASCADE;
DROP TABLE users CASCADE;


CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    img_url TEXT,
    name TEXT UNIQUE NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    img_url TEXT,
    name TEXT NOT NULL,
    sku TEXT UNIQUE NOT NULL,
    price DOUBLE PRECISION NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE products_categories (
    category_id INTEGER REFERENCES categories (category_id) NOT NULL,
    product_id INTEGER REFERENCES products (product_id) NOT NULL
);

CREATE TABLE users (
    uid SERIAL PRIMARY KEY,
    name TEXT UNIQUE,
    role TEXT NOT NULL,
    state TEXT NOT NULL,
    date TIME,
    age INTEGER NOT NULL
);

CREATE TABLE carts (
    cart_id SERIAL PRIMARY KEY,
    uid INTEGER REFERENCES users (uid) NOT NULL,
    total DOUBLE PRECISION,
    time TIMESTAMP
);
--
CREATE TABLE carts_products (
    cart_id INTEGER REFERENCES carts (cart_id) NOT NULL,
    product_id INTEGER REFERENCES products (product_id) NOT NULL
);


INSERT INTO users (uid, name, role, state, age) SELECT 1,	'Sean',		'Owner',	'HI', 23;
INSERT INTO users (uid, name, role, state, age) SELECT 2,	'Vineel',	'Owner',	'CA', 25;
INSERT INTO users (uid, name, role, state, age) SELECT 3,	'Bonnie',	'Customer',	'CA', 22;
INSERT INTO users (uid, name, role, state, age) SELECT 4,	'owner',	'Owner',	'CA', 21;
INSERT INTO users (uid, name, role, state, age) SELECT 5,	'customer',	'Customer',	'CA', 26;

INSERT INTO carts (cart_id, uid) SELECT 6,  1;
INSERT INTO carts (cart_id, uid) SELECT 7,	2;
INSERT INTO carts (cart_id, uid) SELECT 8,	3;
INSERT INTO carts (cart_id, uid) SELECT 9,	4;
INSERT INTO carts (cart_id, uid) SELECT 10,	5;

INSERT INTO categories (category_id, img_url, name, description) SELECT 1, 'sports', 'Sports', 'Sports Equipment';
INSERT INTO categories (category_id, img_url, name, description) SELECT 2, 'clothes', 'Clothing', 'Clothes';
INSERT INTO categories (category_id, img_url, name, description) SELECT 3, 'default', 'Electronics', 'Electronic stuff';
INSERT INTO categories (category_id, img_url, name, description) SELECT 4, 'default', 'Popular', 'Popular Items';
INSERT INTO categories (category_id, img_url, name, description) SELECT 5, 'default', 'Shoes', 'Shoes for feet';
INSERT INTO categories (category_id, img_url, name, description) SELECT 6, 'default', 'Books', 'For reading';
INSERT INTO categories (category_id, img_url, name, description) SELECT 7, 'default', 'Party', 'Party favors, balloons and stuff';

INSERT INTO products (product_id, img_url, name, sku, price, description) SELECT 1,	'default',	'Baseball Helmet',	'123dsa',	'100',	'For protecting your head';
INSERT INTO products (product_id, img_url, name, sku, price, description) SELECT 7, 'baseball_bat', 'Baseball Bat', '567123', '100', 'For hitting balls';
INSERT INTO products (product_id, img_url, name, sku, price, description) SELECT 13, 'default', 'Golf Clubs', '384hfg', '200', 'For golfing';
INSERT INTO products (product_id, img_url, name, sku, price, description) SELECT 14, 'default', 'Football', 'foot099', '13', 'for playing football';
INSERT INTO products (product_id, img_url, name, sku, price, description) SELECT 15, 'default', 'Soccer Ball', 'socc', '17', 'For soccer';
INSERT INTO products (product_id, img_url, name, sku, price, description) SELECT 16, 'default', 'Cardigan', '987123', '45', 'Like a shirt';
INSERT INTO products (product_id, img_url, name, sku, price, description) SELECT 17, 'default', 'Jeggings', '9823jkh', '98', 'Like jeans and leggings';
INSERT INTO products (product_id, img_url, name, sku, price, description) SELECT 18, 'default', 'Hawaiian Shirt', '123jhs', '23', 'For those vacations';
INSERT INTO products (product_id, img_url, name, sku, price, description) SELECT 19, 'default', 'Baseball Hat', 'hatb', '45', 'For games';

INSERT INTO products_categories (category_id, product_id) SELECT 1, 7;
INSERT INTO products_categories (category_id, product_id) SELECT 1,	13;
INSERT INTO products_categories (category_id, product_id) SELECT 1,	14;
INSERT INTO products_categories (category_id, product_id) SELECT 1,	15;
INSERT INTO products_categories (category_id, product_id) SELECT 2,	16;
INSERT INTO products_categories (category_id, product_id) SELECT 2,	17;
INSERT INTO products_categories (category_id, product_id) SELECT 2,	18;
INSERT INTO products_categories (category_id, product_id) SELECT 1,	19;


INSERT INTO carts_products (cart_id, product_id) SELECT 6,	7;
INSERT INTO carts_products (cart_id, product_id) SELECT 6,	7;
INSERT INTO carts_products (cart_id, product_id) SELECT 6,	7;
INSERT INTO carts_products (cart_id, product_id) SELECT 6,	7;
INSERT INTO carts_products (cart_id, product_id) SELECT 6,	13;
INSERT INTO carts_products (cart_id, product_id) SELECT 6,	15;
INSERT INTO carts_products (cart_id, product_id) SELECT 7,	7;
INSERT INTO carts_products (cart_id, product_id) SELECT 7,	13;
INSERT INTO carts_products (cart_id, product_id) SELECT 7,	15;
INSERT INTO carts_products (cart_id, product_id) SELECT 7,	15;
INSERT INTO carts_products (cart_id, product_id) SELECT 7,	15;
INSERT INTO carts_products (cart_id, product_id) SELECT 8,	7;
INSERT INTO carts_products (cart_id, product_id) SELECT 8,	13;
INSERT INTO carts_products (cart_id, product_id) SELECT 8,	13;
INSERT INTO carts_products (cart_id, product_id) SELECT 8,	13;
INSERT INTO carts_products (cart_id, product_id) SELECT 8,	15;


