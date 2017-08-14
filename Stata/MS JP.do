capture log close
clear
set more off

log using "logs\regression_$S_DATE", replace

use "data\MS_collapse_by_tenant_merge_18 Jul 2017"

* intraclass correlations
/*
loneway msgSentPerUser Country
loneway mtgHoursPerAttendee Country
loneway MeanUtilization Country
loneway MeanAfterHoursWork Country
loneway internalnetworksize Country
loneway externalnetworksize Country

* why is intraclass correlation so much stronger for logged variable?

loneway lmsgSentPerUser Country
*/


* Attempting mixed effect models

* these commands took a long time to run and I eventually stopped it
*xtmixed lmsgSentPerUser || _all: R.Country || IndustryGroup:
*xtmixed lmsgSentPerUser || _all: R.Country 


* trying something simpler
encode Country, generate(Country2)
describe Country Country2
tab Country2

regress lmsgSentPerUser sizedum1
outreg2 using "output\JP_regressions_$S_DATE", excel label replace addtext("Type of Regression","OLS")  
xtreg lmsgSentPerUser sizedum1, i(Country2) fe
outreg2 using "output\JP_regressions_$S_DATE", excel label append addtext("Type of Regression","FE")  
xtreg lmsgSentPerUser sizedum1, i(Country2) re
outreg2 using "output\JP_regressions_$S_DATE", excel label append addtext("Type of Regression","RE")

g counter=1
bysort Country: egen sum=sum(counter)
drop if sum<=1

*bysort Country: regress lmsgSentPerUser sizedum1

regress lmsgSentPerUser sizedum1
outreg2 using "output\JP_Countries_$S_DATE", excel label replace addtext("Country","All") 

levelsof Country, local(levels)
foreach l of local levels {
regress lmsgSentPerUser sizedum1 if Country=="`l'"
outreg2 using "output\JP_Countries_$S_DATE", excel label append addtext("Country","`l'") 
}

clear
use "data\MS_collapse_by_tenant_merge_18 Jul 2017"

* add more variables to each model
xtreg lmsgSentPerUser sizedum1, i(Country2) re
outreg2 using "output\JP_regressions_$S_DATE", excel label append addtext("Type of Regression","RE") 
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1, i(Country2) re
outreg2 using "output\JP_regressions_$S_DATE", excel label append addtext("Type of Regression","RE") 
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8, i(Country2) re
outreg2 using "output\JP_regressions_$S_DATE", excel label append addtext("Type of Regression","RE") 

* compare two different ways to model country effect
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv, i(Country2) re
outreg2 using "output\JP_regressions_$S_DATE", excel label append addtext("Type of Regression","RE") 
regress lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv, cluster(Country)
outreg2 using "output\JP_regressions_$S_DATE", excel label append addtext("Type of Regression","OLS") 


* different direction
* test a series of two-way interactions
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv c.sizedum1#c.idv, i(Country2) re
outreg2 using "output\JP_interactions_$S_DATE", excel label replace addtext("Type of Regression","RE")
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 ltowvs c.sizedum1#c.ltowvs, i(Country2) re
outreg2 using "output\JP_interactions_$S_DATE", excel label append addtext("Type of Regression","RE")
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv ltowvs c.sizedum1#c.idv c.sizedum1#c.ltowvs, i(Country2) re
outreg2 using "output\JP_interactions_$S_DATE", excel label append addtext("Type of Regression","RE")
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv ltowvs c.sizedum1#c.idv c.sizedum1#c.ltowvs c.idv#c.ltowvs, i(Country2) re
outreg2 using "output\JP_interactions_$S_DATE", excel label append addtext("Type of Regression","RE")

* test three-way interaction, which is significant
xtreg lmsgSentPerUser lmtgHoursPerAttendee sizedum1 inddum2-inddum8 idv ltowvs c.sizedum1#c.idv c.sizedum1#c.ltowvs c.idv#c.ltowvs c.sizedum1#c.ltowvs#c.idv, i(Country2) re
outreg2 using "output\JP_interactions_$S_DATE", excel label append addtext("Type of Regression","RE")

* try to understand pattern of three-way interaction
bysort sizedum1: xtreg lmsgSentPerUser lmtgHoursPerAttendee inddum2-inddum8 idv ltowvs c.idv#c.ltowvs, i(Country2) re


* sample base model from below
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label replace




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
outreg2 using "output\JP_firstday_$S_DATE", excel label append
regress lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append
regress lMeanUtilization pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append
regress lMeanAfterHoursWork pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append
regress linternalnetworksize pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append
regress lexternalnetworksize pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append

* Test email controlling for meeting hours
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append

* Test meeting hours controlling for emails
regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append

* Test email controlling for meeting hours, with interaction between individualism and longterm
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs c.ltowvs#c.idv uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append

* Test meeting hours controlling for emails, with interaction between individualism and longterm
regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs c.ltowvs#c.idv uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append

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
outreg2 using "output\JP_firstday_$S_DATE", excel label append
bysort sizedum1: regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)
regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1 c.ltowvs#c.sizedum1, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append

regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append
bysort sizedum1: regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)
regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1 c.ltowvs#c.sizedum1, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append

* Control for small bus vs all other sizes, DV = emails sent
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append
bysort sizedum1: regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)
regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1 c.ltowvs#c.sizedum1, cluster(Country)
outreg2 using "output\JP_firstday_$S_DATE", excel label append

erase "output\JP_regressions_$S_DATE.txt"
erase "output\JP_Countries_$S_DATE.txt"
erase "output\JP_interactions_$S_DATE.txt"
erase "output\JP_firstday_$S_DATE.txt"

clear
