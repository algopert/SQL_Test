CREATE DATABASE `mydb`;

USE `mydb`;


DROP TABLE IF EXISTS `COURSE`;

CREATE TABLE COURSE (
  course_id varchar(20) NOT NULL,
  course_name varchar(255) NOT NULL,
  PRIMARY KEY (course_id)
);

INSERT INTO COURSE (course_id, course_name)
VALUES ('CSM103', 'Computer Service Management'), 
('CP102', 'Computing'), 
('CP100', 'Games Design'), 
('SD101', 'Software Development'),
('cnsm2', 'cnsm2');


DROP TABLE IF EXISTS `MODULE`;

CREATE TABLE MODULE (
  module_id varchar(255) NOT NULL,
  module_name varchar(255) NOT NULL,
  course_id varchar(20),
  PRIMARY KEY (module_id),
  FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);

INSERT INTO MODULE (module_id, module_name)
VALUES ('CSC102', 'Computer System Concepts'),
('ECOMP', 'Electronics for Computing'),
('IPD104', 'Interpersonal Development'),
('MM102', 'Mathematical Methods'),
('MMT', 'Mathematics for Computing'),
('Net1', 'Introduction to Computer Metworks'),
('OOP102', 'Introduction to Object Oriented P...'),
('OS1', 'Operating Systems Fundamentals'),
('OSM2', 'Operating Systems Management'),
('PDC101', 'Programme Design Concepts'),
('Prog101', 'Introduction to Programming'),
('WDF', 'Web Development Fundamentals'),
('HNET060190', 'HNET060190'),
('HNET06020', 'HNET06020'),
('CONE06004', 'CONE06004');


DROP TABLE IF EXISTS `COURSE_MODULE`;

CREATE TABLE COURSE_MODULE (
  course_id varchar(20),
  FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
  module_id varchar(255),
  FOREIGN KEY (module_id) REFERENCES MODULE(module_id)
);


DROP TABLE IF EXISTS `USER`;

CREATE TABLE USER (
  user_id int NOT NULL AUTO_INCREMENT,
  user_name varchar(255) NOT NULL,
  gender varchar(255) NOT NULL,
  CHECK (gender = "M" OR gender = "F"),
  email varchar(255) NOT NULL,
  date_created DATE NOT NULL,
  phone varchar(255) NOT NULL,
  course_id varchar(20),
  PRIMARY KEY (user_id),
  FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);

INSERT INTO USER (user_id, user_name, gender, email, date_created, phone, course_id)
VALUES (1, "username1", 'M', 'email1@email.com', '2022-02-02', '12345678', 'cnsm2'),
(2, "username2", 'M', 'email2@email.com', '2022-02-04', '12345679', 'cnsm2');


DROP TABLE IF EXISTS `GRADE`;

CREATE TABLE GRADE (
  module_id varchar(255),
  FOREIGN KEY (module_id) REFERENCES MODULE(module_id),
  student_id int,
  FOREIGN KEY (student_id) REFERENCES USER(user_id),
  grade int
);


DROP TABLE IF EXISTS `TIMETABLE`;

CREATE TABLE TIMETABLE (
  module_id varchar(255),
  module_name varchar(255) NOT NULL,
  FOREIGN KEY (module_id) REFERENCES MODULE(module_id),
  semester int,
  day ENUM('Mon','Tues','Wed', 'Thurs', 'Fri'),
  time varchar(255),
  room varchar(255),
  class_group varchar(255)
  CHECK (semester >= 1 AND semester <= 8)
);

INSERT INTO TIMETABLE (module_id, module_name, semester, day, time, room, class_group)
VALUES ('HNET060190', 'Growing the LAN', 1, 'Mon', '4pm', '8a504', 'cnsm2'),
('HNET06020', 'Connecting the Internet', 2, 'Tues', '9am', '8a201', 'cnsm2'),
('CONE06004', 'IP Systems', 2, 'Wed', '12pm', '8a201', 'cnsm2');


DROP TABLE IF EXISTS `ASSIGNMENT`;

CREATE TABLE ASSIGNMENT (
  assignment_id int NOT NULL AUTO_INCREMENT,
  title varchar(255),
  due_date DATE DEFAULT CURRENT_DATE,
  time_due varchar(255),
  perentage_wt int,
  hand_up_method varchar(255),
  module_id varchar(255),
  PRIMARY KEY (assignment_id),
  FOREIGN KEY (module_id) REFERENCES MODULE(module_id)
);

INSERT INTO ASSIGNMENT (assignment_id, title, due_date, time_due, perentage_wt, hand_up_method, module_id)
VALUES (1, 'Programming a Calculator', '2022-10-04', '12:00:00', 30, 'Upload to Moodle', 'Prog101'),
(2, 'Build a Computer', '2018-09-27', '12:00:00', 30, 'Upload to Moodle', 'CSC102'),
(3, 'Mathematics Rearch', '2018-11-26', '12:00:00', 20, 'Upload to Moodle', 'MMT');


DROP TABLE IF EXISTS `FORUM`;

CREATE TABLE FORUM (
  question_id int NOT NULL AUTO_INCREMENT,
  question_title varchar(255),
  question_content varchar(255),
  date_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  user_id int,
  PRIMARY KEY (question_id),
  FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

INSERT INTO FORUM (question_id, question_title, question_content, date_time, user_id)
VALUES (1, 'question1', 'question_content1', '2008-11-11 13:23:44', 2),
(2, 'question2', 'question_content2', '2008-11-09 15:45:21', 1);



DROP TABLE IF EXISTS `REPLY`;

CREATE TABLE REPLY (
  reply_id int NOT NULL AUTO_INCREMENT,
  question_id int,
  FOREIGN KEY (question_id) REFERENCES FORUM(question_id),
  reply_content varchar(255),
  date_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  user_id int,
  FOREIGN KEY (user_id) REFERENCES USER(user_id),
  PRIMARY KEY (reply_id)
);

INSERT INTO REPLY (reply_id, question_id, reply_content, date_time, user_id)
VALUES (1, 1, 'reply_content1', '2008-12-29 14:56:59', 2);


CREATE VIEW `Timetable 1` AS
SELECT *
FROM TIMETABLE
WHERE semester = 1 AND class_group = '1B'
ORDER BY day ASC, time ASC;

CREATE VIEW `Timetable 2` AS
SELECT *
FROM TIMETABLE
WHERE semester = 1 AND class_group = '1A';


CREATE VIEW `Assignment View` AS
SELECT ASSIGNMENT.title, MODULE.module_name, ASSIGNMENT.due_date
FROM ASSIGNMENT INNER JOIN MODULE ON ASSIGNMENT.module_id = MODULE.module_id
WHERE ASSIGNMENT.due_date > CURRENT_DATE;

CREATE VIEW `Assignment Left Days` AS
SELECT ASSIGNMENT.title, MODULE.module_name, ASSIGNMENT.hand_up_method, SUM(ASSIGNMENT.due_date - CURRENT_DATE) left_day
FROM ASSIGNMENT INNER JOIN MODULE ON ASSIGNMENT.module_id = MODULE.module_id
WHERE ASSIGNMENT.due_date > CURRENT_DATE;