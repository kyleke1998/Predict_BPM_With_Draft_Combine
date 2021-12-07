![image](https://user-images.githubusercontent.com/64662601/144793374-320ddb0a-1675-4ad5-9955-9f6e73a5d33b.png)
### (See *report.pdf* for methods, results, and conclusions)
This project investigates the potential of using anthropometric and strength/agility measurements from draft combine to predict a player’s first-year and four-year average Box Plus/Minus (BPM) both as a regression problem and classification problem.

## Important Scripts
* *web_scraping.R* scrapes player performance data from 2001-2020 from https://www.basketball-reference.com/

* *Data_Cleaning.ipynb* Joins the player performance data and combine measurements by player name and cleans the data

* *Regression_Model_by_Pos_First_Year.ipynb* and *Regression_Model_by_Pos_Four_Year_Avg.ipynb* are regression and lasso regression models by position for first year and four-year average

* *Regression_Model_by_Pos_First_Year.ipynb* and *Regression_Model_by_Pos_Four_Year_Avg.ipynb* are ridge regression models by position for first year and four-year average

* *sklearn_ml_regression.ipynb* is machine learning regression algorithims applied to predict raw BPM

* *Combine_measurements_BPM_Classificaiton.ipynb* Applies classifcation algorithims to see if we can predict a player has a BPM >= 0.




