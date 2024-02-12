# Programming in PySpark RDD's

## Abstracting Data with RDD's
### What is RDD?
RDD = Resilient Distributed Datasets

* Data File on Disk
    * Spark driver creates RDD 
        * Distributes among Nodes


### Decomposing RDDs
* Resilient Distributed Datasets
    * Resilient: Ability to withstand failures
    * Distributed: Spanning across multiple machines
    * Datasets: Collection of partitioned data e.g, Arrays, Tables, Tuples etc.,

### Creating RDDs. How to do it?
* Parallelizing an existing collection of objects
* External datasets:
    * Files in HDFS
    * Objects in Amazon S3 bucket
    * lines in a text file
* From existing RDDs

### Parallelized collection (parallelizing)

* parallelize() for creating RDDs from python lists

```
numRDD = sc.parallelize([1,2,3,4])
helloRDD = sc.parallelize("Hello world")
type(helloRDD)
```

### From external datasets
* textFile() for creating RDDs from external datasets

```
fileRDD = sc.textFile("README.md")
type(fileRDD)
```

### Understanding Partitioning in PySpark
* A partition is a logical division of a large distributed data set
* parallelize() method
```
numRDD = sc.parallelize(range(10), minPartitions = 6)
```

* textFile() method
```
fileRDD = sc.textFile("README.md", minPartitions = 6)
```

* The number of partitions in an RDD can be found by using getNumPartitions() method


## Exercise: RDDS from Parallelized collections

* Create a RDD named RDD from a Python list of words.
* Confirm the object created is RDD.

```
# Create an RDD from a list of words
RDD = sc.parallelize(["Spark", "is", "a", "framework", "for", "Big Data processing"])

# Print out the type of the created object
print("The type of RDD is", type(RDD))
```

## Exercise: RDDs from External Datasets

* Print the file_path in the PySpark shell.
* Create a RDD named fileRDD from a file_path.
* Print the type of the fileRDD created.

```
# Print the file_path
print("The file_path is", file_path)

# Create a fileRDD from file_path
fileRDD = sc.textFile(file_path)

# Check the type of fileRDD
print("The file type of fileRDD is", type(fileRDD))
```

## Exercise: Partitions in your data

* Find the number of partitions that support fileRDD RDD.
* Create an RDD named fileRDD_part from the file path but create 5 partitions.
* Confirm the number of partitions in the new fileRDD_part RDD.

```
# Check the number of partitions in fileRDD
print("Number of partitions in fileRDD is", fileRDD.getNumPartitions())

# Create a fileRDD_part from file_path with 5 partitions
fileRDD_part = sc.textFile(file_path, minPartitions = 5)

# Check the number of partitions in fileRDD_part
print("Number of partitions in fileRDD_part is", fileRDD_part.getNumPartitions())```

```

## Basic RDD Transformations and Actions

* Spark Operations = Transformations + Actions

* Transformations create new RDDs
* Actions perform computation on the RDDs

### RDD Transformations:
* Transformations follow Lazy evaluations

* Example:

* Storage
    * RDD created by reading data from stable storage (RDD1)
        * Transformation (RDD2)
            * Transformation (RDD3)
                * Action (Result)

* Basic RDD Transformations:
* map(), filter(), flatMap(), and union()

#### map() transform
* applies a function to all elements in the RDD

```
RDD = sc.parallelize([1,2,3,4])
RDD_map = RDD.map(lambda x: x * x)
```

#### filter() transform
* returns a new RDD with only the elements that pass the condition

```
RDD = sc.parallelize([1,2,3,4])
RDD_filter = RDD.filter(lambda x: x > 2)
```

#### flatMap() transform
returns multiple values for each element in the original RDD

```
RDD = sc.parallelize(["hello world", "how are you"])
RDD_flatmap = RDD.flatMap(lambda x: x.split(" "))
```

#### union() transform

```
inputRDD = sc.textFile("logs.txt")
errorRDD = inputRDD.filter(lambda x: "error"in x.split())
warningsRDD = inputRDD.filter(lambda x: "warnings"in x.split())
combinedRDD = errorRDD.union(warningsRDD)
```

### RDD Actions
* They are operations that return a value after running a computation on the RDD
* Basic RDD Actions:
    * collect()
    * take(N)
    * first()
    * count()

#### collect() and take() Actions
* collect() return all the elements of the dataset as an array
* take(N) returns an array with the first N elements of the dataset

```
RDD_map.collect()
RDD_map.take(2)

