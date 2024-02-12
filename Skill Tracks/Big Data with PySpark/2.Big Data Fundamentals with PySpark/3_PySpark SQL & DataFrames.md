# PySpark SQL and DataFrames

## Abstracting Data with DataFrames

* PySpark SQL is a Spark library for structured data. It provides more information about thestructure of data and computation
* PySpark DataFrame is an immutable distributed collection of data with named columnsDesigned for processing both structured (e.g relational database) and semi-structured data(e.g JSON)
* Dataframe API is available in Python, R, Scala, and Java
* DataFrames in PySpark support both SQL queries (SELECT * from table) or expressionmethods (df.select())

### Creating DataFrames in PySpark

* Two different methods of creating DataFrames in PySpark
    * From existing RDDs using SparkSession's createDataFrame() method
    * From various data sources (CSV, JSON, TXT) using SparkSession's read method

* Schema controls the data and helps DataFrames to optimize queries
* Schema provides information about column name, type of data in the column, empty valuesetc.,

### Create a DataFrame form RDD

```
iphones_RDD = sc.parallelize([    ("XS", 2018, 5.65, 2.79, 6.24),    ("XR", 2018, 5.94, 2.98, 6.84),    ("X10", 2017, 5.65, 2.79, 6.13),    ("8Plus", 2017, 6.23, 3.07, 7.12)])

names = ['Model', 'Year', 'Height', 'Width', 'Weight']

iphones_df = spark.createDataFrame(iphones_RDD, schema=names)

type(iphones_df)
```

### Create a DataFrame from reading a CSV/JSON/TXT

```
df_csv = spark.read.csv("people.csv", header=True, inferSchema=True)

df_json = spark.read.json("people.json")

df_txt = spark.read.txt("people.txt")
```
* Path to the file and two optional parameters
* Two optional parameters
    * header=True, inferSchema=True

## RDD to DataFrame

```
# Create an RDD from the list
rdd = sc.parallelize(sample_list)

# Create a PySpark DataFrame
names_df = spark.createDataFrame(rdd, schema=['Name', 'Age'])

# Check the type of names_df
print("The type of names_df is", type(names_df))
```

## Loading CSV into DataFrame


```
# Create an DataFrame from file_path
people_df = spark.read.csv(file_path, header=True, inferSchema=True)

# Check the type of people_df
print("The type of people_df is", type(people_df))

```

## Operating on DataFrames in PySpark

* DataFrame operations: Transformations and Actions
* DataFrame Transformations:
    * select(), filter(), groupby(), orderby(), dropDuplicates(), and withColumnRenamed()
* DataFrame Actions :
    * printSchema(), head(), show(), count(), columns, and describe()

* Correction: printSchema() is a method for any Spark dataset/dataframe and not an action

select() transformation subsets the columns in the DataFrame

```
df_id_age = test.select('Age')

```
show() action prints first 20 rows in the DataFrame
```
df_id_age.show(3)
```

filter() transformation filters out the rows based on a condition

```
new_df_age21 = new_df.filter(new_df.Age > 21)
new_df_age21.show(3)
```
groupby() operation can be used to group a variable

```
test_df_age_group = test_df.groupby('Age')
test_df_age_group.count().show(3)
```

orderby() operation sorts the DataFrame based on one or more columns
```
test_df_age_group.count().orderBy('Age').show(3)
```

dropDuplicates() removes the duplicate rows of a DataFrame
```
test_df_no_dup = test_df.select('User_ID','Gender', 'Age').dropDuplicates()
test_df_no_dup.count()
```

withColumnRenamed() renames a column in the DataFrame
```
test_df_sex = test_df.withColumnRenamed('Gender', 'Sex')
test_df_sex.show(3)
```

printSchema() operation prints the types of columns in the DataFrame
```
test_df.printSchema()
```

columns operator prints the columns of a DataFrame
```
test_df.columns['User_ID', 'Gender', 'Age']
```
describe() operation compute summary statistics of numerical columns in the DataFrame
```
test_df.describe().show()
```
## Exercise: Inspecting data in PySpark DataFrame

