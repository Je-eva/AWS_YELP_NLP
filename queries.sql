
select * from tbl_yelp_reviews limit 10;
describe table tbl_yelp_reviews
select * from table_business limit 10;
--1. find no of categories and dispaly in order of highest, we cann use lateral split to spit column based on delimiter
with cte as(
select business_id ,A.value as cat from table_business ,
lateral split_to_table(categories,',')A 
)
select cat,count(*)  as count_business from cte group by 1 order by count(*) desc
--1 means the second column, ie cat
--can use 2 for count(*) to refer to tat
 

--2. top 10 users who revierwd most businesss in restaurant cat

 --since splitto table is costly opreation,we can use ilike, meaing case sensitive search
--using distinct busnies id, as a user can review multple time a restaurant rit, so using dsitinct for tat thing to be eliminated,  uniqure ratingt o business by a user
select r.user_id, count(distinct r.business_id) from tbl_yelp_reviews r inner join table_business b on r.business_id=b.business_id where b.categories ilike '%restaurants%' group by r.user_id order by 2 desc 


--3. find most popular categories of business based on no of reviews , 
--we need each business type and then join with reviews table ,so we know how much reviews each are there

with cte as(
select business_id ,A.value as cat from table_business ,
lateral split_to_table(categories,',')A 
)
select cat, count(*)
from cte inner join tbl_yelp_reviews r on cte.business_id= r.business_id group by 1 order by 2 desc



-- find top 3 recent reeciwew for each busines
with cte as (
select r.*, b.name,
row_number() over (partition by r.businesss_id order by r.review_date desc) as rn from tbl_yelp_reviews r 
inner join table_business b on r.business_id=b.business_id 
)

--5. find month with highest bno of reicew

select month(review_date) as month, count(*) as no_of_reviews  from tbl_yelp_reviews
group by 1 order by 2 desc


--6. find percent of 5 star out of total reicew for each. ie business have 100 review and 10 5 star,o/p =10
-- count and null to be used, if sum 0 enf
SELECT b.name, b.business_id, COUNT(*) AS total_review,
(count(CASE WHEN r.review_stars = 5 THEN 1 ELSE null END) * 100.0) / COUNT(*) AS percent_5_star
FROM tbl_yelp_reviews r INNER JOIN 
    table_business b ON r.business_id = b.business_id
GROUP BY 1,2 order by 3 desc,4 asc;

--7. most 5 reviewd business in each city
--use a cte to join and get the columns needed, 
--use qualify , which can do automatic filterof window function using partion by city and counnt(*) reviews, and <=5
with cte as(

select b.city, b.business_id, b.name, count(*) as total_reviews from tbl_yelp_reviews r inner join table_business b on r.business_id=b.business_id  
group by 1,2,3

)
select * from cte
qualify row_number() over (partition by city order by total_reviews desc) <= 5 

/*
8. get recies by avg rating of busines having at least 100 revicews */
select b.business_id,count(*) as total_revews, avg(review_stars) as avg_rating
from tbl_yelp_reviews r 
inner join table_business b on r.business_id=b.business_id
group by 1
having count(*)>=100

--top 10 users who have writen most revviews  alogn with business
with cte as(
select r.user_id,count(*) as total_reviews
from tbl_yelp_reviews r 
inner join table_business b on r.business_id=b.business_id
group by 1
order by 2 desc
limit 10
)
--got in above the top 10 users

select b.name,r.user_id from tbl_yelp_reviews r join table_business b where user_id in(select user_id from cte) order by user_id 
select user_id , business_id from tbl_yelp_reviews where user_id in(select user_id from cte) order by user_id





-- find  10 top busines with highset pos sentiment reviews
--filter reviews by pos sentiment
select b.business_id,b.name, count(*) as total_reviews
from tbl_yelp_reviews r 
inner join table_business b on r.business_id=b.business_id
where r.sentiments='Positive'
group by 1,2  
order by 3 desc
limit 10


--Sentiment Distribution for Each business
SELECT b.NAME,b.BUSINESS_ID,
       r.SENTIMENTS,
       COUNT(*) AS sentiment_count
FROM tbl_yelp_reviews r
JOIN table_business b ON r.BUSINESS_ID = b.BUSINESS_ID
GROUP BY b.name,b.BUSINESS_ID, r.SENTIMENTS
ORDER BY b.NAME, sentiment_count DESC;




 
