Systemic Racism Project
================
Taniya Adhikari
11/21/2020

### Introduction

In 2020, United States had one of the most historic movement called
Black Lives Matter, brought light to the social issue called systemic
racism. It is form of racism that is deeply rooted in the society as
normal practice. The term was coined in 1967 by Stokely Carmichael, but
it had not gotten attention until 1990. Recent affairs has brought this
concept back into discussion and caused lot of political tension in the
US. Proponents of this believe it’s real problem and causes
discrimination in other issues like, health, criminal justice, housing,
lack of opportunity. Opponents of this concept, don’t believe it exist
and therefore don’t see it as a problem.

**Why this is important?**

Firstly, it is a very controversial topic and is related to current
political affairs, so everyone should know the root cause of political
unrest in the country. Secondly, data science is known for unknowingly
or knowingly influence some of these biases. Lastly, my attempt is to
study more so we can use this to make a better society.

### Research Questions

1.  Do minority tend to get pull over by police more often than White?  
2.  Is there any relationship between race and arrest made during those
    stops?
3.  Is there income disparity in different races?  
4.  Is there any relationship between race and salary?  
5.  Out of the total sample studied, what is the average salary by race,
    salary growth over the years?
6.  Mortgage denial rate vs, race/ethnicity

### Approach

I intend to do this research objectively regardless of my political
stance. Instead of deciding based on my morality, I want to study the
data and find answers to the questions and to test whether systemic
racism is an actual concept or just a myth by studying the distribution
of salary, mortgage approval, etc, by race. We use past data in data
science to predict future, and data science can promote racial bias if
not carefully handled. For example, data science is used in predictive
policing. I hope my approach will help understand the root cause of the
problem.

**Required packages**  
1. Foreign 2. ggplot2 3. Rcmdr 4. ggpubr 5. knitr 6. tidyverse

### Data & Data Import Process

For this analysis and research questions, I am using 4 different data
sets from the following sources:

