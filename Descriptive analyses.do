*import in your merged dataset 
 use "/Users/angel/Downloads/ABCD STUDY DOCS/merged_1HHIbinary.dta" , clear

*making sure propensity weights are set 
 svyset [pw= acs_raked_propensity_score]
*getting the frequency/number of participants with BED in the dataset 
 tab pres_bingeeating_2p
*getting the frequency/number of participants with binge-eating behaviors in the dataset 
 tab pres_bingeED_2p
 
*demographic percentages by binge-eating behavior outcome (with propensity weights) 
svy: tab gender pres_bingeeating_2p, col
svy: tab race pres_bingeeating_2p, col
svy: tab HH_binary pres_bingeeating_2p, col
svy: tab parenteduc pres_bingeeating_2p, col
svy: tab kbi_y_sex_orient2 pres_bingeeating_2p, col

*demographic percentages by BED outcome (with propensity weights) 
svy: tab gender pres_bingeED_2p, col
svy: tab race pres_bingeED_2p, col
svy: tab HH_binary pres_bingeED_2p, col
svy: tab parenteduc pres_bingeED_2p, col
svy: tab kbi_y_sex_orient2 pres_bingeED_2p, col

*creating new variables for regression
 encode kbi_y_sex_orient2, generate(sex_orient2) 
 encode gender, generate(gender2)
 encode race, generate(race2)

 *Table 2
 *Unadjusted
*logistic regression using propensity scores unadusted	   
svy: logistic pres_bingeED_2p ib4.sex_orient2      
svy: logistic pres_bingeED_2p age_y2
svy: logistic pres_bingeED_2p i.gender2
svy: logistic pres_bingeED_2p ib6.race2
svy: logistic pres_bingeED_2p i.parenteduc
svy: logistic pres_bingeED_2p ib1.HH_binary

svy: logistic pres_bingeeating_2p ib4.sex_orient2 age_y2 i.gender2 ib6.race2 i.parenteduc ib1.HH_binary i.HH_binary i.site_id  
 
*logistic regression using propensity scores and setting income reference to greater than and equal to 200k	   
svy: logistic pres_bingeED_2p ib4.sex_orient2 age_y2 i.gender2 ib6.race2 i.parenteduc ib1.HH_binary i.site_id
svy: logistic pres_bingeeating_2p ib4.sex_orient2 age_y2 i.gender2 ib6.race2 i.parenteduc ib1.HH_binary i.HH_binary i.site_id 





*interaction bw race*gender
svy: logistic pres_bingeED_2p ib4.sex_orient2 age_y2 i.gender2##ib6.race2 i.parenteduc ib1.HH_binary i.site_id
svy: logistic pres_bingeeating_2p ib4.sex_orient2 age_y2 i.gender2##ib6.race2 i.parenteduc ib1.HH_binary i.site_id

*interaction bw race*hhincome - white as reference
svy: logistic pres_bingeED_2p ib4.sex_orient2 age_y2 i.gender2 ib6.race2##ib1.HH_binary i.parenteduc i.site_id
svy: logistic pres_bingeeating_2p ib4.sex_orient2 age_y2 i.gender2 ib6.race2##ib1.HH_binary i.parenteduc i.site_id

*interaction bw race*hhincome - asian as reference
svy: logistic pres_bingeED_2p ib4.sex_orient2 age_y2 i.gender2 i.race2##ib1.HH_binary i.parenteduc i.site_id
svy: logistic pres_bingeeating_2p ib4.sex_orient2 age_y2 i.gender2 i.race2##ib1.HH_binary i.parenteduc i.site_id


	   
	   
	   
