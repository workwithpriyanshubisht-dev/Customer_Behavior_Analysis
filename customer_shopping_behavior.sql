select * from  customer_data limit 20;

-- q1 . what is the total revenue genrated by male vs female customers?
select gender , sum(purchase_amount) as revenue
from customer_data
group by gender;

-- q2 which customer used a discount but spent more than the avg purchase amount?
select customer_id, purchase_amount
from customer_data
where discount_applied = "Yes"  and purchase_amount >= (select avg(purchase_amount) from customer_data);

-- q3 which are the top 5 products with highest review rating
select item_purchased,avg(review_rating) as 'average product rating'
from customer_data
group by item_purchased
order by avg(review_rating)desc
limit 5;
-- q4 compare the average purchase amount between standard and wxpress shipping.
select shipping_type ,
round(avg(purchase_amount),2)
from customer_data
where shipping_type in ('standard','express')
group by shipping_type;

-- q5 do subscribed customer spend more ? compare average spend and total revenue between subscribers and non subscribers
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer_data
group by subscription_status
order by total_revenue , avg_spend desc;

-- q6 which 5 products have the highest percentage with discounts applied?
select item_purchased,
round(100* sum(case when discount_applied = 'yes' then 1 else 0 end) / count(*),2) as discount_rate
from customer_data
group by item_purchased
order by discount_rate desc
limit 5;

-- q7 segment customer into new , returning , and loyal based on their total number of previous purchases , and show the count of each segment
with customer_type as(
select customer_id , previous_purchases,
case
	when previous_purchases = 1 then 'new'
	when previous_purchases between 2 and 10 then "returning"
    else "loyal"
    end as customer_segment
from customer_data
)

select customer_segment , count(*) as "number of customers"
from customer_type
group by customer_segment;

-- Q8 what are the   top 3 most purchased product within each category?
with item_counts as (
select category,
item_purchased, 
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer_data
group by category,item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

-- q9 are customer who are repeat buyers are more likely to subscribe??
Select subscription_status,
count(customer_id) as repeat_buyers
from customer_data
where previous_purchases > 5
group by subscription_status;

-- q10 check the revenue by age group
select age_group,
sum(purchase_amount) as total_revenue
from customer_data
group by age_group
order by total_revenue desc;