1.  CPS ASEC 5 year data starting from 2014 to 2018 downloaded from
    [CEPR
    data.](https://ceprdata.org/cps-uniform-data-extracts/march-cps-supplement/march-cps-data/)
    Five year data to compare growth rate.

2.  Standardized police stop data for randomly selected 6 states between
    2013 and 2015 year. North Carolina, Montana, Arizona, Wisconsin and
    Ohio from [The Standford Open Policing
    Project](https://openpolicing.stanford.edu/data/) and Population
    estimated data by each state [by Census
    Bureau](https://www2.census.gov/programs-surveys/popest/datasets/2010-2015/state/asrh/)

3.  HMDA data for Mortgage from [Consumer Financial Protection
    Bureau](https://www.consumerfinance.gov/data-research/hmda/historic-data/)
    for NY data from 2015-2017.

**Data Importing and Data Cleaning**

1.  **CPS ASEC data importing and cleaning**

I did the following steps for each year.

-   First, I imported the data for each of the year and viewed the data
    structure. There were 475+ variables and 200K plus rows in each
    dataset. Since CPS ASEC data is income related data and the main
    purpose of this data is to find relationship between race, income,
    gender, education and etc. I decided to select the variables that
    are important to my analysis and discard variables with empty
    values. The reason for this approach is also because most variables
    have only NA or empty, and lot of variables were also repeated, it
    was easier to select variables instead of dropping it.

-   Second, for this project I was only interested in individual income
    and education level, I decided to exclude family income or household
    income variables.

-   Third, identified any duplicate values based on person’s unique id
    and dropped it.

-   Fourth, I created a subset by excluding anyone with age&lt;18 and
    age&gt;65 because children under 18 are less likely to work and most
    people retire after 65. I also dropped anyone who was marked as
    unemployed or had 0 income.

-   Fifth, Found missing values in the remaining dataset. Since, race
    and education is also one of the main variables, I will be
    analyzing, I decided to drop NA for both of the variables.

-   Sixth, I merged the data vertically, and called it a clean\_asec
    dataframe.

I left the other variables with NA because not quite sure if I will be
using those variables yet. I also converted the dataframe into .csv file
to later import it for analysis.

``` r
# importing data
ASEC2018 <- read.dta("rawdata/cepr_march_2018.dta")
ASEC2017 <- read.dta("rawdata/cepr_march_2017.dta")
ASEC2016 <- read.dta("rawdata/cepr_march_2016.dta")
ASEC2015 <- read.dta("rawdata/cepr_march_2015.dta")
ASEC2014 <- read.dta("rawdata/cepr_march_2014.dta")

# viewing the structure
str(ASEC2018)
str(ASEC2017)
str(ASEC2016)
str(ASEC2015)
str(ASEC2014)

# selecting variables
asec_vars <- c("year", "hhseq", "pppos", "peridh", "age", "popstat", "female", "wbho", "wbhao", "wbhaom", "married", "marstat", "clslyr", "hrslyr", "wrk", "firmsz", "lfstat", "state", "educ", "educ92", "occ2d_03", "incp_all", "incp_ern", "hrearn", "pvlpp")
 
asec_2014 <- ASEC2014[asec_vars]
asec_2015 <- ASEC2015[asec_vars]
asec_2016 <- ASEC2016[asec_vars]
asec_2017 <- ASEC2017[asec_vars]
asec_2018 <- ASEC2018[asec_vars]
 
# Identify and remove duplicate values based on "peridh" this is unique to each individual.
duplicated(asec_2014$peridh)
asec_2014 <-asec_2014[!duplicated(asec_2014$peridh),]

duplicated(asec_2015$peridh)
asec_2015 <-asec_2015[!duplicated(asec_2015$peridh),]

duplicated(asec_2016$peridh)
asec_2016 <-asec_2016[!duplicated(asec_2016$peridh),]

duplicated(asec_2017$peridh)
asec_2017 <-asec_2017[!duplicated(asec_2017$peridh),]

duplicated(asec_2018$peridh)
asec_2018 <-asec_2018[!duplicated(asec_2018$peridh),]

# Creating subset by removing children, elderly and individuals unemployed or 0 income.
asec_2014 <- subset(asec_2014, age>=18 & age<=65 &  lfstat=="Employed" & incp_all!=0)
asec_2015 <- subset(asec_2015, age>=18 & age<=65 &  lfstat=="Employed" & incp_all!=0)
asec_2016 <- subset(asec_2016, age>=18 & age<=65 &  lfstat=="Employed" & incp_all!=0)
asec_2017 <- subset(asec_2017, age>=18 & age<=65 &  lfstat=="Employed" & incp_all!=0)
asec_2018 <- subset(asec_2018, age>=18 & age<=65 &  lfstat=="Employed" & incp_all!=0)

# removing missing values from race and education

asec_2014 <- na.omit(asec_2014, cols=c("wbho", "wbhao", "wbhaom", "educ"))
asec_2015 <- na.omit(asec_2015, cols=c("wbho", "wbhao", "wbhaom", "educ"))
asec_2016 <- na.omit(asec_2016, cols=c("wbho", "wbhao", "wbhaom", "educ"))
asec_2017 <- na.omit(asec_2017, cols=c("wbho", "wbhao", "wbhaom", "educ"))
asec_2018 <- na.omit(asec_2018, cols=c("wbho", "wbhao", "wbhaom", "educ"))

# merging the data vertically.
clean_asec <- rbind(asec_2014, asec_2015, asec_2016, asec_2017, asec_2018)


# .csv files

write.csv(asec_2014, file="clean_asec_2014.csv", row.names = FALSE)
write.csv(asec_2015, file="clean_asec_2015.csv", row.names = FALSE)
write.csv(asec_2016, file="clean_asec_2016.csv", row.names = FALSE)
write.csv(asec_2017, file="clean_asec_2017.csv", row.names = FALSE)
write.csv(asec_2018, file="clean_asec_2018.csv", row.names = FALSE)

write.csv(clean_asec, file="clean_asec_5yr.csv", row.names = FALSE)
```

1.  **Standardized Police Stop data importing and cleaning**

I did the following steps for each selected states.

-   First, I imported the data for each of the selected states and
    viewed the data structure. There were 29 variables and . Since stop
    data by police, is too big with millions of rows, I created a subset
    of stop data with between 2013-2015. Since, each row corresponds
    single stop. I further filtered out the data by type of stop and
    narrowed it to just vehicular stop because there were some
    pedestrian stops as well.

-   Second, I selected the variables that seemed relevant to my analysis
    and further removed columns such as arrest time, lat, lon, date and
    other irrelavant columns.

-   Third, It didn’t have any unique identification to tell whether the
    data had any duplicated values and applying duplicated function was
    removing too much data, So I decided to not remove any data.

-   Fourth, I downloaded Census state population data for each of those
    states for year 2013-2015.

-   I also converted the dataframe into .csv file to later import it for
    analysis.

``` r
# importing data 

mt_stop.data <- read.csv("rawdata/mt_statewide_2020_04_01.csv")
nc_stop.data <- read.csv("rawdata/nc_statewide_2020_04_01.csv")
oh_stop.data <- read.csv("rawdata/oh_statewide_2020_04_01.csv")
az_stop.data <- read.csv("rawdata/az_statewide_2020_04_01.csv")
wi_stop.data <- read.csv("rawdata/wi_statewide_2020_04_01.csv")

# creating subset data for years 2010-2015
date1 <- as.Date(mt_stop.data$date)
date2 <- as.Date(nc_stop.data$date)
date3 <- as.Date(oh_stop.data$date)
date4 <- as.Date(az_stop.data$date)
date5 <- as.Date(wi_stop.data$date)

# adding year variables
mt_stop.data$year <-format(date1, format="%Y")
nc_stop.data$year <-format(date2, format="%Y")
oh_stop.data$year <-format(date3, format="%Y")
az_stop.data$year <-format(date4, format="%Y")
wi_stop.data$year <-format(date5, format="%Y")

mt_stop.data$year <-as.numeric(mt_stop.data$year)
nc_stop.data$year <-as.numeric(nc_stop.data$year)
oh_stop.data$year <-as.numeric(oh_stop.data$year)
az_stop.data$year <-as.numeric(az_stop.data$year)
wi_stop.data$year <-as.numeric(wi_stop.data$year)

# Creating subset.

mt_stop.df <- subset(mt_stop.data, year>=2013 & year<=2015)
nc_stop.df <- subset(nc_stop.data, year>=2013 & year<=2015)
oh_stop.df <- subset(oh_stop.data, year>=2013 & year<=2015)
az_stop.df <- subset(az_stop.data, year>=2013 & year<=2015)
wi_stop.df <- subset(wi_stop.data, year>=2013 & year<=2015)

# adding state variable
mt_stop.df$state <- "Montana"
nc_stop.df$state <- "North Carolina"
oh_stop.df$state <- "Ohio"
az_stop.df$state <-"Arizona"
wi_stop.df$state <- "Wisconsin"

# filter for vehicular stop
mt_stop.df <- mt_stop.df %>% filter(type == "vehicular")
nc_stop.df <- nc_stop.df %>% filter(type == "vehicular")
oh_stop.df <- oh_stop.df %>% filter(type == "vehicular")
az_stop.df <- az_stop.df %>% filter(type == "vehicular")
wi_stop.df <- wi_stop.df %>% filter(type == "vehicular")


# selecting variables
stop_vars <- c("year", "county_name", "subject_race", "subject_sex", "arrest_made", "search_conducted", "state")
 
mt_stop <- mt_stop.df[stop_vars]
nc_stop <- nc_stop.df[stop_vars]
oh_stop <- oh_stop.df[stop_vars]
az_stop <- az_stop.df[stop_vars]
wi_stop <- wi_stop.df[stop_vars]
 

# .csv files
write.csv(mt_stop, file="mt_clean_stop.csv", row.names = FALSE)
write.csv(nc_stop, file="nc_clean_stop.csv", row.names = FALSE)
write.csv(oh_stop, file="oh_clean_stop.csv", row.names = FALSE)
write.csv(az_stop, file="az_clean_stop.csv", row.names = FALSE)
write.csv(wi_stop, file="wi_clean_stop.csv", row.names = FALSE)

population.df <- read.csv("rawdata/sc-est2015-alldata6.csv")
population.df <- population.df %>% select(NAME, RACE, ORIGIN, POPESTIMATE2013, POPESTIMATE2014, POPESTIMATE2015)

states <- c("Arizona", "North Carolina", "Wisconsin", "Ohio", "Montana")
population.df <- population.df %>% filter(NAME == states)
write.csv(population.df, file="population_df.csv", row.names = FALSE)
```

1.  **HMDA data importing and cleaning**

I did the following steps for 2015-2015 year data.

-   First, I imported the data for HMDA data NY and viewed the data
    structure. There are 78 total columns and about 400K plus rows.Since
    I am only interested in approvals and denials. I decided to narrow
    it down to just those. In “action\_taken”, I removed following
    codes:

4 – Application withdrawn by applicant  
5 – File closed for incompleteness  
7 – Preapproval request denied by financial institution  
8 – Preapproval request approved but not accepted (optional reporting)

and kept the following codes:  
1 – Loan originated  
2 – Application approved but not accepted  
3 – Application denied by financial institution  
6 – Loan purchased by the institution

-   Second, I also excluded rows that had “Not applicable” or
    “Information not provided by applicant in mail, Internet, or
    telephone application” in the race column.

-   Third, I removed any columns that were repetitive.

-   Fourth, I removed duplicate values based on respondent ID and loan
    amount, because there were repetitive respondent ID but the loan
    amount was different, so one way to filter out the data is by
    cross-validating.

-   Fifth, I deleted any rows with NA in action\_taken.

-   I also converted the dataframe into .csv file to later import it for
    analysis.

``` r
# importing data 

HMDA.2017 <- read.csv("rawdata/hmda_2017_ny_all-records_labels.csv")
HMDA.2016 <- read.csv("rawdata/hmda_2016_ny_all-records_labels.csv")
HMDA.2015 <- read.csv("rawdata/hmda_2015_ny_all-records_labels.csv")


# filtering data based on denials and approvals

# 2017
Mortgage.2017 <- HMDA.2017 %>% filter(action_taken !=4)
Mortgage.2017 <- Mortgage.2017 %>% filter(action_taken !=5)
Mortgage.2017 <- Mortgage.2017 %>% filter(action_taken !=7)
Mortgage.2017 <- Mortgage.2017 %>% filter(action_taken !=8)

# 2016
Mortgage.2016 <- HMDA.2016 %>% filter(action_taken !=4)
Mortgage.2016 <- Mortgage.2016 %>% filter(action_taken !=5)
Mortgage.2016 <- Mortgage.2016 %>% filter(action_taken !=7)
Mortgage.2016 <- Mortgage.2016 %>% filter(action_taken !=8)


# 2016
Mortgage.2015 <- HMDA.2015 %>% filter(action_taken !=4)
Mortgage.2015 <- Mortgage.2015 %>% filter(action_taken !=5)
Mortgage.2015 <- Mortgage.2015 %>% filter(action_taken !=7)
Mortgage.2015 <- Mortgage.2015 %>% filter(action_taken !=8)


# subsetting data for race
Mortgage.2017 <- Mortgage.2017 %>% filter(applicant_race_1 !=6)
Mortgage.2017 <- Mortgage.2017 %>% filter(applicant_race_1 !=7)

Mortgage.2016 <- Mortgage.2016 %>% filter(applicant_race_1 !=6)
Mortgage.2016 <- Mortgage.2016 %>% filter(applicant_race_1 !=7)

Mortgage.2015 <- Mortgage.2015 %>% filter(applicant_race_1 !=6)
Mortgage.2015 <- Mortgage.2015 %>% filter(applicant_race_1 !=7)




# selecing columns
Mortgage.2017 <- Mortgage.2017 %>% select(respondent_id, agency_abbr, agency_code, loan_type_name, loan_type, property_type, loan_purpose, owner_occupancy, loan_amount_000s, preapproval, action_taken, action_taken_name, msamd, census_tract_number, applicant_ethnicity, applicant_race_1, applicant_race_name_1, co_applicant_race_1)

Mortgage.2016 <- Mortgage.2016 %>% select(respondent_id, agency_abbr, agency_code, loan_type_name, loan_type, property_type, loan_purpose, owner_occupancy, loan_amount_000s, preapproval, action_taken, action_taken_name, msamd, census_tract_number, applicant_ethnicity, applicant_race_1, applicant_race_name_1, co_applicant_race_1)

Mortgage.2015 <- Mortgage.2015 %>% select(respondent_id, agency_abbr, agency_code, loan_type_name, loan_type, property_type, loan_purpose, owner_occupancy, loan_amount_000s, preapproval, action_taken, action_taken_name, msamd, census_tract_number, applicant_ethnicity, applicant_race_1, applicant_race_name_1, co_applicant_race_1)


#removes duplicate rows based on all columns
Mortgage.2017 <- Mortgage.2017 %>% distinct()
Mortgage.2016 <- Mortgage.2016 %>% distinct()
Mortgage.2015 <- Mortgage.2015 %>% distinct()


# drop missing values in action_taken and race
Mortgage.2017 <- na.omit(Mortgage.2017, cols="action_taken")
Mortgage.2016 <- na.omit(Mortgage.2016, cols="action_taken")
Mortgage.2015 <- na.omit(Mortgage.2015, cols="action_taken")


# .csv files
write.csv(Mortgage.2017, file="Mortgage_2017.csv", row.names = FALSE)
write.csv(Mortgage.2016, file="Mortgage_2016.csv", row.names = FALSE)
write.csv(Mortgage.2015, file="Mortgage_2015.csv", row.names = FALSE)
```

### Method

The three data set. For the stop data to analyze Arrest vs. race I used
GLM model, because Arrest was a binary data variable. For ASEC data, I
ended up using simple linear regression, however it violates the
Normality Assumptions. For the HMDA data for denials and approval I used
GLM Model.

### Analyzing Stop data

I will first be using state data for the 5 states (MT, OH, NC, WI, &
AZ).

| year | county\_name    | subject\_race | subject\_sex | arrest\_made | search\_conducted | state   |
|-----:|:----------------|:--------------|:-------------|:-------------|:------------------|:--------|
| 2013 | Maricopa County | white         | male         | FALSE        | FALSE             | Arizona |
| 2013 | Pima County     | white         | male         | FALSE        | FALSE             | Arizona |
| 2013 | Pima County     | hispanic      | male         | FALSE        | FALSE             | Arizona |
| 2013 | Pima County     | white         | female       | FALSE        | FALSE             | Arizona |
| 2013 | Pima County     | white         | female       | FALSE        | FALSE             | Arizona |
| 2013 | Pima County     | other         | male         | FALSE        | FALSE             | Arizona |
| 2013 | Pima County     | white         | male         | FALSE        | FALSE             | Arizona |
| 2013 | Pima County     | hispanic      | male         | FALSE        | FALSE             | Arizona |
| 2013 | Pima County     | white         | male         | FALSE        | FALSE             | Arizona |
| 2013 | Pima County     | white         | male         | FALSE        | FALSE             | Arizona |

Table 1: Consolidated Stop Dataset

    ##   year       n
    ## 1 2013 3257149
    ## 2 2014 3145348
    ## 3 2015 3023197

    ##    year           subject_race       n
    ## 1  2013 asian/pacific islander   48894
    ## 2  2013                  black  667066
    ## 3  2013               hispanic  250118
    ## 4  2013                  other   63094
    ## 5  2013                  white 2227977
    ## 6  2014 asian/pacific islander   49657
    ## 7  2014                  black  650808
    ## 8  2014               hispanic  253741
    ## 9  2014                  other   62696
    ## 10 2014                  white 2128446
    ## 11 2015 asian/pacific islander   46734
    ## 12 2015                  black  654896
    ## 13 2015               hispanic  253782
    ## 14 2015                  other   66664
    ## 15 2015                  white 2001121

![](DSC520_Final-Project1_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->![](DSC520_Final-Project1_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->![](DSC520_Final-Project1_files/figure-gfm/unnamed-chunk-4-3.png)<!-- -->![](DSC520_Final-Project1_files/figure-gfm/unnamed-chunk-4-4.png)<!-- -->![](DSC520_Final-Project1_files/figure-gfm/unnamed-chunk-4-5.png)<!-- -->![](DSC520_Final-Project1_files/figure-gfm/unnamed-chunk-4-6.png)<!-- -->

Looking at the plot, it looks like minority is less likely to get
pullover by police compared to White. However, this data does not
contain population estimates of the states. This could also due to large
population of certain race in those states. Below is the analysis of
number of stops in proportion to population estimates. To compare this I
imported census population data for each race and 5 states, and further
found the proportion by dividing total stops by race/total population by
race for year 2015

| NAME    | RACE  | ORIGIN | POPESTIMATE2013 | POPESTIMATE2014 | POPESTIMATE2015 |
|:--------|:------|-------:|----------------:|----------------:|----------------:|
| Arizona | white |      0 |           65884 |           65436 |           65599 |
| Arizona | white |      0 |           72801 |           74183 |           73077 |
| Arizona | white |      0 |           73633 |           71682 |           72815 |
| Arizona | white |      0 |           72066 |           72881 |           72823 |
| Arizona | white |      0 |           80045 |           77694 |           75985 |
| Arizona | white |      0 |           70513 |           70522 |           73152 |
| Arizona | white |      0 |           72476 |           72857 |           72585 |
| Arizona | white |      0 |           65494 |           67375 |           67756 |
| Arizona | white |      0 |           73196 |           69125 |           66442 |
| Arizona | white |      0 |           67230 |           66709 |           68302 |

Table 2: Population Data for each state

| subject\_race | year | state          |       n | sum(POPESTIMATE2015) |     prop |
|:--------------|-----:|:---------------|--------:|---------------------:|---------:|
| black         | 2015 | North Carolina | 1468490 |              1728953 | 84.93522 |
| hispanic      | 2015 | North Carolina |  336586 |               362783 | 92.77888 |
| other         | 2015 | North Carolina |   91654 |               262158 | 34.96136 |
| white         | 2015 | North Carolina | 2473729 |              5344967 | 46.28146 |

![](DSC520_Final-Project1_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

| subject\_race | year | state   |      n | sum(POPESTIMATE2015) |     prop |
|:--------------|-----:|:--------|-------:|---------------------:|---------:|
| black         | 2015 | Arizona |  75385 |               250611 | 30.08048 |
| hispanic      | 2015 | Arizona | 329895 |               859641 | 38.37590 |
| other         | 2015 | Arizona |  64067 |               384056 | 16.68168 |
| white         | 2015 | Arizona | 761786 |              3766444 | 20.22560 |

| subject\_race | year | state          |       n | sum(POPESTIMATE2015) |     prop |
|:--------------|-----:|:---------------|--------:|---------------------:|---------:|
| black         | 2015 | North Carolina | 1468490 |              1728953 | 84.93522 |
| hispanic      | 2015 | North Carolina |  336586 |               362783 | 92.77888 |
| other         | 2015 | North Carolina |   91654 |               262158 | 34.96136 |
| white         | 2015 | North Carolina | 2473729 |              5344967 | 46.28146 |

| subject\_race | year | state   |      n | sum(POPESTIMATE2015) |     prop |
|:--------------|-----:|:--------|-------:|---------------------:|---------:|
| black         | 2015 | Montana |   4076 |                 4800 | 84.91667 |
| hispanic      | 2015 | Montana |   6741 |                14851 | 45.39088 |
| other         | 2015 | Montana |  17826 |                73057 | 24.40013 |
| white         | 2015 | Montana | 308304 |               728873 | 42.29873 |

| subject\_race | year | state |       n | sum(POPESTIMATE2015) |     prop |
|:--------------|-----:|:------|--------:|---------------------:|---------:|
| black         | 2015 | Ohio  |  396292 |              1165182 | 34.01117 |
| hispanic      | 2015 | Ohio  |   66486 |               168346 | 39.49366 |
| other         | 2015 | Ohio  |   13344 |               211702 |  6.30320 |
| white         | 2015 | Ohio  | 2432239 |              7446233 | 32.66402 |

| subject\_race | year | state     |      n | sum(POPESTIMATE2015) |      prop |
|:--------------|-----:|:----------|-------:|---------------------:|----------:|
| black         | 2015 | Wisconsin |  28527 |               297804 |  9.579119 |
| hispanic      | 2015 | Wisconsin |  17933 |               149484 | 11.996602 |
| other         | 2015 | Wisconsin |   5563 |               125696 |  4.425757 |
| white         | 2015 | Wisconsin | 381486 |              4037286 |  9.449070 |

Looking at the Bar chart, It seems like Hispanics has higher proportion
to population, meaning that 38.37% of hispanics are pulled over more
compare to white 20% in Arizona out of over all population. Same with
blacks with 30% in Arizona. Asians on the other hand are pulled over lot
less when compared to the population data. However in Ohio, blacks have
higher chance of getting pulled over.

Furthermore, I am also interested in “Arrest Made” variable in this data
and it’s relationship to race. I will be using GLM model since
explanatory variable is nominal categorical data and outcome variable is
binary data. Further I am also interested in multinomial regression with
subject sex as another variable.

    ## 
    ## Call:
    ## glm(formula = arrest_made ~ subject_race, family = binomial(logit), 
    ##     data = stop.df)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -0.2171  -0.2021  -0.1454  -0.1454   3.1157  
    ## 
    ## Coefficients:
    ##                      Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)          -4.84600    0.02982 -162.49   <2e-16 ***
    ## subject_raceblack     0.96457    0.03025   31.89   <2e-16 ***
    ## subject_racehispanic  0.98478    0.03090   31.87   <2e-16 ***
    ## subject_raceother     1.10955    0.03344   33.19   <2e-16 ***
    ## subject_racewhite     0.30218    0.03008   10.05   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1354617  on 9425693  degrees of freedom
    ## Residual deviance: 1340224  on 9425689  degrees of freedom
    ## AIC: 1340234
    ## 
    ## Number of Fisher Scoring iterations: 7

    ## 
    ## Call:
    ## glm(formula = arrest_made ~ subject_race + subject_sex, family = binomial(logit), 
    ##     data = stop.df)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -0.2355  -0.1687  -0.1573  -0.1202   3.2427  
    ## 
    ## Coefficients:
    ##                       Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)          -5.252309   0.030291 -173.39   <2e-16 ***
    ## subject_raceblack     1.007433   0.030259   33.29   <2e-16 ***
    ## subject_racehispanic  0.970504   0.030907   31.40   <2e-16 ***
    ## subject_raceother     1.140555   0.033446   34.10   <2e-16 ***
    ## subject_racewhite     0.325372   0.030082   10.82   <2e-16 ***
    ## subject_sexmale       0.540209   0.006597   81.89   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1354617  on 9425693  degrees of freedom
    ## Residual deviance: 1332939  on 9425688  degrees of freedom
    ## AIC: 1332951
    ## 
    ## Number of Fisher Scoring iterations: 7

The null residual deviance is higher than the null deviance and it is
also a larger value, which means it’s not really a good fit. Also the
p-value is lower than .05 meaning we can reject the null hypothesis that
the model is not better than chance at predicting the outcome.

I used Census ASEC data set for years 2014 till 2018.

| year | hhseq | pppos | peridh | age | popstat        | female | wbho  | wbhao | wbhaom | married | marstat   | clslyr                         | hrslyr | wrk     | firmsz  | lfstat   | state | educ         | educ92                     | occ2d\_03                               | incp\_all | incp\_ern |    hrearn | pvlpp               |
|-----:|------:|------:|-------:|----:|:---------------|-------:|:------|:------|:-------|--------:|:----------|:-------------------------------|-------:|:--------|:--------|:---------|:------|:-------------|:---------------------------|:----------------------------------------|----------:|----------:|----------:|:--------------------|
| 2014 |   944 |    41 |  94401 |  54 | Civilian adult |      1 | White | White | White  |       0 | Separated | Private                        |     40 | Working | 100-499 | Employed | Maine | College      | Bachelor’s degree          | Community and social service occs       |     34002 |     34000 | 16.346153 | 150%+ poverty level |
| 2014 |  1239 |    42 | 123902 |  64 | Civilian adult |      1 | White | White | White  |       1 | Married   | Self-employed, not incorp/farm |     15 | Working | &lt;100 | Employed | Maine | Advanced     | Master’s degree            | Life, physical, and social science occs |     35900 |     25000 | 32.051281 | 150%+ poverty level |
| 2014 |   353 |    41 |  35301 |  63 | Civilian adult |      1 | White | White | White  |       0 | Divorced  | Federal Government             |     40 | Working | 1000+   | Employed | Maine | Advanced     | Master’s degree            | Business and financial operations occs  |     70853 |     65000 | 31.250000 | 150%+ poverty level |
| 2014 |  1297 |    41 | 129701 |  55 | Civilian adult |      0 | White | White | White  |       1 | Married   | Private                        |     26 | Working | &lt;100 | Employed | Maine | Advanced     | Master’s degree            | Education, training, and library occs   |     43600 |     12800 |  9.467456 | 150%+ poverty level |
| 2014 |   465 |    41 |  46501 |  58 | Civilian adult |      0 | White | White | White  |       1 | Married   | Private                        |     40 | Working | 500-999 | Employed | Maine | HS           | HS graduate, GED           | Production occs                         |     55000 |     55000 | 26.442308 | 150%+ poverty level |
| 2014 |   465 |    42 |  46502 |  52 | Civilian adult |      1 | White | White | White  |       1 | Married   | Private                        |     32 | Working | 1000+   | Employed | Maine | College      | Bachelor’s degree          | Healthcare support occs                 |     25000 |     25000 | 15.024038 | 150%+ poverty level |
| 2014 |   488 |    41 |  48801 |  34 | Civilian adult |      0 | White | White | White  |       1 | Married   | Local Government               |     60 | Working | 1000+   | Employed | Maine | HS           | HS graduate, GED           | Construction and extraction occs        |     45000 |     45000 | 14.423077 | 150%+ poverty level |
| 2014 |   488 |    42 |  48802 |  38 | Civilian adult |      1 | White | White | White  |       1 | Married   | Private                        |     35 | Working | &lt;100 | Employed | Maine | HS           | HS graduate, GED           | Farming, fishing, and forestry occs     |     16300 |     15000 | 11.278195 | 150%+ poverty level |
| 2014 |   787 |    41 |  78701 |  64 | Civilian adult |      1 | White | White | White  |       0 | Widowed   | Private                        |     60 | Working | &lt;100 | Employed | Maine | Some college | Some college but no degree | Community and social service occs       |     65237 |     60000 | 19.230770 | 150%+ poverty level |
| 2014 |   858 |    41 |  85801 |  58 | Civilian adult |      1 | White | White | White  |       0 | Widowed   | Private                        |     40 | Working | 1000+   | Employed | Maine | Some college | Some college but no degree | Sales and related occs                  |     50010 |     50000 | 24.038462 | 150%+ poverty level |

Table 3: ASEC Census Bureau Data

![](DSC520_Final-Project1_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->![](DSC520_Final-Project1_files/figure-gfm/unnamed-chunk-7-2.png)<!-- -->

The yearly bar chart shows the obvious disparity.

Since I am only interested in Income vs race and Education and any other
variable that can effect Income.I will only be doing Analysis on 2018
for this one.

    ## 
    ## Call:
    ## lm(formula = incp_all ~ wbhao, data = asec2018_df)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ##  -82881  -33590  -16117   11883 1665476 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)    71053.0      962.2  73.844  < 2e-16 ***
    ## wbhaoBlack    -24026.6     1246.8 -19.271  < 2e-16 ***
    ## wbhaoHispanic -27936.2     1137.7 -24.554  < 2e-16 ***
    ## wbhaoOther    -22040.4     2342.9  -9.407  < 2e-16 ***
    ## wbhaoWhite     -4630.3     1021.4  -4.533 5.81e-06 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 73470 on 76235 degrees of freedom
    ## Multiple R-squared:  0.01993,    Adjusted R-squared:  0.01988 
    ## F-statistic: 387.6 on 4 and 76235 DF,  p-value: < 2.2e-16

    ##                    2.5 %     97.5 %
    ## (Intercept)    69167.076  72938.913
    ## wbhaoBlack    -26470.284 -21582.923
    ## wbhaoHispanic -30166.130 -25706.173
    ## wbhaoOther    -26632.524 -17448.281
    ## wbhaoWhite     -6632.184  -2628.384

    ##                Df    Sum Sq   Mean Sq F value Pr(>F)    
    ## wbhao           4 8.371e+12 2.093e+12   387.6 <2e-16 ***
    ## Residuals   76235 4.116e+14 5.399e+09                   
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

We have negative residuals meaning, the actual values were less than
what was predicted. The p-value is less than .05 and R-squared is very
low with 0.019 indicating close to no relationship. Also the model
violates the normality assumption so linear model is not a good fit.
\#\#\# Analyzing HMDA Data

For Mortgage I am interested in Race being the factor in denials of
mortgage. Since approvals and Denials are binary data. I will use GLM.

| respondent\_id | agency\_abbr | agency\_code | loan\_type\_name | loan\_type | property\_type | loan\_purpose | owner\_occupancy | loan\_amount\_000s | preapproval | action\_taken | action\_taken\_name                         | msamd | census\_tract\_number | applicant\_ethnicity | applicant\_race\_1 | applicant\_race\_name\_1  | co\_applicant\_race\_1 |
|:---------------|:-------------|-------------:|:-----------------|-----------:|---------------:|--------------:|-----------------:|-------------------:|------------:|--------------:|:--------------------------------------------|------:|----------------------:|---------------------:|-------------------:|:--------------------------|-----------------------:|
| 11-3019327     | HUD          |            7 | Conventional     |          1 |              1 |             1 |                2 |                356 |           2 |             3 | Application denied by financial institution | 35614 |                626.00 |                    2 |                  5 | White                     |                      8 |
| 20-0193314     | FDIC         |            3 | Conventional     |          1 |              2 |             1 |                1 |                 58 |           3 |             3 | Application denied by financial institution | 46540 |                230.00 |                    3 |                  5 | White                     |                      8 |
| 7197000003     | HUD          |            7 | Conventional     |          1 |              1 |             3 |                1 |                100 |           3 |             1 | Loan originated                             | 35614 |                616.01 |                    2 |                  3 | Black or African American |                      8 |
| 68-0309242     | HUD          |            7 | Conventional     |          1 |              1 |             1 |                2 |                300 |           3 |             6 | Loan purchased by the institution           | 35004 |               4147.00 |                    2 |                  5 | White                     |                      8 |
| 0000060153     | NCUA         |            5 | Conventional     |          1 |              1 |             2 |                1 |                250 |           3 |             3 | Application denied by financial institution | 35614 |               1502.00 |                    2 |                  2 | Asian                     |                      8 |
| 75-2921540     | HUD          |            7 | Conventional     |          1 |              1 |             3 |                1 |                315 |           3 |             1 | Loan originated                             | 35614 |                616.01 |                    2 |                  3 | Black or African American |                      8 |
| 0000852218     | CFPB         |            9 | Conventional     |          1 |              1 |             1 |                1 |                117 |           3 |             1 | Loan originated                             | 20524 |                400.03 |                    2 |                  5 | White                     |                      8 |
| 7197000003     | HUD          |            7 | Conventional     |          1 |              1 |             3 |                1 |                312 |           3 |             1 | Loan originated                             | 35614 |                616.01 |                    2 |                  3 | Black or African American |                      8 |
| 14-1770243     | HUD          |            7 | Conventional     |          1 |              1 |             3 |                1 |                278 |           3 |             3 | Application denied by financial institution | 20524 |                300.00 |                    2 |                  5 | White                     |                      8 |
| 11-3290207     | HUD          |            7 | FHA-insured      |          2 |              1 |             1 |                1 |                599 |           3 |             1 | Loan originated                             | 35614 |                614.00 |                    2 |                  3 | Black or African American |                      3 |

Table 4: HMDA Dataset

    ## 
    ## Call:
    ## glm(formula = action_taken ~ applicant_race_name_1, data = HMDA2017_df)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -0.4540  -0.2112  -0.2112  -0.2112   0.7888  
    ## 
    ## Coefficients:
    ##                                                                Estimate
    ## (Intercept)                                                     1.45398
    ## applicant_race_name_1Asian                                     -0.22849
    ## applicant_race_name_1Black or African American                 -0.08311
    ## applicant_race_name_1Native Hawaiian or Other Pacific Islander -0.06163
    ## applicant_race_name_1White                                     -0.24274
    ##                                                                Std. Error
    ## (Intercept)                                                       0.01098
    ## applicant_race_name_1Asian                                        0.01127
    ## applicant_race_name_1Black or African American                    0.01131
    ## applicant_race_name_1Native Hawaiian or Other Pacific Islander    0.01720
    ## applicant_race_name_1White                                        0.01102
    ##                                                                t value Pr(>|t|)
    ## (Intercept)                                                    132.408  < 2e-16
    ## applicant_race_name_1Asian                                     -20.280  < 2e-16
    ## applicant_race_name_1Black or African American                  -7.346 2.05e-13
    ## applicant_race_name_1Native Hawaiian or Other Pacific Islander  -3.583  0.00034
    ## applicant_race_name_1White                                     -22.029  < 2e-16
    ##                                                                   
    ## (Intercept)                                                    ***
    ## applicant_race_name_1Asian                                     ***
    ## applicant_race_name_1Black or African American                 ***
    ## applicant_race_name_1Native Hawaiian or Other Pacific Islander ***
    ## applicant_race_name_1White                                     ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for gaussian family taken to be 0.1742436)
    ## 
    ##     Null deviance: 45802  on 259204  degrees of freedom
    ## Residual deviance: 45164  on 259200  degrees of freedom
    ## AIC: 282690
    ## 
    ## Number of Fisher Scoring iterations: 2

For HMDA data, the residual deviance is lower than null deviance, but
the p-value is significantly lower than .05 meaning we can reject the
null hypothesis.
