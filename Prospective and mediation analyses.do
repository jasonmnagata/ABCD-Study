********************************************************************************
*Project: Prospective association of screen time with binge‐eating disorder among adolescents in the United States: The mediating role of depression
*Authors: Abubakr AA Al‐Shoaibi, Iris Yuefan Shao, Kyle T Ganson, Jason M Lavender, Alexander Testa, Orsolya Kiss, Jinbo He, David V Glidden, Fiona C Baker, Jason M Nagata
*Data: ABCD study
********************************************************************************

*Drop missing data 
drop if BED_p2==. //*Dropping missing data from the outcome variable*//
drop if screentimetotal_bl==. //*Dropping missing data from the exposure variable *//
drop if depress_rbl==. //*Dropping missing data from depression at baseline variable*//
drop if depress_ry1==. //*Dropping missing data from depression at Year 1 variable *//
drop if BED_pbl==.       //*Dropping missing data from baseline BED assessement variable*//
drop if aces_total9_e0==. //*Dropping missing data from baseline Adverse childhood experience cumulative scorevariable *//
drop if foodinsecurity_bl ==. //*Dropping missing data from baseline food insecurity variable *//
drop if agebl==.              //*Dropping missing data from baseline age variable*//
drop if gender ==.            //*Dropping missing data from gender*// 
drop if parenteduc_bl ==.     //*Dropping missing data from baseline parent education variable *//
drop if HHincomecat_bl ==.    //*Dropping missing data from baseline household income variable *//
drop if site_id ==.           //*Dropping missing data from study site  *//
drop if race ==.                //*Dropping missing data from race variable*//

*Calculating difference in depression from baseline to Year 1
gen depdiff=abs(depress_ry1- depress_rbl)

*SEM model 
gsem (depdiff -> BED_p2, family(bernoulli) link(logit)) (screentimetotal_bl -> BED_p2, family(bernoulli) link(logit)) (screentimetotal_bl -> depdiff, ) (agebl -> BED_p2, family(bernoulli) link(logit)) (agebl -> depdiff, ) (gender -> BED_p2, family(bernoulli) link(logit)) (gender -> depdiff, ) (parenteduc_bl -> BED_p2, family(bernoulli) link(logit)) (BED_pbl -> BED_p2, family(bernoulli) link(logit)) (BED_pbl -> depdiff, ) (HHincomecat_bl -> BED_p2, family(bernoulli) link(logit)) (HHincomecat_bl -> depdiff, ) (site_id -> BED_p2, family(bernoulli) link(logit)) (site_id -> depdiff, ) (race -> BED_p2, family(bernoulli) link(logit)) (race -> depdiff, ) (aces_total9_e0 -> BED_p2, family(bernoulli) link(logit)) (aces_total9_e0 -> depdiff, ) (foodinsecurity_bl -> BED_p2, family(bernoulli) link(logit)) (foodinsecurity_bl -> depdiff, ) [pweight = acs_raked_propensity_score], nocapslatent

*Calculating direct effect, total effect, and mediated proportion

*Indirect effect 
gsem, coeflegend
nlcom _b[depdiff:screentimetotal_bl]*_b[BED_p2:depdiff]

*Total effect
nlcom _b[depdiff:screentimetotal_bl]*_b[BED_p2:depdiff]+_b[BED_p2:screentimetotal_bl]

*Proportion mediated 

nlcom (_b[depdiff:screentimetotal_bl]*_b[BED_p2:depdiff])/(_b[depdiff:screentimetotal_bl]*_b[BED_p2:depdiff]+_b[BED_p2:screentimetotal_bl])




* Generating bias-corrected (BC) 95% CIs for the indirect effect using 5000 bootstrap samples

capture program drop bootmm
program bootmm, rclass
  syntax [if] [in]
  marksample touse  
gsem (depdiff -> BED_p2, family(bernoulli) link(logit)) (screentimetotal_bl -> BED_p2, family(bernoulli) link(logit)) (screentimetotal_bl -> depdiff, ) (agebl -> BED_p2, family(bernoulli) link(logit)) (agebl -> depdiff, ) (gender -> BED_p2, family(bernoulli) link(logit)) (gender -> depdiff, ) (parenteduc_bl -> BED_p2, family(bernoulli) link(logit)) (BED_pbl -> BED_p2, family(bernoulli) link(logit)) (BED_pbl -> depdiff, ) (HHincomecat_bl -> BED_p2, family(bernoulli) link(logit)) (HHincomecat_bl -> depdiff, ) (site_id -> BED_p2, family(bernoulli) link(logit)) (site_id -> depdiff, ) (race -> BED_p2, family(bernoulli) link(logit)) (race -> depdiff, ) (aces_total9_e0 -> BED_p2, family(bernoulli) link(logit)) (aces_total9_e0 -> depdiff, ) (foodinsecurity_bl -> BED_p2, family(bernoulli) link(logit)) (foodinsecurity_bl -> depdiff, ) [pweight = acs_raked_propensity_score], nocapslatent, if  `touse'
  return scalar inddep=_b[depdiff:screentimetotal_bl]*_b[BED_p2:depdiff]
end

bootstrap r(inddep), bca reps(5000): bootmm
estat boot, percentile bc bca







