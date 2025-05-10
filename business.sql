create or replace table yelp_businesses (business_text variant)

COPY INTO yelp_businesses
FROM 's3://yelpjeeva/yelp/yelp_academic_dataset_business.json'
CREDENTIALS = (
    AWS_KEY_ID = '*'
    AWS_SECRET_KEY = '*'
)
FILE_FORMAT = (TYPE = JSON);

create or replace table table_business as
select business_text:business_id::string as business_id
,business_text:name::string as name
,business_text:city::string as city
,business_text:state::string as state
,business_text:review_count::string as review_count
,business_text:stars::number as stars
,business_text:categories::string as categories
from yelp_businesses;

select count(*) from table_business ;
