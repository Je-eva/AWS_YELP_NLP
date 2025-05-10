

The processs is , initally create a snowflake and aws account
Then, GO into aws and create IAM user and login through that

make a secret key 

create s3 bucket and create a folder ( i named it yelp)
split file used to split the 5gb file into 10 files of 500 mb for better loading .
add the splitted files into the yelp(10 files)

go to snowflake and add a new database and connect to it and run the codes in the .sql file provided
1. snowflake databse and initial connection query![image](https://github.com/user-attachments/assets/bf835a0e-7bdf-4bb0-ac46-d014d2d4d622)
2.the aws bucket after loading the data![image](https://github.com/user-attachments/assets/79448da7-4f28-4da8-9949-3a7f8ed3aea4)
3. make yelp_reviews table and yelp_business table by loading the data from s3.
4. these datasets are now in json format, so convert it into tabluar format so we can do analysis on the table
the cast is not in noswlfake, so we use :: ie..,review_text:user_id::string as user_id as example
the way to get data is ",business_text:city::string as city" ie, json fille header, the column needed from tat, cast type , alias
6. use UDF sentiment analysis
