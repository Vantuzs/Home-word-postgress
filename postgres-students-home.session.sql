CREATE TABLE students (
    id serial PRIMARY KEY,
    first_name varchar(64) NOT NULL CONSTRAINT check_first_name CHECK(first_name != ''),
    last_name varchar(64) NOT NULL CONSTRAINT check_last_name CHECK(last_name != ''),
    birthday date CONSTRAINT birthday_not_valid CHECK (birthday <= current_date),
    phone_number varchar(16) NOT NULL CONSTRAINT phone_number_is_not_valid
     CHECK (phone_number ~ '^\+?\d{10,15}$'),
    grupa varchar(64) NOT NULL CHECK(grupa != ''),
    avg_mark numeric(5,2) CONSTRAINT avg_mark_is_not_valid CHECK (avg_mark > 0 AND avg_mark <= 100),
    gender varchar(16) CONSTRAINT gender_is_not_valid CHECK (gender IN ('male', 'female', 'other')),
    entered_at date CONSTRAINT entered_at_is_not_valid CHECK (entered_at <= current_date),
    departament varchar(200) NOT NULL CONSTRAINT departament_is_not_valid CHECK(departament != '')
);



INSERT INTO students(first_name,last_name,birthday,phone_number,grupa,avg_mark,gender,entered_at,departament) VALUES
    ('Joe', 'Doe', '2000-12-02', '+380992208787', 'KRA-122',60,'male', '2024-09-01', 'Kardio Retmicheski Antropoliticheskiy'),
    ('Suzan', 'Buzan', '1998-08-14', '+0663221452', 'SBI-100',76,'female', '2024-09-01' ,'Super Big Ideias'),
    ('Quentin', 'Tarantino', '1963-03-27', '+8265005733', 'CP-1',100,'male', '1980-09-01','Cool producer');

INSERT INTO students(first_name,last_name,birthday,phone_number,grupa,avg_mark,gender,entered_at,departament) VALUES
('Gomer','Simpson','1980-05-09','+58932406601', 'YF-13', 25,'male', '2001-09-01','Yellow Face')

DROP TABLE students;

