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
