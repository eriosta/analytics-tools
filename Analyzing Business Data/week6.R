# Load the Carseats dataset
library(ISLR)
data(Carseats)

# Answer question 1
# INCORRECT

# Fit a multiple regression model with Sales as the response and Price, Urban, and US as predictors
model <- lm(Sales ~ Price + Urban + US, data = Carseats)

# Answer question 2: Interpret the coefficient for Price in the model
# For every $1 increase my price, my sales go down by $54. 
summary(model)$coefficients["Price", "Estimate"] # -0.054

# Answer question 3: Interpret the coefficient for Urban in the model
# For every one unit increase in urban score, my sales go down by $21.
# INCORRECT
summary(model)$coefficients["UrbanYes", "Estimate"] # -0.022

# Answer question 4: Interpret the coefficient for US in the model
# Sales inside of the US are $1,200 higher than sales outside of the US.
summary(model)$coefficients["USYes", "Estimate"] # 1.201

# Answer question 5: Write out the model in equation form
# Sales = 13.043 + (-0.054 * Price) + (-0.022 * UrbanYes) + (1.201 * USYes)

# Answer question 6: Identify which predictors have evidence of association with the outcome
summary(model)$coefficients[, "Pr(>|t|)"] < 0.05 # Price and US

# Answer question 7: Fit a smaller model with only the associated predictors
larger_model <- lm(Sales ~ Price + Urban + US, data = Carseats)
summary(larger_model)
# Fit the smaller model
smaller_model <- lm(Sales ~ Price + US, data = Carseats)
summary(smaller_model)
# Answer: 62.42 - 41.52 = 20.9

# Answer question 8: Find the lower bound of the 95% confidence interval for the coefficient of Price
confint(small_model)["Price", "2.5 %"] # -0.0648

# Answer question 9: Check for outliers or high leverage observations
# Use plots to check for outliers or high leverage observations
# No
plot(model)



