install.packages("ggplot2")
install.packages("knitr")
install.packages("pastecs")
install.packages("moments")



library(pastecs)
library(moments)


getwd()
dir()

library(knitr)
## importing data into R
df <- read.csv("Exercise 05/acs-14-1yr-s0201.csv")
kable(head(df,5),caption = "A table of the Dataset with first 5 values.")

str(df)
n_row <- nrow(df)
n_col <- ncol(df)

summary(df$HSDegree)

library(ggplot2)
theme_set(theme_classic())

## Histogram Plot of HSDegree
ggplot(df, aes(x=HSDegree)) + 
  geom_histogram(bins=40,color="black", fill="lightblue") + ggtitle("HSDegree Histogram Plot with Bins 40") + 
  xlab("HS Degree Completion (%)") + ylab("Number of Counties")


## Histogram with normal curve layered
ggplot(df, aes(x=HSDegree)) + 
  geom_histogram(aes(y=..density..), bins=40,color="black", fill="lightblue") +
  ggtitle("HSDegree Histogram Plot with Normal Curve") + 
  xlab("HS Degree Completion (%)") + ylab("Number of Counties") +
  xlim(60,120) + 
  stat_function(fun = dnorm, args = list(mean = mean(df$HSDegree), sd = sd(df$HSDegree)), color = "darkblue")

## probability plot using ggplot and stat_qq()
ggplot(df, aes(sample=HSDegree)) +
  ggtitle("Probability plot of HSDegree") + 
  xlab("Theoretical") + ylab("HSDegree") +
  stat_qq(colour="orange") + 
  stat_qq_line(color="black")

##Kernel Density curve with normal curve
ggplot(df, aes(x=HSDegree)) + 
  geom_density(bins=40,color="black", fill="lightblue") +
  ggtitle("Kernel Density curve for HSDegree with Normal curve") +
  xlab("HS Degree Completion (%)") + ylab("Density") +
  xlim(60,120) + 
  stat_function(fun = dnorm, args = list(mean = mean(df$HSDegree), sd = sd(df$HSDegree)), color = "black")


library(pastecs)
clean_df = subset(df, select = -c(Id2,PopGroupID,POPGROUP.display.label))
desc_stat <- stat.desc(clean_df)
kable(desc_stat, digits =2,caption = "Descriptive Statistics Table")

library(moments)
skew <- skewness(df$HSDegree)
kurt <- kurtosis(df$HSDegree)
e_kurtosis <- kurtosis(df$HSDegree) - 3


HSDegree_Zscores <-(df$HSDegree -mean(df$HSDegree))/sd(df$HSDegree)
new_df <- cbind(clean_df,HSDegree_Zscores)
kable(head(new_df,5),caption = "Dataset with z-scores appended")

## density curve for z-scores
ggplot(new_df, aes(x=HSDegree_Zscores)) +
  geom_density(bins=40,color="black") + 
  ggtitle("KDensity curve for z-scores") +
  xlab("z-scores") + ylab("Density") +
  xlim(-4,4)
summary(new_df$HSDegree_Zscores)