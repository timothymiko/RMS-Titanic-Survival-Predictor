library(GGally)

train <- read.table("train.csv", sep=",", header=TRUE)

train$Survived[train$Survived == 0] <- "Died"
train$Survived[train$Survived == 1] <- "Survived"
train$Survived <- factor(train$Survived)

levels(train$Embarked) <- c("Unknown", "Cherbourg", "Queenstown", "Southampton")

pairs(train[c('Pclass', 'Sex', 'Age', 'Fare', 'SibSp', 'Parch')], pch=21, bg=c("red", "green")[unclass(train$Survived)])
