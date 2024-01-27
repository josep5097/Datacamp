# Database Views

## Database views

### Database views

        In a database, a view is the result set of a stored query on the data, which the databaseusers can query just as they would in a persistent database collection object (Wikipedia)

Virtual table that is not part of the physical schema
* Query, not data, is stored in memory
* Data is aggregated from data in tables
* Can be queried like a regular database table
* No need to retype common queries or alter schemas

```
CREATE VIEW view_name AS SELECT col1, col2 FROM table_name WHEREcondition;
DATABASE
```

```
CREATE VIEW scifi_books AS SELECT title,  author, genre FROM dim_book_sf JOIN dim_genre_sf ON dim_genre_sf.genre_id = dim_book_sf.genre_id JOIN dim_author_sf ON dim_author_sf.author_id = dim_book_sf.author_id WHERE dim_genre_sf.genre ='science fiction';

```

### Benefits of views
* Doesn't take up storage
* A form of access control
    * Hide sensitive columns and restrict what user can see
* Masks complexity of queries
    * Useful for highly normalized schemas

## Viewing views

* Query the information schema to get views.
* Exclude system views in the results.

```
SELECT * FROM information_schema.views
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');
```


## Creating and querying a view

* Create a view called high_scores that holds reviews with scores above a 9.

```
-- Create a view for reviews with a score above 9
Create view high_scores as
SELECT * FROM reviews
WHERE score > 9;
```

* Count the number of records in high_scores that are self-released in the label field of the labels table.

```
-- Count the number of self-released works in high_scores
SELECT COUNT(*) FROM high_scores
INNER JOIN labels ON high_scores.reviewid = labels.reviewid
WHERE labels.label = 'self-released';
```

## Managing views

### Granting and revoking access to a view

GRANT privilege(s) or REVOKE privilege(s)

ON object
TO role or FROM role

* Privileges:SELECT, INSERT, UPDATE, DELETE, etc
* Objects: table, view, schema, etc
* Roles: a database user or a group of database users



```
GRANT UPDATE ON ratings TO PUBLIC;  REVOKE INSERT ON films FROM db_user;

```

* Not all views are updatable
* Not all views are insertable

Dropping a view

```
DROP VIEW view_name [ CASCADE | RESTRICT ];
```

* RESTRICT (default): returns an error if there are objects that depend on the view
* CASCADE: drops view and any object that depends on that view

### Redefining a view
```
CREATE OR REPLACE VIEW view_name AS new_query
```

* If a view with view_name exists, it is replaced 
* new_query must generate the same column names, order, and data types as the old query
* The column output may be different
* New columns may be added at the end
* If these criteria can't be met, drop the existing view and create a new one

### Altering a view

```
ALTER VIEW [ IF EXISTS ] name ALTER [ COLUMN ] column_name SET DEFAULT expression
ALTER VIEW [ IF EXISTS ] name ALTER [ COLUMN ] column_name DROPDEFAULT
ALTER VIEW [ IF EXISTS ] name OWNER TO new_owner
ALTER VIEW [ IF EXISTS ] name RENAME TO new_name
ALTER VIEW [ IF EXISTS ] name SET SCHEMA new_schema
ALTER VIEW [ IF EXISTS ] name SET ( view_option_name [= view_option_value] [, ... ] ALTER VIEW [ IF EXISTS ] name RESET ( view_option_name [, ... ] )
```


## Creating a view form other views

* Create a view called top_artists_2017 with artist from artist_title.
* To only return the highest scoring artists of 2017, join the views top_15_2017 and artist_title on reviewid.
* Output top_artists_2017.

```
-- Create a view with the top artists in 2017
create view top_artists_2017 as
-- with only one column holding the artist field
SELECT artist_title.artist FROM artist_title
INNER JOIN top_15_2017
ON artist_title.reviewid = top_15_2017.reviewid;

-- Output the new view
SELECT * FROM top_artists_2017;
```

Which is the DROP command that would drop both top_15_2017 and top_artists_2017?

```
DROP VIEW top_15_2017 CASCADE;
```

## Granting and revoking access

* Revoke all database users' update and insert privileges on the long_reviews view.

* Grant the editor user update and insert privileges on the long_reviews view.

```
-- Revoke everyone's update and insert privileges
REVOKE UPDATE, INSERT ON long_reviews FROM PUBLIC; 

-- Grant the editor update and insert privileges 
GRANT UPDATE, INSERT ON long_reviews TO editor;
```

## Redefining a view

* Use CREATE OR REPLACE to redefine the artist_title view.
* Respecting artist_title's original columns of reviewid, title, and artist, add a label column from the labels table.
* Join the labels table using the reviewid field.

```
-- Redefine the artist_title view to have a label column
CREATE OR REPLACE VIEW artist_title AS
SELECT reviews.reviewid, reviews.title, artists.artist, labels.label
FROM reviews
INNER JOIN artists
ON artists.reviewid = reviews.reviewid
INNER JOIN labels
ON labels.reviewid = reviews.reviewid;

SELECT * FROM artist_title;
```

##  Materialized views

```
CREATE MATERIALIZED VIEW my_mv ASSELECT*FROM existing_table;

REFRESH MATERIALIZED VIEW my_mv;

```
### Managing dependencies
* Materialized views often depend on other materialized views
* Creates a dependency chain when refreshing views
* Not the most efficient to refresh all views at the same time


## Materialized versus non materialized

* Create a materialized view called genre_count that holds the number of reviews for each genre.
* Refresh genre_count so that the view is up-to-date.

```
-- Create a materialized view called genre_count 
CREATE MATERIALIZED VIEW genre_count AS
SELECT genre, COUNT(*) 
FROM genres
GROUP BY genre;

INSERT INTO genres
VALUES (50000, 'classical');

-- Refresh genre_count
REFRESH MATERIALIZED VIEW genre_count;

SELECT * FROM genre_count;
```


## Creating and refreshing a materialized view


```
CODE
```