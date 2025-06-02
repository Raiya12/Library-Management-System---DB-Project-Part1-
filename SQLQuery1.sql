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
