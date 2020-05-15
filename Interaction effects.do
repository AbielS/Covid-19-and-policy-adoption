*FIRST RUN STEP 1
run "/Users/ab.3116/Dropbox/covid and pol adoption/GitHub/Step 1.do"

*Democracy X density interaction

*generate combined density
gen sg_dens_reg2b= s1g_dens_reg+ s2g_dens_reg+ s3g_dens_reg+ s5g_dens_reg+ s6g_dens_reg
gen sg_dens2b=s1g_dens+s2g_dens+s3g_dens+s5g_dens+s6g_dens

*generate democracy dummy
gen pol_dummy=1 if poly2>82
recode pol_dummy .=0

*generate impartial adm. dummy
gen ria_dummy=1 if ri_adm2>84.8
recode ria_dummy .=0

*ordered probit/logit
gen saa=1 if sa1==1 | sa1==2
replace saa=2 if sa2==1 | sa2==2
replace saa=3 if sa3==1 | sa3==2
replace saa=4 if sa5==1 | sa5==2
replace saa=5 if sa6==1 | sa6==2
recode saa .=0
*probit/logit
recode saa (2/5=1), gen(saa2)


*margins & figure: democracy
logit saa2 gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop c.sg_dens_reg2b##i.pol_dummy, vce(cl c_id)
margins, at(sg_dens_reg2b=(0(5)40)) over(pol_dummy)
marginsplot

*margins & figure: RIM
logit saa2 gdpcaplog taxr_ gini_ hbed_ s_pop_65 urb_ pdistlog deathpop c.sg_dens_reg2b##i.cso_dummy, vce(cl c_id)
margins, at(sg_dens_reg2b=(0(5)40)) over(ria_dummy)
marginsplot
