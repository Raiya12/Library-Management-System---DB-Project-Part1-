use [ Library Management System]

-- 1. Library
CREATE TABLE Library (
    LibraryID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(150) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    EstablishedYear INT CHECK (EstablishedYear > 1800)
);

-- 2. Member
CREATE TABLE Member (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20) NOT NULL,
    MembershipStartDate DATE NOT NULL
);

-- 3. Book
CREATE TABLE Book (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN VARCHAR(20) NOT NULL UNIQUE,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(50) NOT NULL CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    AvailabilityStatus BIT DEFAULT 1,
    ShelfLocation VARCHAR(50),
    LibraryID INT NOT NULL,
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
);

-- 4. Staff
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    LibraryID INT NOT NULL,
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
);

-- 5. Loan
CREATE TABLE Loan (
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status VARCHAR(20) NOT NULL DEFAULT 'Issued'
        CHECK (Status IN ('Issued', 'Returned', 'Overdue')),
    PRIMARY KEY (MemberID, BookID, LoanDate),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

-- 6. Payment
CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    Method VARCHAR(20) NOT NULL,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE NOT NULL,
    FOREIGN KEY (MemberID, BookID, LoanDate)
        REFERENCES Loan(MemberID, BookID, LoanDate)
);

-- 7. Review
CREATE TABLE Review (
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    ReviewDate DATE NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT DEFAULT 'No comments',
    PRIMARY KEY (MemberID, BookID, ReviewDate),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);
--=========================================================================================================================================================================
--------------------------------------------------------------------------DB Project Part 1 ------------------------------------------------------------------------------
--=========================================================================================================================================================================

--------------------------------------------------------Insert real-world data

INSERT INTO Library (Name, Location, ContactNumber, EstablishedYear) VALUES
('Central City Library', '123 Main St', '555-1234', 1950),
('Westside Branch', '45 West St', '555-5678', 1985),
('University Library', '77 College Rd', '555-9876', 2000);

INSERT INTO Member (FullName, Email, PhoneNumber, MembershipStartDate) VALUES
('Alice Johnson', 'alice.j@example.com', '555-0001', '2023-01-15'),
('Bob Smith', 'bob.smith@example.com', '555-0002', '2022-11-01'),
('Clara Reyes', 'clara.reyes@example.com', '555-0003', '2024-03-21'),
('David Lee', 'david.lee@example.com', '555-0004', '2023-09-08'),
('Emma Stone', 'emma.stone@example.com', '555-0005', '2024-01-10'),
('Frank Ng', 'frank.ng@example.com', '555-0006', '2023-07-12');

INSERT INTO Book (ISBN, Title, Genre, Price, ShelfLocation, LibraryID) VALUES
('978-0451524935', '1984', 'Fiction', 10.99, 'A1', 1),
('978-0140449136', 'The Odyssey', 'Fiction', 12.50, 'A2', 1),
('978-0062316097', 'Sapiens', 'Non-fiction', 15.00, 'B1', 2),
('978-0199535569', 'Pride and Prejudice', 'Fiction', 9.99, 'A3', 1),
('978-0385472579', 'Zen and the Art of Motorcycle Maintenance', 'Non-fiction', 13.49, 'B2', 2),
('978-0545010221', 'Harry Potter and the Deathly Hallows', 'Children', 18.00, 'C1', 3),
('978-0590353427', 'Harry Potter and the Sorcerer''s Stone', 'Children', 16.00, 'C2', 3),
('978-0131103627', 'The C Programming Language', 'Reference', 45.00, 'D1', 3),
('978-0201633610', 'Design Patterns', 'Reference', 49.99, 'D2', 3),
('978-0262033848', 'Introduction to Algorithms', 'Reference', 55.00, 'D3', 3);

INSERT INTO Staff (FullName, Position, ContactNumber, LibraryID) VALUES
('Grace Kim', 'Librarian', '555-2001', 1),
('Henry Ford', 'Assistant Librarian', '555-2002', 1),
('Irene Wells', 'Manager', '555-2003', 2),
('James Bond', 'Technician', '555-2004', 3);

INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, ReturnDate, Status) VALUES
(1, 1, '2024-05-01', '2024-05-15', '2024-05-14', 'Returned'),
(2, 2, '2024-05-10', '2024-05-24', NULL, 'Issued'),
(3, 3, '2024-05-11', '2024-05-25', NULL, 'Overdue'),
(4, 4, '2024-05-09', '2024-05-23', '2024-05-21', 'Returned'),
(5, 5, '2024-05-08', '2024-05-22', NULL, 'Issued'),
(6, 6, '2024-05-12', '2024-05-26', NULL, 'Issued'),
(1, 7, '2024-05-13', '2024-05-27', NULL, 'Issued'),
(2, 8, '2024-05-14', '2024-05-28', NULL, 'Issued'),
(3, 9, '2024-05-15', '2024-05-29', NULL, 'Issued'),
(4, 10, '2024-05-16', '2024-05-30', NULL, 'Issued');

