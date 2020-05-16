expand 5
sort c_id month day

by c_id time, sort: gen rec=_n
*replace rec=. if time==.
sort c_id month day rec
	replace rec=. if time==.

gen status=1 if sa1==1 & rec==1
	replace status=2 if sa1==2 & rec==1
replace status=1 if sa2==1 & rec==2
	replace status=2 if sa2==2 & rec==2
replace status=1 if sa3==1 & rec==3
	replace status=2 if sa3==2 & rec==3
*replace status=1 if sa4==1 & rec==4
*	replace status=2 if sa4==1 & rec==4
replace status=1 if sa5==1 & rec==4
	replace status=2 if sa5==2 & rec==4
replace status=1 if sa6==1 & rec==5
	replace status=2 if sa6==2 & rec==5

*density region
gen sg_dens_reg3=s1g_dens_reg if status!=. & rec==1
replace sg_dens_reg3=s2g_dens_reg if status!=. & rec==2
replace sg_dens_reg3=s3g_dens_reg if status!=. & rec==3
*replace sg_dens_reg3=s4g_dens_reg if status!=. & rec==4
replace sg_dens_reg3=s5g_dens_reg if status!=. & rec==4
replace sg_dens_reg3=s6g_dens_reg if status!=. & rec==5

recode status .=0

replace sg_dens_reg3=s1g_dens_reg if status==0 & rec==1
replace sg_dens_reg3=s2g_dens_reg if status==0 & rec==2
replace sg_dens_reg3=s3g_dens_reg if status==0 & rec==3
*replace sg_dens_reg3=s4g_dens_reg if status==0 & rec==4
replace sg_dens_reg3=s5g_dens_reg if status==0 & rec==4
replace sg_dens_reg3=s6g_dens_reg if status==0 & rec==5

*density total
gen sg_dens3=s1g_dens if status!=0 & rec==1
replace sg_dens3=s2g_dens if status!=0 & rec==2
replace sg_dens3=s3g_dens if status!=0 & rec==3
*replace sg_dens3=s4g_dens if status!=0 & rec==4
replace sg_dens3=s5g_dens if status!=0 & rec==4
replace sg_dens3=s6g_dens if status!=0 & rec==5

replace sg_dens3=s1g_dens if status==0 & rec==1
replace sg_dens3=s2g_dens if status==0 & rec==2
replace sg_dens3=s3g_dens if status==0 & rec==3
*replace sg_dens3=s4g_dens if status==0 & rec==4
replace sg_dens3=s5g_dens if status==0 & rec==4
replace sg_dens3=s6g_dens if status==0 & rec==5


*remove records after failure
gen sa=1 if rec==1 & status!=0
gen sat=time if rec==1 & status!=0
egen sa_max=max(sa), by(c_id)
egen sat_max=max(sat), by(c_id)
sort c_id month day 
drop if rec==1 & status==0 & sa_max==1 & time > sat_max
drop sa sa_max sat sat_max

gen sa=1 if rec==2 & status!=0
gen sat=time if rec==2 & status!=0
egen sa_max=max(sa), by(c_id)
egen sat_max=max(sat), by(c_id)
sort c_id month day 
drop if rec==2 & status==0 & sa_max==1 & time > sat_max
drop sa sa_max sat sat_max

gen sa=1 if rec==3 & status!=0
gen sat=time if rec==3 & status!=0
egen sa_max=max(sa), by(c_id)
egen sat_max=max(sat), by(c_id)
sort c_id month day 
drop if rec==3 & status==0 & sa_max==1 & time > sat_max
drop sa sa_max sat sat_max
/*
gen sa=1 if rec==4 & status!=0
gen sat=time if rec==4 & status!=0
egen sa_max=max(sa), by(c_id)
egen sat_max=max(sat), by(c_id)
sort c_id month day 
drop if rec==4 & status==0 & sa_max==1 & time > sat_max
drop sa sa_max sat sat_max
*/
gen sa=1 if rec==4 & status!=0
gen sat=time if rec==4 & status!=0
egen sa_max=max(sa), by(c_id)
egen sat_max=max(sat), by(c_id)
sort c_id month day 
drop if rec==4 & status==0 & sa_max==1 & time > sat_max
drop sa sa_max sat sat_max

gen sa=1 if rec==5 & status!=0
gen sat=time if rec==5 & status!=0
egen sa_max=max(sa), by(c_id)
egen sat_max=max(sat), by(c_id)
sort c_id month day 
drop if rec==5 & status==0 & sa_max==1 & time > sat_max
drop sa sa_max sat sat_max

label var status "Policy adoption"
label var sg_dens3 "Adoption density (OECD)"
label var sg_dens_reg3 "Adoption density (OECD region)"


