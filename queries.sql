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
round(avg(p.price * s.quantity),0) as average_income
from employees e
inner join sales s
on e.employee_id = s.sales_person_id
inner join products p
on s.product_id = p.product_id
group by concat(e.first_name, ' ', e.last_name)
),
common_average_tab as(
select avg(p.price * s.quantity) as common_average
from employees e
inner join sales s
on e.employee_id = s.sales_person_id
inner join products p
on s.product_id = p.product_id
)
select name, average_income
from tab
cross join common_average_tab
where average_income < common_average
order by average_income ASC
;


--Шаг 5, задание 3 отчет с данными по выручке по каждому продавцу и дню недели
select concat(e.first_name, ' ', e.last_name) as name,
to_char(s.sale_date, 'day') as weekday,
round(sum(p.price * s.quantity),0) as income
from employees e
inner join sales s
on e.employee_id = s.sales_person_id
inner join products p
on s.product_id = p.product_id
group by to_char(s.sale_date, 'ID'), 1, 2
order by to_char(s.sale_date, 'ID'), 1
;

--Шаг 6, задание 1 количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+
select
case
when age >= 16 and age <= 25 then '16-25'
when age >= 26 and age <= 40 then '26-40'
else '40+'
end as age_category,
count(*) as count
from customers
group by age_category
order by age_category
;

--Шаг 6, задание 2  количество покупателей и выручка по месяцам
select
to_char(s.sale_date, 'YYYY-MM') as date,
count(distinct c.customer_id) as total_customers,
sum(p.price * s.quantity) as income
from customers c
inner join sales s
on c.customer_id = s.customer_id
inner join products p
on s.product_id = p.product_id
group by to_char(s.sale_date, 'YYYY-MM')
order by date
;

--Шаг 6, задание 3 покупатели, первая покупка которых пришлась на время проведения специальных акций
select
distinct on (concat(c.first_name, ' ', c.last_name))
concat(c.first_name, ' ', c.last_name) as customer,
sale_date,
concat(e.first_name, ' ', e.last_name) as seller
from customers c
inner join sales s
on c.customer_id = s.customer_id
inner join employees e
on e.employee_id = s.sales_person_id
inner join products p
on s.product_id = p.product_id
where p.price = 0
order by concat(c.first_name, ' ', c.last_name), c.customer_id, sale_date
;
