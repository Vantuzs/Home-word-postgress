-- 30. PostgreSQL. Створення таблиці
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
('Jesyka', 'Forbs', '2002-09-01','+3806323353213', 'SBI-100',80,'female', '2024-09-01','Super Big Ideias'),
('Anya', 'Manya', '2002-09-01','+3806323353003', 'SBI-100',67,'female', '2024-09-01','Super Big Ideias'),
('Nastya', 'Snegova', '2002-09-01','+3806323354444', 'YF-13',80,'female', '2024-09-01','Yellow Face');

-- ('Marge','Simpson','1983-06-09','+5893234217', 'YF-13', 60,'female', '2002-09-01','Yellow Face')
INSERT INTO students(first_name,last_name,birthday,phone_number,grupa,avg_mark,gender,entered_at,departament) VALUES
('Petya','Popkin','1990-12-12','+380662228792', 'SBI-100',85,'male','2024-09-01', 'Super Big Ideias'),
('Jo', 'Simons', '2000-12-13', '+380991234554', 'SBI-100',65,'male','2024-09-01', 'Super Big Ideias'),
('Bruno','Daruno', '1998-08-21', '+380994569889', 'SBI-100', 59, 'male', '2024-09-01', 'Super Big Ideias');


DROP TABLE students;


---------------------------------------------------------------------------------

-- 31. PostgreSQL. Вибірка даних

SELECT first_name || ' ' || last_name AS "Full name", EXTRACT(year FROM AGE(birthday)) || '.' || EXTRACT(month FROM AGE(birthday)) AS age
FROM students
ORDER BY age DESC

SELECT DISTINCT grupa 
FROM students

SELECT first_name || ' ' || last_name AS "Full name", avg_mark
FROM students
ORDER BY avg_mark DESC

SELECT first_name || ' ' || last_name AS "Full name", avg_mark
FROM students
LIMIT 6 OFFSET 6

SELECT first_name || ' ' || last_name AS "Full name", avg_mark, grupa
FROM students
ORDER BY avg_mark DESC
LIMIT 3

SELECT grupa,AVG(avg_mark) AS "Общий средний бал"
FROM students

SELECT SUBSTRING(first_name,1,1) || '.' || last_name, SUBSTRING(phone_number,1,6) || '***********' AS "Number"
FROM students

SELECT first_name,last_name
FROM students
WHERE first_name = 'Anton' AND last_name = 'Antonov'

SELECT first_name,last_name, EXTRACT(year FROM birthday)
FROM students
WHERE EXTRACT(year FROM birthday) BETWEEN 2000 AND 2002 

SELECT first_name,last_name, avg_mark
FROM students
WHERE last_name = 'Simpson' AND avg_mark > 50

SELECT grupa,COUNT(grupa)
FROM students
GROUP BY grupa

SELECT EXTRACT(year FROM entered_at), COUNT(EXTRACT(year FROM entered_at))
FROM students
WHERE EXTRACT(year FROM entered_at) = '2024'
GROUP BY EXTRACT(year FROM entered_at)

SELECT first_name || ' ' || last_name, phone_number
FROM students
WHERE phone_number LIKE '+38099%'

SELECT departament, AVG(avg_mark) AS avg_avg_mark
FROM students
WHERE gender = 'female'
GROUP BY departament
ORDER BY avg_avg_mark DESC

SELECT SUBSTRING(first_name,1,1) || '.' || last_name,departament, avg_mark 
FROM students
WHERE departament = 'Super Big Ideias' AND avg_mark >=60 AND EXTRACT(month FROM birthday) BETWEEN 06 AND 08
GROUP BY id
ORDER BY avg_mark ASC
LIMIT 1

ALTER TABLE students
DROP COLUMN avg_mark




---------------------------------------------------------------------------------

-- 32. PostgresSQL. Зв'язки між таблицями

CREATE TABLE courses(
    id_course serial PRIMARY KEY,
    title varchar(100) NOT NULL CHECK(title!='') UNIQUE,
    discription text,
    study_hours smallint CHECK(study_hours >0)
)

INSERT INTO courses(title,discription,study_hours) VALUES('Химия','blablabla',10)

INSERT INTO courses(title,discription,study_hours) VALUES
('Основи програмування', 'blobloblo', 60),
('Information Technologies', 'blebleble', 45),
('Phisics', 'blublublu',30),
('Физкультура', 'bliblibli', 60),
('Схемотехника' ,'blyblybly', 60),
('История' ,'tratatatat', 90)

