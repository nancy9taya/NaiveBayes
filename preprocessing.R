rm(list=ls())
#install.packages('reader')
library(readr)
dframe <- read.table("Cleaned-Data.csv", header=TRUE, sep=",")
anyNA(dframe) #Check if there is any NULL values in the dataset
#################Change Attributes#######################
dframe$Fever[dframe$Fever== 0] <- "Fever_no"
dframe$Fever[dframe$Fever== 1] <- "Fever_yes"

dframe$Tiredness[dframe$Tiredness == 0] <- "Tiredness_no"
dframe$Tiredness[dframe$Tiredness == 1] <- "Tiredness_yes"

dframe$Dry.Cough[dframe$Dry.Cough == 0] <- "Dry.Cough_no"
dframe$Dry.Cough[dframe$Dry.Cough == 1] <- "Dry.Cough_yes"

dframe$Difficulty.in.Breathing[dframe$Difficulty.in.Breathing == 0] <- "Difficulty.in.Breathing_no"
dframe$Difficulty.in.Breathing[dframe$Difficulty.in.Breathing == 1] <- "Difficulty.in.Breathing_yes"

dframe$Sore.Throat[dframe$Sore.Throat == 0] <- "Sore.Throat_no"
dframe$Sore.Throat[dframe$Sore.Throat == 1] <- "Sore.Throat_yes"

dframe$None_Sympton[dframe$None_Sympton == 0] <- "None_Sympton_no"
dframe$None_Sympton[dframe$None_Sympton == 1] <- "None_Sympton_yes"

dframe$None_Experiencing[dframe$None_Experiencing ==0] <- "None_Experiencing_no"
dframe$None_Experiencing[dframe$None_Experiencing ==1] <- "None_Experiencing_yes"

dframe$Pains[dframe$Pains ==0] <- "Pains_no"
dframe$Pains[dframe$Pains ==1] <- "Pains_yes"


dframe$Nasal.Congestion[dframe$Nasal.Congestion ==0] <- "Nasal.Congestion_no"
dframe$Nasal.Congestion[dframe$Nasal.Congestion ==1] <- "Nasal.Congestion_yes"


dframe$Runny.Nose[dframe$Runny.Nose==0] <- "Runny.Nose_no"
dframe$Runny.Nose[dframe$Runny.Nose ==1] <- "Runny.Nose_yes"


dframe$Diarrhea[dframe$Diarrhea ==0] <- "Diarrhea_no"
dframe$Diarrhea[dframe$Diarrhea ==1] <- "Diarrhea_yes"


dframe$Gender <- paste(dframe$Gender_Female, dframe$Gender_Male, dframe$Gender_Transgender, sep="_")
dframe$Gender[dframe$Gender== "1_0_0"]<-"Female"
dframe$Gender[dframe$Gender== "0_1_0"]<-"Male"
dframe$Gender[dframe$Gender== "0_0_1"]<-"Transgender"

dframe <- subset(dframe, select = -c(Gender_Female,  Gender_Male ,Gender_Transgender))


dframe$Contact <- paste(dframe$Contact_Dont.Know, dframe$Contact_No, dframe$Contact_Yes, sep="_")
dframe$Contact[dframe$Contact== "1_0_0"]<-"Contact_Unknown"
dframe$Contact[dframe$Contact== "0_1_0"]<-"Contact_No"
dframe$Contact[dframe$Contact== "0_0_1"]<-"Contact_Yes"

dframe <- subset(dframe, select = -c(Contact_Dont.Know,  Contact_No ,Contact_Yes))

dframe$Age <- paste(dframe$Age_0.9, dframe$Age_10.19, dframe$Age_20.24, dframe$Age_25.59,dframe$Age_60., sep="_")
dframe$Age[dframe$Age== "1_0_0_0_0"]<-"Age_0.9"
dframe$Age[dframe$Age== "0_1_0_0_0"]<-"Age_10.19"
dframe$Age[dframe$Age== "0_0_1_0_0"]<-"Age_20.24"
dframe$Age[dframe$Age== "0_0_0_1_0"]<-"Age_25.59"
dframe$Age[dframe$Age== "0_0_0_0_1"]<-"Age_60."

dframe <- subset(dframe, select = -c(Age_0.9, Age_10.19, Age_20.24 ,Age_25.59, Age_60.))

dframe$Severity <- paste(dframe$Severity_Mild, dframe$Severity_Moderate, dframe$Severity_None, dframe$Severity_Severe, sep="_")
dframe$Severity[dframe$Severity== "1_0_0_0"]<-"Mild"
dframe$Severity[dframe$Severity== "0_1_0_0"]<-"Moderate"
dframe$Severity[dframe$Severity== "0_0_1_0"]<-"None"
dframe$Severity[dframe$Severity== "0_0_0_1"]<-"Severe"

dframe <- subset(dframe, select = -c(Severity_Mild,  Severity_Moderate ,Severity_None ,Severity_Severe ))

write.table(dframe,"data_preproccesed.csv", sep=",",  col.names=FALSE ,  row.names = FALSE)

dframe <- read.table("data_preproccesed.csv", header=FALSE, sep=",")

##################### shuffle Data ###########################
set.seed(42)
rows <- sample(nrow(dframe))
shuffeled <- dframe[rows, ]
dim(dframe)
dim(shuffeled)
##################### Split the data to trAIN ,validation and test ##########################
spec = c(train = .7, test = .15, validate = .15)

g = sample(cut(
  seq(nrow(shuffeled)), 
  nrow(shuffeled)*cumsum(c(0,spec)),
  labels = names(spec)
))

res = split(shuffeled, g)
dim(res$train)
dim(res$test)
dim(res$validate)
##################### save data ##########################
write.table(res$train ,"train_preproccesed.csv", sep=",",  col.names=FALSE ,  row.names = FALSE)
write.table(res$test,"test_preproccesed.csv", sep=",",  col.names=FALSE ,  row.names = FALSE)
write.table(res$validate,"validation_preproccesed.csv", sep=",",  col.names=FALSE ,  row.names = FALSE)

