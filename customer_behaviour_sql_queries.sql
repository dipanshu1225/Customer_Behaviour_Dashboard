use project;
ALTER TABLE customer
    RENAME COLUMN `Customer ID` TO customer_id,
    RENAME COLUMN `Age` TO age,
    RENAME COLUMN `Gender` TO gender,
    RENAME COLUMN `Item Purchased` TO item_purchased,
    RENAME COLUMN `Category` TO category,
    RENAME COLUMN `Purchase Amount (USD)` TO purchase_amount_usd,
    RENAME COLUMN `Location` TO location,
    RENAME COLUMN `Size` TO size,
    RENAME COLUMN `Color` TO color,
    RENAME COLUMN `Season` TO season,
    RENAME COLUMN `Review Rating` TO review_rating,
    RENAME COLUMN `Subscription Status` TO subscription_status,
    RENAME COLUMN `Shipping Type` TO shipping_type,
    RENAME COLUMN `Discount Applied` TO discount_applied,
    RENAME COLUMN `Promo Code Used` TO promo_code_used,
    RENAME COLUMN `Previous Purchases` TO previous_purchases,
    RENAME COLUMN `Payment Method` TO payment_method,
    RENAME COLUMN `Frequency of Purchases` TO frequency_of_purchases;
select * from customer limit 20;
-- Q1.What is the total revanue genrated by male vs female customers?
select gender , sum(`Purchase Amount (USD)`) as revenue
from customer
group by gender;

-- Q2.Which is the top 5 product with highest avg rating?
select `Item Purchased`, avg(`Review Rating`) AS 'Avg Review Rating'
from customer
group by `Item Purchased`
order by avg(`Review Rating`) DESC
limit 5;


-- Q3.Which customer used a discount but still spent more than the average purchase?
    
SELECT `Customer ID`, `Purchase Amount (USD)`
FROM customer
WHERE `Discount Applied` = 'yes' AND `Purchase Amount (USD)` >= (
    SELECT AVG(`Purchase Amount (USD)`)
    FROM customer
);

-- Q4.Compare the average purchase amount between sandard and express shipping
select shipping_type, avg(purchase_amount)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type;

alter table customer
	RENAME COLUMN purchase_amount_usd to purchase_amount;


-- Q5. Do subscribed coustomers spend more ? compare avg spend and total ravanue bt sus and non- subs
select subscription_status, count(customer_id) astotal_customer,
							avg(purchase_amount) as avg_spend,
							sum(purchase_amount) as total_ravenue
from customer
where subscription_status in ('Yes','No')
group by subscription_status;


-- Q6. Which 5 products havve the highest percentage of puchases with discount
SELECT
    item_purchased AS item_name,
    ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS discount_percentage
FROM customer
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;

-- Q7.)Find the top 5 purchased items that generated the 
-- highest total revenue among customers who received a discount.
select item_purchased as item_name,sum(purchase_amount) as ravanue
from customer
where discount_applied= 'Yes'
group by item_purchased
order by sum(purchase_amount) desc
limit 5
; 
-- Q8.segment customers into new, ruturning, loyal based on the 
-- their total no. of previous purchases and show the count of each segment 
SELECT
	CASE 
		when previous_purchases = 1 Then'New'
		when previous_purchases between 2 and 10 Then 'Returning'
		else 'Loyal'
		End as customer_segment,
   
   COUNT(*) as "Number of Customer"
   from customer
   group by customer_segment;

-- Q9. What are the top most 3 purchases within each category
with item_counts as(
select
	  category,
	  item_purchased,
	  COUNT(customer_id) as Total_Order,
row_number() over (partition by category order by count(customer_id) desc) as item_rank

from customer
group by category,item_purchased
)
 select item_rank,category, item_purchased, Total_order
 from item_counts
 where item_rank <=3;

-- Q10.Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
SELECT subscription_status,
    COUNT(customer_id) AS Repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Q11.WHAT IS RAVENUE CONTRIBUTION OF EACH AGE GROUP?
select age,
sum(purchase_amount) as total_ravanue
from customer
group by age
order by total_ravanue desc;
