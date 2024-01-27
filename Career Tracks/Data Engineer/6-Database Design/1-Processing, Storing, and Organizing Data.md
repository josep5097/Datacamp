#  Processing, Storing, and Organizing Data

## OLTP and OLAP

### How should we organize and manage data?
* Schemas: How should my data be logically organized?
* Normalization: Should my data have minimal dependency and redundancy?
* Views: What joins will be done most often?
* Access control: Should all users of the data have the same level of access
* DBMS: How do I pick between all the SQL and noSQL options?

### Approaches to processing data
* OLTP: Online Transaction Processing
    * Find the price of a book
    * Update latest customer transaction
    * Keep track of employee hours

* OLAP: Online Analytical Processing
    * Calculate books with best profit margin
    * Find most loyal customers
    * Decide employee of the month

| |OLTP |OLAP|
|- |-|- |
|Purpose| support daily transactions| report and analyze| data
|Design| application-oriented| subject-oriented|
|Data| up-to-date, operational| consolidated, historical| 
|Size|snapshot, gigaby| tesarchive, terabytes|
|Queries|simple transactions & frequentupdates| complex, aggregate queries & limited updates| 
|Users|thousands | hundreds|


```
CODE
```

## Storing Data

1. Structured data
    * Follows a schema
    * Defined data types & relationships_e.g., SQL, tables in a relational database _
    
2. Unstructured data 
    * Schemaless
    * Makes up most of data in the worlde.g., photos, chat logs, MP3
3. Semi-structured data
    * Does not follow larger schema
    * Self-describing structuree.g., NoSQL, XML, JSON
    

```
# Example of a JSON file

"user": {     "profile_use_background_image": true,      "statuses_count": 31,      "profile_background_color": "C0DEED",      "followers_count": 3066,      ...

```

### Storing data beyond traditional databases

* Traditional databases
    * For storing real-time relational structured data ? OLTP
* Data warehouses
    * For analyzing archived structured data ? OLAP
* Data lakes
    * For storing data of all structures = flexibility and scalability
    * For analyzing big data


### Data warehouses
* Optimized for analytics - OLAP
    * Organized for reading/aggregating data
    * Usually read-only
* Contains data from multiple sources
* Massively Parallel Processing (MPP)
* Typically uses a denormalized schema and dimensional modeling

### Data marts
* Subset of data warehouses
* Dedicated to a specific topic

### Data lakes
* Store all types of data at a lower cost:e.g., raw, operational databases, IoT device logs, real-time, relational and non-relational
* Retains all data and can take up petabytes
* Schema-on-read as opposed to schema-on-write
* Need to catalog data otherwise becomes a data swamp
* Run big data analytics using services such as Apache Spark and Hadoop
    * Useful for deep learning and data discovery because activities require so much data



## Database design


### Data modeling

 Process of creating a data model for the data to be stored

1. Conceptual data model: describes entities, relationships, and attributes
    * Tools: data structure diagrams, e.g., entity-relational diagrams and UML diagrams
2. Logical data model: defines tables, columns, relationships
    * Tools: database models and schemas, e.g., relational model and star schema
3. Physical data model: describes physical storage
    * Tools: partitions, CPUs, indexes, backup systems and tablespaces

```
CODE
```


## Deciding fact and dimension tables


```
-- Create a route dimension table
CREATE TABLE route (
	route_id INTEGER PRIMARY KEY,
    park_name VARCHAR(160) NOT NULL,
    city_name VARCHAR(160) NOT NULL,
    distance_km FLOAT NOT NULL,
    route_name VARCHAR(160) NOT NULL
);
-- Create a week dimension table
CREATE TABLE week(
    week_id INTEGER PRIMARY KEY,
    week INTEGER NOT NULL,
    month VARCHAR(160) NOT NULL,
    year INTEGER NOT NULL
);
```


## Querying the dimensional model


```
SELECT 
	-- Get the total duration of all runs
	SUM(duration_mins)
FROM 
	runs_fact
-- Get all the week_id's that are from July, 2019
INNER JOIN week_dim ON week_dim.week_id = runs_fact.week_id
WHERE week_dim.month = 'July' and week_dim.year = '2019';
```