-- Create a new database
CREATE DATABASE IF NOT EXISTS nodejs_sql;
USE nodejs_sql;

-- Create user table with age validation trigger
CREATE TABLE IF NOT EXISTS user (
    name VARCHAR(50),
    age INT
);

-- Insert a sample user
INSERT INTO user (name, age) 
VALUES ('archit', 19);

-- Select all users
SELECT * FROM user;

-- Create trigger for age validation (ensure age is at least 18)
DELIMITER $$

CREATE TRIGGER hello
    BEFORE INSERT ON user
    FOR EACH ROW
    BEGIN
        IF NEW.age < 18 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Age must be 18 or older';
        END IF;
    END $$

DELIMITER ;

-- Create node table to store email and created date
CREATE TABLE IF NOT EXISTS node (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into the node table
INSERT INTO node (email) 
VALUES ('archit@gmail.com');

-- Select all data from node table
SELECT * FROM node;


-- 1. Fetch the earliest record based on created_At with formatted date
SELECT DATE_FORMAT(created_At, "%M %D %Y") AS earliest_date 
FROM node 
ORDER BY created_At ASC 
LIMIT 1;

-- 2. Select the email and created date of the earliest record
SELECT email, created_At 
FROM node 
ORDER BY created_At ASC 
LIMIT 1;

-- 3. Fetch the earliest created_at using subquery for comparison
SELECT * 
FROM node
WHERE created_At = (SELECT MIN(created_At) FROM node);

-- 4. Count the number of users by month, ordered by most frequent month
SELECT DISTINCT DATE_FORMAT(created_at, '%M') AS month, 
                COUNT(*) AS count 
FROM node 
GROUP BY month 
ORDER BY count DESC;

-- 5. Extract email providers from the domain and count occurrences
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(email, '@', -1), '.', 1) AS provider, 
       COUNT(*) AS total_user 
FROM node 
GROUP BY provider;

-- 6. Case-based grouping by email providers and counting users
SELECT CASE 
           WHEN email LIKE '%@gmail.com' THEN 'gmail' 
           WHEN email LIKE '%@yahoo.com' THEN 'yahoo' 
           WHEN email LIKE '%@hotmail.com' THEN 'hotmail' 
           ELSE 'other' 
       END AS provider, 
       COUNT(*) AS total_users 
FROM node 
GROUP BY provider 
ORDER BY total_users DESC;

