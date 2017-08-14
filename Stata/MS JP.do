capture log close
clear
set more off

log using "logs\regression_$S_DATE", replace

use "data\MS_collapse_by_tenant_merge_18 Jul 2017"

* intraclass correlations

loneway msgSentPerUser Country
loneway mtgHoursPerAttendee Country
loneway MeanUtilization Country
loneway MeanAfterHoursWork Country
loneway internalnetworksize Country
loneway externalnetworksize Country

* why is intraclass correlation so much stronger for logged variable?

loneway lmsgSentPerUser Country



* Attempting mixed effect models

* these commands took a long time to run and I eventually stopped it
xtmixed lmsgSentPerUser || _all: R.Country || IndustryGroup:
xtmixed lmsgSentPerUser || _all: R.Country 


* trying something simpler
encode Country, generate(Country2)
describe Country Country2
tab Country2

regress lmsgSentPerUser sizedum1
xtreg lmsgSentPerUser sizedum1, i(Country2) fe
xtreg lmsgSentPerUser sizedum1, i(Country2) re

bysort Country: regress lmsgSentPerUser sizedum1

* add more variables to each model
xtreg lmsgSentPerUser sizedum1, i(Country2) re
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1, i(Country2) re
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8, i(Country2) re

* compare two different ways to model country effect
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv, i(Country2) re
regress lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv, cluster(Country)


* different direction
* test a series of two-way interactions
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv c.sizedum1#c.idv, i(Country2) re
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 ltowvs c.sizedum1#c.ltowvs, i(Country2) re
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv ltowvs c.sizedum1#c.idv c.sizedum1#c.ltowvs, i(Country2) re
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv ltowvs c.sizedum1#c.idv c.sizedum1#c.ltowvs c.idv#c.ltowvs, i(Country2) re

* test three-way interaction, which is significant
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv ltowvs c.sizedum1#c.idv c.sizedum1#c.ltowvs c.idv#c.ltowvs c.sizedum1#c.ltowvs#c.idv, i(Country2) re

* try to understand pattern of three-way interaction
bysort sizedum1: xtreg lmsgSentPerUser lmtgHoursPerAttendee inddum2-inddum8 idv ltowvs c.idv#c.ltowvs, i(Country2) re


* sample base model from below
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)




* Older commands below from previous day analyses, as examples for above

* Descriptives

summarize lmtgHoursPerAttendee lmsgSentPerUser lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize

summarize mtgHoursPerAttendee msgSentPerUser MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize

scatter lmsgSentPerUser lmtgHoursPerAttendee
scatter idv lmsgSentPerUser
scatter idv ltowvs

pwcorr lmsgSentPerUser lmtgHoursPerAttendee

pwcorr lmtgHoursPerAttendee lmsgSentPerUser lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize, sig obs

pwcorr mtgHoursPerAttendee msgSentPerUser MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize, sig obs

pwcorr pdi idv ltowvs uai, sig obs

pwcorr lmsgSentPerUser lmtgHoursPerAttendee linternalnetworksize lexternalnetworksize idv ltowvs, sig obs

* Base regression model for each MS DV
regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
regress lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
regress lMeanUtilization pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
regress lMeanAfterHoursWork pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
regress linternalnetworksize pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
regress lexternalnetworksize pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)

* Test email controlling for meeting hours
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)

* Test meeting hours controlling for emails
regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)

* Test email controlling for meeting hours, with interaction between individualism and longterm
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs c.ltowvs#c.idv uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)

* Test meeting hours controlling for emails, with interaction between individualism and longterm
regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs c.ltowvs#c.idv uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)

* Need to understand industries and tenant size, and whether patterns hold across all categories
tab IndustryGroup TenantSize, cell

tabstat mtgHoursPerAttendee msgSentPerUser, by(TenantSize) stat(n mean sd min max)
tabstat mtgHoursPerAttendee msgSentPerUser, by(IndustryGroup) stat(n mean sd min max)

bysort IndustryGroup: pwcorr lmsgSentPerUser lmtgHoursPerAttendee
bysort TenantSize: pwcorr lmsgSentPerUser lmtgHoursPerAttendee

bysort TenantSize: regress lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)
bysort IndustryGroup: regress lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop sizedum2-sizedum5, cluster(Country)

bysort TenantSize: regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)
bysort IndustryGroup: regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop sizedum2-sizedum5, cluster(Country)

* Control for small bus vs all other sizes, DV = meeting hours
regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1, cluster(Country)
bysort sizedum1: regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)
regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1 c.ltowvs#c.sizedum1, cluster(Country)

regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1, cluster(Country)
bysort sizedum1: regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)
regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1 c.ltowvs#c.sizedum1, cluster(Country)

* Control for small bus vs all other sizes, DV = emails sent
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1, cluster(Country)
bysort sizedum1: regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1 c.ltowvs#c.sizedum1, cluster(Country)


clear
