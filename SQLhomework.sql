use classicmodels

Single entity
----------------
##1.1
select officeCode
from offices
order by country, state,city

##1.2
select count(employeeNumber) as num
from employees

##1.3
select sum(amount) as total
from payments

##1.4
select productline
from products
where productline like '%Cars%'

##1.5
select *
from payments
where paymentDate='2004-10-28'

##1.6
select *
from payments
where amount >100000

##1.7
select productname, productline
from products
order by productline

##1.8
select count(productCode) num, productline
from products
group by productline

##1.9
select min(amount)
from payments

##1.10
select * 
from Payments 
where amount > (select avg(amount)*2 from Payments)

##1.11
select avg((MSRP-Buyprice)/MSRP)
from products

##1.12
select count(productCode)
from products

##1.13
select customerName, city
from customers
where salesRepEmployeeNumber is null

##1.14
select concat(lastname, ' ' ,firstname) as name
from employees
where jobTitle not in ('Sales Rep', 'President')

##1.15
select *
from orderdetails
where quantityordered*priceEach>5000


One to many relationship
-----------------------------
##2.1
SELECT c.customerName, e.firstName, e.lastName
FROM customers c join employees e 
on c.salesRepEmployeeNumber=e.employeeNumber

##2.2
select sum(amount) as total
from payments p
join customers c
on p.customerNumber = c.customerNumber
where customerName = "Atelier graphique"

##2.3
select sum(amount) as total
from Payments
group by paymentDate

##2.4
select * 
from Products
where productCode 
not in (select od.productCode from orders o
join orderdetails od
on o.ordernumber = od.ordernumber)

##2.5
select c.customerName,sum(p.amount) 
from customers c join payments p
on c.customerNumber = p.customerNumber
group by c.customerName

##2.6
select count(*) 
from customers c join orders o
on c.customerNumber = o.customerNumber
where customerName = "Herkku Gifts"

##2.7
select * 
from employees e join offices o
on e.officeCode = o.officeCode
where o.city = "Boston"

##2.8
select c.customerName, sum(p.amount) 
from payments join customers c
on p.customerNumber = c.customerNumber
group by p.customerNumber
having sum(p.amount) > 100000
order by sum(p.amount) desc

##2.9
select sum(quantityOrdered*priceEach) as value 
from orders o join orderdetails od
on o.orderNumber = od.orderNumber
where status = "On Hold"

##2.10
select count(*) as num, c.customerName
from customers c join orders o
on c.customerNumber=o.customerNumber
where status = "On Hold"
group by c.customerNumber


Many to many relationship
-----------------------------
##3.1
select p.productName, o.orderDate 
from products p
join orderdetails od on od.productCode = p.productCode
join orders o on od.orderNumber = o.orderNumber
order by o.orderDate

##3.2
select * 
from products p
join orderdetails od on od.productCode = p.productCode
join orders o on od.orderNumber = o.orderNumber
where p.productName = "1940 Ford Pickup Truck"

##3.3
select c.customerName, o.orderNumber
from customers c join orders o
on c.customerNumber=o.customerNumber
join payments p
on p.customerNumber = c.customerNumber
where p.amount>25000

##3.4
select *
from products 
where productCode in (select od.productCode                        
					from orders o join orderdetails od 
					on od.orderNumber = o.orderNumber)

##3.5
select * 
from products p
join orderdetails od on od.productCode = p.productCode
where od.priceeach < 0.8*p.msrp

##3.6
select * 
from products p join orderdetails od
on od.productCode = p.productCode
where priceEach>=2*buyPrice

##3.7
select * 
from products p
join orderdetails od on od.productCode = p.productCode
join orders o on od.orderNumber = o.orderNumber
where dayname(o.orderdate)="Monday"

##3.8
select p.productName, p.quantityinstock
from products p
join orderdetails od on od.productCode = p.productCode
join orders o on od.orderNumber = o.orderNumber
where o.status="On Hold"


Regular expressions
-----------------------
##4.1
select *
from products 
where productName like "%Ford%"

##4.2
select *
from products 
where productName like "%ship"

##4.3
select country ,count(*)
from customers
where country in ("Denmark","Norway", "Sweden")
group by country

##4.4
select *
from products
where productcode regexp "S700_1[0-4][0-9][0-9]"

##4.5
select *
from customers
where customername regexp "[0-9]"

##4.6
select * 
from Employees
where lastName regexp "Dianne|Diane" or firstName regexp "Dianne|Diane"

##4.7
select *
from product
where productname regexp "ship|boat"

##4.8
select * 
from Products
where productCode regexp "^S700"

##4.9
select * 
from Employees
where lastName regexp "Larry|Barry" or firstName regexp "Larry|Barry"

##4.10
select * 
from Employees
where  lastName not regexp "[a-zA-Z]" or firstName not regexp "[a-zA-Z]"


##4.11
select * 
from Products
where productVendor regexp "Diecast$"


General queries
-------------------
##5.1
select * from employees where reportsTo is null

##5.2
select *
from employees
where reportsTo in (select employeeNumber
from (select * from employees where firstname='William' and lastname='Patterson') t)

##5.3
select p.*
from customers c join orders o on c.customerNumber=o.customerNumber
join orderdetails od on o.orderNumber=od.orderNumber
join products p on od.productCode=p.productCode
where c.customerName='Herkku Gifts'

##5.4
select salesRepEmployeeNumber, sum(commission) as commission
from
(select 0.05*amount as commission, c.salesRepEmployeeNumber, e.lastname, e.firstname
from employees e join customers c on e.employeeNumber=c.salesRepEmployeeNumber
join payments p on c.customerNumber=p.customerNumber) t
group by salesRepEmployeeNumber
order by lastname, firstname