INSERT INTO Payment (PaymentDate, Amount, Method, MemberID, BookID, LoanDate) VALUES
('2024-05-20', 2.50, 'Cash', 3, 3, '2024-05-11'),
('2024-05-22', 1.75, 'Card', 4, 4, '2024-05-09'),
('2024-05-25', 3.00, 'Cash', 1, 1, '2024-05-01'),
('2024-05-26', 4.00, 'Card', 5, 5, '2024-05-08');

INSERT INTO Review (MemberID, BookID, ReviewDate, Rating, Comments) VALUES
(1, 1, '2024-05-15', 5, 'Amazing read!'),
(2, 2, '2024-05-16', 4, 'Classic story.'),
(3, 3, '2024-05-17', 5, 'Very insightful.'),
(4, 4, '2024-05-18', 3, 'Not bad.'),
(5, 5, '2024-05-19', 4, 'Great philosophy.'),
(6, 6, '2024-05-20', 5, 'Loved every chapter!');


------------------------------------------------------------------DML to simulate real application behavior
----Mark books as returned
UPDATE Loan SET ReturnDate = '2024-05-28', Status = 'Returned'WHERE MemberID = 2 AND BookID = 2 AND LoanDate = '2024-05-10';

----Delete a review
DELETE FROM Review WHERE MemberID = 5 AND BookID = 5 AND ReviewDate = '2024-05-19';

--Delete a payment
DELETE FROM Payment WHERE PaymentID = 2;

--Update loan status to overdue
UPDATE Loan SET Status = 'Overdue' WHERE MemberID = 6 AND BookID = 6 AND LoanDate = '2024-05-12';


------------------------------------------------------------------Error-Based Learning (Live Testing Phase)


DELETE FROM Member WHERE MemberID = 1;
--Resolve: Delete the loans first or enable ON DELETE CASCADE.

DELETE FROM Member WHERE MemberID = 3;
--RESOLUTION: Delete reviews first or cascade delete.

DELETE FROM Book WHERE BookID = 6;
--RESOLUTION: Delete or return the loaned book first.

DELETE FROM Book WHERE BookID = 1;
--RESOLUTION: Delete reviews before deleting the book.

INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, Status)
VALUES (999, 1, '2024-06-01', '2024-06-10', 'Issued');
--RESOLUTION: Insert only for existing members.

INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, Status)
VALUES (1, 999, '2024-06-01', '2024-06-10', 'Issued');
--RESOLUTION: Use valid BookID from the database.

UPDATE Book SET Genre = 'Sci-Fi' WHERE BookID = 1;
--RESOLUTION: Allowed values: 'Fiction', 'Non-fiction', 'Reference', 'Children'.

INSERT INTO Payment (PaymentDate, Amount, Method, MemberID, BookID, LoanDate)
VALUES ('2024-06-01', -5.00, 'Cash', 1, 1, '2024-05-01');
--RESOLUTION: Ensure payment amounts are positive.

INSERT INTO Payment (PaymentDate, Amount, MemberID, BookID, LoanDate)
VALUES ('2024-06-01', 2.50, 1, 1, '2024-05-01');
--RESOLUTION: Supply a valid non-null payment method.

INSERT INTO Review (MemberID, BookID, ReviewDate, Rating)
VALUES (1, 999, '2024-06-01', 5);
--RESOLUTION: Book must exist before reviewing.

INSERT INTO Review (MemberID, BookID, ReviewDate, Rating)
VALUES (999, 1, '2024-06-01', 4);
--RESOLUTION: Register the member first.

UPDATE Loan SET MemberID = 999 WHERE BookID = 1 AND LoanDate = '2024-05-01';
--RESOLUTION: Only assign to existing members.

--=========================================================================================================================================================================
--------------------------------------------------------------------------DB Project Part 2 ------------------------------------------------------------------------------
--=========================================================================================================================================================================

--1. GET /books/popular — Top 3 books by number of times loaned
SELECT b.BookID, b.Title, COUNT(l.LoanDate) AS LoanCount
FROM Book b
LEFT JOIN Loan l ON b.BookID = l.BookID
GROUP BY b.BookID, b.Title
ORDER BY LoanCount DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

--2. GET /members/:id/history — Full loan history of a member
SELECT b.Title, l.LoanDate, l.ReturnDate
FROM Loan l
JOIN Book b ON l.BookID = b.BookID
WHERE l.MemberID = 1  
ORDER BY l.LoanDate DESC;

--3. GET /books/:id/reviews — All reviews for a book with member name and comments
SELECT m.FullName, r.Rating, r.Comments, r.ReviewDate
FROM Review r
JOIN Member m ON r.MemberID = m.MemberID
WHERE r.BookID = 1 
ORDER BY r.ReviewDate DESC;