CREATE TABLE Exams(
    id_stud int REFERENCES students(id),
    id_course int REFERENCES courses(id_course),
    mark smallint NOT NULL CHECK(mark >0 AND mark <=100),
    CONSTRAINT primary_key_exams PRIMARY KEY (id_stud,id_course)
)

INSERT INTO Exams VALUES(1,1,75)

INSERT INTO Exams VALUES
(15,1,78),
(15,2,80),
(15,3,96),
(15,4,60),
(15,5,78),
(15,6,79),
(15,7,69)
--1
SELECT first_name || ' ' || last_name, title
FROM ( SELECT * FROM students JOIN Exams
ON students.id = Exams.id_stud) AS joinene JOIN courses
ON joinene.id_course = courses.id_course
--3
SELECT first_name || ' ' || last_name AS full_name, title, mark
FROM ( SELECT * FROM students JOIN Exams
ON students.id = Exams.id_stud) AS joinene JOIN courses
ON joinene.id_course = courses.id_course
WHERE first_name = 'Joe' AND last_name = 'Doe' AND title = 'High Math'
--4
SELECT first_name || ' ' || last_name AS full_name, title, mark
FROM ( SELECT * FROM students JOIN Exams
ON students.id = Exams.id_stud) AS joinene JOIN courses
ON joinene.id_course = courses.id_course
WHERE mark <=75 
ORDER BY mark DESC
--5
SELECT first_name || ' ' || last_name AS full_name, title, mark
FROM ( SELECT * FROM students JOIN Exams
ON students.id = Exams.id_stud) AS joinene JOIN courses
ON joinene.id_course = courses.id_course
WHERE title = 'Схемотехника' AND mark IS NOT NULL
--6
SELECT first_name || ' ' || last_name AS full_name, ROUND(AVG(mark),2) AS avg_mark, COUNT(title)
FROM ( SELECT * FROM students JOIN Exams
ON students.id = Exams.id_stud) AS joinene JOIN courses
ON joinene.id_course = courses.id_course
GROUP BY full_name
--7
SELECT first_name || ' ' || last_name AS full_name,title, mark
FROM ( SELECT * FROM students JOIN Exams
ON students.id = Exams.id_stud) AS joinene JOIN courses
ON joinene.id_course = courses.id_course
WHERE mark > 80
--8
SELECT title
FROM courses LEFT JOIN Exams
ON courses.id_course = Exams.id_course
WHERE Exams.id_course IS NULL
--9
SELECT first_name || ' ' || last_name AS full_name,birthday
FROM students
WHERE birthday = (SELECT birthday FROM students WHERE first_name = 'Anya' AND last_name = 'Manya')
AND NOT (first_name = 'Anya' AND last_name = 'Manya')
--10
SELECT first_name || ' ' || last_name AS full_name, ROUND(AVG(mark),2)
FROM students JOIN Exams
ON students.id = Exams.id_stud
WHERE mark > (SELECT ROUND(AVG(mark),2) FROM students JOIN Exams ON students.id = Exams.id_stud WHERE first_name = 'Anya' AND last_name = 'Manya')
AND NOT (first_name = 'Anya' AND last_name = 'Manya')
GROUP BY full_name
--11
SELECT title, study_hours
FROM courses
WHERE study_hours > (SELECT study_hours FROM courses WHERE title = 'Information Technologies')
--12
SELECT first_name || ' ' || last_name AS full_name, title, mark
FROM ( SELECT * FROM students JOIN Exams
ON students.id = Exams.id_stud) AS joinene JOIN courses
ON joinene.id_course = courses.id_course
WHERE mark > (SELECT MAX(mark) FROM students JOIN Exams ON students.id = Exams.id_stud WHERE first_name = 'Anya' AND last_name = 'Manya')
--13
SELECT first_name || ' ' || last_name AS full_name, title, mark,
CASE 
    WHEN mark >= 60 THEN 'Задовільно'
    WHEN mark >= 75 THEN 'Добре'
    WHEN mark >= 90 THEN 'Відмінно'
    WHEN mark < 60 THEN 'Грустна =('
END AS Оценка
FROM ( SELECT * FROM students JOIN Exams
ON students.id = Exams.id_stud) AS joinene JOIN courses
ON joinene.id_course = courses.id_course