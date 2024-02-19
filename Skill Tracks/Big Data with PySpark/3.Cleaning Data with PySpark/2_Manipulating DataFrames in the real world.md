# Manipulating DataFrames in the real workd

## DataFrame column operations

DataFrames:
* Rows and columns
* Inmutables
* Use various transformation operations to modify data

```
# Return rows where name starts with "M" 
voter_df.filter(voter_df.name.like('M%'))
# Return name and position only
voters = voter_df.select('name', 'position')
```

Common DataFrame transformations 
* Filter/Where
```
voter_df.filter(voter_df.date > '1/1/2019') # or voter_df.where(...)
```
* Select
```
voter_df.select(voter_df.name)
```

* withColumn
```
voter_df.withColumn('year', voter_df.date.year)
```
* drop
```
voter_df.drop('unused_column')
```

Filtering Data:
* Remove nulls
* Remove odd entries
* Split data from combined sources
* Negate with ~

```
voter_df.filter(voter_df['name'].isNotNull())
voter_df.filter(voter_df.date.year > 1800)
voter_df.where(voter_df['_c0'].contains('VOTE'))
voter_df.where(~ voter_df._c1.isNull())
```

### Column string transformations
* Contained in pyspark.sql.functions 
import pyspark.sql.functions as F

* Applied per column as transformation 
voter_df.withColumn('upper', F.upper('name'))
* Can create intermediary columns
voter_df.withColumn('splits', F.split('name', ' '))
Can cast to other types
voter_df.withColumn('year', voter_df['_c4'].cast(IntegerType()))

## Exercise: Filtering column content with Python

* Show the distinct VOTER_NAME entries.
* Filter voter_df where the VOTER_NAME is 1-20 characters in length.
* Filter out voter_df where the VOTER_NAME contains an _.
* Show the distinct VOTER_NAME entries again.

```
# Show the distinct VOTER_NAME entries
voter_df.select(F.col('VOTER_NAME')).distinct().show(40, truncate=False)


# Filter voter_df where the VOTER_NAME is 1-20 characters in length
voter_df = voter_df.filter('length(VOTER_NAME) > 0 and length(VOTER_NAME) < 20')

# Filter out voter_df where the VOTER_NAME contains an underscore
voter_df = voter_df.filter(~ F.col('VOTER_NAME').contains('_'))

# Show the distinct VOTER_NAME entries again
voter_df.select(F.col('VOTER_NAME')).distinct().show(40, truncate=False)

```

## Exercise: Modifying DataFrame columns

* Add a new column called splits holding the list of possible names.
* Use the getItem() method and create a new column called first_name.
* Get the last entry of the splits list and create a column called last_name.
* Drop the splits column and show the new voter_df.

```
# Add a new column called splits separated on whitespace
voter_df = voter_df.withColumn('splits', F.split(voter_df.VOTER_NAME, '\s+'))


# Create a new column called first_name based on the first item in splits
voter_df = voter_df.withColumn('first_name', voter_df.splits.getItem(0))

# Get the last entry of the splits list and create a column called last_name
voter_df = voter_df.withColumn('last_name', voter_df.splits.getItem(F.size('splits') - 1))

# Drop the splits column
voter_df = voter_df.drop('splits')

# Show the voter_df DataFrame
voter_df.show()
```

## Conditional DataFrame column operations

Conditional clauses:
* Inline version of if/then/else
* .when()
* .otherwise()

```
.when(<if condition>, <then x>)

df.select(df.Name, df.Age, F.when(df.Age >= 18, "Adult"))
```
Multiple.when()

```
df.select(df.Name, df.Age,           
        .when(df.Age >= 18, "Adult")          
        .when(df.Age < 18, "Minor"))

```

.otherwise() is like else
```
df.select(df.Name, df.Age,          
        .when(df.Age >= 18, "Adult")          
        .otherwise("Minor"))

```

## Exercise: when() example

* Add a column to voter_df named random_val with the results of the F.rand() method for any voter with the title Councilmember.
* Show some of the DataFrame rows, noting whether the .when() clause worked.

```
# Add a column to voter_df for any voter with the title **Councilmember**
voter_df = voter_df.withColumn('random_val',
                               F.when(voter_df.TITLE == 'Councilmember', F.rand()))

# Show some of the DataFrame rows, noting whether the when clause worked
voter_df.show()
```

## Exercise: When / Otherwise

* Add a column to voter_df named random_val with the results of the F.rand() method for any voter with the title Councilmember. Set random_val to 2 for the Mayor. Set any other title to the value 0.
* Show some of the Data Frame rows, noting whether the clauses worked.
* Use the .filter clause to find 0 in random_val.

