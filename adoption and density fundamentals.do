*generate policy adoption by type of policy
tsset c_id edate
tsspell s1_school_closing
gen sa1=1 if _seq==1
recode sa1 .=0
drop _spell _seq _end

tsset c_id edate
tsspell s2_workplace_closing
gen sa2=1 if _seq==1
recode sa2 .=0
drop _spell _seq _end

tsset c_id edate
tsspell s3_cancel_public_events
gen sa3=1 if _seq==1
recode sa3 .=0
drop _spell _seq _end

tsset c_id edate
tsspell s4_close_public_transport
gen sa4=1 if _seq==1
recode sa4 .=0
drop _spell _seq _end

tsset c_id edate
tsspell s5_public_information_campaigns
gen sa5=1 if _seq==1
recode sa5 .=0
drop _spell _seq _end

tsset c_id edate
tsspell s6_restrictions_on_internal_move
gen sa6=1 if _seq==1
recode sa6 .=0
drop _spell _seq _end


*adjust adoption: so they do not include policy that has no measure (s=0)
replace sa1=0 if s1_school_closing==0 | s1_school_closing==.
replace sa2=0 if s2_workplace_closing==0 | s2_workplace_closing==.
replace sa3=0 if s3_cancel_public_events==0 | s3_cancel_public_events==.
replace sa4=0 if s4_close_public_transport==0 | s4_close_public_transport==.
replace sa5=0 if s5_public_information_campaigns==0 | s5_public_information_campaigns==.
replace sa6=0 if s6_restrictions_on_internal_move==0 | s6_restrictions_on_internal_move==.

replace sa1=0 if s1_isgeneral==0 | s1_isgeneral==.
replace sa2=0 if s2_isgeneral==0 | s2_isgeneral==.
replace sa3=0 if s3_isgeneral==0 | s3_isgeneral==.
replace sa4=0 if s4_isgeneral==0 | s4_isgeneral==.
replace sa5=0 if s5_isgeneral==0 | s5_isgeneral==.
replace sa6=0 if s6_isgeneral==0 | s6_isgeneral==.


*keep adoption variables only if they are general
tsset c_id edate
tsspell s1_isgeneral
gen sa1b=1 if _seq==1
recode sa1b .=0
drop _spell _seq _end

tsset c_id edate
tsspell s2_isgeneral
gen sa2b=1 if _seq==1
recode sa2b .=0
drop _spell _seq _end

tsset c_id edate
tsspell s3_isgeneral
gen sa3b=1 if _seq==1
recode sa3b .=0
drop _spell _seq _end

tsset c_id edate
tsspell s4_isgeneral
gen sa4b=1 if _seq==1
recode sa4b .=0
drop _spell _seq _end

tsset c_id edate
tsspell s5_isgeneral
gen sa5b=1 if _seq==1
recode sa5b .=0
drop _spell _seq _end

tsset c_id edate
tsspell s6_isgeneral
gen sa6b=1 if _seq==1
recode sa6b .=0
drop _spell _seq _end


*adjust adoptions: remove adoptions that are targeted (general=0)
replace sa1b=0 if s1_isgeneral==0 | s1_isgeneral==.
replace sa2b=0 if s2_isgeneral==0 | s2_isgeneral==.
replace sa3b=0 if s3_isgeneral==0 | s3_isgeneral==.
replace sa4b=0 if s4_isgeneral==0 | s4_isgeneral==.
replace sa5b=0 if s5_isgeneral==0 | s5_isgeneral==.
replace sa6b=0 if s6_isgeneral==0 | s6_isgeneral==.

replace sa1b=0 if s1_school_closing==0 | s1_school_closing==.
replace sa2b=0 if s2_workplace_closing==0 | s2_workplace_closing==.
replace sa3b=0 if s3_cancel_public_events==0 | s3_cancel_public_events==.
replace sa4b=0 if s4_close_public_transport==0 | s4_close_public_transport==.
replace sa5b=0 if s5_public_information_campaigns==0 | s5_public_information_campaigns==.
replace sa6b=0 if s6_restrictions_on_internal_move==0 | s6_restrictions_on_internal_move==.


replace sa1=sa1b if sa1==0
replace sa2=sa2b if sa2==0
replace sa3=sa3b if sa3==0
replace sa4=sa4b if sa4==0
replace sa5=sa5b if sa5==0
replace sa6=sa6b if sa6==0

drop sa1b sa2b sa3b sa4b sa5b sa6b


*generate different status depending on required or recommended
replace sa1=2 if sa1 ==1 & s1_school_closing==2
replace sa2=2 if sa2 ==1 & s2_workplace_closing==2
replace sa3=2 if sa3 ==1 & s3_cancel_public_events==2
replace sa4=2 if sa4 ==1 & s4_close_public_transport==2
replace sa5=2 if sa5 ==1 & s5_public_information_campaigns==2
replace sa6=2 if sa6 ==1 & s6_restrictions_on_internal_move==2




