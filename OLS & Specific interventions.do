	cd "/Users/ab.3116/Dropbox/covid and pol adoption/"
	run "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/Step 1.do"

*EVENT HISTORY ANALYSIS FOR SPECIFIC POLICY ADOPTIONS (APPENDIX B/POST-HOC TEST)
	*1) SCHOOL CLOSURE
	stset edate, failure(sa1==1, 2) id(c_id) origin(time firstdate_c2)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s1g_dens_reg poly2 , efron vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label  eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) replace ctitle(School closure)
	*2) WORKPLACE CLOSURE
	stset edate, failure(sa2==1, 2) id(c_id) origin(time firstdate_c2)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s2g_dens_reg poly2 , efron vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label  eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Workplace closure)
	*3) CANCEL PUBLIC EVENTS
	stset edate, failure(sa3==1, 2) id(c_id) origin(time firstdate_c2)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s3g_dens_reg poly2 , efron vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label  eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Cancellation of public events)
	/*4) CLOSURE OF PUBLIC TRANSPORTATION
	stset edate, failure(sa4==1, 2) id(c_id) origin(time firstdate_c2)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s4g_dens_reg poly2 , efron vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label  eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Closure of public transportation)
		*/
	*5) PUBLIC INFORMATION CAMPAIGNS
	stset edate, failure(sa5==1, 2) id(c_id) origin(time firstdate_c2)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s5g_dens_reg poly2 , efron vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label  eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Public information campaigns)
	*6) RESTRICTIONS ON INTERNAL MOBILITY
	stset edate, failure(sa6==1, 2) id(c_id) origin(time firstdate_c2)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s6g_dens_reg poly2 , efron vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label  eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Restrictions on internal mobility)

		seeout using "regs/oxstreg1.txt", label



					*PLOT THE RESULTS  (FIGURE 4)
					*1) SCHOOL CLOSURE
					stset edate, failure(sa1==1, 2) id(c_id) origin(time firstdate_c2)
						gen s1g_dens_reg1= s1g_dens_reg
						stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s1g_dens_reg1 poly2 , efron vce(cluster c_id) hr
						estimates store res1
					*2) WORKPLACE CLOSURE
					stset edate, failure(sa2==1, 2) id(c_id) origin(time firstdate_c2)
						drop s1g_dens_reg1
						gen s1g_dens_reg1= s2g_dens_reg
						stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s1g_dens_reg1 poly2 , efron vce(cluster c_id) hr
						estimates store res2
					*3) CANCEL PUBLIC EVENTS
					stset edate, failure(sa3==1, 2) id(c_id) origin(time firstdate_c2)
						drop s1g_dens_reg1
						gen s1g_dens_reg1= s3g_dens_reg
						stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s1g_dens_reg1 poly2 , efron vce(cluster c_id) hr
						estimates store res3
					/*4) CLOSURE OF PUBLIC TRANSPORTATION
					stset edate, failure(sa4==1, 2) id(c_id) origin(time firstdate_c2)
						drop s1g_dens_reg1
						gen s1g_dens_reg1= s4g_dens_reg
						stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s1g_dens_reg1 poly2 , efron vce(cluster c_id) hr
						estimates store res4
						*/
					*5) PUBLIC INFORMATION CAMPAIGNS
					stset edate, failure(sa5==1, 2) id(c_id) origin(time firstdate_c2)
						drop s1g_dens_reg1
						gen s1g_dens_reg1= s5g_dens_reg
						gen s1g_dens_reg2= s5g_dens_reg
						stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s1g_dens_reg1 poly2 , efron vce(cluster c_id) hr
						estimates store res5
						stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s1g_dens_reg2 poly2 , efron vce(cluster c_id) hr
						estimates store res5b
					*6) RESTRICTIONS ON INTERNAL MOBILITY
					stset edate, failure(sa6==1, 2) id(c_id) origin(time firstdate_c2)
						drop s1g_dens_reg1
						gen s1g_dens_reg1= s6g_dens_reg
						stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop s1g_dens_reg1 poly2 , efron vce(cluster c_id) hr
						estimates store res6
					*FIGURE 4: excluding death from all and density from public information campaigns
					coefplot (res1, aseq(School closure) \ res2, aseq(Workplace closure) \ res3, aseq(Cancellation of public events) \ res5b, aseq(Public information campaigns) \ res6, aseq(Restrictions on internal mobility) ), drop(gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog pdistlog deathpop s1g_dens_reg2 _cons) xline(1) eform xtitle(Hazard ratio) swapnames
						*b) all included
						coefplot (res1, aseq(School closure) \ res2, aseq(Workplace closure) \ res3, aseq(Cancellation of public events) \  res5, aseq(Public information campaigns) \ res6, aseq(Restrictions on internal mobility) ), drop(gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog pdistlog s1g_dens _cons) xline(1) eform xtitle(Hazard ratio) swapnames
						*c) exclude death from all
						coefplot (res1, aseq(School closure) \ res2, aseq(Workplace closure) \ res3, aseq(Cancellation of public events) \ res5, aseq(Public information campaigns) \ res6, aseq(Restrictions on internal mobility) ), drop(gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog pdistlog deathpop _cons) xline(1) eform xtitle(Hazard ratio) swapnames
						*d) all separetly
						coefplot (res1, aseq(School closure) \ res2, aseq(Workplace closure) \ res3, aseq(Cancellation of public events) \  res5, aseq(Public information campaigns) \ res6, aseq(Restrictions on internal mobility) ), drop(gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog pdistlog s1g_dens_reg1 poly2 _cons) xline(1) eform xtitle(Hazard ratio) swapnames
						coefplot (res1, aseq(School closure) \ res2, aseq(Workplace closure) \ res3, aseq(Cancellation of public events) \  res5, aseq(Public information campaigns) \ res6, aseq(Restrictions on internal mobility) ), drop(gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog pdistlog deathpop poly2 s1g_dens_reg2 _cons) xline(1) eform xtitle(Hazard ratio) swapnames
						coefplot (res1, aseq(School closure) \ res2, aseq(Workplace closure) \ res3, aseq(Cancellation of public events) \  res5, aseq(Public information campaigns) \ res6, aseq(Restrictions on internal mobility) ), drop(gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog pdistlog deathpop s1g_dens_reg1 _cons) xline(1) eform xtitle(Hazard ratio) swapnames




