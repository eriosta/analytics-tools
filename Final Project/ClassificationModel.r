# Load required libraries
# install.packages(c("caret", "randomForest", "rpart", "rpart.plot", "tidyverse"))

library(caret)
library(randomForest)
library(rpart)
library(rpart.plot)
library(tidyverse)

# Print the session information
sessionInfo()

# Define a class and methods for the classification process
ClassificationModel <- R6::R6Class("ClassificationModel",
  public = list(
    train_data = NULL,
    test_data = NULL,
    model = NULL,
    seed = 12345,

        initialize = function(data_path) {
        final_data <- self$load_and_preprocess_data(data_path)
        self$partition_data(final_data)
        },

        load_and_preprocess_data = function(data_path) {
        # 1. Read .csv into R
        final_data <- read.csv(data_path)

        # Perform feature selection and preprocessing
        final_data <- final_data %>%
            select(CustomerID, TerritoryID, TotalPurchaseYTD, DateFirstPurchase,
                MaritalStatus, YearlyIncome, Gender, TotalChildren,
                NumberChildrenAtHome, Education, Occupation, HomeOwnerFlag,
                NumberCarsOwned, CommuteDistance, Age, BicyclePurchaseFlag) %>% 
            na.omit()

        # Rename BicyclePurchaseFlag to PurchasedBike
        final_data <- final_data %>% rename(PurchasedBike = BicyclePurchaseFlag)

        # Drop CustomerID, TerritoryID, and DateFirstPurchase. 
        # These variables are not useful for classification.
        final_data <- final_data %>% select(-CustomerID, -TerritoryID, -DateFirstPurchase)

        # Convert Age from chr to int
        final_data$Age <- as.integer(final_data$Age)

        # Categorical variables: MaritalStatus, Gender, Education, Occupation, CommuteDistance
        # One-hot encode multiple categorical columns
        # Identify categorical variables
        cat_vars <- c("MaritalStatus", "Gender", "Education", "Occupation", "CommuteDistance","YearlyIncome")

        # Create dummy variables for categorical variables
        dummy_variables <- dummyVars(~., data = final_data[,cat_vars])

        # Transform the data set using the dummy variables
        final_data_encoded <- predict(dummy_variables, newdata = final_data)

        # Combine the encoded data with the non-categorical variables
        final_data_final <- cbind(final_data_encoded, final_data[,!(names(final_data) %in% c(cat_vars))])

        # Remove all spaces from columns
        colnames(final_data_final) <- gsub(" ", "", colnames(final_data_final))

        # Substitute special characters with underscore
        colnames(final_data_final) <- gsub("[^[:alnum:]]", "_", colnames(final_data_final))

        return(final_data_final)

        },


        partition_data = function(final_data) {
        set.seed(self$seed)
        train_size <- floor(0.8 * nrow(final_data))
        train_index <- sample(seq_len(nrow(final_data)), size = train_size)
        self$train_data <- final_data[train_index,]
        self$test_data <- final_data[-train_index,]
        },

        fit_logistic_regression = function() {
        self$model <- glm(factor(PurchasedBike, levels=c(0,1)) ~ ., data = self$train_data, family = "binomial")
        },

        fit_decision_tree = function() {
        self$model <- rpart(factor(PurchasedBike, levels=c(0,1)) ~ ., data = self$train_data, method = "class", parms=list(split='information'))
        },

        fit_random_forest = function() {
        self$model <- randomForest(factor(PurchasedBike, levels=c(0,1)) ~ ., data = self$train_data, ntree = 100)
        },

        predict_model = function(cutoff = 0.75) {
        # Check the class of the model
        model_class <- class(self$model)[1]
        
        # Prepare the test data for prediction
        test_data_for_prediction <- self$test_data
        
        # For logistic regression, reorder the test data columns to match the train data
        if (model_class == "glm") {
            test_data_for_prediction <- test_data_for_prediction[, colnames(self$train_data)[-ncol(self$train_data)]]
        }
        
        # Set the type of prediction based on the model class
        if (model_class == "glm") {
            pred_type <- "response"  # For logistic regression, use "response"
        } else {
            pred_type <- "prob"  # For decision tree, random forest, and XGBoost, use "prob"
        }
        
        # Make predictions
        if (model_class == "xgb.Booster") {
            preds <- predict(self$model, as.matrix(test_data_for_prediction[, -ncol(test_data_for_prediction)]))
        } else {
            preds <- predict(self$model, newdata = test_data_for_prediction, type = pred_type)
            # Apply the cutoff for logistic regression
            if (model_class == "glm") {
            preds <- as.numeric(preds > cutoff)
            } else {
            preds <- preds[, 2]  # Extract probabilities for decision tree and random forest
            }
        }
        
        return(preds)
        },

        model_accuracy = function() {
        preds <- self$predict_model()
        accuracy <- mean(round(preds) == self$test_data$PurchasedBike)
        return(accuracy)
        },

        plot_decision_tree = function() {
        if (inherits(self$model, "rpart")) {
            rpart.plot(self$model,
                    extra = 101,                # Show the count and percentage for each node
                    box.palette = "auto",        # Use automatic color palette
                    fallen.leaves = TRUE,        # Plot terminal nodes at the bottom
                    main = "Decision Tree Plot"  # Add a title to the plot
            )
        } else {
            print("The model is not a decision tree.")
        }
        },
        
        confusion_matrix = function() {
        preds <- self$predict_model()
        cm <- caret::confusionMatrix(as.factor(round(preds)), as.factor(self$test_data$PurchasedBike))
        return(cm)
        },

        cross_validate = function(k = 10) {
        cv_folds <- createFolds(self$train_data$PurchasedBike, k = k, list = TRUE, returnTrain = TRUE)
        accuracies <- c()

        for (i in 1:k) {
            train_fold <- self$train_data[cv_folds[[i]], ]
            test_fold <- self$train_data[-cv_folds[[i]], ]
            model <- glm(PurchasedBike ~ ., data = train_fold, family = "binomial")
            preds <- predict(model, newdata = test_fold, type = "response")
            accuracy <- mean(round(preds) == test_fold$PurchasedBike)
            accuracies <- c(accuracies, accuracy)
        }

        return(mean(accuracies))
        },

        roc_auc = function() {
        preds <- self$predict_model()
        roc_obj <- pROC::roc(self$test_data$PurchasedBike, preds)
        auc <- pROC::auc(roc_obj)
        return(list(roc = roc_obj, auc = auc))
        }

    )
)

