create database quickshop_db;

use quickshop_db;

select count(*) from items_data;
select * from items_data;

CREATE TABLE items_data (
  Item_Fat_Content text,
  Item_Identifier text,
  Item_Type text,
  Outlet_Establishment_Year int,
  Outlet_Identifier text,
  Outlet_Location_Type text,
  Outlet_Size text,
  Outlet_Type text,
  Item_Visibility double,
  Item_Weight double NULL,
  Total_Sales double,
  Rating double
);

LOAD DATA LOCAL INFILE 'C:/Users/tarun/naukri/trainings/data-analysis/sql_project_data_tutorials/BlinkIT Grocery Data.csv'
INTO TABLE items_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Item_Fat_Content,Item_Identifier,Item_Type,Outlet_Establishment_Year,Outlet_Identifier,Outlet_Location_Type,Outlet_Size,Outlet_Type,Item_Visibility,Item_Weight,Total_Sales,Rating);

show global variables like 'local_infile';
set global local_infile=true;

select count(*) from items_data;
select * from items_data;

select DISTINCT(Item_Fat_Content) from items_data;

update items_data
set Item_Fat_Content = 
CASE 
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END;

-- to disable safe mode
SET SQL_SAFE_UPDATES = 0;

-- KPI
select SUM(total_sales) as Total_Sales from items_data;

-- Total sale in Millions
select CONCAT(CAST(SUM(total_sales)/1000000 AS DECIMAL(10,2)), ' Millions') as Total_Sales_Millions
from items_data;

-- Average sale in Millions
select CAST(AVG(total_sales) AS DECIMAL(10,0)) as Average_Sales
from items_data;

-- Number of items
select count(*) as Items_Count from items_data;

-- Total sale in Millions for Low fat items
select CONCAT(CAST(SUM(total_sales)/1000000 AS DECIMAL(10,2)), ' Millions') as Total_Sales_Millions
from items_data
where Item_Fat_Content = 'Low Fat';

-- Average sale in Millions for Low fat items
select CAST(AVG(total_sales) AS DECIMAL(10,0)) as Average_Sales
from items_data
where Item_Fat_Content = 'Low Fat';

-- Total sale in Millions for Outlets established in 2022
select CONCAT(CAST(SUM(total_sales)/1000000 AS DECIMAL(10,2)), ' Millions') as Total_Sales_Millions
from items_data
where Outlet_Establishment_Year = 2022;

-- Average sale in Millions for Outlets established in 2022
select CAST(AVG(total_sales) AS DECIMAL(10,0)) as Average_Sales
from items_data
where Outlet_Establishment_Year = 2022;

-- Total sale in Millions for Outlets in Tier 1 cities
select CONCAT(CAST(SUM(total_sales)/1000000 AS DECIMAL(10,2)), ' Millions') as Total_Sales_Millions
from items_data
where Outlet_Location_Type = 'Tier 1';

-- Average sale in Millions for Outlets in Tier 1 cities
select CAST(AVG(total_sales) AS DECIMAL(10,0)) as Average_Sales
from items_data
where Outlet_Location_Type = 'Tier 1';

-- Average rating
select cast(avg(Rating) as decimal(10,2)) as Avg_Rating from items_data;


-- Granular Requirements

-- Total Sales by Fat Content
select Item_Fat_Content, CONCAT(CAST(SUM(total_sales)/1000000 AS DECIMAL(10,2)), ' Millions') as Total_Sales_Millions
from items_data
group by Item_Fat_Content;

-- Values by Fat Content
select Item_Fat_Content, 
	CAST(SUM(total_sales) AS DECIMAL(10,2)) as Total_Sales,
    CAST(avg(total_sales) AS DECIMAL(10,2)) as Average_Sales,
    CAST(avg(Rating) AS DECIMAL(10,2)) as Average_Rating,
    count(*) as Items_Count
from items_data
group by Item_Fat_Content
order by Total_Sales desc;

-- Values by Fat Content for Outlets established in 2022
select Item_Fat_Content, 
	CAST(SUM(total_sales) AS DECIMAL(10,2)) as Total_Sales,
    CAST(avg(total_sales) AS DECIMAL(10,2)) as Average_Sales,
    CAST(avg(Rating) AS DECIMAL(10,2)) as Average_Rating,
    count(*) as Items_Count
from items_data
where Outlet_Establishment_Year = 2022
group by Item_Fat_Content
order by Total_Sales desc;