##5.5
select MAX(datediff(b.orderDate,a.orderDate)) as diff  
from orders a join orders b

##5.6
select CustomerNumber,avg(diff) as avg_d
from 
(select c.customerNumber, datediff(shippedDate, orderDate) as diff 
from customers c join orders o on c.customerNumber=o.customerNumber) t
group by customerNumber
order by avg_d desc

##5.7
select orderNumber, sum(value) as value
from
(select o.orderNumber, od.priceEach*od.quantityOrdered as value
from orders o join orderdetails od 
on o.orderNumber=od.orderNumber
where date_format(shippedDate, '%Y-%m') = '2004-08') t
group by orderNumber


Correlated subqueries
------------------------
##6.1
select a.employeeNumber, a.lastName, b.firstName
from employees a join employees b
on a.reportsto=b.employeeNumber
where b.lastname="Patterson" and b.firstname="Mary"

##6.2
with t as (select DATE_FORMAT(paymentDate, "%Y-%m") as date, avg(amount) as avg_amount
from payments
group by DATE_FORMAT(paymentDate, "%Y-%m"))

select p.*
from payments p join t on DATE_FORMAT(p.paymentDate, "%Y-%m") = t.date
where p.amount > 2*t.avg_amount

##6.3
with t as (select productline, sum(quantityinstock) as quantityinstock
from products
group by productline)

select p.*, round(p.quantityinstock/t.quantityinstock, 2) as percentage
from products p join t on p.productline=t.productline
order by p.productline, percentage desc

##6.4
with a as (select o.orderNumber
from products p
join orderdetails od on od.productCode = p.productCode
join orders o on od.orderNumber = o.orderNumber
group by o.orderNumber
having count(*) >2
),

b as (select sum(quantityordered*priceEach) as total, a.orderNumber
from orderdetails od 
join a on od.orderNumber = a.orderNumber
group by a.orderNumber)

select p.*
from b join orderdetails od on od.orderNumber = b.orderNumber
join products p on od.productCode=p.productCode
where quantityordered*priceEach>0.5*total


Spatial data
--------------
##7.1
SELECT *
from customers
where ST_X(ST_GeomFromText(ST_AsText(customerLocation))) <0

##7.2
with a as (select ST_X(ST_GeomFromText(ST_AsText(officeLocation))) as NYC_lat, ST_Y(ST_GeomFromText(ST_AsText(officeLocation))) as NYC_lng 
from offices  
where city ='NYC'
group by city)

select CustomerNumber, CustomerName
from customers join a 
where ST_X(ST_GeomFromText(ST_AsText(customerLocation))) < NYC_lat and ST_Y(ST_GeomFromText(ST_AsText(customerLocation))) < NYC_lng

##7.3
with t1 as (select a.customerNumber, customerName, (ACOS(SIN(lat1*PI()/180)*SIN(lat2*PI()/180)+COS(lat1*PI()/180)*COS(lat2*PI()/180)* COS((lon1-lon2)*PI()/180))*180/PI())*60*1.8532 as distance
from
(select *, ST_X(ST_GeomFromText(ST_AsText(customerLocation))) as lat1, ST_Y(ST_GeomFromText(ST_AsText(customerLocation))) as lon1
from customers) a
join
(select ST_X(ST_GeomFromText(ST_AsText(officeLocation))) as lat2, ST_Y(ST_GeomFromText(ST_AsText(officeLocation))) as lon2
from offices
where city ='Tokyo') b ), 

t2 as (select *, dense_rank() over(order by distance) as rk from t1)

select customerNumber, customerName
from t2 
where rk=1

##7.4
with t1 as (select a.customerNumber, customerName, (ACOS(SIN(lat1*PI()/180)*SIN(lat2*PI()/180)+COS(lat1*PI()/180)*COS(lat2*PI()/180)* COS((lon1-lon2)*PI()/180))*180/PI())*60*1.8532 as distance
from
(select *, ST_X(ST_GeomFromText(ST_AsText(customerLocation))) as lat1, ST_Y(ST_GeomFromText(ST_AsText(customerLocation))) as lon1
from customers where country='France') a
join
(select ST_X(ST_GeomFromText(ST_AsText(officeLocation))) as lat2, ST_Y(ST_GeomFromText(ST_AsText(officeLocation))) as lon2
from offices
where city ='Paris') b ),

t2 as (select *, dense_rank() over(order by distance desc) as rk from t1)

select customerNumber, customerName
from t2 
where rk=1

##7.5
select c.*
from customers c join (select MAX(ST_X(ST_GeomFromText(ST_AsText(customerLocation)))) as MAX_lat from customers) t
where ST_X(ST_GeomFromText(ST_AsText(customerLocation))) = MAX_lat

##7.6
select (ACOS(SIN(lat1*PI()/180)*SIN(lat2*PI()/180)+COS(lat1*PI()/180)*COS(lat2*PI()/180)* COS((lon1-lon2)*PI()/180))*180/PI())*60*1.8532 as distance
from
(select  ST_X(ST_GeomFromText(ST_AsText(officeLocation))) as lat1, ST_Y(ST_GeomFromText(ST_AsText(officeLocation))) as lon1
from offices 
where city ='Paris') a
join
(select ST_X(ST_GeomFromText(ST_AsText(officeLocation))) as lat2, ST_Y(ST_GeomFromText(ST_AsText(officeLocation))) as lon2
from offices 
where city ='Boston') b
