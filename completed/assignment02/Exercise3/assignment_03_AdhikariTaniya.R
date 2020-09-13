install.packages("ggplot2")
install.packages("plyr")

library(ggplot2)
library(plyr)

getwd()
dir()

## importing data into R
scores_df <- read.csv("Exercise3/scores.csv")
str(scores_df)
summary(scores_df)

## subsetting data by section variables
sports_df <- subset(scores_df, scores_df$Section =="Sports")
regular_df <- subset(scores_df, scores_df$Section =="Regular")
head(sports_df)
summary(sports_df)

head(regular_df)
summary(regular_df)

## calculating total number of students
total_students <- ddply(scores_df, "Section", summarise, grp.sum=sum(Count))
total_students

## calculating mean
mu <- ddply(scores_df, "Section", summarise, grp.mean=mean(Score))
mu

## calculating median
med <- ddply(scores_df, "Section", summarise, grp.median=median(Score))
med

## calculating std
std <- ddply(scores_df, "Section", summarise, grp.sd=sd(Score))
std

## plot for number of students vs Test Scores
ggplot(scores_df, mapping=aes(x=Score,y=Count)) + 
  geom_col(aes(color=Section)) + 
  labs(title="Histogram of Test Scores",x="Test Scores", y = "Number of Students") +
  theme(legend.position="top")

## Density plot for graph tendency
ggplot(scores_df, aes(x=Score, color=Section)) +
  geom_density()+
  geom_vline(data=mu, aes(xintercept=grp.mean, color=Section),
             linetype="dashed") + 
  labs(title="Density Plot",x="Test Scores", y = "Density")

## Box Plot for spread
ggplot(scores_df, aes(x=Score, fill=Section)) +
  geom_boxplot() +
  labs(title="Box Plot",x="Test Scores")