*generate adoption density
gen edate1=edate if sa1==1 | sa1==2
egen edate1_max=max(edate1), by(c_id)
sort c_id month day 
gen sa1b=1 if edate>=edate1_max
recode sa1b .=0
drop edate1_max
egen edate1_max=min(edate1), by(c_id)
sort c_id month day 
gen sa1b2=1 if edate>=edate1_max
replace sa1b=sa1b+sa1b2 if c_id==100
replace sa1b=sa1b+sa1b2 if c_id==153
replace sa1b=sa1b+sa1b2 if c_id==175
drop edate1 edate1_max sa1b2
recode sa1b .=0


gen edate2=edate if sa2==1 | sa2==2
egen edate2_max=max(edate2), by(c_id)
sort c_id month day 
gen sa2b=1 if edate>=edate2_max
recode sa2b .=0
drop edate2_max
egen edate2_max=min(edate2), by(c_id)
sort c_id month day 
gen sa2b2=1 if edate>=edate2_max
replace sa2b=sa2b+sa2b2 if c_id==13
replace sa2b=sa2b+sa2b2 if c_id==16
replace sa2b=sa2b+sa2b2 if c_id==80
replace sa2b=sa2b+sa2b2 if c_id==110
replace sa2b=sa2b+sa2b2 if c_id==114
replace sa2b=sa2b+sa2b2 if c_id==153
replace sa2b=sa2b+sa2b2 if c_id==175
drop edate2 edate2_max sa2b2
recode sa2b .=0


gen edate3=edate if sa3==1 | sa3==2
egen edate3_max=max(edate3), by(c_id)
sort c_id month day 
gen sa3b=1 if edate>=edate3_max
recode sa3b .=0
drop edate3_max
egen edate3_max=min(edate3), by(c_id)
sort c_id month day 
gen sa3b2=1 if edate>=edate3_max
replace sa3b=sa3b+sa3b2 if c_id==16
replace sa3b=sa3b+sa3b2 if c_id==36
replace sa3b=sa3b+sa3b2 if c_id==54
replace sa3b=sa3b+sa3b2 if c_id==74
replace sa3b=sa3b+sa3b2 if c_id==80
replace sa3b=sa3b+sa3b2 if c_id==110
replace sa3b=sa3b+sa3b2 if c_id==114
replace sa3b=sa3b+sa3b2 if c_id==220
replace sa3b=sa3b+sa3b2 if c_id==243
drop edate3 edate3_max sa3b2
recode sa3b .=0


gen edate4=edate if sa4==1 | sa4==2
egen edate4_max=max(edate4), by(c_id)
sort c_id month day 
gen sa4b=1 if edate>=edate4_max
recode sa4b .=0
drop edate4_max
egen edate4_max=min(edate4), by(c_id)
sort c_id month day 
gen sa4b2=1 if edate>=edate4_max
replace sa4b=sa4b+sa4b2 if c_id==114
replace sa4b=sa4b+sa4b2 if c_id==243
drop edate4 edate4_max sa4b2
recode sa4b .=0


gen edate5=edate if sa5==1 | sa5==2
egen edate5_max=max(edate5), by(c_id)
sort c_id month day 
gen sa5b=1 if edate>=edate5_max
recode sa5b .=0
drop edate5_max
replace edate5=. if c_id==221 & time==5

egen edate5_max=max(edate5), by(c_id)
sort c_id month day 
gen sa5b3=1 if edate>=edate5_max
recode sa5b3 .=0
replace sa5b=sa5b+sa5b3 if c_id==221
drop edate5_max sa5b3

egen edate5_max=min(edate5), by(c_id)
sort c_id month day 
gen sa5b2=1 if edate>=edate5_max
replace sa5b=sa5b+sa5b2 if c_id==69
replace sa5b=sa5b+sa5b2 if c_id==80
replace sa5b=sa5b+sa5b2 if c_id==115
replace sa5b=sa5b+sa5b2 if c_id==221
replace sa5b=sa5b+sa5b2 if c_id==243
drop edate5 edate5_max sa5b2
recode sa5b .=0

gen edate6=edate if sa6==1 | sa6==2
egen edate6_max=max(edate6), by(c_id)
sort c_id month day 
gen sa6b=1 if edate>=edate6_max
recode sa6b .=0
drop edate6_max
egen edate6_max=min(edate6), by(c_id)
sort c_id month day 
gen sa6b2=1 if edate>=edate6_max
replace sa6b=sa6b+sa6b2 if c_id==54
replace sa6b=sa6b+sa6b2 if c_id==69
replace sa6b=sa6b+sa6b2 if c_id==80
replace sa6b=sa6b+sa6b2 if c_id==114
replace sa6b=sa6b+sa6b2 if c_id==175
replace sa6b=sa6b+sa6b2 if c_id==179
drop edate6 edate6_max sa6b2
recode sa6b .=0

label var sa1 "Adoption School closure"
label var sa2 "Adoption Workplace closure"
label var sa3 "Adoption Cancellation of public events"
label var sa4 "Adoption Closure of public transportation"
label var sa6 "Adoption Restrictions on internal mobility"

