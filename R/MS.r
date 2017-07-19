# *****************************************************************************************
#   File            : MS_17July2017.r  
#   Author          : Jeff Polzer
#   Most Recent Edit: Nina Tobio
#   Created         : 17 July 2017
#   Modified        : 19 July 2017
#   Description     : .r file for analyzing MS_collapse_by_tenant_merge_18_Jul_2017.RData
#*****************************************************************************************/

# This clears R's data memory so new data can be loaded
rm(list = ls())

# Set working directory for this session
setwd("C:/Users/ktobio/Desktop/Jeff/MS_Standalone/workspace")

# list working directory and contents: 
getwd()
list.files()

# open haven package to import Stata .dta file
library(haven)

# import Stata .dta file
msdata.data <- read_dta("C:/Users/ktobio/Desktop/Jeff/MS_Standalone/Stata/data/MS_collapse_by_tenant_merge_small_18 Jul 2017.dta")

#View(msdata.data)

# open a log file
filename <- paste0("C:/Users/ktobio/Desktop/Jeff/MS_Standalone/R/logs/MS_", Sys.Date(), ".log")
sink(filename)

# use these packages

## install.packages("dplyr")
library(dplyr)

## install.packages('Hmisc')
library(Hmisc)

# The following command lists the contents (including name, type and numbers of variables, as well as
# number of observations, of the data frame.
contents(msdata.data)

# The following command lists the first 5 rows of the data frame.
head(msdata.data,n=5L)

# provide structure of the dataset
str(msdata.data)

summary(msdata.data)

names(msdata.data)

table(msdata.data$IndustryGroup)
ftable(msdata.data$IndustryGroup)

mytable <- table(msdata.data$IndustryGroup, msdata.data$TenantSize)
mytable # print table
ftable (mytable) # print table

install.packages("gmodels")
library(gmodels)
help(CrossTable)
CrossTable(msdata$IndustryGroup,msdata.data$TenantSize, digits=3, max.width = 1, format = c("SPSS"))

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



