# DataFrame Detail

## Intro to data cleaning with Apache Spark

### SparkSchemas
* Define the format of a DataFrame
* May contain various data types:Strings,dates,integers, arrays
* Can filter garbage data during import
* Improves read performance

Import Spark Schema

```
import pyspark.sql.types
peopleSchema = StructType([
    # Define the name field  
    StructField('name', StringType(), True),
    # Add the age field  
    StructField('age', IntegerType(), True),
    # Add the city field  
    StructField('city', StringType(), True)  ])
```

Read CSV file containing data

```
people_df = spark.read.format('csv').load(name='rawdata.csv', schema=peopleSchema)
```

## Exercise: Defining a schema
* Import * from the pyspark.sql.types library.
* Define a new schema using the StructType method.
* Define a StructField for name, age, and city. Each field should correspond to the correct datatype and not be nullable.

```
# Import the pyspark.sql.types library
from pyspark.sql.types import *

# Define a new schema using the StructType method
people_schema = StructType([
  # Define a StructField for each field
  StructField('name', StringType(), False),
  StructField('age', IntegerType(), False),
  StructField('city', StringType(), False)
])
```

## Immutability and lazy processing

Python variables are:
* Mutable, Flexiblity, Potential for issues with concurrency, and Likely adds complexity.

Immutability:
* A component of funcitional programming
* Is defined once
* Unable to be directly modified
* Re-created if reassigned
* Able to be shared efficiently

Immutablity Example

```
voter_df = spark.read.csv('voterdata.csv')
```
Making changes:

```
voter_df = voter_df.withColumn('fullyear',     
                                voter_df.year + 2000)
voter_df = voter_df.drop(voter_df.year)

voter_df.count()
```
## Exercise: Using lazy processing

* Load the Data Frame.
* Add the transformation for F.lower() to the Destination Airport column.
* Drop the Destination Airport column from the Data Frame aa_dfw_df. Note the time for these operations to complete.
* Show the Data Frame, noting the time difference for this action to complete.

```
# Load the CSV file
aa_dfw_df = spark.read.format('csv').options(Header=True).load('AA_DFW_2018.csv.gz')

# Add the airport column using the F.lower() method
aa_dfw_df = aa_dfw_df.withColumn('airport', F.lower(aa_dfw_df['Destination Airport']))

# Drop the Destination Airport column
aa_dfw_df = aa_dfw_df.drop(aa_dfw_df['Destination Airport'])

# Show the DataFrame
aa_dfw_df.show()
```

## Understanding Parquet

Difficulties with CSV files

* No defined schema 
* Nested data requires special handling
* Encoding format limited

Spark and CSV files
* Slow to parse
* Files cannot be filtered 
* Any intermediate use requires redefining schema

The Parquet Format
* A columnar data format
* Supported in Spark and other data processing frameworks
* Supports predicate pushdown
* Automatically stores schema information 

### Working with Parquet

Readin Parquet files

```
df = spark.read.format('parquet').load('filename.parquet')df = spark.read.parquet('filename.parquet')
```

Writing Parquet files

```
df.write.format('parquet').save('filename.parquet')df.write.parquet('filename.parquet')
```

Parquet and SQL
```
flight_df = spark.read.parquet('flights.parquet')
flight_df.createOrReplaceTempView('flights')
short_flights_df = spark.sql('SELECT * FROM flights WHERE flightduration < 100')
```

## Exercise: Saving a DataFrame in Parquet Format

* View the row count of df1 and df2.
* Combine df1 and df2 in a new DataFrame named df3 with the union method.
* Save df3 to a parquet file named AA_DFW_ALL.parquet.
* Read the AA_DFW_ALL.parquet file and show the count.

```
# View the row count of df1 and df2
print("df1 Count: %d" % df1.count())
print("df2 Count: %d" % df2.count())

# Combine the DataFrames into one
df3 = df1.union(df2)

# Save the df3 DataFrame in Parquet format
df3.write.parquet('AA_DFW_ALL.parquet', mode='overwrite')

# Read the Parquet file into a new DataFrame and run a count
print(spark.read.parquet('AA_DFW_ALL.parquet').count())
```

## SQL and Parquet

* Import the AA_DFW_ALL.parquet file into flights_df.
* Use the createOrReplaceTempView method to alias the flights table.
* Run a Spark SQL query against the flights table.

```
# Read the Parquet file into flights_df
flights_df = spark.read.parquet('AA_DFW_ALL.parquet')

# Register the temp table
flights_df.createOrReplaceTempView('flights')

# Run a SQL query of the average flight duration
avg_duration = spark.sql('SELECT avg(flight_duration) from flights').collect()[0]
print('The average flight time is: %d' % avg_duration)
```