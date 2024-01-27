#  Database Schemas and Normalization

## Star and snowflake schema

### Star schema

Dimensional modeling: star schema
1. Fact tables
* Holds records of a metric
* Changes regularly
* Connects to dimensions via foreign keys

2. Dimension tables
* Holds descriptions of attributes
* Does not change as often

Star chemas: One dimension

Snowflake schemas: more than one dimension. This is due to tables are normalized.

### What is normalization?
* Database design technique
* Divides tables into smaller tables and connects them via relationships
* Goal: reduce redundancy and increase data integrity

Identify repeating groups of data and create new tables for them


## Adding foreign keys

Foreign key references are essential to both the snowflake and star schema. When creating either of these schemas, correctly setting up the foreign keys is vital because they connect dimensions to the fact table.


In the constraint called sales_book, set book_id as a foreign key.

In the constraint called sales_time, set time_id as a foreign key.

In the constraint called sales_store, set store_id as a foreign key.

You need to create the foreign key constraint from the fact_booksales table to the dim_book_star.


```
-- Add the book_id foreign key
ALTER TABLE fact_booksales ADD CONSTRAINT sales_book
    FOREIGN KEY (book_id) REFERENCES dim_book_star (book_id);

-- Add the time_id foreign key
ALTER TABLE fact_booksales ADD CONSTRAINT sales_time
    FOREIGN KEY(time_id) REFERENCES dim_time_star (time_id);
    
-- Add the store_id foreign key
ALTER TABLE fact_booksales ADD CONSTRAINT sales_store
    FOREIGN KEY (store_id) REFERENCES dim_store_star (store_id);
```

* The foreign keys have been added so now we can ensure data consistency whenever new data is inserted to the database.

## Extending the book dimension

```
-- Create a new table for dim_author with an author column
CREATE TABLE dim_author (
    author varchar(256)  NOT NULL
);

-- Insert authors 
INSERT INTO dim_author
SELECT DISTINCT author FROM dim_book_star;

-- Add a primary key 
ALTER TABLE dim_author ADD COLUMN author_id SERIAL PRIMARY KEY;

-- Output the new table
SELECT * FROM dim_author;
```


## Normalized and denormalized databases

### Denormalized Query

Goal: get quantity of all Octavia E. Butler books sold in Vancouver in Q4 of 2018

```
SELECT SUM(quantity) 
FROM fact_booksales
-- Join to get city
INNER JOIN dim_store_star on fact_booksales.store_id = dim_store_star.store_id
-- Join to get author
INNER JOIN dim_book_star on fact_booksales.book_id = dim_book_star.book_id
-- Join to get year and quarter
INNER JOIN dim_time_star on fact_booksales.time_id = dim_time_star.time_id
WHERE dim_store_star.city ='Vancouver'AND dim_book_star.author ='Octavia E. Butler' AND dim_time_star.year =2018 AND dim_time_star.quarter =4;
```

### Normalized query
```
SELECT SUM(fact_booksales.quantity)
FROM  fact_booksales
-- Join to get city 
INNER JOIN dim_store_sf ON fact_booksales.store_id = dim_store_sf.store_id
INNER JOIN dim_city ON dim_store_sf.city_id = dim_city_sf.city_id
-- Join to get author
INNER JOIN dim_book_sf ON fact_booksales.book_id = dim_book_sf.book_id
INNER JOIN dim_author_sf ON dim_book_sf.author_id = dim_author_sf.author_id
-- Join to get year and quarter
INNER JOIN dim_time_sf ON fact_booksales.time_id = dim_time_sf.time_id
INNER JOIN dim_month_sf ON dim_time_sf.month_id = dim_month_sf.month_id
INNER JOIN dim_quarter_sf ON dim_month_sf.quarter_id =  dim_quarter_sf.quarter_id
INNER JOIN dim_year_sf ON dim_quarter_sf.year_id = dim_year_sf.year_id
WHERE  dim_city_sf.city = `Vancouver` AND  dim_author_sf.author = `Octavia E. Butler` AND  dim_year_sf.year =2018AND dim_quarter_sf.quarter =4;
```

* Denormalized databases enable data redundancy
* Normalization eliminates data redundancy

### Normalization ensures better data integrity

1. Enforces data consistency
    * Must respect naming conventions because of referential integrity, e.g., 'California', not 'CA' or'california'
2. Safer updating, removing, and inserting
    * Less data redundancy = less records to alter
3. Easier to redesign by extending
    * Smaller tables are easier to extend than larger tables

### Advantages
* Normalization eliminates data redundancy: save on storage
* Better data integrity: accurate and consistent data

### Disadvantages
* Complex queries require more CPU

### OLTP and OLAP
* OLTP: Typically highly normalized
    * Write-intensive
    * Prioritize quicker and safer insertion of data

* OLAP: Typically less normalized 
* Read-intensive
* Prioritize quicker queries for analytics

## Querying the star schema

Select state from the appropriate table and the total sales_amount.

Complete the JOIN on book_id.

Complete the JOIN to connect the dim_store_star table

Conditionally select for books with the genre novel.

Group the results by state.

