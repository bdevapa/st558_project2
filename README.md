# ST 558 - Project 2 - Bank Phone Marketing Interactive Explorer

An interactive app for exploring a Portuguese bank's phone marketing campaigns. The campaign is to try to get term deposits. Filter by client traits such as age, job, education to see if the campaign was successful. A successful campaign is defined as client subscribing to term deposit.

The data comes from [Banking Dataset - Marketing Targets](https://www.kaggle.com/datasets/prakharrathi25/banking-dataset-marketing-targets). This is picked up from publicly available research data [UCI Machine Learning](https://archive.ics.uci.edu/ml/datasets/Bank+Marketing) using random sampling plus a few additional columns are introduced in Kaggle data.

**Client Traits (column names in the data set):**

bank client data:

1. age (numeric)
1. job : type of job (categorical: "admin.","unknown","unemployed","management","housemaid","entrepreneur","student","blue-collar","self-employed","retired","technician","services")
1. marital : marital status (categorical: "married","divorced","single"; note: "divorced" means divorced or widowed)
1. education (categorical: "unknown","secondary","primary","tertiary")
1. default: has credit in default? (binary: "yes","no")
1. balance: average yearly balance, in euros (numeric)
1. housing: has housing loan? (binary: "yes","no")
1. loan: has personal loan? (binary: "yes","no")
# related with the last contact of the current campaign:
1. contact: contact communication type (categorical: "unknown","telephone","cellular")
1. day: last contact day of the month (numeric)
1. month: last contact month of year (categorical: "jan", "feb", "mar", …, "nov", "dec")
1. duration: last contact duration, in seconds (numeric)
# other attributes:
1. campaign: number of contacts performed during this campaign and for this client (numeric, includes last contact)
1. pdays: number of days that passed by after the client was last contacted from a previous campaign (numeric, -1. means client was not previously contacted)
1. previous: number of contacts performed before this campaign and for this client (numeric)
1. poutcome: outcome of the previous marketing campaign (categorical: "unknown","other","failure","success")

**Output variable (desired target):**

1. y - has the client subscribed a term deposit? (binary: "yes","no")

## How to use the app
TBD