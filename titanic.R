library(tidyverse)
library(h2o)
source("R/model_plots.R")

# start and clear h2o server
h2o.init()
h2o.removeAll()

# read data
data <- read.csv("data/train.csv")

# make "Survived" a categorial variable
data$Survived <- as.factor(data$Survived)

# seed for reproducibility
seed <- 42

# split and import datasets to h2o
split <- h2o.splitFrame(as.h2o(data), ratios = 0.75, seed = seed)

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
                     seed = seed,
                     model_id = "titanic_rf_defaults")

# create model plots
ggsave("rf_defaults_model_factors.png", plot_model_factors(m), "png", "figs")
ggsave("rf_defaults_model_scoring_history.png", plot_scoring_history(m), "png", "figs")

# save model
h2o.saveModel(m, "output/models", force = TRUE)

# predict on test data
prediction <- h2o.predict(m, test)

# create output csv 
output <- cbind(as.vector(test$PassengerId), as.vector(prediction$predict))
colnames(output) <- c("PassengerId", "Survived")
write.csv(output, "output/predictions/rf_defaults.csv", row.names = FALSE)