```
# Add a column to voter_df for a voter based on their position
voter_df = voter_df.withColumn('random_val',
                               F.when(voter_df.TITLE == 'Councilmember', F.rand())
                               .when(voter_df.TITLE == 'Mayor', 2)
                               .otherwise(0)
                               )

# Show some of the DataFrame rows
voter_df.show()

# Use the .filter() clause with random_val
voter_df.filter(voter_df.random_val == 0).show()
```

## User defined functions

User defined functions or UDFs:
* Python method
* Wrapped via the pyspark.sql.functions.udf method
* Stored as a variable
* Called like a normal Spark function

Reverse string UDF:
Define a Python method
```
def reverseString(mystr):
        return mystr[::-1]
```

Wrap the function and store as a variable

```
udfReverseString = udf(reverseString, StringType())
```

Use with Spark 

```
user_df = user_df.withColumn('ReverseName',                  
                        udfReverseString(user_df.Name))
```

### Argument-less example
```
def sortingCap():
        return random.choice(['G', 'H', 'R', 'S'])
udfSortingCap = udf(sortingCap, StringType())
user_df = user_df.withColumn('Class', udfSortingCap())
```

## Exercise: User defined functions in Spark

* Edit the getFirstAndMiddle() function to return a space separated string of names, except the last entry in the names list.
* Define the function as a user-defined function. It should return a string type.
* Create a new column on voter_df called first_and_middle_name using your UDF.
* Show the Data Frame.

```
def getFirstAndMiddle(names):
  # Return a space separated string of names
  return ' '.join(names[:-1])

# Define the method as a UDF
udfFirstAndMiddle = F.udf(getFirstAndMiddle, StringType())

# Create a new column using your UDF
voter_df = voter_df.withColumn('first_and_middle_name', udfFirstAndMiddle(voter_df.splits))

# Show the DataFrame
voter_df.show()
```

## Partitioning and lazy processing

* DataFrames are broken up into partitions
* Partition size can vary
* Each partition is handled independently

Lazy processing
* Transformations are lazy
        * .withcolumn()
        * .select()
* Nothing is actually done until an action is performed
        * .count()
        * .write()

* Transformations can be re-ordered for best performance
* Sometimes causes unexpected behavior


## Exercise: Adding an ID Field

* Select the unique entries from the column VOTER NAME and create a new DataFrame called voter_df.
* Count the rows in the voter_df DataFrame.
* Add a ROW_ID column using the appropriate Spark function.
* Show the rows with the 10 highest ROW_IDs.

```
# Select all the unique council voters
voter_df = df.select(df["VOTER NAME"]).distinct()

# Count the rows in voter_df
print("\nThere are %d rows in the voter_df DataFrame.\n" % voter_df.count())

# Add a ROW_ID
voter_df = voter_df.withColumn('ROW_ID', F.monotonically_increasing_id())

# Show the rows with 10 highest IDs in the set
voter_df.orderBy(voter_df.ROW_ID.desc()).show(10)
```

## Exercise: IDs with different partitions

* To check the number of partitions, use the method .rdd.getNumPartitions() on a DataFrame.
* Print the number of partitions on each DataFrame.
* Add a ROW_ID field to each DataFrame.
* Show the top 10 IDs in each DataFrame.

```
# Print the number of partitions in each DataFrame
print("\nThere are %d partitions in the voter_df DataFrame.\n" % voter_df.rdd.getNumPartitions())
print("\nThere are %d partitions in the voter_df_single DataFrame.\n" % voter_df_single.rdd.getNumPartitions())

# Add a ROW_ID field to each DataFrame
voter_df = voter_df.withColumn('ROW_ID', F.monotonically_increasing_id())
voter_df_single = voter_df_single.withColumn('ROW_ID', F.monotonically_increasing_id())

# Show the top 10 IDs in each DataFrame 
voter_df.orderBy(voter_df.ROW_ID.desc()).show(10)
voter_df_single.orderBy(voter_df_single.ROW_ID.desc()).show(10)
```

## Exercise: More ID tricks
* Determine the highest ROW_ID in voter_df_march and save it in the variable previous_max_ID. The statement .rdd.max()[0] will get the maximum ID.
* Add a ROW_ID column to voter_df_april starting at the value of previous_max_ID.
* Show the ROW_ID's from both Data Frames and compare.

```
# Determine the highest ROW_ID and save it in previous_max_ID
previous_max_ID = voter_df_march.select('ROW_ID').rdd.max()[0]

# Add a ROW_ID column to voter_df_april starting at the desired value
voter_df_april = voter_df_april.withColumn('ROW_ID', F.monotonically_increasing_id() + previous_max_ID)

# Show the ROW_ID from both DataFrames and compare
voter_df_march.select('ROW_ID').show()
voter_df_april.select('ROW_ID').show()
```