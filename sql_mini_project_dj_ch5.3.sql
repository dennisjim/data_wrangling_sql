/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

ANS Qry : SELECT name from `Facilities` WHERE `membercost`>0


/* Q2: How many facilities do not charge a fee to members? */

ANS Qry : SELECT COUNT(*) FROM Facilities WHERE `membercost`>0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */


ANS Qry : SELECT facid,name,membercost,monthlymaintenance FROM Facilities WHERE membercost<(10*monthlymaintenance)/100;


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */


ANS Qry : SELECT * FROM Facilities WHERE facid IN(1,5);



/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */


ANS Qry : SELECT name,`monthlymaintenance`,
          (CASE WHEN monthlymaintenance>100 THEN 'expensive' ELSE 'cheap' END) AS status
          FROM Facilities;


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */


ANS Qry : SELECT firstname,surname FROM Members WHERE joindate = (SELECT MAX(joindate) FROM Members);



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


ANS Qry : SELECT CONCAT(fc.`name`,' : ',`firstname`,' ',`surname`) AS booking_detail FROM `Bookings` bk JOIN `Members` mm ON mm.`memid`=bk.`memid` 
	  JOIN `Facilities` fc on fc.`facid`=bk.`facid` 
 	  WHERE fc.`name` LIKE 'Tennis Court%' GROUP BY bk.`facid`,bk.`memid` ORDER BY CONCAT(`firstname`,' ',`surname`);
 



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


ANS Qry : SELECT fc.`name` AS FacilityName,concat(mm.`firstname`,' ',mm.`surname`) AS UserName,
	  (case when bk.memid=0 then (fc.`guestcost`*bk.`slots`) else (fc.`membercost`*bk.`slots`) END) AS UsageCost 
          FROM `Bookings` bk join `Members` mm on mm.`memid`=bk.`memid` 
	  join `Facilities` fc on fc.`facid`=bk.`facid` 
	  WHERE DATE_FORMAT(bk.`starttime`, "%Y-%m-%d")=DATE('2012-09-14') 
	  HAVING UsageCost>30 
	  ORDER BY UsageCost DESC;


/* Q9: This time, produce the same result as in Q8, but using a subquery. */


ANS Qry : SELECT fc.`name` AS FacilityName,concat(mm.`firstname`,' ',mm.`surname`) AS UserName,
	  (SELECT (case when bk.memid=0 then fcc.`guestcost`*bk.`slots` ELSE fcc.`membercost`*bk.`slots` END)
	   FROM `Facilities` fcc WHERE fcc.`facid`=bk.`facid`) AS UsageCost 
          FROM `Bookings` bk join `Members` mm on mm.`memid`=bk.`memid` 
	  join `Facilities` fc on fc.`facid`=bk.`facid` 
	  WHERE DATE(bk.`starttime`)=DATE('2012-09-14') 
	  HAVING UsageCost>30 
	  ORDER BY UsageCost DESC;


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


ANS Qry :   SELECT fc.`name` AS FacilityName,
  	    ((SELECT fc.`guestcost`*SUM(bb.`slots`) FROM `Bookings` bb WHERE bb.`facid`=fc.facid AND bb.`memid`=0) + 
   	    (SELECT fc.`membercost`*SUM(bb2.`slots`) FROM `Bookings` bb2 WHERE bb2.`facid`=fc.facid AND bb2.`memid`!=0))
    	    AS TotalRevenue 
  	    FROM `Facilities` fc GROUP BY fc.`facid` HAVING TotalRevenue<1000 ORDER BY TotalRevenue DESC ;
  

