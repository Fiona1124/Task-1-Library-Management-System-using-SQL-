Project Title: Library Management System (using SQL)
Project Description:
Design and develop a Library Management System using SQL. The project should 
involve three tables: Books, Members, BorrowingRecords. The system will manage book 
inventories, member details, and borrowing transactions.
The project will include the following tasks:
Database Creation:
a) Create Books table with columns BOOK_ID, TITLE, AUTHOR, GENRE, 
YEAR_PUBLISHED, AVAILABLE_COPIES.
b) Create Members table with columns MEMBER_ID, NAME, EMAIL, PHONE_NO, 
ADDRESS, MEMBERSHIP_DATE.
c) Create BorrowingRecords table with columns BORROW_ID, MEMBER_ID, 
BOOK_ID, BORROW_DATE, RETURN_DATE. Set foreign key constraints linking 
MEMBER_ID to Members and BOOK_ID to Books.
Data Creation:
Insert sample data into all three tables.
Information Retrieval:
a) Retrieve a list of books currently borrowed by a specific member.
b) Find members who have overdue books (borrowed more than 30 days ago, not 
returned).
c) Retrieve books by genre along with the count of available copies.
d) Find the most borrowed book(s) overall.
e) Retrieve members who have borrowed books from at least three different genres.
Reporting and Analytics:
a) Calculate the total number of books borrowed per month.
b) Find the top three most active members based on the number of books 
borrowed.
c) Retrieve authors whose books have been borrowed at least 10 times.
d) Identify members who have never borrowed a book.