* Print the first 10 observations in the people_df DataFrame.
* Count the number of rows in the people_df DataFrame.
* How many columns does people_df DataFrame have and what are their names?

```
# Print the first 10 observations 
people_df.show(10)

# Count the number of rows 
print("There are {} rows in the people_df DataFrame.".format(people_df.count()))

# Count the number of columns and print their names
print("There are {} columns in the people_df DataFrame and their names are {}".format(len(people_df.columns), people_df.columns))
```

## Exercise: PySpark DataFrame subsetting and cleaning

After the data inspection, it is often necessary to clean the data which mainly involves subsetting, renaming the columns, removing duplicated rows etc., PySpark DataFrame API provides several operators to do this.

* Select 'name', 'sex', and 'date of birth' columns from people_df and create people_df_sub DataFrame.
* Print the first 10 observations in the people_df_sub DataFrame.
* Remove duplicate entries from people_df_sub DataFrame and create people_df_sub_nodup DataFrame.
* How many rows are there before and after duplicates are removed?

```
# Select name, sex and date of birth columns
people_df_sub = people_df.select('name', 'sex', 'date of birth')

# Print the first 10 observations from people_df_sub
people_df_sub.show(10)

# Remove duplicate entries from people_df_sub
people_df_sub_nodup = people_df_sub.dropDuplicates()

# Count the number of rows
print("There were {} rows before removing duplicates, and {} rows after removing duplicates".format(people_df_sub.count(), people_df_sub_nodup.count()))
```

## Exercise: Filtering your DataFrame

* Filter the people_df DataFrame to select all rows where sex is female into people_df_female DataFrame.
* Filter the people_df DataFrame to select all rows where sex is male into people_df_male DataFrame.
* Count the number of rows in people_df_female and people_df_male DataFrames.

```
# Filter people_df to select females 
people_df_female = people_df.filter(people_df.sex == "female")

# Filter people_df to select males
people_df_male = people_df.filter(people_df.sex == "male")

# Count the number of rows 
print("There are {} rows in the people_df_female DataFrame and {} rows in the people_df_male DataFrame".format(people_df_female.count(), people_df_male.count()))
```

## Interacting with DataFrames using PySpark SQL

* The SparkSession sql() method executes SQL 
* querysql() method takes a SQL statement as an argument and returns the result as DataFrame

```
df.createOrReplaceTempView("table1")
df2 = spark.sql("SELECT field1, field2 FROM table1")
df2.collect()
```

Extract Data
```
test_df.createOrReplaceTempView("test_table")
query = '''SELECT Product_ID FROM test_table'''
test_product_df = spark.sql(query)
test_product_df.show(5)
```

Summarizing and grouping data using SQL queries
```
test_df.createOrReplaceTempView("test_table")
query = '''SELECT Age, max(Purchase) FROM test_table GROUP BY Age'''
spark.sql(query).show(5)
```

Filtering columns using SQL queries
```
test_df.createOrReplaceTempView("test_table")
query = '''SELECT Age, Purchase, Gender FROM test_table WHERE Purchase > 20000 AND Gender == "F"'''
spark.sql(query).show(5)
```

## Exercise: Running SQL Queries Programmatically

* Create a temporary table people that's a pointer to the people_df DataFrame.
* Construct a query to select the names of the people from the temporary table people.
* Assign the result of Spark's query to a new DataFrame - people_df_names.
* Print the top 10 names of the people from people_df_names DataFrame.

```
# Create a temporary table "people"
people_df.createOrReplaceTempView("people")

# Construct a query to select the names of the people from the temporary table "people"
query = '''SELECT name FROM people'''

# Assign the result of Spark's query to people_df_names
people_df_names = spark.sql(query)

# Print the top 10 names of the people
people_df_names.show(10)
```
## SQL queries for filtering Table

* Filter the people table to select all rows where sex is female into people_female_df DataFrame.
* Filter the people table to select all rows where sex is male into people_male_df DataFrame.
* Count the number of rows in both people_female and people_male DataFrames.

