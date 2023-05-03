################
## Question 1 ## -- Correct
################

# Coefficients
beta0 <- -6
beta1 <- 0.05
beta2 <- 1

# Part (a)
# Variables
X1 <- 40
X2 <- 3.5

# Calculate the linear combination of coefficients and variables
linear_combination <- beta0 + beta1*X1 + beta2*X2

# Compute the probability
probability_A <- 1 / (1 + exp(-linear_combination))

# Convert probability to percentage and print
probability_A_percent <- probability_A * 100
print(probability_A_percent)

# Part (b)
# We set the probability at 0.5 and solve for X1
X1_needed <- (log(1 / 0.5 - 1) - beta0 - beta2*X2) / beta1

# Print the hours needed to study
print(X1_needed)

################
## Question 2 ## -- Correct
################

library(ISLR)
library(ggplot2)
library(GGally)
library(cowplot)

data(Weekly)

summary(Weekly)
cor(Weekly[, -9]) # Excluding the 'Direction' column as it is a factor

# Histogram for Volume
volume_hist <- ggplot(Weekly, aes(x = Volume)) +
  geom_histogram(fill = "blue", color = "black", bins = 30) +
  theme_minimal() +
  labs(title = "Histogram of Weekly Volume")

# Boxplot for Today
today_box <- ggplot(Weekly, aes(x = 1, y = Today)) +
  geom_boxplot(fill = "orange", color = "black") +
  theme_minimal() +
  labs(title = "Boxplot of Today's Returns", x = "")

# Scatterplot matrix for Lag1, Lag2, and Today
scatter_matrix <- ggpairs(Weekly, columns = c("Lag1", "Lag2", "Today"))

# Combine plots
combined_plots <- plot_grid(volume_hist, today_box, scatter_matrix, ncol = 1, align = 'v', rel_heights = c(1, 1, 2))

library(gridExtra)

# # Save the volume histogram
# ggsave("volume_hist.pdf", volume_hist, width = 8, height = 6)

# # Save the boxplot
# ggsave("today_box.pdf", today_box, width = 8, height = 6)

# # Save the scatterplot matrix
# pdf("scatter_matrix.pdf", width = 8, height = 6)

# print(scatter_matrix)
# dev.off()

# Open the PDF file
pdf("all_plots.pdf", width = 8, height = 6)

# Create the volume histogram
print(volume_hist)

# Create the boxplot
print(today_box)

# Create the scatterplot matrix
print(scatter_matrix)

# Close the PDF file
dev.off()

################
## Question 3 ## -- Correct
################

# Perform logistic regression
logit_model <- glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
                  data = Weekly, family = binomial)

# Print the summary
summary(logit_model)

# Define a function to print statistically significant predictors
print_significant_predictors <- function(model, significance_level = 0.05) {
  # Get the summary of the model
  model_summary <- summary(model)

  # Get the p-values of the predictors
  predictor_p_values <- coef(model_summary)[, 4]

  # Find which predictors are statistically significant
  significant_predictors <- names(predictor_p_values)[predictor_p_values <= significance_level]

  # Print the significant predictors
  if (length(significant_predictors) > 0) {
    cat("The statistically significant predictors at a significance level of", significance_level, "are:\n")
    print(significant_predictors)
  } else {
    cat("No predictors are statistically significant at a significance level of", significance_level, ".\n")
  }
}

# Use the function on the logistic regression model
print_significant_predictors(logit_model)

################
## Question 4 ## -- Correct
################

# Get the predicted probabilities
predicted_probabilities <- predict(logit_model, type = "response")

# Convert the predicted probabilities to class labels (Up or Down)
predicted_labels <- ifelse(predicted_probabilities > 0.5, "Up", "Down")

# Create a confusion matrix
confusion_matrix <- table(Predicted = predicted_labels, Actual = Weekly$Direction)

# Calculate the percentage of correct predictions
correct_predictions <- sum(diag(confusion_matrix))
total_predictions <- sum(confusion_matrix)
accuracy <- correct_predictions / total_predictions * 100

# Print the confusion matrix and the percentage of correct predictions
print(confusion_matrix)
cat("Percentage of correct predictions:", accuracy, "\n")


################
## Question 5 ## -- Correct
################
library(lubridate)
# Load the Weekly dataset
data(Weekly)

# Identify the training data (1990 to 2008)
train <- (Weekly$Year < 2009)

# Fit the logistic regression model using the training data
logit_model <- glm(Direction ~ Lag2, data = Weekly, subset = train, family = binomial)

# Predict the Direction for the test data (2009 and 2010)
predicted_probabilities <- predict(logit_model, newdata = Weekly[!train, ], type = "response")
predicted_labels <- ifelse(predicted_probabilities > 0.5, "Up", "Down")

# Compute the confusion matrix for the test data
confusion_matrix <- table(Predicted = predicted_labels, Actual = Weekly$Direction[!train])

# Calculate the fraction of correct predictions for the test data
correct_predictions <- sum(diag(confusion_matrix))
total_predictions <- sum(confusion_matrix)
accuracy <- correct_predictions / total_predictions

# Print the confusion matrix and the fraction of correct predictions
print(confusion_matrix)
cat("Fraction of correct predictions:", accuracy, "\n")