*PANEL OLS REGRESSION MODELS OF STRINGENCY (TABLE 3)
	xtset c_id edate 
	
	*death rate
	xtreg stringencyindex gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop, re cl(c_id)
	outreg2 using "regs/ols_regstring.txt", label bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addtext(Country FE, NO) addsta(Adjusted R-square, e(r2_a), F, e(F), Within R-square, e(r2_w), Between R-square, e(r2_b), Overall R-square, e(r2_o), Log likelihood, e(ll), Model chi-square, e(chi2), Root MSE, e(rmse)) replace  ctitle(String)
	xtreg stringencyindex gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog poly2, re cl(c_id)
	outreg2 using "regs/ols_regstring.txt", label bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addtext(Country FE, NO) addsta(Adjusted R-square, e(r2_a), F, e(F), Within R-square, e(r2_w), Between R-square, e(r2_b), Overall R-square, e(r2_o), Log likelihood, e(ll), Model chi-square, e(chi2), Root MSE, e(rmse)) append  ctitle(String)
	xtreg stringencyindex gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop poly2, re cl(c_id)
	outreg2 using "regs/ols_regstring.txt", label bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addtext(Country FE, NO) addsta(Adjusted R-square, e(r2_a), F, e(F), Within R-square, e(r2_w), Between R-square, e(r2_b), Overall R-square, e(r2_o), Log likelihood, e(ll), Model chi-square, e(chi2), Root MSE, e(rmse)) append  ctitle(String)
	seeout using "regs/ols_regstring.txt", label

		*infection rate (TABLE D2)
		xtreg stringencyindex gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog confpop, re cl(c_id)
		outreg2 using "regs/ols_regstring.txt", label bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addtext(Country FE, NO) addsta(Adjusted R-square, e(r2_a), F, e(F), Within R-square, e(r2_w), Between R-square, e(r2_b), Overall R-square, e(r2_o), Log likelihood, e(ll), Model chi-square, e(chi2), Root MSE, e(rmse)) replace  ctitle(String)
		xtreg stringencyindex gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog poly2, re cl(c_id)
		outreg2 using "regs/ols_regstring.txt", label bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addtext(Country FE, NO) addsta(Adjusted R-square, e(r2_a), F, e(F), Within R-square, e(r2_w), Between R-square, e(r2_b), Overall R-square, e(r2_o), Log likelihood, e(ll), Model chi-square, e(chi2), Root MSE, e(rmse)) append  ctitle(String)
		xtreg stringencyindex gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog confpop poly2, re cl(c_id)
		outreg2 using "regs/ols_regstring.txt", label bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addtext(Country FE, NO) addsta(Adjusted R-square, e(r2_a), F, e(F), Within R-square, e(r2_w), Between R-square, e(r2_b), Overall R-square, e(r2_o), Log likelihood, e(ll), Model chi-square, e(chi2), Root MSE, e(rmse)) append  ctitle(String)
		seeout using "regs/ols_regstring.txt", label
	
		*OLS stringency descriptives (APPENDIX C)
		label var stringencyindex "Stringency index"
		mkcorr stringencyindex gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop confpop poly2, log("regs/olsreg1.txt")  cdec(3) mdec(3) lab means num casewise replace

		*winsor test of outliers (FOOTNOTE)
		winsor poly2, gen(poly2_w5) p(0.05)
		xtreg stringencyindex gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog poly2_w5, re cl(c_id)
		outreg2 using "regs/ols_regstring.txt", label bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addtext(Country FE, NO) addsta(Adjusted R-square, e(r2_a), F, e(F), Within R-square, e(r2_w), Between R-square, e(r2_b), Overall R-square, e(r2_o), Log likelihood, e(ll), Model chi-square, e(chi2), Root MSE, e(rmse)) replace  ctitle(String)
		xtreg stringencyindex gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop poly2_w5, re cl(c_id)
		outreg2 using "regs/ols_regstring.txt", label bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addtext(Country FE, NO) addsta(Adjusted R-square, e(r2_a), F, e(F), Within R-square, e(r2_w), Between R-square, e(r2_b), Overall R-square, e(r2_o), Log likelihood, e(ll), Model chi-square, e(chi2), Root MSE, e(rmse)) append  ctitle(String)
		seeout using "regs/ols_regstring.txt", label

