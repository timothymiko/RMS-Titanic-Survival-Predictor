data.train.raw <- read.table("train.csv", sep=",", header=TRUE)
data.test.raw <- read.table("test.csv", sep=",", header=TRUE)

selected_columns <- c("Pclass", "Sex", "Age", "SibSp", "Parch", "Fare", "Embarked")
data.train.cleaned <- data.train.raw[selected_columns]
data.test.cleaned <- data.test.raw[selected_columns]

data.train <- data.train.cleaned
data.train_class <- data.train.raw[, "Survived"]

data.test <- data.test.cleaned

# This function takes a set of training data and summarizes it with probability
# tables for each attribute, effectively creating a data "model". This model is
# then used to predict future classifications with the predict function.
#
# This function is a modified version of the one included in the e1071 package.
# I implemented the function in code here for two reasons:
#   1) To ensure that I understand how to implement Naive Bayes Classification.
#   2) To ensure that this code works in the future as e1071 is updated.
#
# e1071 package - https://cran.r-project.org/web/packages/e1071/index.html
naiveBayes <- function(train, class, laplace)
{
  class = as.factor(class)
  train = as.data.frame(train)
  Yname <- "Survived"
  
  # This function creates a summary of a given attribute. For a numeric 
  # attribute, it calculates the mean and standard deviation of each class.
  # For a categorical attribute, it calculates the relative distribution of
  # each level of the attribute for each class using laplace smoothing.
  summarize <- function(attr)
  {
    if (is.numeric(attr)) {
      cbind(tapply(attr, class, mean, na.rm = TRUE),
            tapply(attr, class, sd, na.rm = TRUE))
    } else {
      tab <- table(class, attr)
      (tab + laplace) / (rowSums(tab) + laplace * nlevels(attr))
    }
  }
  
  # Create a priori probability table
  apriori <- table(class)
  
  # Create a summary of each attribute in the training data set.
  tables <- lapply(train, summarize)
  
  # Fix the row and column names of the data model
  for (i in 1:length(tables))
    names(dimnames(tables[[i]])) <- c(Yname, colnames(train)[i])
  names(dimnames(apriori)) <- Yname
  
  # Return the structured data model
  structure(list(apriori = apriori,
                 tables = tables,
                 levels = levels(class),
                 call   = call
            ),
            
            class = "naiveBayes"
            )
}

# This function takes the data model returned by the naiveBayes function and 
# uses it to classify each object in the new data set.
#
# This function is a modified version of the one included in the e1071 package.
# I implemented the function in code here for two reasons:
#   1) To ensure that I understand how to implement Naive Bayes Classification.
#   2) To ensure that this code works in the future as e1071 is updated.
#
# e1071 package - https://cran.r-project.org/web/packages/e1071/index.html
predict <- function(object, 
                    newdata,
                    type = c("class", "raw"),
                    threshold = 0.001,
                    eps = 0,
                    ...)
{
  type <- match.arg(type)
  newdata <- as.data.frame(newdata)
  attribs <- match(names(object$tables), names(newdata))
  isnumeric <- sapply(newdata, is.numeric)
  newdata <- data.matrix(newdata)
  L <- sapply(1:nrow(newdata), function(i) {
    ndata <- newdata[i, ]
    L <- log(object$apriori) + apply(log(sapply(seq_along(attribs),
                                                function(v) {
                                                  nd <- ndata[attribs[v]]
                                                  if (is.na(nd)) rep(1, length(object$apriori)) else {
                                                    prob <- if (isnumeric[attribs[v]]) {
                                                      msd <- object$tables[[v]]
                                                      msd[, 2][msd[, 2] <= eps] <- threshold
                                                      dnorm(nd, msd[, 1], msd[, 2])
                                                    } else object$tables[[v]][, nd]
                                                    prob[prob <= eps] <- threshold
                                                    prob
                                                  }
                                                })), 1, sum)
    
    if (type == "class")
      L
    else {
      ## Numerically unstable:
      ##            L <- exp(L)
      ##            L / sum(L)
      ## instead, we use:
      sapply(L, function(lp) {
        1/sum(exp(L - lp))
      })
    }
  })
  if (type == "class")
    factor(object$levels[apply(L, 2, which.max)], levels = object$levels)
  else t(L)
}

model <- naiveBayes(data.train, data.train_class)

Survived <- predict(model, data.test)
PassengerId <- data.test.raw$PassengerId
Sex <- data.test.raw$Sex

write.csv(cbind(PassengerId, as.data.frame(Survived)), file="naive-bayes-results.csv")

levels(Survived) <- c("No", "Yes")

tab <- table(Sex, Survived)
tab