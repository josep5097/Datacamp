# Machine Learning with PySpark MLib

## Overview of PySpak MLib

* Various tools provided by MLlib include:
    * ML Algorithms: collaborative filtering, classification, and clustering
    * Featurization: feature extraction, transformation, dimensionality reduction, and selection
    * Pipelines: tools for constructing, evaluating, and tuning ML Pipelines

* Scikit-learn algorithms only work for small datasets on a single machine
    * Spark's MLlib algorithms are designed for parallel processing on a cluster
    * Supports languages such as Scala, Java, and R


* MLlib Algorithms
    * Classification (Binary and Multiclass) and Regression: Linear SVMs, logistic regression,decision trees, random forests, gradient-boosted trees, naive Bayes, linear least squares,Lasso, ridge regression, isotonic regression
    * Collaborative filtering: Alternating least squares (ALS)
    * Clustering: K-means, Gaussian mixture, Bisecting K-means and Streaming K-Means

### PySpark MLlib imports

* Collaborative filtering

```
from pyspark.mllib.recommendation import ALS
```

* Classification

```
from pyspark.mllib.classification import LogisticRegressionWithLBFGS
```

* Clustering

```
from pyspark.mllib.clustering import KMeans
```

## Exercise: PySpark MLib algorithms

* Import pyspark.mllib recommendation submodule and Alternating Least Squares class.
* Import pyspark.mllib classification submodule and Logistic Regression with LBFGS class.
* Import pyspark.mllib clustering submodule and kmeans class.

```
# Import the library for ALS
from pyspark.mllib.recommendation import ALS

# Import the library for Logistic Regression
from pyspark.mllib.classification import LogisticRegressionWithLBFGS

# Import the library for Kmeans
from pyspark.mllib.clustering import KMeans
```

## Collaborative filtering

* Common interests
* Recommender systems
* Approaches:
    * User-User Collaborative filtering: Finds users that are similar to the target user
    * Item-Item Collaborative filtering: Finds and recommend items that are similar to items withe the target user

### Rating class in pyspark.mllib.recommendation submodule
* The Rating class is a wrapper around tuple (user, product and rating)
* Useful for parsing the RDD and creating a tuple of user, product and rating
```
from pyspark.mllib.recommendation import Rating 
r = Rating(user = 1, product = 2, rating = 5.0)
(r[0], r[1], r[2])
```

### PYSPARK Splitting the data using randomSplit()
* Splitting data into training and testing sets is important for evaluating predictive modeling
* Typically a large portion of data is assigned to training compared to testing data
* PySpark's randomSplit() method randomly splits with the provided weights and returns multiple RDD

```
sdata = sc.parallelize([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

training, test=data.randomSplit([0.6, 0.4])
training.collect()
test.collect()

```

### Alternating Least Squares (ALS)

* Alternating Least Squares (ALS) algorithm in spark.mllib provides collaborative filtering
* ALS.train(ratings, rank, iterations)



```
r1 = Rating(1, 1, 1.0)
r2 = Rating(1, 2, 2.0)
r3 = Rating(2, 1, 2.0)
ratings = sc.parallelize([r1, r2, r3])
ratings.collect()

model = ALS.train(ratings, rank=10, iterations=10)
```

### predictAll()
* The predictAll() method returns a list of predicted ratings for input user and product pair
* The method takes in a RDD without ratings to generate the ratings


```
unrated_RDD = sc.parallelize([(1, 2), (1, 1)])
predictions = model.predictAll(unrated_RDD)
predictions.collect()
```

### Model evaluation

```
rates = ratings.map(lambda x: ((x[0], x[1]), x[2]))
rates.collect()

preds = predictions.map(lambda x: ((x[0], x[1]), x[2]))
preds.collect()

rates_preds = rates.join(preds)
rates_preds.collect()
```

The MSE is the average value of the square of(actual rating - predicted rating)

```
MSE = rates_preds.map(lambda r: (r[1][0] - r[1][1])**2).mean()
```


## Exercise: Loading Movie Lens dataset into RDDs

* Load the ratings.csv dataset into an RDD.
* Split the RDD using , as a delimiter.
* For each line of the RDD, using Rating() class create a tuple of userID, productID, rating.
* Randomly split the data into training data and test data (0.8 and 0.2).

```
# Load the data into RDD
data = sc.textFile(file_path)

# Split the RDD 
ratings = data.map(lambda l: l.split(','))

# Transform the ratings RDD 
ratings_final = ratings.map(lambda line: Rating(int(line[0]), int(line[1]), float(line[2])))

# Split the data into training and test
training_data, test_data = ratings_final.randomSplit([0.8, 0.2])
```


## Exercise: Model training and predictions

* Train ALS algorithm with training data and configured parameters (rank = 10 and iterations = 10).
* Drop the rating column in the test data, which is the third column.
* Test the model by predicting the rating from the test data.
* Return a list of two rows of the predicted ratings.