###########################
# Linear regression model:#
###########################

# 1. Create a ClassificationModel object by providing the path to the data file
data_path <- "C:/Users/erios/Desktop/UTSA/analytics-tools/Final Project/final_data.csv"
model <- ClassificationModel$new(data_path)

# 2. Fit a logistic regression model
model$fit_logistic_regression()

# 3. Calculate the confusion matrix
cm <- model$confusion_matrix()
print(cm)

extract_cm_metrics <- function(cm) {
  measures <- c("Accuracy", "95% CI", "No Information Rate", "P-Value [Acc > NIR]",
                "Kappa", "Mcnemar's Test P-Value", "Sensitivity", "Specificity",
                "Pos Pred Value", "Neg Pred Value", "Prevalence", "Detection Rate",
                "Detection Prevalence", "Balanced Accuracy")
  
  values <- c(round(cm$overall['Accuracy'],4),
              paste0("(", round(cm$byClass['Sensitivity'], 4), ", ", round(cm$byClass['Specificity'], 4), ")"),
              round(cm$byClass['No Information Rate'], 4),
              "< 2.2e-16",  # add NA value for missing measure
              round(cm$overall['Kappa'], 4),
              "< 2.2e-16",
              round(cm$byClass['Sensitivity'], 4),
              round(cm$byClass['Specificity'], 4),
              round(cm$byClass['Pos Pred Value'], 4),
              round(cm$byClass['Neg Pred Value'], 4),
              round(cm$byClass['Prevalence'], 4),
              round(cm$byClass['Detection Rate'], 4),
              round(cm$byClass['Detection Prevalence'], 4),
              round(cm$byClass['Balanced Accuracy'], 4))
  
  df <- data.frame(measure = measures, value = values)
  return(df)
}

metrics = extract_cm_metrics(cm)

# Save csv with metrics and change name to make sure it has the name of the model
write.csv(metrics, "metrics_logit.csv")

# 4. Perform cross-validation (default is 10-fold)
cv_accuracy <- model$cross_validate()
print(paste("Cross-validated accuracy:", cv_accuracy))

# 5. Calculate the ROC AUC
roc_auc <- model$roc_auc()
print(paste("ROC AUC:", roc_auc$auc))

# Print the coefficients and odds ratios from the logistic regression model
print(summary(model$model))

# Extract coefficients table from the logistic regression model into a dataframe with Estimate, Std Effor, z value, and p value
coefficients <- summary(model$model)$coefficients
coefficients <- as.data.frame(coefficients)

# Create new column for odds ratio, lower CI, upper CI
coefficients$odds_ratio <- exp(coefficients$Estimate)
coefficients$lower_CI <- exp(coefficients$Estimate - 1.96 * coefficients$`Std. Error`)
coefficients$upper_CI <- exp(coefficients$Estimate + 1.96 * coefficients$`Std. Error`)
coefficients

#######################
# Decision tree model:#
#######################

# 1. Create a ClassificationModel object by providing the path to the data file
data_path <- "C:/Users/erios/Desktop/UTSA/analytics-tools/Final Project/final_data.csv"
model <- ClassificationModel$new(data_path)

# 2. Fit a logistic regression model
model$fit_decision_tree()

# 3. Calculate the confusion matrix
cm <- model$confusion_matrix()
print(cm)

metrics = extract_cm_metrics(cm)

# Save csv with metrics and change name to make sure it has the name of the model
write.csv(metrics, "metrics_dt.csv")

# 4. Perform cross-validation (default is 10-fold)
cv_accuracy <- model$cross_validate()
print(paste("Cross-validated accuracy:", cv_accuracy))

# 5. Calculate the ROC AUC
roc_auc <- model$roc_auc()
print(paste("ROC AUC:", roc_auc$auc))

# Print the coefficients and odds ratios from the Decision tree model
print(summary(model$model))

# Plot the decision tree
model$plot_decision_tree()

#######################
# Random forest model:#
#######################

# 1. Create a ClassificationModel object by providing the path to the data file
data_path <- "C:/Users/erios/Desktop/UTSA/analytics-tools/Final Project/final_data.csv"
model <- ClassificationModel$new(data_path)

# print their column names
colnames(model$train_data)
colnames(model$test_data)

# 2. Fit a random forest model
model$fit_random_forest()

# 3. Calculate the confusion matrix
cm <- model$confusion_matrix()
print(cm)

metrics = extract_cm_metrics(cm)

# Save csv with metrics and change name to make sure it has the name of the model
write.csv(metrics, "metrics_rf.csv")

# 4. Perform cross-validation (default is 10-fold)
cv_accuracy <- model$cross_validate()
print(paste("Cross-validated accuracy:", cv_accuracy))

# 5. Calculate the ROC AUC
roc_auc <- model$roc_auc()
print(paste("ROC AUC:", roc_auc$auc))

# print(summary(model$model))
# 6. Show feature importance
# Show variable importance plot with cutoff
varImpPlot(model$model,
           sort = T,
           n.var = 10,
           main = "Top 10 Features, Random Forest Model")