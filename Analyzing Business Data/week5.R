# Load the MASS library and the Boston dataset
library(MASS)
data(Boston)

dim(Boston)

# Define a function to create pairwise scatterplots and return a correlation matrix
create_scatterplot_matrix <- function(data) {
  # Create the pairwise scatterplot matrix
  pairs(data)
  
  # Calculate the correlation matrix
  cor_matrix <- cor(data)
  
  # Return the correlation matrix
  return(cor_matrix)
}

# Call the function to create the scatterplot matrix and get the correlation matrix
cor_matrix <- create_scatterplot_matrix(Boston)

# Print the correlation matrix
print(cor_matrix)

# Answer question 7: Check if rad and nox are correlated
# Look for the correlation coefficient between rad and nox
rad_nox_cor <- cor_matrix["rad", "nox"]
if (abs(rad_nox_cor) > 0.5) {
  print("rad and nox are correlated with each other")
}

# Answer question 7: Check if there is a strong negative relationship between medv and rm
# Look for the correlation coefficient between medv and rm
medv_rm_cor <- cor_matrix["medv", "rm"]
if (medv_rm_cor < -0.7) {
  print("There is a strong negative linear relationship between medv and rm")
}

# Answer question 7: Check if there is a strong positive relationship between medv and indus
# Look for the correlation coefficient between medv and indus
medv_indus_cor <- cor_matrix["medv", "indus"]
if (medv_indus_cor > 0.7) {
  print("There is a strong positive linear relationship between medv and indus")
}

# Answer question 7: Check if lstat is uncorrelated with medv
# Look for the correlation coefficient between lstat and medv
lstat_medv_cor <- cor_matrix["lstat", "medv"]
if (abs(lstat_medv_cor) < 0.2) {
  print("lstat is uncorrelated with medv")
}

# Answer question 8: Check if any of the predictors are associated with per capita crime rate
# Look for the correlation coefficients between the predictors and the per capita crime rate (crim)
crim_cor <- cor_matrix["crim", ]
if (any(abs(crim_cor) > 0.5)) {
  print("At least one predictor is associated with per capita crime rate")
}

# Answer question 9: Check which suburbs have particularly high crime rates, tax rates, or pupil-teacher ratios
# Find the suburbs that have values greater than the thresholds given in the question
high_crime_suburbs <- Boston$crim > 5.392556
high_tax_suburbs <- Boston$tax > 580.5
high_ptratio_suburbs <- Boston$ptratio > 3.6

# Print the number of suburbs for each category
print(paste("Number of suburbs with high crime rates:", sum(high_crime_suburbs)))
print(paste("Number of suburbs with high tax rates:", sum(high_tax_suburbs)))
print(paste("Number of suburbs with high pupil-teacher ratios:", sum(high_ptratio_suburbs)))

# Answer question 10: Find how many suburbs in the dataset bound the Charles river
charles_river_suburbs <- Boston$chas == 1
print(paste("Number of suburbs that bound the Charles river:", sum(charles_river_suburbs)))

# Answer question 11: Find the median pupil-teacher ratio among the towns in this data
median_ptratio <- median(Boston$ptratio)
print(paste("Median pupil-teacher ratio among the towns in this data set:", median_ptratio))

# Answer question 12: Find the suburb of Boston with the lowest median value of owner occupied homes and the value of nox for that suburb
min_medv <- min(Boston$medv)
min_medv_suburb <- Boston[Boston$medv == min_medv, ]
min_medv_nox <- min(min_medv_suburb$nox)
print(paste("Suburb with lowest median value of owner occupied homes:", min_medv_suburb$town[1]))
print(paste("Value of nox for that suburb:", min_medv_nox))

# Answer question 13: Find the number of suburbs that average more than seven rooms per dwelling
suburbs_gt_7_rooms <- Boston$rm > 7
num_suburbs_gt_7_rooms <- sum(suburbs_gt_7_rooms)
print(paste("Number of suburbs that average more than seven rooms per dwelling:", num_suburbs_gt_7_rooms))
