-- ============================================================
-- SMART LIBRARY MANAGEMENT SYSTEM
-- FINAL DATABASE - MySQL 8+
-- ============================================================
--
-- ADMIN        : 1
-- MEMBERS      : 111
-- BOOKS        : 1317
-- TRANSACTIONS : 444
--
-- MEMBER ID = ENROLLMENT NUMBER
--
-- 25162201001 - 25162201056  -> 56 MEMBERS
-- 26162201001 - 26162201055  -> 55 MEMBERS
--
-- TOTAL MEMBERS = 111
-- ============================================================


-- ============================================================
-- 0. RECURSIVE CTE LIMIT
-- ============================================================

SET SESSION cte_max_recursion_depth = 5000;


-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

DROP DATABASE IF EXISTS library_db;

CREATE DATABASE library_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE library_db;


-- ============================================================
-- 2. CATEGORIES TABLE
-- ============================================================

CREATE TABLE categories (
    category_id BIGINT PRIMARY KEY AUTO_INCREMENT,

    category_name VARCHAR(100) NOT NULL UNIQUE
);


-- ============================================================
-- 3. USERS TABLE
-- ============================================================

CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,

    name VARCHAR(120) NOT NULL,

    email VARCHAR(150) NOT NULL UNIQUE,

    password_hash VARCHAR(100) NOT NULL,

    role ENUM('ADMIN', 'MEMBER') NOT NULL,

    status ENUM('ACTIVE', 'INACTIVE')
        NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 4. MEMBER DETAILS TABLE
--
-- member_id IS ENROLLMENT NUMBER
-- NOT AUTO_INCREMENT
-- ============================================================

CREATE TABLE member_details (

    member_id BIGINT PRIMARY KEY,

    user_id BIGINT NOT NULL UNIQUE,

    phone VARCHAR(20) NOT NULL,

    course VARCHAR(100) NOT NULL,

    department VARCHAR(100) NOT NULL,

    semester TINYINT UNSIGNED NOT NULL,

    registration_date DATE NOT NULL,

    CONSTRAINT chk_member_semester
        CHECK (semester BETWEEN 1 AND 12),

    CONSTRAINT fk_member_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);


-- ============================================================
-- 5. ADMIN DETAILS TABLE
-- ============================================================

CREATE TABLE admin_details (

    admin_id BIGINT PRIMARY KEY AUTO_INCREMENT,

    user_id BIGINT NOT NULL UNIQUE,

    employee_id VARCHAR(50) NOT NULL UNIQUE,

    CONSTRAINT fk_admin_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);


-- ============================================================
-- 6. BOOKS TABLE
-- ============================================================

CREATE TABLE books (

    book_id BIGINT PRIMARY KEY AUTO_INCREMENT,

    isbn VARCHAR(20) NOT NULL UNIQUE,

    book_name VARCHAR(200) NOT NULL,

    author VARCHAR(150) NOT NULL,

    category_id BIGINT NOT NULL,

    publisher VARCHAR(150),

    publication_year SMALLINT UNSIGNED NOT NULL,

    quantity INT UNSIGNED NOT NULL,

    available_quantity INT UNSIGNED NOT NULL,

    shelf_number VARCHAR(30) NOT NULL,

    status ENUM('ACTIVE', 'INACTIVE')
        NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_available_quantity
        CHECK (available_quantity <= quantity),

    CONSTRAINT chk_publication_year
        CHECK (publication_year BETWEEN 1000 AND 2100),

    CONSTRAINT fk_book_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);


-- ============================================================
-- 7. TRANSACTIONS TABLE
-- ============================================================

CREATE TABLE transactions (

    transaction_id BIGINT PRIMARY KEY AUTO_INCREMENT,

    book_id BIGINT NOT NULL,

    member_id BIGINT NOT NULL,

    issue_date DATE NOT NULL,

    due_date DATE NOT NULL,

    return_date DATE NULL,

    fine DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    status ENUM(
        'ISSUED',
        'RETURNED',
        'OVERDUE'
    ) NOT NULL DEFAULT 'ISSUED',

    CONSTRAINT chk_transaction_dates
        CHECK (
            return_date IS NULL
            OR return_date >= issue_date
        ),

    CONSTRAINT chk_transaction_fine
        CHECK (fine >= 0),

    CONSTRAINT fk_transaction_book
        FOREIGN KEY (book_id)
        REFERENCES books(book_id),

    CONSTRAINT fk_transaction_member
        FOREIGN KEY (member_id)
        REFERENCES member_details(member_id)
);


