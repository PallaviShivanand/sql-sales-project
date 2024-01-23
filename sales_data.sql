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

