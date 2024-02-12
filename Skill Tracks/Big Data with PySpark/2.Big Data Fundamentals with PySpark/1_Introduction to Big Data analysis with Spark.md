# Introduction to Big Data analysis with Spark

## What is Big Data?

* Volume, Variety and Velocity
    * Volume: Size of the data
    * Variety: Different sources and formats
    * Velocity: Speed of the data


### Big Data concepts and Terminology
* Clustered computing: Collection of resources of multiple machines
* Parallel computing: Simultaneous computation on single computer
* Distributed computing: Collection of nodes (networked computers) that run in parallel
* Batch processing: Breaking the job into small pieces and running them on individualmachines
* Real-time processing: Immediate processing of data


### Big Data processing systems

* Hadoop/MapReduce: Scalable and fault tolerant framework written in Java
    * Open source
    * Batch processing
* Apache Spark: General purpose and lightning fast cluster computing system
    * Open source
    * Both batch and real-time data processing

Note: Apache Spark is nowadays preferred over Hadoop/MapReduce

### Features of Apache Spark framework
* Distributed cluster computing framework
* Efficient in-memory computations for large data sets
* Lightning fast data processing framework
* Provides support for Java, Scala, Python, R and SQL


## PySpark: Spark with Python

### Understanding SparkContext
* SparkContext is an entry point into the world of Spark
* An entry point is a way of connecting to Spark cluster
* An entry point is like a key to the house
* PySpark has a default SparkContext called sc

Version: To retrieve SparkContext version
```
sc.version
```

Python Version: To retrieve Python version of SparkContext

```
sc.pythonVer
```

Master: URL of the cluster or local string to run in local mode of SparkContext

```
sc.master
```

## Understanding SparkContext

When we run any Spark application, a driver program starts, which has the main function and your SparkContext gets initiated here. PySpark automatically creates a SparkContext for you in the PySpark shell (so you don't have to create it by yourself) and is exposed via a variable sc.


## Exercise: Interactive Use of PySpark

* Create a Python list named numb containing the numbers 1 to 100.
* Load the list into Spark using Spark Context's parallelize method and assign it to a variable spark_data.

```
# Create a Python list of numbers from 1 to 100 
numb = range(1, 100)

# Load the list into PySpark  
spark_data = sc.parallelize(numb)
```

## Loading data in PySpark Shell

In PySpark, we express our computation through operations on distributed collections that are automatically parallelized across the cluster.

```
# Load a local file into PySpark shell
lines = sc.textFile(file_path)
```

## Review of functional programming in Python

### What are anonymous functions in Python?

* Lambda functions are anonymous functions in Python
* Very powerful and used in Python. Quite efficient with map() and filter()
* Lambda functions create functions to be called later similar to def
* It returns the functions without any name (i.e anonymous)
* Inline a function definition or to defer execution of a code

```
lambda arguments: expression
```

Example of lambda function

```
double = lambda x: x * 2
print(double(3))
```

### Use of Lambda function in Python - map()

* map() applies a function to all items in the input list
* General syntax of map()
```
map(function, list)
```

Example of map()
```
items = [1, 2, 3, 4]
list(map(lambda x: x + 2 , items))
```

### Use of Lambda function in python - filter()

* filter() function takes a function and a list and returns a new list for which the function evaluates as true
* General syntax of filter()
```
filter(function, list)
```

Example of filter()
```
items = [1, 2, 3, 4]
list(filter(lambda x: (x%2 != 0), items))
```

## Exercise: Use of lambda() with map()

The map() function in Python returns a list of the results after applying the given function to each item of a given iterable (list, tuple etc.). The general syntax of map() function is map(fun, iter). We can also use lambda functions with map().

* Print my_list which is available in your environment.
* Square each item in my_list using map() and lambda().
* Print the result of map function.

```
# Print my_list in the console
print("Input list is", my_list)

# Square all numbers in my_list
squared_list_lambda = list(map(lambda x: x**2, my_list))

# Print the result of the map function
print("The squared numbers are", squared_list_lambda)

```

## Exercise: Use of lambda() with filter()
Another function that is used extensively in Python is the filter() function. The filter() function in Python takes in a function and a list as arguments. Similar to the map(), filter() can be used with lambda function. 

* Print my_list2 which is available in your environment.
* Filter the numbers divisible by 10 from my_list2 using filter() and lambda().
* Print the numbers divisible by 10 from my_list2.

```
# Print my_list2 in the console
print("Input list is:", my_list2)

# Filter numbers divisible by 10
filtered_list = list(filter(lambda x: (x%10 == 0), my_list2))

# Print the numbers divisible by 10
print("Numbers divisible by 10 are:", filtered_list)
```
