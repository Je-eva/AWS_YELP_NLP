# 📝 Yelp Sentiment Analysis using AWS S3 and Snowflake

This project performs **Sentiment Analysis** on Yelp reviews using Snowflake's data warehousing and AWS S3 for scalable storage. It processes a 5GB dataset, splits it, loads it into Snowflake, and applies a UDF to analyze sentiment (polarity).

---

## 📌 Project Flow

1. **Account Setup**
   - Create a **Snowflake** and **AWS** account.
   - In AWS, create an **IAM user** with programmatic access.
   - Generate **Access Key ID** and **Secret Access Key**.

2. **AWS S3 Configuration**
   - Create a **bucket** in AWS S3 (e.g., `yelp-bucket`).
   - Inside the bucket, create a **folder** (named `yelp`).
   - Use the provided Jupyter Notebook to **split the original 5GB Yelp dataset** into **10 smaller files (~500MB each)** for efficient loading.
   - Upload these 10 files to the `yelp/` folder in the S3 bucket.

   ![AWS S3 bucket structure](https://github.com/user-attachments/assets/79448da7-4f28-4da8-9949-3a7f8ed3aea4)

3. **Snowflake Setup**
   - Create a new **database** and **warehouse** in Snowflake.
   - Choose an **XL compute size** for loading large datasets (recommended over the default small size).

   ![Snowflake connection query](https://github.com/user-attachments/assets/bf835a0e-7bdf-4bb0-ac46-d014d2d4d622)

4. **Connect Snowflake to S3**
   - Use the **Access Key** and **Secret Key** to configure the S3 stage in Snowflake.
   - Create **external stages** to access S3 folders from Snowflake.

5. **Create Tables and Load Data**
   - Create two main tables:  
     - `yelp_reviews_raw`
     - `yelp_business_raw`
   - Use `COPY INTO` command to load JSON data from S3 into these tables.

6. **Transform JSON to Tabular Format**
   - Use `SELECT` with **dot notation** and `::` type casting to extract JSON fields.  
     Example:
     ```sql
     review_text:user_id::string AS user_id,
     business_text:city::string AS city
     ```
   - Create clean, tabular versions of the tables for analysis:
     - `yelp_reviews_clean`
     - `yelp_business_clean`

7. **Apply Sentiment Analysis**
   - Define a **UDF (User Defined Function)** in Snowflake to calculate **polarity score**.
   - Apply the function to review text to generate sentiment labels (`positive`, `neutral`, `negative`).

---

## 💡 Sample SQL Snippet for JSON Transformation

```sql
SELECT
  review_text:review_id::string AS review_id,
  review_text:text::string AS review,
  review_text:user_id::string AS user_id,
  review_text:stars::integer AS stars
FROM yelp_reviews_raw;
