rm(list=ls())
library("e1071")
library(gmodels)
#install.packages("caret")
library("caret")
#install.packages("data.table")           
library("data.table") 
library(ROCR)
#install.packages('ROCR')
######################### set the  probability table from train Hadoop ###############################
getwd()
setwd("C:/Users/Lenovo/Desktop/Code/Preprocessing")
dframe <- read.table("train_preproccesed.csv", header=FALSE, sep=",")
totalrecords <-dim(dframe)
totalrecords <-totalrecords[1]

data <- read.table("C:/Users/Lenovo/Desktop/Code/Hadoop_train70.txt", sep = "," , header = F , 
                   na.strings ="", stringsAsFactors= F)
data

setnames(data ,"V1" ,"A")
setnames(data ,"V2" ,"Class")
setnames(data ,"V3" ,"count")

# each class probability is occurs in almost same way that give us equal chances for each class for prediction 
#also insight that there is not rare class exists

###################### access the probabilities ########################################################
c=data[data$A == "CLASS" & data$Class== "Severe",]
SevereP =c$count/totalrecords

c=data[data$A == "CLASS" & data$Class== "None",]
NoneP =c$count/totalrecords

c=data[data$A == "CLASS" & data$Class== "Moderate",]
ModerateP =c$count/totalrecords

c=data[data$A == "CLASS" & data$Class== "Mild",]
MildP =c$count/totalrecords


Classes =c("Severe","None", "Moderate" , "Mild" )
ClassProbability = c(SevereP,NoneP, ModerateP ,MildP)
length(Classes)
Classes[1]
######################################### prediction Function ###################################################
index_class<-1
ProbabilitesFinal = c()
predictFunction<-function(input,laplaceSmoothing)
{
# assume the input attribute is array of strings    
  for (class in Classes) {
    prior = ClassProbability[index_class]
    posterior = prior
    #print(NB)
    index_class<-index_class+1
    for (attribute in input) {
      P = data[data$A == attribute & data$Class== class,]
      #print(P)
      #### here check NULL Attribute####
      if(length(P$count) == 0){
        print("Replace Attribute with laplace smoothing")
        class_occurance=data[data$A == "CLASS" & data$Class== class,]
        posterior = posterior * ( laplaceSmoothing/ (class_occurance$count  + (laplaceSmoothing*length(Classes))) )# handling laplace smoothing
      }
      else{
       
        class_occurance=data[data$A == "CLASS" & data$Class== class,]
        print(class_occurance$count)
        print(laplaceSmoothing)
        posterior = posterior* ( P$count +laplaceSmoothing / (class_occurance$count  + laplaceSmoothing * length(Classes) ) )#likelihood
      }
    }
    ProbabilitesFinal <- c(ProbabilitesFinal, posterior)
    posterior = 0
  } 
  index <- which.max(ProbabilitesFinal)
  #print(index)
  return(Classes[index])## modify to return the class name not its probability DONE
}

####################################### How to extract Attributes from csv ##############################################

dframe2 <- read.table("test_preproccesed.csv", header=FALSE, sep=",")
extract_prediction_Function<-function(dframe){
  test_truePrediction <- c()
    for(i in 1:length(dframe[,1])){
      testRow = dframe[i,]
      our_array =c()
      for (value in 1:length(testRow)-1 ){
        V <-testRow[value] [1,]
        our_array <-c(our_array, V)
      } 
      predicition = testRow[length(testRow)][1,]
      test_truePrediction <- c(predicition,test_truePrediction )
    }
    return(test_truePrediction)
}
test_prediction <- extract_prediction_Function(dframe2)
train_prediction <- extract_prediction_Function(dframe)

######################################### Tune Hyper Parameter Using Validation Dataset ############################
α_set = c(0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000, 10000)
dframe3 <- read.table("validation_preproccesed.csv", header=FALSE, sep=",")

####################################### partition the data to equal parts based on values of laplace smoothing ####################

df <- dframe3
N <-length(α_set)
stopifnot(nrow(df) %% N == 0)
df    <- df[order(runif(nrow(df))), ]
bins  <- rep(1:N, nrow(df) / N)
arraySplits <- split(df, bins)

###################################### calculate accuracy in each split with corresponding laplace smoothing ###################

accuracies <- c()
for(i in 1:N){
  k<-arraySplits[[i]]# change range from 1 : 9 splits
  truePrediction <- arraySplits[[i]][,16]
  ourPrediction <-c()
  α <- α_set[i]
  sizeSplit <- dim(k)[1]# dimension each split 
  for(i in 1:sizeSplit){
    Attribute <- k[i,-16]# attribute without the classification 
    prediction <- predictFunction(Attribute ,α)
    ourPrediction <-c(prediction,ourPrediction)

  }
  union_levels <- union(ourPrediction, truePrediction)
  t <- table(factor(ourPrediction, union_levels), factor(truePrediction, union_levels))
  ConfusionOutput <-  confusionMatrix(t)
  AcuracyModel = ConfusionOutput$overall['Accuracy']
  accuracies <- c(accuracies ,  AcuracyModel)
 
}
write.table(accuracies,"accuracies.txt", sep=",",  col.names=FALSE ,  row.names = FALSE)

############################### find the max accuracy that correspond to laplace value #########################
α_index <- which.max(accuracies)
finallaplace <- α_set[α_index]
############################### End of tune Hyper parameter ###################################################


EvaluteFunction<-function(input,laplaceSmoothing)
{
  # assume the input is test dataset  
  ourPrediction <-c()
  #print(length(input[,1]))
  for(i in 1:length(input[,1])){
    Attribute <- input[i,-16]# attribute without the classification 
    prediction <- predictFunction(Attribute ,laplaceSmoothing)
    ourPrediction <-c(prediction,ourPrediction)
    
  }
 return(ourPrediction )
}

############################### Evaluation Test & train #########################################################

our_test_prediction <- EvaluteFunction(dframe2,finallaplace )

union_levels <- union(our_test_prediction, test_prediction)
t <- table(factor(our_test_prediction, union_levels), factor(test_prediction, union_levels))
ConfusionOutput1 <-  confusionMatrix(t)
ConfusionOutput1 # evaluate test 

our_train_prediction <- EvaluteFunction(dframe,finallaplace )
union_levels <- union(our_train_prediction, train_prediction)
t <- table(factor(our_train_prediction, union_levels), factor(train_prediction, union_levels))
ConfusionOutput2 <-  confusionMatrix(t)
ConfusionOutput2


############################ Trials ###########################################################
testAttribute <-c("Fever_yes",	"Tiredness_yes"	,"Dry.Cough_no"	,"Difficulty.in.Breathing_no",	"Sore.Throat_no","	None_Sympton_no","	Pains_yes",	"Nasal.Congestion_no",	"Runny.Nose_no"	,"Diarrhea_no	","None_Experiencing_no"	,"Iran",	"Male",	"Contact_Yes"	,"Age_10.19")

prediction <- predictFunction(Attribute ,α)
print(prediction)