-- ============================================================
-- 8. INDEXES
-- ============================================================

CREATE INDEX idx_books_name
ON books(book_name);

CREATE INDEX idx_books_author
ON books(author);

CREATE INDEX idx_transactions_member_status
ON transactions(member_id, status);

CREATE INDEX idx_transactions_due_date
ON transactions(due_date);


-- ============================================================
-- 9. CATEGORIES
-- ============================================================

INSERT INTO categories (category_name)
VALUES
('Programming'),
('Database'),
('Networking'),
('Artificial Intelligence'),
('Machine Learning'),
('Mathematics'),
('Operating Systems'),
('Computer Science');


-- ============================================================
-- 10. ADMIN
-- ============================================================

INSERT INTO users
(
    name,
    email,
    password_hash,
    role,
    status
)
VALUES
(
    'Anshu',
    'anshu@admin',
    '$2a$12$IT/fsi.p7b0K975UhkOMPeapPAXLq8ei1DVVuCwcFRlu116eW4NEK',
    'ADMIN',
    'ACTIVE'
),
(
    'Krrish',
    'krrish@admin',
    '$2a$12$zvVQbFlUOhlgzwg3b.hnPu.gZnR5KKKDy6HF01LCxrkCHpV26.yKO',
    'ADMIN',
    'ACTIVE'
);


INSERT INTO admin_details
(
    user_id,
    employee_id
)
VALUES
(
    1,
    'ADM-001'
),
(
    2,
    'ADM-002'
);


-- ============================================================
-- 11. EXACTLY 111 MEMBERS
--
-- Using JSON_TABLE so exactly 111 names are inserted.
-- No accidental 88-member problem.
-- ============================================================

INSERT INTO users
(
    name,
    email,
    password_hash,
    role,
    status
)

SELECT

    student_name,

    CONCAT(
        LOWER(
            REPLACE(student_name, ' ', '.')
        ),
        '@gnu.ac.in'
    ),

    '$2a$12$v5SRP4gziJjDA5unlGysc.H6PmfW0Ku6DvgiDmQjK0mzQ0eMNaPdi',

    'MEMBER',

    'ACTIVE'

FROM JSON_TABLE(

'[
"Aarav Sharma",
"Aayush Kumar",
"Abhishek Verma",
"Adarsh Patel",
"Aditya Shah",
"Akash Mehta",
"Aman Gupta",
"Amit Sharma",
"Aniket Kumar",
"Anirudh Patel",
"Ankit Mehta",
"Ansh Shah",
"Anuj Verma",
"Arjun Patel",
"Aryan Mehta",
"Ashish Kumar",
"Ayush Sharma",
"Bhavik Patel",
"Bhavesh Shah",
"Bharat Mehta",
"Chirag Patel",
"Darshan Shah",
"Darshil Mehta",
"Dev Patel",
"Devansh Kumar",
"Dhruv Shah",
"Dhruvil Patel",
"Dikshant Mehta",
"Divyesh Shah",
"Eshan Patel",
"Harsh Kumar",
"Harshil Shah",
"Himanshu Patel",
"Hriday Mehta",
"Ishaan Shah",
"Jaimin Patel",
"Jatin Kumar",
"Jay Shah",
"Jeet Patel",
"Karan Mehta",
"Kartik Shah",
"Ketan Patel",
"Kishan Kumar",
"Krish Mehta",
"Krishiv Shah",
"Kunal Patel",
"Lakshya Kumar",
"Manan Shah",
"Manav Patel",
"Meet Mehta",
"Mihir Shah",
"Mohit Patel",
"Naitik Kumar",
"Naman Shah",
"Nayan Patel",
"Neel Mehta",
"Nikhil Shah",
"Nirav Patel",
"Om Kumar",
"Parth Mehta",
"Pranav Shah",
"Pratik Patel",
"Rahul Kumar",
"Raj Mehta",
"Rajat Shah",
"Rakesh Patel",
"Rohan Kumar",
"Ronak Mehta",
"Rudra Shah",
"Sachin Patel",
"Sahil Kumar",
"Samarth Shah",
"Sarthak Patel",
"Shivam Mehta",
"Shrey Shah",
"Siddharth Patel",
"Smit Kumar",
"Soham Mehta",
"Tanish Shah",
"Tanmay Patel",
"Tejas Kumar",
"Utsav Shah",
"Vaibhav Patel",
"Vedant Mehta",
"Vikas Kumar",
"Vivek Shah",
"Yash Patel",
"Yash Mehta",
"Yashvi Shah",
"Yuvraj Patel",
"Zaid Khan",
"Aarohi Patel",
"Aditi Shah",
"Ananya Mehta",
"Anjali Patel",
"Anushka Shah",
"Bhavya Mehta",
"Diya Patel",
"Isha Shah",
"Kavya Mehta",
"Khushi Patel",
"Krupa Shah",
"Muskan Mehta",
"Neha Patel",
"Nisha Shah",
"Pooja Mehta",
"Priya Patel",
"Riya Shah",
"Sakshi Mehta",
"Sneha Patel",
"Simran Shah"
]',

