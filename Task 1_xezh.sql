create database Library_Management_System;
use Library_Management_System;
create table Books(Book_ID int primary key, TITLE varchar(100), AUTHOR varchar(100), GENRE varchar(100), YEAR_PUBLISHED INT, AVAILABLE_COPIES INT);
create  table Members(MEMBER_ID int primary key, NAME varchar(100), EMAIL varchar(100), PHONE_NO varchar(100), ADDRESS varchar(100), MEMBERSHIP_DATE date);
create table BorrowingRecords(BORROW_ID INT, MEMBER_ID INT, BOOK_ID INT, BORROW_DATE DATE, RETURN_DATE DATE, primary key(BORROW_ID), foreign key(MEMBER_ID) references Members(MEMBER_ID), foreign key(BOOK_ID) references Books(BOOK_ID));
insert into Books(Book_ID, TITLE, AUTHOR, GENRE, YEAR_PUBLISHED, AVAILABLE_COPIES) values(1, "Gone with the wind", "Margaret Mitchell", "classic", 1936, 4),(2,"To kill a Mockingbird","Harper Lee","classic",1960,2),(3,"1984","George Orwell","Dystopian",1949,4),(4,"The Greate Gatsby","F.Scott Fitzgerald","classic",1925,3),(5,"The Hobbit", "J.R.R. Tolkien", "Fantasy",1937,5),(6,"Pride and Prejudice","Jane Austen","classic","1813",4);
insert into Members(MEMBER_ID, NAME, EMAIL, PHONE_NO, ADDRESS, MEMBERSHIP_DATE) values(1,"Alice","10100@example.com","123456","123 street","2024-01-15"),(2,"Bob","12345@example.com","342342","Oak Avenue","2024-02-20"),(3,"Brown","Brown@example.com","232434","999 road","2024-03-10"),(4,"Lily","Lily@example.com","203802","YY street","2014-03-25"),(5,'Emma','emma@example.com','555-9999','Park Lane','2025-08-01');
insert into BorrowingRecords(BORROW_ID,MEMBER_ID,BOOK_ID,BORROW_DATE,RETURN_DATE) values(1,1,2,"2025-07-01",NULL),(2,1,2,"2025-06-15","2015-07-15"),(3,2,3,"2025-06-01",NULL),(4,3,4,"2025-05-10",NULL),(5,3,5,"2025-07-20",NULL),(6,4,2,"2025-05-01","2025-05-20"),(7,1,6,"2025-08-01",NULL),(8,3,3,"2019-09-20","2020-01-02"),(9,2,2,'2025-08-02',NULL),(10,3,2,'2025-08-03',NULL),(11,4,2,'2025-08-04',NULL),(12,1,2,'2025-08-05',NULL),(13,2,2,'2025-08-06',NULL),(14,3,2,'2025-08-07',NULL),(15,4,2,'2025-08-08',NULL);
select * from Books;
select* from Members;
select* from BorrowingRecords;
# Information Retrieval
# a) Retrieve a list of books currently borrowed by a specific member.
select B.TITLE,B.Book_ID, BR.MEMBER_ID from BorrowingRecords BR join Books B on BR.BOOK_ID=B.BOOK_ID
where BR.MEMBER_ID=2 AND BR.RETURN_DATE IS NULL;
# b) Find members who have overdue books (borrowed more than 30 days ago, not returned).
select M.MEMBER_ID,M.name from Members M left join BorrowingRecords BR on M.MEMBER_ID=BR.MEMBER_ID
where BR.BORROW_DATE<CURDATE()-INTERVAL 30 DAY AND BR.RETURN_DATE IS NULL;
# c) Retrieve books by genre along with the count of available copies.
select GENRE,COUNT(*) AS book_count,SUM(AVAILABLE_COPIES)AS Borrow_Availabe from Books group by GENRE;
# d) Find the most borrowed book(s) overall
select Books.TITLE, BR.BOOK_ID,count(BR.BOOK_ID) as Borrow_COUNT
from Books left join BorrowingRecords BR on Books.BOOK_ID=BR.BOOK_ID
Group by Books.TITLE, BR.BOOK_ID
Order by Borrow_COUNT DESC
LIMIT 1;
# CTE
with BorrowCounts as(
select BR.BOOK_ID, COUNT(*) AS Borrow_COUNT
FROM BorrowingRecords BR
Group by BR.BOOK_ID)
select B.TITLE, BC.BOOK_ID, BC.Borrow_COUNT
from BorrowCounts BC left join Books B on BC.BOOK_ID=B.BOOK_ID
where BC.Borrow_COUNT=(select MAX(Borrow_COUNT) FROM BorrowCounts);
#e) Retrieve members who have borrowed books from at least three different genres.
select M.MEMBER_ID,M.NAME
from BorrowingRecords BR left join Books B on BR.BOOK_ID=B.BOOK_ID
left join Members M on BR.MEMBER_ID=M.MEMBER_ID
group by M.MEMBER_ID,M.NAME
having count(distinct B.GENRE)>=3;
#CTE
WITH MemberGenreRank AS(
select BR.MEMBER_ID,B.GENRE,DENSE_RANK() over (partition by BR.MEMBER_ID order by B.GENRE) as genre_rank
from BorrowingRecords BR left join Books B on BR.BOOK_ID=B.BOOK_ID)
select M.MEMBER_ID,M.NAME
from Members M left join MemberGenreRank MG on M.MEMBER_ID=MG.MEMBER_ID
group by M.MEMBER_ID,M.NAME
having MAX(MG.genre_rank)>=3;
# Reporting and Analytics:
# a) Calculate the total number of books borrowed per month.
select MONTH(BR.BORROW_DATE) AS month,COUNT(*) AS total_sum
from books B left join BorrowingRecords BR on B.BOOK_ID=BR.BOOK_ID
where BR.BORROW_DATE IS NOT NULL
group by MONTH(BR.BORROW_DATE)
order by month;
# b) Find the top three most active members based on the nmuber of books borrowed.
select M.NAME,COUNT(BR.BOOK_ID) as total_borrow
from BorrowingRecords BR left join Members M on BR.MEMBER_ID=M.MEMBER_ID
group by BR.MEMBER_ID
HAVING COUNT(BR.BOOK_ID)
ORDER BY COUNT(BR.BOOK_ID) desc
LIMIT 3;
#CTE display members with the same rank
with MemberBorrowCount as(
select BR.MEMBER_ID, COUNT(*) as borrow_count
from BorrowingRecords BR
group by BR.MEMBER_ID
),
RankedMembers as(
select MEMBER_ID, borrow_count,dense_rank()over(order by borrow_count desc) as rnk 
from MemberBorrowCount
)
select M.MEMBER_ID, M.NAME,R.borrow_count
from RankedMembers R left join Members M on R.MEMBER_ID=M.MEMBER_ID
where R.rnk<=3
order by R.borrow_count DESC;
# c) Retrieve authors whose books have been borrowed at least 10 times.
WITH AuthorBorrowCount AS(
SELECT b.AUTHOR,count(br.BORROW_ID) as total_borrows
from Books b join BorrowingRecords br
on b.BOOK_ID=br.BOOK_ID
group by b.AUTHOR)
select AUTHOR,total_borrows
from AuthorBorrowCount
where total_borrows>=10
group by AUTHOR,total_borrows;
# d) Identify members who have never borrowed a book
select M.NAME, BR.BORROW_DATE
from Members M left join BorrowingRecords BR on M.MEMBER_ID=BR.MEMBER_ID
where BR.BORROW_DATE IS NULL
group by M.NAME, BR.BORROW_DATE;


