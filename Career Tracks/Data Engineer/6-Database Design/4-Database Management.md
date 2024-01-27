#  Database Management

## Database roles and access control

### Granting and revoking access to a view

GRANT privilege(s) or REVOKE privilege(s)

ON object

TO role or FROM role

* Privileges:SELECT, INSERT, UPDATE, DELETE, etc.
* Objects: table, view, schema, etc.
* Roles: a database user or a group of database users.


```
GRANT UPDATE ON ratings TO PUBLIC; 
REVOKE INSERTON films FROM db_user;
```

### Database roles

* Manage database access permissions
* A database role is an entity that contains information that:
    * Define the role's privileges
        * Can you login?
        * Can you create databases?
        * Can you write to tables?
    * Interact with the client authentication system
        * Password
* Roles can be assigned to one or more users
* Roles are global across a database cluster installation

### Create a role

Empty role
```
CREATE ROLE data_analyst;
```
Roles with some attributes set
```
CREATE ROLE intern WITH PASSWORD 'PasswordForIntern' VALID UNTIL '2020-01-01';
```
```
CREATE ROLE admin CREATEDB;
```
```
ALTER ROLE admin CREATEROLE;
```

### GRANT and REVOKE privileges from roles
```
GRANT UPDATE ON ratings TO data_analyst;
REVOKE UPDATE ON ratings FROM data_analyst;
```
The available privileges in PostgreSQL are:SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER, CREATE, CONNECT, TEMPORARY, EXECUTE, and USAGE


### Users and groups (are both roles)

* A role is an entity that can function as a user and/or a group
    * User roles
    * Group roles

Group role
```
CREATE ROLE data_analyst;
```
User role
```
CREATE ROLE intern WITH PASSWORD 'PasswordForIntern' VALID UNTIL '2020-01-01';

GRANT data_analyst TO alex;

REVOKE data_analyst FROM alex;

```

## Create a role

```
-- Create a data scientist role
create role data_scientist;

-- Create a role for Marta
CREATE ROLE marta LOGIN;

-- Create an admin role
create role admin WITH CREATEDB CREATEROLE;
```

## GRANT privileges and ALTER attributes

```
-- Grant data_scientist update and insert privileges
grant update, insert ON long_reviews TO data_scientist;

-- Give Marta's role a password
alter role marta WITH PASSWORD 's3cur3p@ssw0rd';
```


## Add a user role to a group role


```
-- Add Marta to the data scientist group
grant data_scientist to Marta;

-- Celebrate! You hired data scientists.

-- Remove Marta from the data scientist group
revoke data_scientist from Marta;
```


## Table partitioning

Tables grow (100s Gb / Tb)

Problem: queries/updates become slower
Because: e.g., indices don't fit memory
Solution: split table into smaller parts (= partitioning)

* Vertical partitioning: Split table even when fully normalized.

* Horizontal partitioning

```
CREATE TABLE sales (    
    ...
    timestamp DATE NOT NULL)PARTITION BY RANGE (timestamp);
    
CREATE TABLE sales_2019_q1 PARTITION OF sales FOR VALUES FROM ('2019-01-01') TO ('2019-03-31');

...
CREATE TABLE sales_2019_q4 PARTITION OF sales FOR VALUES FROM ('2019-09-01') TO ('2019-12-31');CREATE INDEX ON sales ('timestamp');

```
### Pros/cons of horizontal partitioning

Pros

* Indices of heavily-used partitions fit in memory
* Move to specific medium: slower vs. faster
* Used for both OLAP as OLTP

Cons
* Partitioning existing table can be a hassle
* Some constraints can not be set

## Creating vertical partitions

* Create a new table film_descriptions containing 2 fields: film_id, which is of type INT, and long_description, which is of type TEXT.
* Occupy the new table with values from the film table.

* Drop the field long_description from the film table.

* Join the two resulting tables to view the original table.

```
-- Create a new table called film_descriptions
CREATE TABLE film_descriptions (
    film_id INT,
    long_description TEXT
);

-- Copy the descriptions from the film table
insert into film_descriptions
SELECT film_id,long_description  FROM film;

-- Drop the descriptions from the original table
ALTER TABLE film DROP COLUMN long_description;

-- Join to view the original table
SELECT * FROM film 
JOIN film_descriptions USING(film_id);
```
## Creating horizontal partitions
* Create the table film_partitioned, partitioned on the field release_year.

```
-- Create a new table called film_partitioned
CREATE TABLE film_partitioned (
  film_id INT,
  title TEXT NOT NULL,
  release_year TEXT
)
PARTITION BY LIST (release_year);
```

* Create three partitions: one for each release year: 2017, 2018, and 2019. Call the partition for 2019 film_2019, etc.

```
-- Create the partitions for 2019, 2018, and 2017
CREATE TABLE film_2019
	PARTITION OF film_partitioned FOR VALUES IN ('2019');
    
CREATE TABLE film_2018
	PARTITION OF film_partitioned FOR VALUES IN  ('2018');
    
CREATE TABLE film_2017
	PARTITION OF film_partitioned FOR VALUES IN  ('2017');
```

Occupy the new table, film_partitioned, with the three fields required from the film table.

```
-- Insert the data into film_partitioned
INSERT INTO film_partitioned
SELECT film_id, title, release_year FROM film;

-- View film_partitioned
SELECT * FROM film_partitioned;
```

## Data integration

Data Integration combines data from different sources, formats, technologies to provideusers with a translated and unified view of that data.

### Choosing a data integration tool
* Flexible
* Reliable
* Scalable

## Picking a Database Managemenet System (DBMS)

DBMS

* DBMS: DataBase Management System
* Create and maintain databases
    * Data
    * Database schema
    * Database engine
* Interface between database and end users

### DBMS types
* Choice of DBMS depends on database type
* Two types:SQL DBMSNoSQL DBMS

#### SQL DBMS

* Relational DataBase Management System(RDBMS)
* Based on the relational model of data
* Query language: SQL
* Best option when:
    * Data is structured and unchanging
    * Data must be consistent

#### NoSQL DBMS
* Less structured
* Document-centered rather than table-centered
* Data doesn’t have to fit into well-defined rows and columns

* Best option when:
    * Rapid growth
    * No clear schema definitions
    * Large quantities of data
* Types: key-value store, document store, columnar database, graph database

#### NoSQL DBMS - key-value store
* Combinations of keys and values
    * Key: unique identifier
    * Value: anything
* Use case: managing the shopping cart foran on-line buyer
Example: redis

#### NoSQL DBMS - document store
* Similar to key-value
* Values (= documents) are structured
* Use case: content management
Example: mongoDB

#### NoSQL DBMS - columnar database
* Store data in columns
* Scalable
* Use case: big data analytics where speed is important
Example: Cassandra