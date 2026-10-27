# ST 558 - Project 2 - Bank Phone Marketing Interactive Explorer

An interactive app for exploring a Portuguese bank's phone marketing campaigns. The campaign is to try to get term deposits. Filter by client traits such as age, job, education to see if the campaign was successful. A successful campaign is defined as client subscribing to term deposit.

The data comes from [Banking Dataset - Marketing Targets](https://www.kaggle.com/datasets/prakharrathi25/banking-dataset-marketing-targets). This is picked up from publicly available research data [UCI Machine Learning](https://archive.ics.uci.edu/ml/datasets/Bank+Marketing) using random sampling plus a few additional columns are introduced in Kaggle data.

**Client Traits (column names in the data set):**

## bank client data:

1.  age (numeric)
2.  job : type of job (categorical: "admin.","unknown","unemployed","management","housemaid","entrepreneur","student","blue-collar","self-employed","retired","technician","services")
3.  marital : marital status (categorical: "married","divorced","single"; note: "divorced" means divorced or widowed)
4.  education (categorical: "unknown","secondary","primary","tertiary")
5.  default: has credit in default? (binary: "yes","no")
6.  balance: average yearly balance, in euros (numeric)
7.  housing: has housing loan? (binary: "yes","no")
8.  loan: has personal loan? (binary: "yes","no") \## related with the last contact of the current campaign:
9.  contact: contact communication type (categorical: "unknown","telephone","cellular")
10. day: last contact day of the month (numeric)
11. month: last contact month of year (categorical: "jan", "feb", "mar", …, "nov", "dec")
12. duration: last contact duration, in seconds (numeric) \## other attributes:
13. campaign: number of contacts performed during this campaign and for this client (numeric, includes last contact)
14. pdays: number of days that passed by after the client was last contacted from a previous campaign (numeric, -1. means client was not previously contacted)
15. previous: number of contacts performed before this campaign and for this client (numeric)
16. poutcome: outcome of the previous marketing campaign (categorical: "unknown","other","failure","success")

**Output variable (desired target):**

1.  y - has the client subscribed a term deposit? (binary: "yes","no")

## How to use the app

**Live App:** <https://bdevapa.shinyapps.io/st558_project2/>

- **Sidebar:** choose an education level, a marital status and a range of two numerical variables, then click **Subset the data**. Nothing is updated in the main panel until this is done.
- **About:** the purpose of the app and details of source of the data that is used in the app
- **Data Download:** view the subsetted data and download it as csv
- **Data Exploration:** one- and two-way contingency tables, bar charts and heatmap of categorical variables; summary statistics, histograms (with faceting) and box plots for numeric variables.
