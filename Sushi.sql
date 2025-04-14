CREATE TABLE menu(
    id serial PRIMARY KEY,
    names varchar(100) NOT NULL CHECK(names!=''),
    compound varchar(1000) NOT NULL CHECK(compound!=''),
    weights smallint NOT NULL CHECK(weights >0),
    price numeric(6,2) NOT NULL CHECK(price >0)
)

CREATE TABLE users(
    id serial PRIMARY KEY,
    first_name varchar(64) NOT NULL CONSTRAINT first_name_require CHECK(first_name!=''),
    last_name varchar(100) NOT NULL CONSTRAINT last_name_require CHECK(last_name!=''),
    email text NOT NULL CONSTRAINT email_require CHECK(email!=''),
    gender varchar(6) NOT NULL CONSTRAINT gender_is_not_valid CHECK (gender IN ('male', 'female', 'other')),
    is_subscribe boolean NOT NULL,
    birthday date CONSTRAINT birthday_not_valid CHECK (birthday <= current_date),
    phone_number varchar(16) NOT NULL CONSTRAINT phone_number_is_not_valid CHECK (phone_number ~ '^\+?\d{10,15}$')
)


CREATE TABLE orders(
    id serial PRIMARY KEY,
    order_date timestamp DEFAULT current_timestamp,
    customer_id int REFERENCES users(id)
)

CREATE TABLE orders_to_menu(
    order_id int REFERENCES orders(id),
    menu_id int REFERENCES menu(id),
    quantity int NOT NULL CHECK(quantity>0) DEFAULT 1,
    PRIMARY KEY (order_id,menu_id)
)


INSERT INTO orders(order_date,customer_id) VALUES('2000-12-12',2)

INSERT INTO orders(customer_id) VALUES
(1),(2),(3),(4),(2),(3),(2),(3),(3),(3),(2),(2),(4),(4),(1),(4),(3),(2)

INSERT INTO orders_to_menu VALUES
(19,1,2),(19,2,1),(19,3,3)
(2,6,2),(2,5,1),(2,4,3),
(3,8,2),(3,7,1),(3,2,3),
(4,8,2),(4,1,1),(4,5,3),
(5,2,2),(5,8,1),(5,9,3),
(6,1,2),(6,4,1),(6,7,3),
(7,6,2),(7,5,1),(7,4,3),
(8,8,2),(8,7,1),(8,2,3),
(9,8,2),(9,1,1),(9,5,3),
(10,2,2),(10,8,1),(10,9,3),
(11,1,2),(11,2,1),(11,3,3),
(12,6,2),(12,5,1),(12,4,3),
(13,5,2),(13,6,1),(13,8,3),
(14,3,2),(14,2,1),(14,9,3),
(15,2,2),(15,8,1),(15,9,3),
(16,1,2),(16,2,1),(16,3,3),
(17,6,2),(17,5,1),(17,4,3),
(18,5,2),(18,6,1),(18,8,3)


INSERT INTO menu(names,compound,weights,price) VALUES
('Калифорния с лососем','Лосось,  рис, нори, икра тобико, японский майонез',220,179.00),
('Филадельфия с икрой','Лосось, икра лососевая, сыр филадельфия, рис, нори',300,259.00),
('Калифорния с тунцом','Тунец, авокадо, огурец, японский майонез, нори, рис, икра тобико',220,159.00),
('Ролл Красный дракон','Лосось, рис, нори, филадельфия, огурец, коктельная креветка',270,199.00),
('Филадельфия с лососем','Лосось, сыр филадельфия, рис, нори',270,199.00),
('Ролл с тунцом тереяки','Тунец тереяки, огурец, кимчи, кунжут, лист салата',230,144.00),
('Ролл с угрем в кунжуте','Угорь, болгарский перец, кунжут, икра массаго',210,219.00),
('Ролл Сяке Фламбе','Лосось, угорь, огурец, лист салата, спайси',250,249.00),
('Ролл с угрем и лососем','Лосось , сыр Филадельфия, огурец, угорь, соус Унаги, кунжут',270,299.00)

INSERT INTO users(first_name,last_name,email,gender,is_subscribe,birthday,phone_number) VALUES
('Simon','Dziha','simon.dziha@gmail.com','male',true,'2000-12-01','+380669872222')
('John','Doe','john.doe@gmail.com','male',true,'2000-12-01','+380669871221')
('Gomer','Simpson','gomer.simpson@gmail.com','male',false,'1980-05-06','+380999233454'),
('Marge','Simpson','marg.simpson@gmail.com','female',true,'1983-09-12','+380666666262'),
('Timon','Pumbovich','tomoha@gmail.com','male',false,'1990-05-23','+3804044184412')


--1
WITH order_detals AS (
    SELECT o.id,m.names,otm.quantity,m.price,(m.price * otm.quantity) AS total_price_position FROM menu AS m JOIN orders_to_menu AS otm
ON m.id = otm.menu_id
JOIN orders AS o ON o.id = otm.order_id
WHERE o.id = 3
)
SELECT *,(SELECT SUM(total_price_position) FROM order_detals) AS total_price FROM order_detals
--2
SELECT o.id,m.names,o.order_date,otm.quantity,m.price,(m.price * otm.quantity) AS total_price_position FROM menu AS m JOIN orders_to_menu AS otm
ON m.id = otm.menu_id
JOIN orders AS o ON o.id = otm.order_id
WHERE DATE(o.order_date) = current_date
--3
SELECT o.id,m.names,o.order_date,otm.quantity,m.price,(m.price * otm.quantity) AS total_price_position FROM menu AS m JOIN orders_to_menu AS otm
ON m.id = otm.menu_id
JOIN orders AS o ON o.id = otm.order_id
WHERE DATE(o.order_date) BETWEEN '2025-04-04' AND current_date
--4
SELECT DATE(o.order_date), SUM(m.price * otm.quantity) FROM menu AS m JOIN orders_to_menu AS otm
ON m.id = otm.menu_id
JOIN orders AS o ON o.id = otm.order_id
WHERE DATE(o.order_date) = current_date
GROUP BY o.order_date
--5
SELECT DATE(o.order_date), SUM(m.price * otm.quantity) FROM menu AS m JOIN orders_to_menu AS otm
ON m.id = otm.menu_id
JOIN orders AS o ON o.id = otm.order_id
WHERE DATE(o.order_date) BETWEEN current_date - INTERVAL '1 month'  AND current_date
GROUP BY o.order_date
--6
SELECT first_name|| ' ' ||  last_name AS full_name FROM users AS u JOIN orders AS o
ON u.id = o.customer_id
GROUP BY full_name
--7
WITH orders_data AS (SELECT o.id,m.id AS menu_id,m.names,otm.quantity FROM menu AS m JOIN orders_to_menu AS otm
ON m.id = otm.menu_id
JOIN orders AS o ON o.id = otm.order_id
WHERE DATE(o.order_date) BETWEEN current_date - INTERVAL '1 month' AND current_date)
SELECT orders_data.names,SUM(orders_data.quantity) FROM orders_data
GROUP BY orders_data.names
ORDER BY orders_data.count DESC
LIMIT 5
--8
SELECT DATE(o.order_date), SUM(m.price * otm.quantity) - (SUM(m.price * otm.quantity) * 0.97) AS прибыль FROM menu AS m JOIN orders_to_menu AS otm
ON m.id = otm.menu_id
JOIN orders AS o ON o.id = otm.order_id
WHERE DATE(o.order_date) BETWEEN current_date - INTERVAL '1 month'  AND current_date
GROUP BY o.order_date