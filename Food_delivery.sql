  ----1.Find Top 3 outlet by cusine type without using limit and Top function

  With cte as (
  Select Cuisine,Restaurant_id,Count(*) as No_of_orders
  From orders
  Group By Cuisine,Restaurant_id
  )
  Select *
  From (Select *, ROW_NUMBER() over(partition by Cuisine order by No_of_orders desc)as Row_Num
  From cte)a
  Where Row_Num<=3


  Select * from orders

  Select Restaurant_id, (select count(*) from orders) as No_of_ordes
  from orders
  Group By Restaurant_id

----2.Find the daily new customer count from the launch date(everyday how many new customers are acquiring)

 Select * from orders

 With cte as
 (
 Select Customer_code, Cast( Min(Placed_at) as date) as first_order_date
 From orders
 Group by Customer_code
 )
 Select First_order_date, count(*) as no_of_orders
 From cte
 Group By First_order_date
 Order by first_order_date Asc
 
 ----4.Count of all the user who were aquired in Jan 2025 and only place one order in Jan didnt place any other order
  
  Select * from orders

  Select Customer_code,count(*) as no_of_orders
  From orders
  Where Month(Placed_at)=1
  AND customer_code not in (  Select distinct Customer_code
  From orders
  Where NOT (Month(placed_at)=1 and Year(Placed_at)=2025)
  )
  Group By Customer_code
  Having Count(*)=1;

  ----Select distinct Customer_code
  ----From orders
  ----Where NOT (Month(placed_at)=1 and Year(Placed_at)=2025))

----4. List all the customer with no order in last 7 days were acquired one month ago with their first order on promo
Select * from orders

With cte as 
(Select Customer_code,Min(placed_at)as first_order_date,Max(Placed_at) as last_order_date
From orders
Group By Customer_code
)
Select cte.*,orders.Promo_code_Name
From cte Join orders ON cte.customer_code = orders.customer_code and cte.first_date=orders.Placed_at
Where last_date<DATEADD(Day,-7,GETDATE())
      and first_date<DATEADD(Month,-1,getdate())
      and Promo_code_Name Is not Null

-----5.Growth team is planning to create trigger that will target customer after every third order with persionalized communication and they have asked you to create query for this
Select * from orders

with cte as 
(Select *,
Row_Number() over (partition by customer_code order by Placed_at ) as Order_number
From orders 
)
Select customer_code,order_number
From cte
Where order_number%3=0 and cast(placed_at as date)= cast(Getdate() as date)


----6.List customer who has placed more than 1 order and all their orders on promo only.

Select * from orders

Select Customer_code,count(*) as Total_orders,count(Promo_code_Name) as Promo_Orders
From orders
Group By Customer_code
Having count(*)>1 and count(*)=count(Promo_code_Name)

----7.What percent of customer were organically aquired in Jan 2025.(Placed their first order without promo code)

with cte as
(Select *,ROW_NUMBER() over (partition by customer_code order by Placed_at)as rn
From orders
Where Month(Placed_at)=1 and Year(Placed_at)=2025 
)
Select Count(case when rn=1 and Promo_code_Name Is Null then customer_code end)*100.00/count (distinct customer_code)
From cte
   