```

#### first() and count() Actions

* first() prints the first element of the RDD
```
RDD_map.first()[1]
```

* count() return the number of elements in the RDD
```
RDD_flatmap.count()
```

## Exercise: Map and Collect

The main method with which you can manipulate data in PySpark is using map(). The map() transformation takes in a function and applies it to each element in the RDD. It can be used to do any number of things, from fetching the website associated with each URL in our collection to just squaring the numbers.

* Create map() transformation that cubes all of the numbers in numbRDD.
* Collect the results in a numbers_all variable.
* Print the output from numbers_all variable.

```
# Create map() transformation to cube numbers
cubedRDD = numbRDD.map(lambda x: x**3)

# Collect the results
numbers_all = cubedRDD.collect()

# Print the numbers from numbers_all
for numb in numbers_all:
	print(numb)
```

## Exercise: Filter and Count

The RDD transformation filter() returns a new RDD containing only the elements that satisfy a particular function. It is useful for filtering large datasets based on a keyword. 

* Create filter() transformation to select the lines containing the keyword Spark.
* How many lines in fileRDD_filter contain the keyword Spark?
* Print the first four lines of the resulting RDD.

```
# Filter the fileRDD to select lines with Spark keyword
fileRDD_filter = fileRDD.filter(lambda line: 'Spark' in line)

# How many lines are there in fileRDD?
print("The total number of lines with the keyword Spark is", fileRDD_filter.count())

# Print the first four lines of fileRDD
for line in fileRDD_filter.take(4):
  print(line)
```

## Pair RDDs in PySpark

* Real life datasets are usually key/value pairs
* Each row is a key and maps to one or more values
* Pair RDD is a special data structure to work with this kind of datasets
* Pair RDD: Key is the identifier and value is the data


Two common ways to create pair RDDs
* From a list of key-value tuple
* From a regular RDD

Get the data into key/value form for paired RDD

```
my_tuple = [('Sam', 23), ('Mary', 34), ('Peter', 25)]
pairRDD_tuple = sc.parallelize(my_tuple)

my_list = ['Sam 23', 'Mary 34', 'Peter 25']
regularRDD = sc.parallelize(my_list)
pairRDD_RDD = regularRDD.map(lambda s: (s.split(' ')[0], s.split(' ')[1]))
```

### Transformations on pair RDDs
* All regular transformations work on pair RDD
* Have to pass functions that operate on key value pairs rather than on individual elements

* Examples of paired RDD Transformations
    * reduceByKey(func): Combine values with the same key
    * groupByKey(): Group values with the same key
    * sortByKey(): Return an RDD sorted by the key
    * join(): Join two pair RDDs based on their key

#### reduceByKey() transformation
transformation combines values with the same key
It runs parallel operations for each key in the dataset
It is a transformation and not action


```
regularRDD = sc.parallelize([("Messi", 23), ("Ronaldo", 34),                              ("Neymar", 22), ("Messi", 24)])

pairRDD_reducebykey = regularRDD.reduceByKey(lambda x,y : x + y)
pairRDD_reducebykey.collect()
```
#### sortByKey() transformation
* orders pair RDD by key
* It returns an RDD sorted by key in ascending or descending 

```
orderpairRDD_reducebykey_rev = pairRDD_reducebykey.map(lambda x: (x[1], x[0]))pairRDD_reducebykey_rev.sortByKey(ascending=False).collect()
```

#### groupByKey() transformation
* groups all the values with the same key in the pair 

```
RDDairports = [("US", "JFK"),("UK", "LHR"),("FR", "CDG"),("US", "SFO")]
regularRDD = sc.parallelize(airports)
pairRDD_group = regularRDD.groupByKey().collect()

for cont, air in pairRDD_group:
    print(cont, list(air))
```

#### join() transformation
* joins the two pair RDDs based on their key

```
RDD1 = sc.parallelize([("Messi", 34),("Ronaldo", 32),("Neymar", 24)])
RDD2 = sc.parallelize([("Ronaldo", 80),("Neymar", 120),("Messi", 100)])
RDD1.join(RDD2).collect()
```

## Exercise: RedceByKey and Collect

One of the most popular pair RDD transformations is reduceByKey() which operates on key, value (k,v) pairs and merges the values for each key. 

* Create a pair RDD named Rdd with tuples (1,2),(3,4),(3,6),(4,5).
* Transform the Rdd with reduceByKey() into a pair RDD Rdd_Reduced by adding the values with the same key.
* Collect the contents of pair RDD Rdd_Reduced and iterate to print the output.

```
# Create PairRDD Rdd with key value pairs
Rdd = sc.parallelize([(1,2),(3,4),(3,6),(4,5)])

