--cwiczenie UNION
--union po prostu zbiera 2 selcty i je scala

--Podaj listę członków biblioteki mieszkających w Arizonie (AZ)
--którzy mają  więcej niż dwoje dzieci zapisanych do biblioteki
--oraz takich którzy mieszkają w Kaliforni
--i mają więcej niż troje dzieci zapisanych do biblioteki

USE library

SELECT member.firstname, member.lastname, adult.state, count(member.member_no) as "liczba dzieci"
FROM member
INNER JOIN juvenile ON member.member_no = juvenile.adult_member_no
INNER JOIN adult ON member.member_no = adult.member_no AND adult.state = 'AZ'
GROUP BY member.member_no, member.firstname, member.lastname, adult.state
HAVING count(member.member_no) > 2
UNION
SELECT member.firstname, member.lastname, adult.state, count(member.member_no) as "liczba dzieci"
FROM member
INNER JOIN juvenile ON member.member_no = juvenile.adult_member_no
INNER JOIN adult ON member.member_no = adult.member_no AND adult.state = 'CA'
GROUP BY member.member_no, member.firstname, member.lastname, adult.state
HAVING count(member.member_no) > 3
ORDER BY member.lastname, member.firstname