```
# Create the ALS model on the training data
model = ALS.train(training_data, rank=10, iterations=10)

# Drop the ratings column 
testdata_no_rating = test_data.map(lambda p: (p[0], p[1]))

# Predict the model  
predictions = model.predictAll(testdata_no_rating)

# Return the first 2 rows of the RDD
predictions.take(2)
```

## Exercise: Model evaluation using MSE

* Organize ratings RDD to make ((user, product), rating).
* Organize predictions RDD to make ((user, product), rating).
* Join the prediction RDD with the ratings RDD.
* Evaluate the model using MSE between original rating and predicted rating and print it.

```
# Prepare ratings data
rates = ratings_final.map(lambda r: ((r[0], r[1]), r[2]))

# Prepare predictions data
preds = predictions.map(lambda r: ((r[0], r[1]), r[2]))

# Join the ratings data with predictions data
rates_and_preds = rates.join(preds)

# Calculate and print MSE
MSE = rates_and_preds.map(lambda r: (r[1][0] - r[1][1])**2).mean()
print("Mean Squared Error of the model for the test data = {:.2f}".format(MSE))
```

## Classification

Classification is a supervised machine learning algorithm for sorting the input data intodifferent categories: Binary or multi-class classification

Logistic Regression predicts a binary response based on some variables

### Working with Vectors
* PySpark MLlib contains specific data types Vectors and LabelledPoint
* Two types of Vectors
    * Dense Vector: store all their entries in an array of floating point numbers
    * Sparse Vector: store only the nonzero values and their indices

```
denseVec = Vectors.dense([1.0, 2.0, 3.0])
sparseVec = Vectors.sparse(4, {1: 1.0, 3: 5.5}
```

### LabeledPoint() in PySpark MLlib
* A LabeledPoint is a wrapper for input features and predicted value
* For binary classification of Logistic Regression, a label is either 0 (negative) or 1 (positive)

```
positive = LabeledPoint(1.0, [1.0, 0.0, 3.0])
negative = LabeledPoint(0.0, [2.0, 1.0, 1.0])
print(positive)
print(negative)
```

### HashingTF() in PySpark MLlib
* HashingTF() algorithm is used to map feature value to indices in the feature vector

```
from pyspark.mllib.feature import HashingTF
sentence = "hello hello world"
words = sentence.split()
tf = HashingTF(10000) 
tf.transform(words)
```

### Logistic Regression using LogisticRegressionWithLBFGS

Logistic Regression using Pyspark MLlib is achieved using LogisticRegressionWithLBFGSclass

```
data = [        LabeledPoint(0.0, [0.0, 1.0]),        LabeledPoint(1.0, [1.0, 0.0]),]
RDD = sc.parallelize(data)
lrm = LogisticRegressionWithLBFGS.train(RDD)
lrm.predict([1.0, 0.0])
lrm.predict([0.0, 1.0])
```

## Exercise: Loading span and non-spam data

* Create two RDDS, one for 'spam' and one for 'non-spam (ham)'.
* Split each email in 'spam' and 'non-spam' RDDs into words.
* Print the first element in the split RDD of both 'spam' and 'non-spam'.

```
# Load the datasets into RDDs
spam_rdd = sc.textFile(file_path_spam)
non_spam_rdd = sc.textFile(file_path_non_spam)

# Split the email messages into words
spam_words = spam_rdd.flatMap(lambda email: email.split(' '))
non_spam_words = non_spam_rdd.flatMap(lambda email: email.split(' '))

# Print the first element in the split RDD
print("The first element in spam_words is", spam_words.first())
print("The first element in non_spam_words is", non_spam_words.first())

```


## Exercise: Feature hasing and LabelPoint

* Create a HashingTF() instance to map email text to vectors of 200 features.
* Each message in 'spam' and 'non-spam' datasets are split into words, and each word is mapped to one feature.
* Label the features: 1 for spam, 0 for non-spam.
* Combine both the spam and non-spam samples into a single dataset.

```
# Create a HashingTF instance with 200 features
tf = HashingTF(numFeatures=200)

# Map each word to one feature
spam_features = tf.transform(spam_words)
non_spam_features = tf.transform(non_spam_words)

# Label the features: 1 for spam, 0 for non-spam
spam_samples = spam_features.map(lambda features: LabeledPoint(1, features))
non_spam_samples = non_spam_features.map(lambda features: LabeledPoint(0, features))

# Combine the two datasets
# Combine the two datasets
samples = spam_samples.union(non_spam_samples)
```

## Exercise: Logistic Regression model training

* Split the combined data into training and test datasets in 80:20 ratio.
* Train the Logistic Regression model with the training dataset.
* Create a prediction label from the trained model on the test dataset.
* Combine the labels in the test dataset with the labels in the prediction dataset using zip function.
* Calculate the accuracy of the trained model using original and predicted labels, and print it

