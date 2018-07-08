library(tidyverse)
library(h2o)

# start and clear h2o server
h2o.init()
h2o.removeAll()

# read data
data <- read.csv("data/train.csv")

# make "Survived" a categorial variable
data$Survived <- as.factor(data$Survived)

# split and import datasets to h2o
split <- h2o.splitFrame(as.h2o(data), ratios = 0.75)

train <- split[[1]]
valid <- split[[2]]
test <- as.h2o(read.csv("data/test.csv"))

# set predictor and response columns
x <- c("Sex", "Age", "Pclass")
y <- "Survived"

# create Random Forest model
m <- h2o.randomForest(x = x,
                     y = y,
                     training_frame = train,
                     validation_frame = valid,
                     model_id = "titanic_rf_defaults")


# predict on test data
result <- h2o.predict(m, test)