```
# Filter the people table to select female sex 
people_female_df = spark.sql('SELECT * FROM people WHERE sex=="female"')

# Filter the people table DataFrame to select male sex
people_male_df = spark.sql('SELECT * FROM people WHERE sex=="male"')

# Count the number of rows in both people_df_female and people_male_df DataFrames
print("There are {} rows in the people_female_df and {} rows in the people_male_df DataFrames".format(people_female_df.count(), people_male_df.count()))
```

## Data Visualization in PySpark using DataFrames

* What is Data visualization?
* Data visualization is a way of representing your data in graphs or charts
* Open source plotting tools to aid visualization in Python:
    Matplotlib, Seaborn, Bokeh etc.,
* Plotting graphs using PySpark DataFrames is done using three methods
    * pyspark_dist_explore 
    * librarytoPandas()
    * HandySpark library


Data Visualization using Pyspark_dist_explore
* Pyspark_dist_explore library provides quick insights into DataFrames
* Currently three functions available : hist(), distplot(), and pandas_histogram()

```
test_df = spark.read.csv("test.csv", header=True, inferSchema=True)
test_df_age = test_df.select('Age')
hist(test_df_age, bins=20, color="red")
```

Using Pandas for plotting DataFrames
* It's easy to create charts from pandas DataFrames
```
test_df = spark.read.csv("test.csv", header=True, inferSchema=True)
test_df_sample_pandas = test_df.toPandas()
test_df_sample_pandas.hist('Age')
```

HandySpark method of visualization
* HandySpark is a package designed to improve PySpark user experience
* Easy data fetching
* Distributed computation retained

```
test_df = spark.read.csv('test.csv', header=True, inferSchema=True)
hdf = test_df.toHandy()
hdf.cols["Age"].hist()
```

## Exercise: PySaprk DataFrame Visualization

* Print the names of the columns in names_df DataFrame.
* Convert names_df DataFrame to df_pandas Pandas DataFrame.
* Use matplotlib's plot() method to create a horizontal bar plot with 'Name' on x-axis and 'Age' on y-axis.

```
# Check the column names of names_df
print("The column names of names_df are", names_df.columns)

# Convert to Pandas DataFrame  
df_pandas = names_df.toPandas()

# Create a horizontal bar plot
df_pandas.plot(kind='barh', x='Name', y='Age', colormap='winter_r')
plt.show()
```

## Create a DataFrame from CSV file, SQL Queries on DataFrame and Datavisualization

### Exercise part 1

* Create a PySpark DataFrame from file_path (which is the path to the Fifa2018_dataset.csv file).
* Print the schema of the DataFrame.
* Print the first 10 observations.
* How many rows are in there in the DataFrame?

```
# Load the Dataframe
fifa_df = spark.read.csv(file_path, header=True, inferSchema=True)

# Check the schema of columns
fifa_df.printSchema()

# Show the first 10 observations
fifa_df.show(10)

# Print the total number of rows
print("There are {} rows in the fifa_df DataFrame".format(fifa_df.count()))
```

### Exercise part 2

* Create temporary table fifa_df_table from fifa_df DataFrame.
* Construct a "query" to extract the "Age" column from Germany players in fifa_df_table.
* Apply the SQL "query" and create a new DataFrame fifa_df_germany_age.
* Computes basic statistics of the created DataFrame.

```
# Create a temporary view of fifa_df
fifa_df.createOrReplaceTempView('fifa_df_table')

# Construct the "query"
query = '''SELECT Age FROM fifa_df_table WHERE Nationality == "Germany"'''

# Apply the SQL "query"
fifa_df_germany_age = spark.sql(query)

# Generate basic statistics
fifa_df_germany_age.describe().show()
```
### Exercise part 3

* Convert fifa_df_germany_age to fifa_df_germany_age_pandas Pandas DataFrame.
* Generate a density plot of the 'Age' column from the fifa_df_germany_age_pandas Pandas DataFrame.

```
# Convert fifa_df to fifa_df_germany_age_pandas DataFrame
fifa_df_germany_age_pandas = fifa_df_germany_age.toPandas()

# Plot the 'Age' density of Germany Players
fifa_df_germany_age_pandas.plot(kind='density')
plt.show()
```