'$[*]'
COLUMNS
(
    student_name VARCHAR(120) PATH '$'
)

) AS names;


-- ============================================================
-- 12. EXACTLY 111 MEMBER DETAILS
--
-- First 56:
-- 25162201001 - 25162201056
--
-- Next 55:
-- 26162201001 - 26162201055
-- ============================================================

INSERT INTO member_details
(
    member_id,
    user_id,
    phone,
    course,
    department,
    semester,
    registration_date
)

SELECT

    CASE

        WHEN rn <= 56 THEN
            25162201000 + rn

        ELSE
            26162201000 + (rn - 56)

    END AS member_id,

    user_id,

    CONCAT(
        '9',
        LPAD(
            100000000 + rn,
            9,
            '0'
        )
    ) AS phone,

    CASE MOD(rn, 4)

        WHEN 0 THEN 'B.Tech'

        WHEN 1 THEN 'B.Tech'

        WHEN 2 THEN 'BCA'

        ELSE 'MCA'

    END AS course,

    CASE MOD(rn, 6)

        WHEN 0 THEN
            'Computer Science'

        WHEN 1 THEN
            'Artificial Intelligence and ML'

        WHEN 2 THEN
            'Information Technology'

        WHEN 3 THEN
            'Computer Engineering'

        WHEN 4 THEN
            'Data Science'

        ELSE
            'Electronics and Communication'

    END AS department,

    CASE MOD(rn, 4)

        WHEN 0 THEN 3

        WHEN 1 THEN 3

        WHEN 2 THEN 4

        ELSE 5

    END AS semester,

    DATE_ADD(
        '2026-07-01',
        INTERVAL MOD(rn, 60) DAY
    ) AS registration_date

FROM
(
    SELECT

        user_id,

        ROW_NUMBER() OVER (
            ORDER BY user_id
        ) AS rn

    FROM users

    WHERE role = 'MEMBER'

) AS member_list;


-- ============================================================
-- 13. EXACTLY 1317 BOOKS
-- ============================================================

INSERT INTO books
(
    isbn,
    book_name,
    author,
    category_id,
    publisher,
    publication_year,
    quantity,
    available_quantity,
    shelf_number,
    status
)

WITH RECURSIVE numbers AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1

    FROM numbers

    WHERE n < 1317
)

