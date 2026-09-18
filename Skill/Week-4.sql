CREATE DATABASE CollegeDB;
USE CollegeDB;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    department VARCHAR(50),
    marks INT
);

CREATE TABLE Student_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    old_marks INT,
    new_marks INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Students VALUES
(1, 'Sathish', 'CSE', 85),
(2, 'Rahul', 'CSE', 78),
(3, 'Sai', 'ECE', 92),
(4, 'Kiran', 'IT', 67),
(5, 'Arjun', 'CSE', 55);

SELECT * FROM Students;
DELIMITER //

CREATE TRIGGER after_marks_update
AFTER UPDATE ON Students
FOR EACH ROW
BEGIN
    IF OLD.marks <> NEW.marks THEN
        INSERT INTO Student_Audit
        (student_id, old_marks, new_marks)
        VALUES
        (OLD.student_id, OLD.marks, NEW.marks);
    END IF;
END //

DELIMITER ;
UPDATE Students
SET marks = 90
WHERE student_id = 1;
SELECT * FROM Student_Audit;
DELIMITER //

CREATE PROCEDURE GetStudentsByDepartment(IN dept_name VARCHAR(50))
BEGIN
    SELECT *
    FROM Students
    WHERE department = dept_name;
END //

DELIMITER ;
CALL GetStudentsByDepartment('CSE');
CREATE VIEW CSE_Students AS
SELECT student_id, student_name, marks
FROM Students
WHERE department = 'CSE';
SELECT * FROM CSE_Students;
SHOW TRIGGERS;
SHOW PROCEDURE STATUS
WHERE Db = 'CollegeDB';
SHOW FULL TABLES
WHERE Table_type = 'VIEW';