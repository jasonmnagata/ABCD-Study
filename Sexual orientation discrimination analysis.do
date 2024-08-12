
*Create a cleaned sexual orientation discrimination variable
*1 = Yes; 0 = No; 777 = Don't know; 999 = Refused to answer
gen dim_sex_incl_y2 = dim_yesno_q3_y2 if dim_yesno_q3_y2 !=. & dim_yesno_q3_y2 !=777 & dim_yesno_q3_y2 !=999

********************************************
*Without survey/sampling weights (N=9,345)
********************************************

*Create sociodemographic inclusion variable to ensure no sociodemographics are missing
gen socio_incl_y2 = 0
replace socio_incl_y2 = 1 if age_y2 !=. & race_num !=. & sex_orient_y2 !=. & gender_num !=. & HHincomecat_y2 !=. & parenteduc_y2 !=. & site_id !=. & child_relig_biv !=. 

*Chi square - to get prevalence of sexual orientation discrimination by sexual orientation status (didn't report chi-square test statistic or p-value)
tab dim_sex_incl_y2 sex_orient_y2 if socio_incl_y2==1, chi2 col 

*Get 95% CI for the figure of the prevalence of sexual orientation discrimination by sexual orientation status (error bars were added to the figure in Excel):
levelsof sex_orient_y2 if socio_incl_y2==1, local(sex_orient_levels)
levelsof dim_sex_incl_y2 if socio_incl_y2==1, local(dim_sex_levels)

foreach sex in `sex_orient_levels' {
    foreach dim in `dim_sex_levels' {
        display "Calculating for sex_orient_y2 = `sex' and dim_sex_incl_y2 = `dim'"
        proportion dim_sex_incl_y2 if sex_orient_y2 == `sex' & socio_incl_y2 == 1
    }
}

*Descriptives: M(SD) / %
dtable dim_sex_incl_y2 c.age_y2 i.gender_num ib3.sex_orient_y2 ib6.race_num ib1.child_relig_biv ib6.HHincomecat_y2 ib1.parenteduc_y2 if socio_incl_y2 ==1 & dim_sex_incl_y2 !=.

*Full sample Poisson
poisson dim_sex_incl_y2 c.age_y2 i.gender_num ib3.sex_orient_y2 ib6.race_num ib1.child_relig_biv ib6.HHincomecat_y2 ib1.parenteduc_y2 i.site_id if socio_incl_y2 ==1, cformat(%5.2f) irr vce(robust)

*Stratified Poisson (sexual orientation: "yes" (gay bisexual) and "maybe" (maybe gay/bisexual))
poisson dim_sex_incl_y2 c.age_y2 i.gender_num ib6.race_num ib1.child_relig_biv ib6.HHincomecat_y2 ib1.parenteduc_y2 i.site_id if socio_incl_y2 ==1 & nonhetero_yes_maybe == 1, cformat(%5.2f) irr vce(robust)

*Add number of participants experiencing discrimination by sociodemographic subgroup to appendix
dtable c.age_y2 i.gender_num i.race_num i.sex_orient_y2 i.HHincomecat_y2 i.parenteduc_y2 i.child_relig_biv if dim_sex_incl_y2==1 & socio_incl_y2 ==1

*Percentage of participants experiencing discrimination out of total sample
tab dim_sex_incl_y2 if socio_incl_y2 ==1
*4.88%


























