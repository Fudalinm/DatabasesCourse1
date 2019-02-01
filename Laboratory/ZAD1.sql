USE library

SELECT title, title_no from title

SELECT title, title_no from title WHERE title_no = 10
SELECT member_no, fine_assessed from loanhist WHERE title_no = 10 AND fine_assessed =< 9 AND fine_assesed >= 8
SELECT title_no, author from title where author in ('Charles Dickens' or 'Jane Austen')

SELECT title, title_no from title where title like '%adventures%'
SELECT member_no, fine_assessed, fine_paid, fine_waived from loanhist where ( ISNULL(fine_paid,0) + ISNULL(fine_waived,0) < ISNULL(fine_assessed,0 ))
--isnull szuka nulla i wstawia za niego jakas wartosc :)


SELECT DISTINCT st  te, city from adult
SELECT title FROM title ORDER BY title
SELECT member_no, isbn, fine_assessed,fine_assessed*2 as Double_fine FROM  loanhist where fine_assessed != 0
SELECT CONCAT (firstname, middleinitial, lastname) as email_name from member where lastname like 'Anderson'
SELECT CONCAT (LOWER(firstname), LOWER(middleinitial), substring(LOWER(lastname),1,2)) as lista_proponowanych_emaili from member where lastname like 'Anderson'

SELECT CONCAT('The title is: ',title,', title number ', title_no) from title


cast concat char