# Apply reduceByKey() operation on Rdd
Rdd_Reduced = Rdd.reduceByKey(lambda x, y: y+x)

# Iterate over the result and print the output
for num in Rdd_Reduced.collect(): 
  print("Key {} has {} Counts".format(num[0], num[1]))
```

## Exercise: SortByKey and Collect

Many times it is useful to sort the pair RDD based on the key.

* Sort the Rdd_Reduced RDD using the key in descending order.
* Collect the contents and iterate to print the output.

```
# Sort the reduced RDD with the key by descending order
Rdd_Reduced_Sort = Rdd_Reduced.sortByKey(ascending=False)

# Iterate over the result and retrieve all the elements of the RDD
for num in Rdd_Reduced_Sort.collect():
  print("Key {} has {} Counts".format( num[0], num[1]))
```

## Advanced RDD Actions

### reduce() action
* reduce(func) action is used for aggregating the elements of a regular RDD
* The function should be commutative (changing the order of the operands does not changethe result) and associative
* An example of reduce() action in PySpark

```
x = [1,3,4,6]
RDD = sc.parallelize(x)
RDD.reduce(lambda x, y : x + y)
```
### saveAsTextFile() action
* saves RDD into a text file inside a directory with each partition as a separate file

```
RDD.saveAsTextFile("tempFile")
```
coalesce() method can be used to save RDD as a single text file

```
RDD.coalesce(1).saveAsTextFile("tempFile")
```


## Exercise: CountingByKey
For many datasets, it is important to count the number of keys in a key/value dataset. For example, counting the number of countries where the product was sold or to show the most popular baby names.

* countByKeyand assign the result to a variable total.
* What is the type of total?
* Iterate over the total and print the keys and their counts.

```
# Count the unique keys
total = Rdd.countByKey()

# What is the type of total?
print("The type of total is", type(total))

# Iterate over the total and print the output
for k, v in total.items(): 
  print("key", k, "has", v, "counts")
```

## Create a base RDD and transform it

The volume of unstructured data (log lines, images, binary files) in existence is growing dramatically, and PySpark is an excellent framework for analyzing this type of data through RDDs. 

### Exercise 1 

Here are the brief steps for writing the word counting program:

* Create a base RDD from Complete_Shakespeare.txt file.
* Use RDD transformation to create a long list of words from each element of the base RDD.
* Remove stop words from your data.
* Create pair RDD where each element is a pair tuple of ('w', 1)
* Group the elements of the pair RDD by key (word) and add up their values.
* Swap the keys (word) and values (counts) so that keys is count and value is the word.
* Finally, sort the RDD by descending order and print the 10 most frequent words and their frequencies.

```
# Create a baseRDD from the file path
baseRDD = sc.textFile(file_path)

# Split the lines of baseRDD into words
splitRDD = baseRDD.flatMap(lambda x: x.split())

# Count the total number of words
print("Total number of words in splitRDD:", splitRDD.count())
```
### Exercise 2

Remove stop words from your data. Stop words are common words that are often uninteresting, for example, "I", "the", "a" etc. You can remove many obvious stop words with a list of your own.

* Convert the words in splitRDD in lower case and then remove stop words from stop_words curated list. Think carefully about which function to use here.
* Create a pair RDD tuple containing the word and the number 1 from each word element in splitRDD.
* Get the count of the number of occurrences of each word (word frequency) in the pair RDD. Use a transformation which operates on key, value (k,v) pairs. Think carefully about which function to use here.

```
# Convert the words in lower case and remove stop words from the stop_words curated list
splitRDD_no_stop = splitRDD.filter(lambda x: x.lower() not in stop_words)

# Create a tuple of the word and 1 
splitRDD_no_stop_words = splitRDD_no_stop.map(lambda w: (w,1))

# Count of the number of occurences of each word
resultRDD = splitRDD_no_stop_words.reduceByKey(lambda x, y: x + y)
```
## Print word frequencies

```
# Display the first 10 words and their frequencies from the input RDD
for word in resultRDD.take(10):
	print(word)

# Swap the keys and values from the input RDD
resultRDD_swap = resultRDD.map(lambda x: (x[1], x[0]))

# Sort the keys in descending order
resultRDD_swap_sort = resultRDD_swap.sortByKey(ascending=False)

# Show the top 10 most frequent words and their frequencies from the sorted RDD
for word in resultRDD_swap_sort.take(10):
	print("{},{}". format(word[1], word[0]))
```