```
# Split the data into training and testing
train_samples,test_samples = samples.randomSplit([0.8, 0.2])

# Train the model
model = LogisticRegressionWithLBFGS.train(train_samples)

# Create a prediction label from the test data
predictions = model.predict(test_samples.map(lambda x: x.features))

# Combine original labels with the predicted labels
labels_and_preds = test_samples.map(lambda x: x.label).zip(predictions)

# Check the accuracy of the model on the test data
accuracy = labels_and_preds.filter(lambda x: x[0] == x[1]).count() / float(test_samples.count())
print("Model accuracy : {:.2f}".format(accuracy))
```

## Clustering

* Clustering is the unsupervised learning task to organize a collection of data into groups
PySpark MLlib library currently supports the following clustering models
    * K-means
    * Gaussian mixture
    * Power iteration clustering (PIC)
    * Bisecting k-means
    * Streaming k-means

### K-means with Spark MLLib

```
RDD = sc.textFile("WineData.csv"). \
map(lambda x: x.split(",")).\
map(lambda x: [float(x[0]), float(x[1])])

RDD.take(5)
```

#### Train a K-means clustering model

Training K-means model is done using KMeans.train() method

```
from pyspark.mllib.clustering import KMeans
model = KMeans.train(RDD, k = 2, maxIterations = 10)
model.clusterCenters
```

#### Evaluating the K-means Model

```
from math import sqrt
def error(point):    
    center = model.centers[model.predict(point)]
    return sqrt(sum([x**2 for x in (point - center)]))

WSSSE = RDD.map(lambda point: error(point)).reduce(lambda x, y: x + y)
print("Within Set Sum of Squared Error = " + str(WSSSE))

```

#### Visualizing cluster

```
swine_data_df = spark.createDataFrame(RDD, schema=["col1", "col2"])
wine_data_df_pandas = wine_data_df.toPandas()

cluster_centers_pandas = pd.DataFrame(model.clusterCenters, columns=["col1", "col2"])
cluster_centers_pandas.head()

plt.scatter(wine_data_df_pandas["col1"], wine_data_df_pandas["col2"]);
plt.scatter(cluster_centers_pandas["col1"], cluster_centers_pandas["col2"], color="red", marker="x"
```


## Loading and parsing the 5000 points data

# Exercise
* Load the 5000_points dataset into an RDD named clusterRDD.
* Transform the clusterRDD by splitting the lines based on the tab ("\t").
* Transform the split RDD to create a list of integers for the two columns.
* Confirm that there are 5000 rows in the dataset.
```
# Load the dataset into an RDD
clusterRDD = sc.textFile(file_path)

# Split the RDD based on tab
rdd_split = clusterRDD.map(lambda x: x.split("\t"))

# Transform the split RDD by creating a list of integers
rdd_split_int = rdd_split.map(lambda x: [int(x[0]), int(x[1])])

# Count the number of rows in RDD 
print("There are {} rows in the rdd_split_int dataset".format(rdd_split_int.count()))
```

## Exercise: K-means training

* Train the KMeans model with clusters from 13 to 16 and print the WSSSE for each cluster.
* Train the KMeans model again with the best k.
* Get the Cluster Centers (centroids) of KMeans model trained with the best k.

```
# Train the model with clusters from 13 to 16 and compute WSSSE
for clst in range(13, 17):
    model = KMeans.train(rdd_split_int, clst, seed=1)
    WSSSE = rdd_split_int.map(lambda point: error(point)).reduce(lambda x, y: x + y)
    print("The cluster {} has Within Set Sum of Squared Error {}".format(clst, WSSSE))

# Train the model again with the best k
model = KMeans.train(rdd_split_int, clst, seed=1)

# Get cluster centers
cluster_centers = model.clusterCenters
```

## Exercise: Visualizing clusters

* Convert the rdd_split_int RDD to a Spark DataFrame, then to a pandas DataFrame.
* Create a pandas DataFrame from the cluster_centers list.
* Create a scatter plot from the pandas DataFrame of raw data (rdd_split_int_df_pandas) and overlay that with a scatter plot from the Pandas DataFrame of centroids (cluster_centers_pandas).

```
# Convert rdd_split_int RDD into Spark DataFrame and then to Pandas DataFrame
rdd_split_int_df_pandas = spark.createDataFrame(rdd_split_int, schema=["col1", "col2"]).toPandas()

# Convert cluster_centers to a pandas DataFrame
cluster_centers_pandas = pd.DataFrame(cluster_centers, columns=["col1", "col2"])

# Create an overlaid scatter plot of clusters and centroids
plt.scatter(rdd_split_int_df_pandas["col1"], rdd_split_int_df_pandas["col2"])
plt.scatter(cluster_centers_pandas["col1"], cluster_centers_pandas["col2"], color="red", marker="x")
plt.show()
```