*-------> STEP 1

*in order to run the do-file change location of the following folder:
*"/Users/ab.3116/Dropbox/covid and pol adoption/
*and change directory
cd "/Users/ab.3116/Dropbox/covid and pol adoption/"


*use main database
use "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/OxCGRT_Download_latest_data OECD.dta", clear
*brow countryname c_id month day edate time s1_isgeneral s2_isgeneral s3_isgeneral s4_isgeneral s5_isgeneral s6_isgeneral s1_school_closing s2_workplace_closing s3_cancel_public_events s4_close_public_transport s5_public_information_campaigns s6_restrictions_on_internal_move

*run adoption and density fundamentals
run "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/adoption and density fundamentals.do"

**DEFINE TIME AT RISK**
	*date for each country when first infection case appear
	gen edate_c=edate if time!=.
	egen edate_c_min=min(edate_c), by(c_id)
	sort c_id month day 
	gen edate_cc=edate if edate_c==edate_c_min
	drop edate_c edate_c_min
		egen firstdate_c=min(edate_cc), by(c_id)
		sort c_id month day
		replace firstdate_c=. if time==.
	
	egen firstdate_c2=max(firstdate_c), by(c_id)
	sort c_id month day

*generate regional adtoption density
	*for each specific adoption
	forvalues i=1(1)6 {
	by un_reg3 month day, sort: egen s`i'g_dens_reg=sum(sa`i'b)
	label var s`i'g_dens_reg "Adoption density (OECD region)"
	}
	sort c_id month day year
		*combined
		gen sg_dens_reg= s1g_dens_reg+ s2g_dens_reg+ s3g_dens_reg+ s4g_dens_reg+ s5g_dens_reg+ s6g_dens_reg
		label var sg_dens_reg "Adoption density (OECD region)"
		gen sg_dens_reg2= s1g_dens_reg+ s2g_dens_reg+ s3g_dens_reg+ s4g_dens_reg+ s6g_dens_reg
		label var sg_dens_reg2 "Adoption density (OECD region)"

*general total adoption density
	*for each specific adoption
	forvalues i=1(1)6 {
	by month day, sort: egen s`i'g_dens=sum(sa`i'b)
	label var s`i'g_dens "Adoption density (OECD)"	
	}
	sort c_id month day year
		*combined
		gen sg_dens=s1g_dens+s2g_dens+s3g_dens+s4g_dens+s5g_dens+s6g_dens
		label var sg_dens "Adoption density (OECD)"
		gen sg_dens2=s1g_dens+s2g_dens+s3g_dens+s4g_dens+s6g_dens
		label var sg_dens2 "Adoption density (OECD)"

*YOU CAN NOW RUN OLS & EVENT HISTORY ANALYIS FOR SEPARATE ADOPTIONS (SEE SEPARATE DO-FILE)


*-------> STEP 2
***************************************************
		**MARGINAL RISK SET MODEL**
***************************************************

*run marginal risk set fundamentals
run "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/marginal risk set fundamentals.do"


*now stset the data
stset edate, failure(status=1, 2) origin(time firstdate_c2)
	*robustness test
		*stset edate, failure(status=1) origin(time firstdate_c2)
		*stset edate, failure(status=2) origin(time firstdate_c2)


*Main model: marginal risk set (TABLE 2)
stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop , efron strata(rec) vce(cluster c_id) hr
outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) replace ctitle(Policy adoption)
stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog sg_dens_reg3, efron strata(rec) vce(cluster c_id) hr
outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog poly2, efron strata(rec) vce(cluster c_id) hr
outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll), Df, e(df_m)) append ctitle(Policy adoption)
stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2 c.sg_dens_reg3#c.poly2, efron strata(rec) vce(cluster c_id) hr
outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
seeout using "regs/oxstreg1.txt", label
	*descriptives (APPENDIX A)
	gen densdem=sg_dens_reg3*poly2
	label var densdem "Adoption density X electoral democracy"	
	mkcorr status gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop confpop sg_dens_reg3 poly2 densdem, log("regs/marginalrisk.txt")  cdec(3) mdec(3) lab means num casewise replace

	*plot the results (FIGURE 3)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
	estimates store mrs1
	coefplot mrs1, drop(gdpcaplog taxr_ s_pop_65 urb_ _cons) xline(1) eform xtitle(Hazard ratio)

		*Ibid. infection rate (TABLE D1)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog confpop , efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) replace ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog sg_dens_reg3, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog poly2, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog confpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog confpop sg_dens_reg3 poly2 c.sg_dens_reg3#c.poly2, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		seeout using "regs/oxstreg1.txt", label
		*plot the results
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog confpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
		estimates store ols2
		coefplot ols2, drop(gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog _cons) xline(1) eform xtitle(Hazard ratio)

	*post-hoc test: does uncertainty tolerance drive the adoption rate (Hofstede)?
		*insert hoefstede data
		sort c_id 
		merge c_id using "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/hoefstede.dta"
		drop _merge
		sort c_id month day

		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) replace ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2 uncertainty_avoidance, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2 long_term_orientation, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		seeout using "regs/oxstreg1.txt", label
			*descripties
			mkcorr gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop confpop sg_dens3 poly2 uncertainty_avoidance long_term_orientation, log("regs/institution.txt")  cdec(3) mdec(3) lab means num casewise replace

*post-hoc test: teasing out elements of the democratic structure
	*insert V-dem, ICRG, GSoD, & WB-data
	sort c_id 
	merge c_id using "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/indicators.dta"
	drop _merge

	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) replace ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2exremhog, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2exrescon, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2lgotovst, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2cscnsult, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2csprtcpt, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2exl_legitlead, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 i_adm2, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 ri_adm2, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 Bureaucratic_quality, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 effective_parliament, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)

		*interactions
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2exremhog c.sg_dens_reg3#c.v2exremhog, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop c.sg_dens_reg3##c.v2exrescon, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop c.sg_dens_reg3##c.v2lgotovst, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop c.sg_dens_reg3##c.v2cscnsult, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop c.sg_dens_reg3##c.v2csprtcpt, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop c.sg_dens_reg3##c.v2exl_legitlead, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop c.sg_dens_reg3##c.i_adm2, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop c.sg_dens_reg3##c.ri_adm2, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 Bureaucratic_quality c.sg_dens_reg3#c.Bureaucratic_quality, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 effective_parliament c.sg_dens_reg3#c.effective_parliament, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)	

		seeout using "regs/oxstreg1.txt", label

	*plot the results
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2exremhog, efron strata(rec) vce(cluster c_id) hr
		estimates store res1
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2exrescon, efron strata(rec) vce(cluster c_id) hr
		estimates store res2	
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2lgotovst, efron strata(rec) vce(cluster c_id) hr
		estimates store res3	
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2cscnsult, efron strata(rec) vce(cluster c_id) hr
		estimates store res4	
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2csprtcpt, efron strata(rec) vce(cluster c_id) hr
		estimates store res5	
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 v2exl_legitlead, efron strata(rec) vce(cluster c_id) hr
		estimates store res6	
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 i_adm2, efron strata(rec) vce(cluster c_id) hr
		estimates store res7	
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 ri_adm2, efron strata(rec) vce(cluster c_id) hr
		estimates store res8	
		stcox taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 Bureaucratic_quality, efron strata(rec) vce(cluster c_id) hr
		estimates store res9	
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 effective_parliament, efron strata(rec) vce(cluster c_id) hr
		estimates store res10
	
		coefplot (res2 \ res3 \ res4 \ res5 \ res7 \ res8 \ res9 \ res10), drop(gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog pdistlog deathpop sg_dens_reg3 poly2 _cons) xline(1) eform xtitle(Hazard ratio)

	*World Bank indicators
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) replace ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 Bureaucratic_quality, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 government_effectiveness2, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	seeout using "regs/oxstreg1.txt", label
	
		
*post-hoc test: Political color
		*insert political party data
		sort c_id
		merge c_id using "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/political parties.dta"
		drop _merge
		sort c_id month day

		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) replace ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2 pol_col, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2 pol_col c.poly2#c.sg_dens_reg3, efron strata(rec) vce(cluster c_id) hr
		outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
		seeout using "regs/oxstreg1.txt", label
		*descriptives
		mkcorr gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop confpop sg_dens_reg3 poly2 pol_col, log("regs/institution.txt")  cdec(3) mdec(3) lab means num casewise replace



*OTHER

*Transparency index (footnote)
	*insert data
	sort c_id
	merge c_id using "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/transparency-indices-scores.dta"
	drop _merge

	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) replace ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2 information_transparency, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2 accountability_transparency, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2 transparency_index, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	seeout using "regs/oxstreg1.txt", label

*#covid testing / 1,000 people (footnote)
	*insert covid testing data
	sort c_id month day
	merge c_id month day using "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/covid testing.dta"
	drop _merge
	
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) replace ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop sg_dens_reg3 poly2 new_tests_per_thousand, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	stcox gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ deathpop sg_dens_reg3 poly2 new_tests_per_thousand, efron strata(rec) vce(cluster c_id) hr
	outreg2 using "regs/oxstreg1.txt", label eform bdec(3) rdec(3) excel symbol(***, **, *, +) alpha(0.001, 0.01, 0.05, 0.10) addsta(Number of countries, e(N_clust), Number of failures, e(N_fail), Pseudo-R-squared, e(r2_p), Log likelihood, e(ll)) append ctitle(Policy adoption)
	seeout using "regs/oxstreg1.txt", label


*Figures 1 (% adopted)
	gen no_c=36
	forvalues i=1(1)6 {
	gen p_s`i'= s`i'g_dens/no_c
	label var p_s`i' "School closure"
	}
	sort c_id edate
	format edate %dM_d
	*line p_s1 p_s2 p_s3 p_s4 p_s5 p_s6 edate if edate>21960 in 25/90
	line p_s1 p_s2 p_s3 p_s5 p_s6 edate if edate>21960 in 25/90

*Figure 2
	stset edate, failure(sa1==1, 2) id(c_id) origin(time firstdate_c2)
	gen s1_time=time if _d==1
	stset edate, failure(sa2==1, 2) id(c_id) origin(time firstdate_c2)
	gen s2_time=time if _d==1
	stset edate, failure(sa3==1, 2) id(c_id) origin(time firstdate_c2)
	gen s3_time=time if _d==1
	stset edate, failure(sa4==1, 2) id(c_id) origin(time firstdate_c2)
	gen s4_time=time if _d==1
	stset edate, failure(sa5==1, 2) id(c_id) origin(time firstdate_c2)
	gen s5_time=time if _d==1
	stset edate, failure(sa6==1, 2) id(c_id) origin(time firstdate_c2)
	gen s6_time=time if _d==1	
	
	sc s1_time v2x_polyarchy, title("A. School closure", size(medium)) ytitle("Days since first reported infection case") xtitle("Electoral democracy") mlabel(countrycode) mlabsize(vsmall)
	sc s2_time v2x_polyarchy, title("B. Workplace closure", size(medium)) ytitle("Days since first reported infection case") xtitle("Electoral democracy") mlabel(countrycode) mlabsize(vsmall)
	sc s3_time v2x_polyarchy, title("C. Cancellation of public events", size(medium)) ytitle("Days since first reported infection case") xtitle("Electoral democracy") mlabel(countrycode) mlabsize(vsmall)
	sc s6_time v2x_polyarchy, title("D. Restrictions on internal mobility", size(medium)) ytitle("Days since first reported infection case") xtitle("Electoral democracy") mlabel(countrycode) mlabsize(vsmall)		












