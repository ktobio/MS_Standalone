capture log closeclearset more offlog using "logs\NET_regression_$S_DATE", replace*use "MS_collapse_by_tenant_merge_$S_DATE"use "data\MS_collapse_by_tenant_merge_ 4 Aug 2017"*ID Outliers*foreach var in msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize TotalHumanMailboxes UserCount mtgAttendees msgSenders {egen ptile1_`var'=pctile(`var'), p(1)egen ptile99_`var'=pctile(`var'), p(99)egen ptile999_`var'=pctile(`var'), p(99.9)}stop*Create reverse idv"g idv_reverse=100-idvlabel var idv_reverse "Hofstede: Reverse of Individualism. Higher number = collectivism valued more"egen group=group(Country)bysort group: g counter=_npwcorr idv lto if counter==1, sigpwcorr idv_reverse lto if counter==1, sigdrop group counter/*REGRESSIONS - PDI, IDV LTO plus Controls*/pwcorr  pdi idv lto foreach DV in lmsgSentPerUser lmtgHoursPerAttendee lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize {regress `DV' pdi  inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs replace addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' idv  inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' lto  inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' pdi idv lto inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' pdi idv lto  lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') sortvar(pdi idv lto  lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5)erase "output\`DV'_$S_DATE.txt"}/*REGRESSIONS - PDI and IDV plus Controls*/foreach DV in lmsgSentPerUser lmtgHoursPerAttendee lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize {*foreach DV in lmsgSentPerUser {regress `DV' pdi lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label replace noobs addtext("# Countries", `number', "Observations or # tenants", `obs')}foreach DV in lmsgSentPerUser lmtgHoursPerAttendee lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize {*foreach DV in lmsgSentPerUser {regress `DV' idv lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' pdi idv lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' pdi idv c.pdi#c.idv lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') sortvar(pdi idv c.pdi#c.idv lyr2015gdp_pc lyr2016pop  inddum2-inddum8 sizedum2-sizedum5)erase "output\`DV'_$S_DATE.txt"}/*REGRESSIONS - PDI, IDV and UAI plus Controls*/foreach DV in lmsgSentPerUser lmtgHoursPerAttendee lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize {regress `DV' pdi inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "20170807\\`DV'_$S_DATE", excel label replace noobs addtext("# Countries", `number', "Observations or # tenants", `obs')}foreach DV in lmsgSentPerUser lmtgHoursPerAttendee lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize {regress `DV' idv  inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' uai  inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' Tight  inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' pdi idv uai inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' pdi idv uai Tight  inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' pdi idv uai lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') regress `DV' pdi idv uai Tight lyr2015gdp_pc lyr2016pop inddum2-inddum8 sizedum2-sizedum5, cluster(Country)local number=e(N_clust)local obs=e(N)outreg2 using "output\`DV'_$S_DATE", excel label  noobs append addtext("# Countries", `number', "Observations or # tenants", `obs') sortvar(pdi idv uai Tight lyr2015gdp_pc lyr2016pop  inddum2-inddum8 sizedum2-sizedum5)erase "output\`DV'_$S_DATE.txt"}/*REGRESSIONS - TRUST VARIABLES*/foreach DV in lmsgSentPerUser lmtgHoursPerAttendee lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize {regress `DV' prosocial_oecd inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\`DV'_$S_DATE", excel label replace}foreach DV in lmsgSentPerUser lmtgHoursPerAttendee lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize {foreach IV in antisocial_oced trustinthepolice trustlegal_oecd trustpolitical_oecd trustinpolice_oecd trustinothers_oecd trustinothers_wvs2014 {regress `DV' `IV' inddum2-inddum8 sizedum2-sizedum5, cluster(Country)outreg2 using "output\`DV'_$S_DATE", excel label append }}/*CREATING HISTOGRAMS*//*bysort Country: g tenants_in_country=_Nlabel var tenants_in_country "Number of Tenants in Country"drop if tenants_in_country<=1quietly scatter lmsgSentPerUser lmsgSentPerUser graph export tmp.png, replacepng2rtf using "histograms_$S_DATE.doc", g(tmp.png) replace  *foreach var in lmsgSentPerUser lmtgHoursPerAttendee lMeanUtilization lMeanAfterHoursWork linternalnetworksize lexternalnetworksize msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize  {foreach var in msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize TotalHumanMailboxes UserCount mtgAttendees msgSenders {egen ptile1=pctile(`var'), p(1)egen ptile99=pctile(`var'), p(99)*egen ptile10=pctile(`var'), p(10)*egen ptile90=pctile(`var'), p(90)sum `var', detail*sum `var' if `var'>=ptile1 & `var'<=ptile99, detailsum `var' if `var'<=1, detailsum `var' if `var'<=0, detailsum `var' if `var'<=ptile1, detail*sum `var' if `var'>=ptile99, detailtab Tenant if `var'<=ptile1 *tab Tenant if `var'>=ptile99tab IndustryG if `var'<=ptile1 tab Country if `var'<=ptile1 drop ptile*histogram `var' if `var'>=ptile1 & `var'<=ptile99, fractiongraph export "hist_`var'_all.png", replacepng2rtf using "histograms_$S_DATE.doc", g("hist_`var'_all.png") appendhistogram `var' if `var'>=ptile1 & `var'<=ptile99, by(Country) fractiongraph export "hist_`var'_by_country.png", replacepng2rtf using "histograms_$S_DATE.doc", g("hist_`var'_by_country.png") appenddrop ptile*}replace Tenant="1. 1-250" if Tenant=="1 - SMB: 1-250"replace Tenant="2. 250-500" if Tenant=="2 - SMS&P (Medium/Small): 250-500"replace Tenant="3. 500-1000" if Tenant=="3 - SMS&P (Medium/Large): 500-1000"replace Tenant="4. 1000-5000" if Tenant=="4 - Corporate Enterprise (EPG): 1000-5000"replace Tenant="5. 5000+" if Tenant=="5 - Major Large Enterprise: 5000+"scatter lmsgSentPerUser lmsgSentPerUser graph export tmp.png, replacepng2rtf using "histograms_$S_DATE.doc", g(tmp.png) replace	  *levelsof Tenant, local(levels)*foreach var in msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize TotalHumanMailboxes UserCount mtgAttendees msgSenders {foreach var in msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize  {*foreach l of local levels {egen ptile1=pctile(`var'), p(1)egen ptile99=pctile(`var'), p(99)*histogram `var' if `var'>=ptile1 & `var'<=ptile99 & Tenant=="`l'", fraction*graph export "hist_`var'_all.png", replace*png2rtf using "histograms_$S_DATE.doc", g("hist_`var'_all.png") appendhistogram `var' if `var'>=ptile1 & `var'<=ptile99, by(Tenant) fraction bin(20)*histogram `var', by(Tenant) fractiongraph export "hist_`var'_by_size.png", replacepng2rtf using "histograms_$S_DATE.doc", g("hist_`var'_by_size.png") appenddrop ptile*erase "hist_`var'_by_size.png"}*levelsof Tenant, local(levels)*foreach var in msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize TotalHumanMailboxes UserCount mtgAttendees msgSenders {foreach var in msgSentPerUser mtgHoursPerAttendee MeanUtilization MeanAfterHoursWork internalnetworksize externalnetworksize  {*foreach l of local levels {egen ptile1=pctile(`var'), p(1)egen ptile99=pctile(`var'), p(99)*histogram `var' if `var'>=ptile1 & `var'<=ptile99 & Tenant=="`l'", fraction*graph export "hist_`var'_all.png", replace*png2rtf using "histograms_$S_DATE.doc", g("hist_`var'_all.png") appendhistogram `var' if `var'>=ptile1 & `var'<=ptile99, by(Industry) fraction bin(20)*histogram `var', by(Tenant) fractiongraph export "hist_`var'_by_ind.png", replacepng2rtf using "histograms_$S_DATE.doc", g("hist_`var'_by_ind.png") appenddrop ptile*erase "hist_`var'_by_ind.png"}*/