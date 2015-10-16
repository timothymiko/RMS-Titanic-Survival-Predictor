# Titanic: Machine Learning from Disaster

The goal of this project is to determine whether or not a given passenger on the Titanic survived the disaster or not. This problem and data set is presented by [Kaggle](https://www.kaggle.com/c/titanic).

## Features
Attribute | Description
---|---
survival|Survival<br>(0 = No; 1 = Yes)
pclass|Passenger Class<br>(1 = 1st; 2 = 2nd; 3 = 3rd)
name|Name
sex|Sex
age|Age
sibsp|Number of Siblings/Spouses Aboard
parch|Number of Parents/Children Aboard
ticket|Ticket Number
fare|Passenger Fare
cabin|Cabin
embarked|Port of Embarkation<br>(C = Cherbourg; Q = Queenstown; S = Southampton)

**Special Notes**<br>
Pclass is a proxy for socio-economic status (SES)<br>
 1st ~ Upper; 2nd ~ Middle; 3rd ~ Lower

Age is in Years; Fractional if Age less than One (1)
 If the Age is Estimated, it is in the form xx.5

With respect to the family relation variables (i.e. sibsp and parch)
some relations were ignored.  The following are the definitions used
for sibsp and parch.

 |Info
---|---
Sibling|Brother, Sister, Stepbrother, or Stepsister of Passenger Aboard Titanic
Spouse|Husband or Wife of Passenger Aboard Titanic (Mistresses and Fiances Ignored)
Parent|Mother or Father of Passenger Aboard Titanic
Child|Son, Daughter, Stepson, or Stepdaughter of Passenger Aboard Titanic

Other family relatives excluded from this study include cousins,
nephews/nieces, aunts/uncles, and in-laws.  Some children travelled
only with a nanny, therefore parch=0 for them.  As well, some
travelled with very close friends or neighbors in a village, however,
the definitions do not support such relations.

## Analysis
For the initial data analysis, go [here](Analysis.md).