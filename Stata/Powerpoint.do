capture log closeclearset more offset scheme s1color/*use "data\network_upper"bysort tenant: sum *upper*clear*/use "data\MS_collapse_by_tenant_merge_ 4 Aug 2017"drop if Country==""drop if Oms==""replace MeanUtilizatio=. if MeanUtilizatio<0g idv_reverse=100-idvlabel var idv_reverse "Hofstede: Collectivism. Higher = valued more"replace Country="Macedonia" if Country=="Macedonia (Former Yugoslav Republic of Macedonia)"foreach var in idv lto pdi mas uai lto ivr {replace `var'=100 if `var'>=100 & `var'~=.}pwcorr msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize, sigpwcorr lmsgSentPerUser lmtgHoursPerAttendee lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize, sigkeep idv_reverse lto pd uai Countryduplicates droppwcorr idv_reverse lto pd uai, sigstop/*/*counttab TenantSize, missingtab IndustryGroup, missingegen group=group(Country)tab groupsum msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize*bysort TenantSize: sum msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksizebysort TenantSize: sum *Upper**bysort IndustryG: sum msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksizeg counter=1collapse (sum) counter, by (Country)gsort -counterg order=_ngraph bar counter, over(Country, sort(order) label(nolabels)) ytitle("Number of Tenants") xsize(8)graph save "output\\tenants", replacegraph export "output\\tenants.png", replaceclearuse "data\MS_collapse_by_tenant_merge_ 4 Aug 2017"drop if Country==""drop if Oms==""replace MeanUtilizatio=. if MeanUtilizatio<0*/*/*collapse (mean) msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize idv, by (Country)/*foreach var in msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize {gsort -`var'g order=_ntab Country if order==1tab Country if order==130tab Country if order==25graph bar  `var', over(Country, sort(order) label(nolabels)) ytitle("`var'") drop ordergraph save "output\\`var'", replace}keep if idv_reverse~=. | lto~=. | pdi~=. |  idv~=. |  mas~=. |  uai~=. |  ltowvs~=. |  ivr~=. keep Country idv* lto pdi mas uai lto ivrduplicates dropsum idv* lto pdi mas uai ivrkeep idv_reverse lto Countryduplicates dropforeach var in idv_reverse lto {gsort -`var'g order=_nlocal mytitle : variable label `var'*graph bar  `var', over(Country, sort(order) label(angle(45) labsize(vsmall))) ytitle(`mytitle') xsize(8) b1title("Countries") nofillgraph bar  `var', over(Country, sort(order) label(angle(45) labsize(vsmall))) ytitle(`mytitle') xsize(8)  nofilldrop ordergraph save "output\\`var'", replacegraph export "output\\`var'.png", replace}*Create scatter plots of idv and lto**keep idv_reverse lto Country*duplicates droppwcorr idv_reverse lto, sigg corr=r(rho)g count=r(N)g t=corr/sqrt((1-(corr*corr))/(count-2))g new=tprob(count, t)local corr: di %-12.3f  corrlocal sig: di %-12.3f  newscatter lto idv_reverse , msymbol(none) mlabel(Country) ytitle("Hofstede: Longterm Orientation") note("Coeff.=`corr' Pvalue=`sig'") graph export "output//ido_idv.png", replacelabel var msgSentPerUser  "Mean Messages Sent per User"label var mtgHoursPer "Mean Meeting Hours per Attendee"label var MeanUtil "Mean Utilization Hours"label var MeanAfter "Mean After Hours"label var internal "Mean Internal Network"label var external "Mean External Network"keep if idv~=.egen group=group(Country)tab groupforeach var in msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize {gsort -`var'g order=_nlocal mytitle : variable label `var'egen mean=mean(`var')local mean=meangraph bar  `var', over(Country, sort(order) label(angle(45) labsize(vsmall))) ytitle(`mytitle') xsize(8) nofill yline(`mean')drop ordergraph save "output\\`var'_small", replacegraph export "output\\`var'_small.png", replacekeep if idv~=.drop mean}egen country_g=group(Country)xtset country_g* sample base model from belowregress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label replace*/* Older commands below from previous day analyses, as examples for above* Descriptives* sample base model from belowregress lmsgSentPerUser pdi idv_reverse ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country) outreg2 using "output\ppt1_$S_DATE", excel label replace dec(3)regress lmtgHoursPerAttendee pdi idv_reverse ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\ppt1_$S_DATE", excel label append dec(3)regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv_reverse ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\ppt1_$S_DATE", excel label append dec(3)regress lmtgHoursPerAttendee lmsgSentPerUser  pdi idv_reverse ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\ppt1_$S_DATE", excel label append dec(3)stop* Base regression model for each MS DVregress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appendregress lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appendregress lMeanUtilization pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appendregress lMeanAfterHoursWork pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appendregress linternalnetworksize pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appendregress lexternalnetworksize pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label append* Test email controlling for meeting hoursregress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label append* Test meeting hours controlling for emailsregress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label append* Test email controlling for meeting hours, with interaction between individualism and longtermregress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs c.ltowvs#c.idv uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label append* Test meeting hours controlling for emails, with interaction between individualism and longtermregress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs c.ltowvs#c.idv uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label append* Need to understand industries and tenant size, and whether patterns hold across all categoriestab IndustryGroup TenantSize, celltabstat mtgHoursPerAttendee msgSentPerUser, by(TenantSize) stat(n mean sd min max)tabstat mtgHoursPerAttendee msgSentPerUser, by(IndustryGroup) stat(n mean sd min max)bysort IndustryGroup: pwcorr lmsgSentPerUser lmtgHoursPerAttendeebysort TenantSize: pwcorr lmsgSentPerUser lmtgHoursPerAttendeebysort TenantSize: regress lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)bysort IndustryGroup: regress lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop sizedum2-sizedum5, cluster(Country)bysort TenantSize: regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)bysort IndustryGroup: regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop sizedum2-sizedum5, cluster(Country)* Control for small bus vs all other sizes, DV = meeting hoursregress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appendbysort sizedum1: regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)regress lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1 c.ltowvs#c.sizedum1, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appendregress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appendbysort sizedum1: regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)regress lmtgHoursPerAttendee lmsgSentPerUser pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1 c.ltowvs#c.sizedum1, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label append* Control for small bus vs all other sizes, DV = emails sentregress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appendbysort sizedum1: regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8, cluster(Country)regress lmsgSentPerUser lmtgHoursPerAttendee pdi idv ltowvs uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum1 c.ltowvs#c.sizedum1, cluster(Country)outreg2 using "output\JP_firstday_$S_DATE", excel label appenderase "output\JP_regressions_$S_DATE.txt"erase "output\JP_Countries_$S_DATE.txt"erase "output\JP_interactions_$S_DATE.txt"erase "output\JP_firstday_$S_DATE.txt"