-- Values by Fat Content for Outlets in Tier 1 cities
select Item_Fat_Content, 
	CAST(SUM(total_sales) AS DECIMAL(10,2)) as Total_Sales,
    CAST(avg(total_sales) AS DECIMAL(10,2)) as Average_Sales,
    CAST(avg(Rating) AS DECIMAL(10,2)) as Average_Rating,
    count(*) as Items_Count
from items_data
where Outlet_Location_Type = 'Tier 1'
group by Item_Fat_Content
order by Total_Sales desc;

-- Values by Fat Content for Outlets in Tier 2 cities
select Item_Fat_Content, 
	CAST(SUM(total_sales) AS DECIMAL(10,2)) as Total_Sales,
    CAST(avg(total_sales) AS DECIMAL(10,2)) as Average_Sales,
    CAST(avg(Rating) AS DECIMAL(10,2)) as Average_Rating,
    count(*) as Items_Count
from items_data
where Outlet_Location_Type = 'Tier 2'
group by Item_Fat_Content
order by Total_Sales desc;

-- Values by Fat Content for Outlets in Tier 3 cities
select Item_Fat_Content, 
	CAST(SUM(total_sales) AS DECIMAL(10,2)) as Total_Sales,
    CAST(avg(total_sales) AS DECIMAL(10,2)) as Average_Sales,
    CAST(avg(Rating) AS DECIMAL(10,2)) as Average_Rating,
    count(*) as Items_Count
from items_data
where Outlet_Location_Type = 'Tier 3'
group by Item_Fat_Content
order by Total_Sales desc;

-- Top 5 sales by Item type
select Item_Type, 
	CAST(SUM(total_sales) AS DECIMAL(10,2)) as Total_Sales,
    CAST(avg(total_sales) AS DECIMAL(10,2)) as Average_Sales,
    CAST(avg(Rating) AS DECIMAL(10,2)) as Average_Rating,
    count(*) as Items_Count
from items_data
group by Item_Type
order by Total_Sales desc
limit 5;

-- Top 5 sales by Outlet location and fat content
select Outlet_Location_Type, Item_Fat_Content,
	CAST(SUM(total_sales) AS DECIMAL(10,2)) as Total_Sales,
    CAST(avg(total_sales) AS DECIMAL(10,2)) as Average_Sales,
    CAST(avg(Rating) AS DECIMAL(10,2)) as Average_Rating,
    count(*) as Items_Count
from items_data
group by Outlet_Location_Type, Item_Fat_Content
order by Total_Sales asc
limit 5;


-- pivot - using case as pivot not supported in mysql
select Outlet_Location_Type, -- Item_Fat_Content,
	CAST(SUM(case when Item_Fat_Content = 'Regular' then total_sales else 0 end) AS DECIMAL(10,2)) as Regular_Total_Sales,
	CAST(SUM(case when Item_Fat_Content = 'Low Fat' then total_sales else 0 end) AS DECIMAL(10,2)) as LowFat_Total_Sales    
from items_data
group by Outlet_Location_Type
order by Outlet_Location_Type;

-- Top 5 sales by outlet establishment year
select Outlet_Establishment_Year,
	CAST(SUM(total_sales) AS DECIMAL(10,2)) as Total_Sales,
    CAST(avg(total_sales) AS DECIMAL(10,2)) as Average_Sales,
    CAST(avg(Rating) AS DECIMAL(10,2)) as Average_Rating,
    count(*) as Items_Count
from items_data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year asc;

-- percentage of sales by outlet size

-- Using sub query
select 
	Outlet_Size, 
	(CAST(SUM(total_sales) / (select SUM(total_sales) as Total_Sales from items_data) AS DECIMAL(10,2)) * 100.0) as Sales_Percentage
from items_data
group by Outlet_Size;

-- Using window function
select
	Outlet_Size,
    sum(total_sales) as Total_Sales_Outlet_Size,
	sum(sum(total_sales)) over () as Total_Sales,
    (CAST(sum(total_sales) / sum(sum(total_sales)) over () AS DECIMAL(10,2))) * 100.0 as Sales_Percentage
from items_data
group by Outlet_Size;


-- sales by outlet type
select
	Outlet_Type,
    count(*) as Items_Count,
    CAST(sum(total_sales) AS DECIMAL(10,2)) as Total_Sales_Outlet_Type,    
	CAST(sum(sum(total_sales)) over () AS DECIMAL(10,2)) as Total_Sales,
    (CAST(sum(total_sales) / sum(sum(total_sales)) over () AS DECIMAL(10,2))) * 100.0 as Sales_Percentage,
    CAST(avg(rating) AS DECIMAL(10,2)) as Age_Rating
from items_data
group by Outlet_Type;