SELECT

    CONCAT(
        '978',
        LPAD(n, 10, '0')
    ) AS isbn,

    CONCAT(

        CASE MOD(n, 20)

            WHEN 0 THEN 'Advanced Java Programming'

            WHEN 1 THEN 'Python Programming'

            WHEN 2 THEN 'Data Structures and Algorithms'

            WHEN 3 THEN 'Database Management Systems'

            WHEN 4 THEN 'Computer Networks'

            WHEN 5 THEN 'Artificial Intelligence'

            WHEN 6 THEN 'Machine Learning Fundamentals'

            WHEN 7 THEN 'Deep Learning'

            WHEN 8 THEN 'Operating System Concepts'

            WHEN 9 THEN 'Computer Architecture'

            WHEN 10 THEN 'Software Engineering'

            WHEN 11 THEN 'Web Development'

            WHEN 12 THEN 'Cloud Computing'

            WHEN 13 THEN 'Cyber Security'

            WHEN 14 THEN 'Discrete Mathematics'

            WHEN 15 THEN 'Linear Algebra'

            WHEN 16 THEN 'Statistics for Computer Science'

            WHEN 17 THEN 'Object Oriented Programming'

            WHEN 18 THEN 'Computer Science Fundamentals'

            ELSE 'Algorithms and Problem Solving'

        END,

        ' - Volume ',

        n

    ) AS book_name,

    CASE MOD(n, 15)

        WHEN 0 THEN 'Joshua Bloch'

        WHEN 1 THEN 'Robert C. Martin'

        WHEN 2 THEN 'Thomas H. Cormen'

        WHEN 3 THEN 'Abraham Silberschatz'

        WHEN 4 THEN 'Andrew S. Tanenbaum'

        WHEN 5 THEN 'Ian Goodfellow'

        WHEN 6 THEN 'Aurelien Geron'

        WHEN 7 THEN 'Stuart Russell'

        WHEN 8 THEN 'Raj Kamal'

        WHEN 9 THEN 'James Kurose'

        WHEN 10 THEN 'Ramesh Bangia'

        WHEN 11 THEN 'Kenneth Rosen'

        WHEN 12 THEN 'Bjarne Stroustrup'

        WHEN 13 THEN 'Herbert Schildt'

        ELSE 'Seymour Lipschutz'

    END AS author,

    MOD(n - 1, 8) + 1 AS category_id,

    CASE MOD(n, 8)

        WHEN 0 THEN 'Pearson'

        WHEN 1 THEN 'McGraw Hill'

        WHEN 2 THEN 'OReilly'

        WHEN 3 THEN 'Wiley'

        WHEN 4 THEN 'MIT Press'

        WHEN 5 THEN 'Springer'

        WHEN 6 THEN 'Prentice Hall'

        ELSE 'Oxford Press'

    END AS publisher,

    2000 + MOD(n, 27) AS publication_year,

    3 + MOD(n, 3) AS quantity,

    3 + MOD(n, 3) AS available_quantity,

    CONCAT(

        CHAR(65 + MOD(n - 1, 8)),

        '-',

        LPAD(
            1 + FLOOR((n - 1) / 8),
            3,
            '0'
        )

    ) AS shelf_number,

    'ACTIVE'

FROM numbers;


-- ============================================================
-- 14. 100 CURRENT / OVERDUE TRANSACTIONS
-- ============================================================

INSERT INTO transactions
(
    book_id,
    member_id,
    issue_date,
    due_date,
    return_date,
    fine,
    status
)

WITH RECURSIVE numbers AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1

    FROM numbers

    WHERE n < 100
)

SELECT

    n AS book_id,

    CASE

        WHEN n <= 56 THEN
            25162201000 + n

        ELSE
            26162201000 + (n - 56)

    END AS member_id,

    DATE_SUB(
        '2026-10-04',
        INTERVAL MOD(n, 20) DAY
    ) AS issue_date,

    DATE_ADD(
        DATE_SUB(
            '2026-10-04',
            INTERVAL MOD(n, 20) DAY
        ),
        INTERVAL 14 DAY
    ) AS due_date,

    NULL AS return_date,

    CASE

        WHEN MOD(n, 7) = 0
        THEN 15.00

        ELSE 0.00

    END AS fine,

    CASE

        WHEN MOD(n, 7) = 0
        THEN 'OVERDUE'

        ELSE 'ISSUED'

    END AS status

FROM numbers;


-- ============================================================
-- 15. 344 RETURNED TRANSACTIONS
-- ============================================================

INSERT INTO transactions
(
    book_id,
    member_id,
    issue_date,
    due_date,
    return_date,
    fine,
    status
)

WITH RECURSIVE numbers AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1

    FROM numbers

    WHERE n < 344
)

SELECT

    101 + MOD(n - 1, 1216) AS book_id,

    CASE

        WHEN (MOD(n - 1, 111) + 1) <= 56 THEN

            25162201000
            + MOD(n - 1, 111)
            + 1

        ELSE

            26162201000
            + (
                MOD(n - 1, 111)
                + 1
                - 56
            )

    END AS member_id,

    DATE_SUB(
        '2026-09-01',
        INTERVAL MOD(n, 90) DAY
    ) AS issue_date,

    DATE_ADD(

        DATE_SUB(
            '2026-09-01',
            INTERVAL MOD(n, 90) DAY
        ),

        INTERVAL 14 DAY

    ) AS due_date,

    DATE_ADD(

        DATE_SUB(
            '2026-09-01',
            INTERVAL MOD(n, 90) DAY
        ),

        INTERVAL 12 + MOD(n, 8) DAY

    ) AS return_date,

    CASE

        WHEN MOD(n, 5) = 0
        THEN 15.00

        WHEN MOD(n, 11) = 0
        THEN 10.00

        ELSE 0.00

    END AS fine,

    'RETURNED' AS status

