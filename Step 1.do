*-------> START STEP 1

*in order to run the do-file change location of the following folder:
*"/Users/ab.3116/Dropbox/covid and pol adoption/

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
