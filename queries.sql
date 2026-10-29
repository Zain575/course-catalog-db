-- queries.sql: queries for the API routes

-- 1. GET /courses?is_elective=false&sort=popular&page=1&page_size=3
SELECT id, title, credits, likes 
FROM courses 
WHERE is_elective = false 
ORDER BY likes DESC, id ASC 
LIMIT 3 OFFSET 0;

-- 1b. The same, page 2 (OFFSET = 3)
SELECT id, title, credits, likes 
FROM courses 
WHERE is_elective = false 
ORDER BY likes DESC, id ASC 
LIMIT 3 OFFSET 3;

-- 2. GET /courses/{course_id} ('api-design')
SELECT id, title, credits, is_elective, likes 
FROM courses 
WHERE id = 'api-design';

-- 2b. Nonexistent course ('no-such-course')
SELECT id, title, credits, is_elective, likes 
FROM courses 
WHERE id = 'no-such-course';

-- 3. POST /courses/{course_id}/like
BEGIN;
UPDATE courses 
SET likes = likes + 1 
WHERE id = 'api-design' 
RETURNING id, likes;

-- 3b. Nonexistent course like
UPDATE courses 
SET likes = likes + 1 
WHERE id = 'no-such-course' 
RETURNING id, likes;
ROLLBACK;

-- 4. POST /enrollments (enroll student 3 in 'web-security')
BEGIN;
INSERT INTO enrollments (course_id, student_id) 
VALUES ('web-security', 3) 
RETURNING id, course_id, student_id;
ROLLBACK;

-- 5. GET /enrollments (All enrollments with student name and course title)
SELECT e.id, s.name AS student, c.title AS course 
FROM enrollments e
JOIN students s ON s.id = e.student_id
JOIN courses c ON c.id = e.course_id
ORDER BY e.id;

-- 6. Statistics: enrollments per course, including courses with none
SELECT c.id, count(e.id) AS enrolled 
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.id
GROUP BY c.id
ORDER BY enrolled DESC, c.id ASC;
