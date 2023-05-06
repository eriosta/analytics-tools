import pandas as pd
df = pd.read_csv('C:/Users/erios/Desktop/UTSA/analytics-tools/Final Project/final_data.csv')

df.info()

# Data columns (total 16 columns):
#  #   Column                Non-Null Count  Dtype
# ---  ------                --------------  -----
#  0   CustomerID            19119 non-null  int64
#  1   TerritoryID           19119 non-null  int64
#  2   TotalPurchaseYTD      19119 non-null  float64
#  3   DateFirstPurchase     18484 non-null  object
#  4   MaritalStatus         18484 non-null  object
#  5   YearlyIncome          18484 non-null  object
#  6   Gender                18484 non-null  object
#  7   TotalChildren         18484 non-null  float64
#  8   NumberChildrenAtHome  18484 non-null  float64
#  9   Education             18484 non-null  object
#  10  Occupation            18484 non-null  object
#  11  HomeOwnerFlag         18484 non-null  float64
#  12  NumberCarsOwned       18484 non-null  float64
#  13  CommuteDistance       18484 non-null  object
#  14  Age                   18484 non-null  float64
#  15  BicyclePurchaseFlag   19119 non-null  int64

# Drop the variables that are not needed
df = df.drop(['CustomerID', 'TerritoryID', 'DateFirstPurchase'], axis=1)

# # Replace values under BicyclePurchaseFlag with Yes and No
# df['BicyclePurchaseFlag'] = df['BicyclePurchaseFlag'].replace({1: 'Purchase', 0: 'No Purchase'})

# # Define categorical variables
cats = [
    'MaritalStatus',
    'YearlyIncome',
    'Gender',
    'Education',
    'Occupation',
    'HomeOwnerFlag',
    'CommuteDistance'
]

# # Define numerical variables
# nums = [
#     'TotalPurchaseYTD',
#     'TotalChildren',
#     'NumberChildrenAtHome',
#     'NumberCarsOwned',
#     'Age']

# vars = cats + nums + ['BicyclePurchaseFlag']

# # use tableone to generate summary statistics
# from tableone import TableOne

# # tableone object; group by BicyclePurchaseFlag, 0 = no purchase, 1 = purchase
# table = TableOne(
#     df,
#     columns=vars,
#     categorical=cats,
#     groupby='BicyclePurchaseFlag',
#     pval=True,
#     htest_name=True,
#     sort=True,
#     label_suffix=True
# )

# # print tableone object
# print(table.tabulate(tablefmt='github'))

# # Convert output to dataframe
# table_df = table.tableone

# # convert index into a column
# table_df.reset_index(level=0, inplace=True)
# table_df.reset_index(level=0, inplace=True)

# # combine columns index and level_0 into one string, separated by a "-"
# table_df['index'] = table_df['index'].astype(str) + ' ' + table_df['level_0'].astype(str)
# table_df

# Train test split 80/20, then train a logistic regression model, decision tree, and random forest, and plot the AUROC for all three models
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier

# One-hot encode categorical variables except for BicyclePurchaseFlag
df = pd.get_dummies(df, columns=cats).dropna()

df.columns

# Define X and y
X = df.drop('BicyclePurchaseFlag', axis=1)
y = df['BicyclePurchaseFlag']

# Split data into train and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=.2, random_state=12345)

# Define models
lr = LogisticRegression()
dt = DecisionTreeClassifier()
rf = RandomForestClassifier()

# Fit models
lr.fit(X_train, y_train)
dt.fit(X_train, y_train)
rf.fit(X_train, y_train)

# Import roc_auc_score
from sklearn.metrics import roc_auc_score

# Predict probabilities
lr_probs = lr.predict_proba(X_test)
dt_probs = dt.predict_proba(X_test)
rf_probs = rf.predict_proba(X_test)

# Keep probabilities for the positive outcome only
lr_probs = lr_probs[:, 1]
dt_probs = dt_probs[:, 1]
rf_probs = rf_probs[:, 1]

# # Calculate AUROC
# lr_auc = roc_auc_score(y_test, lr_probs)
# dt_auc = roc_auc_score(y_test, dt_probs)
# rf_auc = roc_auc_score(y_test, rf_probs)

# # Print AUROC scores
# print('Logistic: AUROC = %.3f' % (lr_auc))
# print('Decision Tree: AUROC = %.3f' % (dt_auc))
# print('Random Forest: AUROC = %.3f' % (rf_auc))

# # Visualize plot with AUROC for all three models
# import matplotlib.pyplot as plt
# from sklearn.metrics import roc_curve

# # Calculate roc curves
# lr_fpr, lr_tpr, _ = roc_curve(y_test, lr_probs)
# dt_fpr, dt_tpr, _ = roc_curve(y_test, dt_probs)
# rf_fpr, rf_tpr, _ = roc_curve(y_test, rf_probs)

# # Plot the roc curve for the model
# plt.plot(lr_fpr, lr_tpr, linestyle='--', label='Logistic')
# plt.plot(dt_fpr, dt_tpr, linestyle='--', label='Decision Tree')
# plt.plot(rf_fpr, rf_tpr, linestyle='--', label='Random Forest')

# # Axis labels
# plt.xlabel('False Positive Rate')
# plt.ylabel('True Positive Rate')

# # Show legend
# plt.legend()

# # Show plot
# plt.show()

# Perform TreeSHAP for the random forest model
import shap

# Create object that can calculate shap values
explainer = shap.TreeExplainer(rf)

# Calculate shap_values for all of X_test rather than a single row, to have more data for plot
shap_values = explainer.shap_values(X_test)

# Make plot
shap.summary_plot(shap_values[1], X_test, plot_type="bar")

# Dependence plot for all features
for i in range(len(X.columns)):
    shap.dependence_plot(i, shap_values[1], X_test, display_features=X_test)

# SHAP waterfall plot for a single row
shap.initjs()
shap.force_plot(explainer.expected_value[1], shap_values[1][0,:], X_test.iloc[0,:])
