--Шаг 4 запрос, который считает общее количество покупателей
select count(customer_id) as customers_count
from customers;

--Шаг 5, задание 1 отчет с продавцами у которых наибольшая выручка
select concat(e.first_name, ' ', e.last_name) as name,
count(s.sales_id) as operations,
sum(p.price * s.quantity) as income  
from employees e
inner join sales s
on e.employee_id = s.sales_person_id
inner join products p
on s.product_id = p.product_id
group by concat(e.first_name, ' ', e.last_name)
order by income desc
limit 10;

--Шаг 5, задание 2 отчет с продавцами, чья выручка ниже средней выручки всех продавцов
with tab as(
select concat(e.first_name, ' ', e.last_name) as name,
avg(p.price * s.quantity) as average_income
from employees e
inner join sales s
on e.employee_id = s.sales_person_id
inner join products p
on s.product_id = p.product_id
group by concat(e.first_name, ' ', e.last_name)
),
common_average as(
select avg(average_income) as common_average
from tab
)
select name, round(average_income, 0)
from tab
where average_income < (select common_average from common_average)
order by average_income ASC
;


--НЕПРАВИЛЬНОШаг 5, задание 3 отчет с данными по выручке по каждому продавцу и дню недели
select concat(e.first_name, ' ', e.last_name) as name,
to_char(s.sale_date, 'Day') as weekday,
round(sum(p.price * s.quantity),0) as income
from employees e
inner join sales s
on e.employee_id = s.sales_person_id
inner join products p
on s.product_id = p.product_id
group by to_char(s.sale_date, 'ID'), concat(e.first_name, ' ', e.last_name)
order by name, s.sale_date
;