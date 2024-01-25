use salesdata;

delimiter $
CREATE PROCEDURE getallcustomers()
BEGIN
SELECT * FROM customers;
END $

CALL getallcustomers();

delimiter //
CREATE PROCEDURE getallproductnorder()
BEGIN
SELECT * FROM products;
SELECT * FROM orders;
END //

CALL getallproductnorder();

delimiter $
CREATE PROCEDURE getemployee(empid DECIMAL(10))
BEGIN
SELECT * FROM employees
WHERE employeenumber = empid;
END $

CALL getemployee(1088);

/* Create a stored procedure that displays the employee
names if we provide the city in which the office of the employee is located*/

delimiter $
CREATE PROCEDURE getempbycity(empcity VARCHAR(20))
BEGIN
SELECT firstname, lastname
FROM employees JOIN offices
USING(officecode)
WHERE city= empcity;
END;

call getempbycity('london');

/* Create a procedure that displays the average of the buy price based
on the product line provided by us*/

select * from products;

delimiter $
CREATE PROCEDURE getavgbuyprice(prodline varchar(50))
BEGIN
SELECT avg(buyprice)
FROM products
WHERE productline = prodline
GROUP BY productline;
END;

call getavgbuyprice('planes');

delimiter $
CREATE PROCEDURE sample()
BEGIN
DECLARE a int;
SELECT a;
end;

call sample();

drop procedure sample;

delimiter $
CREATE PROCEDURE sample()
BEGIN
DECLARE a int DEFAULT 1;
SELECT a;
end;

call sample();

delimiter $
CREATE PROCEDURE sample1()
BEGIN
DECLARE a int DEFAULT 1;
SELECT a;
set a=10;
SELECT a;
end;

call sample1();

delimiter $
CREATE PROCEDURE getcredit(custid DECIMAL(10))
BEGIN
DECLARE creditlim decimal(10,2) DEFAULT 0.0;
SELECT creditlimit
INTO creditlim
FROM customers
where customernumber = custid;
SELECT creditlim;
end;

call getcredit(112);

/* Create a stored procedure to take two numbers as the input and return the result of
their sum*/
delimiter $
CREATE PROCEDURE getsum(in a int, in b int, out sum int)
BEGIN
	SET sum= a+b;
end;

call getsum(12,78,@result);
select @result;

/* Create a stored procedure to take two numbers as the input and return the result of
their sum and product*/
delimiter $
CREATE PROCEDURE getsumnprod(in a int, in b int, out sum int, out prod int)
BEGIN
	SET sum= a+b;
    SET prod = a*b;
end;

call getsumnprod(12,78,@result1,@result2);
select @result1, @result2;

delimiter  $
CREATE PROCEDURE ifelsedemo(num int)
BEGIN
	IF num>0 then
		SELECT "positive";
	ELSEIF num<0 then
		SELECT "negative";
	ELSE
		SELECT "zero";
	END IF;
END;
    
call ifelsedemo(9);

-- delimiter
-- create 

/* while loop */

delimiter $
create procedure loopexample11()
begin
	declare ij int default 1;
    declare str varchar(100);
		set str = ''; /*string is empty initially*/
	while ij<=10 do
		set str=concat(str,ij,' ');
        set ij=ij+1;
	end while;
    select str;
end $
    
    call loopexample11();
    
delimiter $
create procedure loopexample1(lastvalue int)
begin
	declare i int default 1;
    declare str varchar(100);
		set str = ''; /*string is empty initially*/
	while i<=lastvalue do    /*pre-test*/
		set str=concat(str,i,' ');
        set i=i+1;
	end while;
    select str;
end $
    
    call loopexample1(30);
    
    /*repeat until loop*/
delimiter $
create procedure loopexample2(lastvalue int)
begin
	declare i int default 1;
    declare str varchar(100);
		set str = ''; /*string is empty initially*/
	repeat
		set str=concat(str,i,' ');
        set i=i+1;
	until i>lastvalue  /*post-test*/
	end repeat;
    select str;
end $
    
call loopexample2(30);

/*Write a stored procedure to fill the employee_name table with the data from the 
employees table.  The name should be concantenated and then saved in the employees_name table*/

CREATE TABLE employees_name(
		empid int,
        empname varchar(50));
        
desc employees_name;

delimiter $
create procedure employee_name_cursor()
begin
/* declare the variable as the column values will be fetched in them by the fetch command*/
	declare done boolean default false;
	declare empid int;
    declare fname varchar(20);
    declare lname varchar(20);
    
/* declare the cursor, make sure that the select query only contain the columns which we need*/
declare cur cursor for
	select employeenumber, firstname, lastname
    from employees;

/*declare the exception that is raised when there are no more rows to be fetched*/
declare continue handler for not found set done=true;
    
/*open the cursor, get the table from the database into cursor memory*/
open cur;

/*fetch the rows and put the values of each row in the variable*/
while not done do
	fetch cur into empid, fname, lname; #first row
	insert into employees_name values(empid, concat(fname,' ' , lname));
end while;

/*close the cursor once the task is completed*/
close cur;
end;

call employee_name_cursor();

drop procedure employee_name_cursor;

select * from employees_name;
