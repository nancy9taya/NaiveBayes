# NaiveBayes
Naive Bayes from scratch for symptoms corona virus dataset in R

## MapReduce
Here we using Hadoop MapReduce in java to calculte the occurance of each attrbute give each class 
the code is here:![NaiveBayesMapReduce](https://github.com/nancy9taya/NaiveBayes/blob/main/NaiveBayes.java)
the output is here: ![OutputMapReduce](https://github.com/nancy9taya/NaiveBayes/blob/main/Hadoop_train70.txt)

## Preprocessing 
The dataset contained  27 columns, comprised of 11 symptoms, 5 columns of different age groups (0-9, 10-19, 20-24, 25-59, 60-),  3 columns of gender (male, female, transgender),
4 columns of severity (none, mild, moderate, severe), 3 columns of whether the person was in contact with an infected person or not (yes, no, unknown) and 1 column for the country.
As we can see, this is totally inefficient so we decided to merge the columns of similar attribute
the code is here: ![Preprocessing](https://github.com/nancy9taya/NaiveBayes/blob/main/preprocessing.R)


## Naive Bayes Classifier 
We split the data into 70 % train 15 % validation 15% test and enter 70% train data to Hadoop MapReduce

### Train phase 
Done by Hadoop MapReduce

### Validation Phase 
We here try to tune the hyper parameters which is laplace smoothing (α) to handle zero probability element  
We take a set of alpha values α_set = [0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000, 10000].
and tune to α = 100 

### Test phase
Give us accuracy 25% 

   