--4. GET /libraries/:id/staff — List all staff for a librar
DECLARE @LibraryID INT = 1;  
SELECT StaffID, FullName, Position, ContactNumber
FROM Staff
WHERE LibraryID = @LibraryID;

--5. Show books within a price range
DECLARE @MinPrice DECIMAL(10,2) = 5.00;
DECLARE @MaxPrice DECIMAL(10,2) = 15.00;

SELECT BookID, Title, Price
FROM Book
WHERE Price BETWEEN @MinPrice AND @MaxPrice;

--6. List all currently active loans (not returned)
SELECT l.MemberID, m.FullName, l.BookID, b.Title, l.LoanDate, l.DueDate
FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b ON l.BookID = b.BookID
WHERE l.Status = 'Issued';

--7. Members who have paid any fine
SELECT DISTINCT m.MemberID, m.FullName
FROM Member m
JOIN Payment p ON m.MemberID = p.MemberID;

--8. Books never reviewed
SELECT b.BookID, b.Title
FROM Book b
LEFT JOIN Review r ON b.BookID = r.BookID
WHERE r.BookID IS NULL;

--9. Member’s loan history with book titles and status
DECLARE @MemberID INT = 1;  -- Set desired MemberID here

SELECT b.Title, l.LoanDate, l.ReturnDate, l.Status
FROM Loan l
JOIN Book b ON l.BookID = b.BookID
WHERE l.MemberID = @MemberID
ORDER BY l.LoanDate DESC;

--10. Members who have never borrowed any book
SELECT m.MemberID, m.FullName
FROM Member m
LEFT JOIN Loan l ON m.MemberID = l.MemberID
WHERE l.MemberID IS NULL;

--11. Books that were never loaned
SELECT b.BookID, b.Title
FROM Book b
LEFT JOIN Loan l ON b.BookID = l.BookID
WHERE l.BookID IS NULL;

--12. List all payments with member name and book title
SELECT p.PaymentID, m.FullName, b.Title, p.PaymentDate, p.Amount, p.Method
FROM Payment p
JOIN Member m ON p.MemberID = m.MemberID
JOIN Book b ON p.BookID = b.BookID
ORDER BY p.PaymentDate DESC;

--13. List all overdue loans with member and book details
SELECT l.MemberID, m.FullName, l.BookID, b.Title, l.LoanDate, l.DueDate
FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b ON l.BookID = b.BookID
WHERE l.Status = 'Overdue';

--14. Number of times a book was loaned
DECLARE @BookID INT = 1;  

SELECT b.BookID, b.Title, COUNT(l.LoanDate) AS LoanCount
FROM Book b
LEFT JOIN Loan l ON b.BookID = l.BookID
WHERE b.BookID = @BookID
GROUP BY b.BookID, b.Title;

--15. Total fines paid by a member
DECLARE @MemberID INT = 1;

SELECT m.MemberID, m.FullName, COALESCE(SUM(p.Amount), 0) AS TotalFinesPaid
FROM Member m
LEFT JOIN Payment p ON m.MemberID = p.MemberID
WHERE m.MemberID = @MemberID
GROUP BY m.MemberID, m.FullName;

--16. Count available and unavailable books in a library
DECLARE @LibraryID INT = 1;  -- Set desired LibraryID here

SELECT 
  SUM(CASE WHEN AvailabilityStatus = 1 THEN 1 ELSE 0 END) AS AvailableBooks,
  SUM(CASE WHEN AvailabilityStatus = 0 THEN 1 ELSE 0 END) AS UnavailableBooks
FROM Book
WHERE LibraryID = @LibraryID;

--17. Books with more than 5 reviews and average rating > 4.5
SELECT b.BookID, b.Title, COUNT(r.ReviewDate) AS ReviewCount, AVG(r.Rating) AS AvgRating
FROM Book b
JOIN Review r ON b.BookID = r.BookID
GROUP BY b.BookID, b.Title
HAVING COUNT(r.ReviewDate) > 5 AND AVG(r.Rating) > 4.5;

---------------------------------Simple Views Practice
--1. ViewAvailableBooks
CREATE VIEW ViewAvailableBooks AS
SELECT BookID, Title, Genre, Price, ShelfLocation, LibraryID
FROM Book
WHERE AvailabilityStatus = 1;

SELECT * FROM ViewAvailableBooks;

--2. ViewActiveMembers
CREATE VIEW ViewActiveMembers AS
SELECT MemberID, FullName, Email, PhoneNumber, MembershipStartDate
FROM Member
WHERE MembershipStartDate >= DATEADD(year, -1, GETDATE());

SELECT * FROM ViewActiveMembers;

--3. ViewLibraryContacts
CREATE VIEW ViewLibraryContacts AS
SELECT LibraryID, Name, ContactNumber
FROM Library;

SELECT * FROM ViewLibraryContacts;

