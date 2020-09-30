use classicmodels
##1
select city, count(city) as employee_count
from employees e join offices o on e.officeCode=o.officeCode
group by city
order by employee_count desc
limit 3

##2
select productline ,round((sum(msrp)-sum(buyprice))/sum(msrp),4) as profit_margin
from products 
group by productline

##3
###A
select  salesRepEmployeeNumber, round(sum(amount),2) as revenue
from Customers c join Payments p on c.customerNumber=p.customerNumber
group by salesRepEmployeeNumber
order by revenue desc
limit 3

###B
employees & customers

###C

DELIMITER $$
CREATE  PROCEDURE employee_inactive(in emp_id int)
Begin

update customers
set salesrepemployeenumber=(select reportsto from employees where employeenumber=emp_id);

delete from employees
where employeenumber=emp_id;

end$$

DELIMITER ;

##4
select E.employee_id, E.employee_name, D.department_name, count(distinct Es.salary) as SC
from Employee E join Employee_salary Es on E.employee_id=Es.employee_id
join Department D on E.department_id=D.department_id
group by Es.department_name

##5
with t as (select E.employee_id, E.employee_name, dense_rank() over(partition by department_id order by E.current_salary desc) as rk, D.department_name
from Employee E join Department D on E.department_id=D.department_id)

select employee_id, employee_name, department_name
from t
where rk <=3
