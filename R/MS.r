# **********************************************************************************
#   File        : MS_17July2017.r  
#   Author      : Jeff Polzer
#   Created     : 17 July 2017
#   Modified    : 17 July 2017
#   Description : .r file for analyzing MS_collapse_by_tenant_merge_13_Jul_2017.RData
#   **********************************************************************************/

# This clears R's data memory so new data can be loaded
rm(list = ls())

# Set working directory for this session
setwd("~/Dropbox/Dashboard")

# list working directory and contents: 
getwd()
list.files()

# open haven package to import Stata .dta file
library(haven)

# import Stata .dta file
msdata <- read_dta("~/Dropbox/Dashboard/data/MS_collapse_by_tenant_merge_13 Jul 2017.dta")

View(msdata)

# open a log file
sink(file = "./logs/MS_18July2017", append = FALSE, type = c("output", "message"), split = TRUE)

# use these packages

## install.packages("dplyr")
library(dplyr)

## install.packages('Hmisc')
library('Hmisc')

# The following command lists the contents (including name, type and numbers of variables, as well as
# number of observations, of the data frame.
contents(msdata)

# The following command lists the first 5 rows of the data frame.
head(msdata,n=5L)

# provide structure of the dataset
str(msdata)

summary(msdata)

names(msdata)

table(msdata$IndustryGroup)
ftable(msdata$IndustryGroup)

mytable <- table(msdata$IndustryGroup, msdata$TenantSize)
mytable # print table
ftable (mytable) # print table

install.packages("gmodels")
library(gmodels)
help(CrossTable)
CrossTable(msdata$IndustryGroup,msdata$TenantSize, digits=3, max.width = 1, format = c("SPSS"))

install.packages("pastecs")
library(pastecs)
stat.desc(msdata$UserCount)
round(stat.desc(msdata$UserCount))

hist(msdata$internalnetworksize, breaks = "FD")
hist(msdata$externalnetworksize, breaks = "FD")

plot(msdata$idv, msdata$yr2016gdp_pc)

install.packages("stargazer") 
library(stargazer)
mydata <- msdata
stargazer(mydata[c("msgSentPerUser", "mtgHoursPerAttendee")], type = "text",
          title="Descriptive statistics/selected variables", digits=1, out="table2.txt")


# run a regression / linear model
fit1 <- lm(lmsgSentPerUser ~ lyr2016gdp_pc, data = msdata)  
summary(fit1)
fit2 <- lm(lmsgSentPerUser ~ idv, data = msdata)  
summary(fit2)
fit3 <- lm(lmsgSentPerUser ~ lyr2016gdp_pc + idv, data = msdata)  
summary(fit3)
stargazer(fit1, fit2, fit3, type = "text")


regress lmsgSentPerUser lyr2016gdp_pc idv inddum2-inddum8 sizedum2-sizedum5, cluster(Country)



