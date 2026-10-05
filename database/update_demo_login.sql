-- Run this once only if you already ran library.sql before the updated login was provided.
USE library_db;

UPDATE users
SET name = 'Anshu', email = 'anshu@admin', password_hash = '$2a$12$IT/fsi.p7b0K975UhkOMPeapPAXLq8ei1DVVuCwcFRlu116eW4NEK'
WHERE role = 'ADMIN' AND email = 'java@0333';

INSERT INTO users (name, email, password_hash, role, status)
SELECT 'Krrish', 'krrish@admin', '$2a$12$zvVQbFlUOhlgzwg3b.hnPu.gZnR5KKKDy6HF01LCxrkCHpV26.yKO', 'ADMIN', 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'krrish@admin');

INSERT INTO admin_details (user_id, employee_id)
SELECT u.user_id, 'ADM-002' FROM users u
WHERE u.email = 'krrish@admin' AND NOT EXISTS (SELECT 1 FROM admin_details a WHERE a.user_id = u.user_id);

-- Optional: make all old sample hashes directly compatible with jBCrypt 0.4.
UPDATE users
SET password_hash = CONCAT('$2a$', SUBSTRING(password_hash, 5))
WHERE password_hash LIKE '$2b$%';