```
-- Output each state and their total sales_amount
SELECT dim_store_star.state, sum(sales_amount)
FROM fact_booksales
	-- Join to get book information
    JOIN dim_book_star ON fact_booksales.book_id = dim_book_star.book_id
	-- Join to get store information
    JOIN dim_store_star ON fact_booksales.store_id = dim_store_star.store_id
-- Get all books with in the novel genre
WHERE  
    dim_book_star.genre = 'novel'
-- Group results by state
GROUP BY
    dim_store_star.state;
```


## Querying the snowflake schema

Select state from the appropriate table and the total sales_amount.

Complete the two JOINS to get the genre_id's.

Complete the three JOINS to get the state_id's.

Conditionally select for books with the genre novel.

Group the results by state.


```
-- Output each state and their total sales_amount
SELECT dim_state_sf.state, sum(sales_amount)
FROM fact_booksales
    -- Joins for genre
    JOIN dim_book_sf on fact_booksales.book_id = dim_book_sf.book_id
    JOIN dim_genre_sf on dim_book_sf.genre_id = dim_genre_sf.genre_id
    -- Joins for state 
    JOIN dim_store_sf on fact_booksales.store_id = dim_store_sf.store_id 
    JOIN dim_city_sf on dim_store_sf.city_id = dim_city_sf.city_id
	JOIN dim_state_sf on  dim_city_sf.state_id = dim_state_sf.state_id
-- Get all books with in the novel genre and group the results by state
WHERE  
    dim_genre_sf.genre = 'novel'
GROUP BY
    dim_state_sf.state;
```

## Extending the snowflake schema 

Add a continent_id column to dim_country_sf with a default value of 1. Note thatNOT NULL DEFAULT(1) constrains a value from being null and defaults its value to 1.

Make that new column a foreign key reference to dim_continent_sf's continent_id.

```
-- Add a continent_id column with default value of 1
ALTER TABLE dim_country_sf
ADD continent_id int NOT NULL DEFAULT(1);

-- Add the foreign key constraint
ALTER TABLE dim_country_sf ADD CONSTRAINT country_continent
   FOREIGN KEY (continent_id) REFERENCES dim_continent_sf(continent_id);
   
-- Output updated table
SELECT * FROM dim_country_sf;
```

## Normal forms

### Normalization

Identify repeating groups of data and create new tables for them

A more formal definition:
    
The goals of normalization are to:
* Be able to characterize the level of redundancy in a relational schema
* Provide mechanisms for transforming schemas in order to remove redundancy


### Normal forms (NF)

Ordered from least to most normalized:

* First normal form (1NF)
* Second normal form (2NF)
* Third normal form (3NF)
* Elementary key normal form (EKNF)
* Boyce-Codd normal form (BCNF)
* Fourth normal form (4NF)
* Essential tuple normal form (ETNF)
* Fifth normal form (5NF)
* Domain-key Normal Form (DKNF)
* Sixth normal form (6NF)

#### 1NF rules
* Each record must be unique - no duplicate rows
* Each cell must hold one value

#### 2NF
* Must satisfy 1NF AND
    * If primary key is one column 
        * then automatically satisfies 2NF
    * If there is a composite primary key
        * then each non-key column must be dependent on all the keys


#### 3NF
* Satisfies 2NF
* No transitive dependencies: non-key columns can't depend on other non-key columns

#### Data anomalies

What is risked if we don't normalize enough?
1. Update anomaly
2. Insertion anomaly
3. Deletion anomaly



## Converting to 1NF

* cars_rented holds one or more car_ids and invoice_id holds multiple values. Create a new table to hold individual car_ids and invoice_ids of the customer_ids who've rented those cars.

* Drop two columns from customers table to satisfy 1NF

```
-- Create a new table to hold the cars rented by customers
CREATE TABLE cust_rentals (
  customer_id INT NOT NULL,
  car_id VARCHAR(128) NULL,
  invoice_id VARCHAR(128) NULL
);

-- Drop a column from customers table to satisfy 1NF
ALTER TABLE customers
DROP COLUMN invoice_id,
DROP COLUMN cars_rented;

```

## Converting to 2NF

* Create a new table for the non-key columns that were conflicting with 2NF criteria.

* Drop those non-key columns from customer_rentals.

```
-- Create a new table to satisfy 2NF
CREATE TABLE cars (
  car_id VARCHAR(256) NULL,
  model VARCHAR(128),
  manufacturer VARCHAR(128),
  type_car VARCHAR(128),
  condition VARCHAR(128),
  color VARCHAR(128)
);

-- Drop columns in customer_rentals to satisfy 2NF
ALTER TABLE customer_rentals
DROP COLUMN model,
DROP COLUMN manufacturer, 
DROP COLUMN type_car,
DROP COLUMN condition,
DROP COLUMN color;
```

## Converting to 3NF

* Create a new table for the non-key columns that were conflicting with 3NF criteria.
* Drop those non-key columns from rental_cars.

```
-- Create a new table to satisfy 3NF
CREATE TABLE car_model(
  model VARCHAR(128),
  manufacturer VARCHAR(128),
  type_car VARCHAR(128)
);

-- Drop columns in rental_cars to satisfy 3NF
ALTER TABLE rental_cars
DROP COLUMN manufacturer, 
DROP COLUMN type_car;
```