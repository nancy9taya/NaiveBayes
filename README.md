# NaiveBayes
Naive Bayes from scratch for symptoms corona virus dataset in R

## MapReduce
Here we using Hadoop MapReduce in java to calculte the occurance of each attrbute give each class 
the code is here:![NaiveBayesMapReduce](https://github.com/nancy9taya/NaiveBayes/blob/main/NaiveBayes.java)
the output is here: ![OutputMapReduce](https://github.com/nancy9taya/NaiveBayes/blob/main/Hadoop_train70.txt)

## preprocessing 
The dataset contained  27 columns, comprised of 11 symptoms, 5 columns of different age groups (0-9, 10-19, 20-24, 25-59, 60-),  3 columns of gender (male, female, transgender),
4 columns of severity (none, mild, moderate, severe), 3 columns of whether the person was in contact with an infected person or not (yes, no, unknown) and 1 column for the country.
As we can see, this is totally inefficient so we decided to merge the columns of similar attribute
the code is here: ![Preprocessing](https://github.com/nancy9taya/NaiveBayes/blob/main/preprocessing.R)