FROM numbers;


-- ============================================================
-- 16. FINAL COUNTS
-- ============================================================

SELECT
    'Categories' AS table_name,
    COUNT(*) AS total
FROM categories

UNION ALL

SELECT
    'Users',
    COUNT(*)
FROM users

UNION ALL

SELECT
    'Admin Details',
    COUNT(*)
FROM admin_details

UNION ALL

SELECT
    'Member Details',
    COUNT(*)
FROM member_details

UNION ALL

SELECT
    'Books',
    COUNT(*)
FROM books

UNION ALL

SELECT
    'Transactions',
    COUNT(*)
FROM transactions;


-- ============================================================
-- 17. USER ROLE COUNT
-- ============================================================

SELECT
    role,
    COUNT(*) AS total
FROM users
GROUP BY role;


-- ============================================================
-- 18. MEMBER ID RANGE CHECK
-- ============================================================

SELECT
    MIN(member_id) AS first_enrollment,
    MAX(member_id) AS last_enrollment,
    COUNT(*) AS total_members
FROM member_details;


-- ============================================================
-- 19. VERIFY 2516 SERIES
-- ============================================================

SELECT
    COUNT(*) AS members_2516
FROM member_details
WHERE member_id BETWEEN
    25162201001
    AND
    25162201056;


-- ============================================================
-- 20. VERIFY 2616 SERIES
-- ============================================================

SELECT
    COUNT(*) AS members_2616
FROM member_details
WHERE member_id BETWEEN
    26162201001
    AND
    26162201055;


-- ============================================================
-- 21. DISPLAY ALL MEMBERS
-- ============================================================

SELECT

    m.member_id AS enrollment_no,

    u.name,

    u.email,

    m.phone,

    m.course,

    m.department,

    m.semester,

    m.registration_date,

    u.status

FROM member_details m

JOIN users u
    ON m.user_id = u.user_id

ORDER BY m.member_id;


-- ============================================================
-- 22. BOOK COUNT
-- ============================================================

SELECT
    COUNT(*) AS total_books
FROM books;


-- ============================================================
-- 23. TRANSACTION COUNT
-- ============================================================

SELECT
    COUNT(*) AS total_transactions
FROM transactions;


-- ============================================================
-- 24. TRANSACTION STATUS
-- ============================================================

SELECT

    status,

    COUNT(*) AS total

FROM transactions

GROUP BY status;


-- ============================================================
-- 25. CATEGORY-WISE BOOK COUNT
-- ============================================================

SELECT

    c.category_id,

    c.category_name,

    COUNT(b.book_id) AS total_books

FROM categories c

LEFT JOIN books b
    ON c.category_id = b.category_id

GROUP BY
    c.category_id,
    c.category_name

ORDER BY
    c.category_id;


-- ============================================================
-- 26. MEMBER TRANSACTION REPORT
-- ============================================================

SELECT

    m.member_id AS enrollment_no,

    u.name AS member_name,

    u.email,

    COUNT(t.transaction_id)
        AS total_transactions

FROM member_details m

JOIN users u
    ON m.user_id = u.user_id

LEFT JOIN transactions t
    ON m.member_id = t.member_id

GROUP BY

    m.member_id,

    u.name,

    u.email

ORDER BY
    m.member_id;


-- ============================================================
-- 27. BOOK SAMPLE
-- ============================================================

SELECT

    b.book_id,

    b.isbn,

    b.book_name,

    b.author,

    c.category_name,

    b.publisher,

    b.publication_year,

    b.quantity,

    b.available_quantity,

    b.shelf_number

FROM books b

JOIN categories c
    ON b.category_id = c.category_id

ORDER BY b.book_id

LIMIT 20;


-- ============================================================
-- 28. TRANSACTION SAMPLE
-- ============================================================

SELECT

    t.transaction_id,

    t.book_id,

    b.book_name,

    t.member_id AS enrollment_no,

    u.name AS member_name,

    t.issue_date,

    t.due_date,

    t.return_date,

    t.fine,

    t.status

FROM transactions t

JOIN books b
    ON t.book_id = b.book_id

JOIN member_details m
    ON t.member_id = m.member_id

JOIN users u
    ON m.user_id = u.user_id

ORDER BY
    t.transaction_id

LIMIT 20;
