
//############################# Working Directory ############################//
cd "C:\Users\yx\Box\ABCD Study"

//################################ DataFile ################################//
//++++++++++++++++++++++++++++++++ Screen Time +++++++++++++++++++++++++++++++//
insheet using "ABCD 4.0\abcd_stq01.txt", tab clear names

// Labeling the variables:
foreach var of varlist * {
    label variable `var' "`=`var'[1]'"
}
drop in 1 

// Dropping the unnecessary columns:
drop collection_id - dataset_id src_subject_id collection_title

// Destring the variables:
destring, replace


// Eventname for follow-up:
tab eventname
encode eventname, gen(event)
recode event (4 = 0)
label define followup_lab 0 "Baseline Year 1" 1 "1-year Follow-up" 2 "2-year Follow-up" 3 "3-year Follow-up"
label values event followup_lab

drop eventname

sort subjectkey event

save "ABCD_Edith Files\ScreenTime\Working Folder\DataFiles\Draft\Screen_Time_draft4.0.dta", replace


//############################# Variable Recoding ##########################//
use "ABCD_Edith Files\ScreenTime\Working Folder\DataFiles\Draft\Screen_Time_draft4.0.dta", clear

keep if event==2

// Converting min into hrs:
foreach var of varlist screentime_1_wkdy_min screentime_2_wkdy_min screentime_3_wkdy_min screentime_4_wkdy_min screentime_5_wkdy_min screentime_6_wkdy_min screentime_8_wkdy_min screentime_9_wkdy_min screentime_7_wknd_min screentime_8_wknd_min screentime_9_wknd_min screentime_10_wknd_min screentime_11_wknd_min screentime_12_wknd_min screentime_14_wknd_min screentime_15_wknd_min {
	recode `var'(15=.25) (30=.5) (45=.75)
}

// Screentime variables recoding:
gen tvavg_2 = ((screentime_1_wkdy_hr + screentime_1_wkdy_min) * 5 + (screentime_7_wknd_hr + screentime_7_wknd_min) *2)/7
label variable tvavg_2 "Average screen time on TV shows or movies at Year 2"
summ tvavg_2

gen vidavg_2 = ((screentime_2_wkdy_hr + screentime_2_wkdy_min) * 5 + (screentime_8_wknd_hr + screentime_8_wknd_min) *2)/7
label variable vidavg_2 "Average screen time on watching videos (such as YouTube) at Year 2"
summ vidavg_2

gen vidgames_single_avg_2 = ((screentime_3_wkdy_hr + screentime_3_wkdy_min) * 5 + (screentime_9_wknd_hr + screentime_9_wknd_min) *2)/7
label variable vidgames_single_avg_2 "Average screen time on single-player video games on a computer, console, phone or other device (Xbox, Play Station, iPad) at Year 2"
summ vidgames_single_avg_2

gen vidgames_multi_avg_2 = ((screentime_4_wkdy_hr + screentime_4_wkdy_min) * 5 + (screentime_10_wknd_hr + screentime_10_wknd_min) *2)/7
label variable vidgames_multi_avg_2 "Average screen time on multiplayer video games on a computer, console, phone or other device (Xbox, Play Station, iPad) at Year 2"
summ vidgames_multi_avg_2

gen textavg_2 = ((screentime_5_wkdy_hr + screentime_5_wkdy_min) * 5 + (screentime_11_wknd_hr + screentime_11_wknd_min) *2)/7
label variable textavg_2 "Average screen time on texting on a cell phone, tablet, or computer (e.g. GChat, Whatsapp, etc.) at Year 2"
summ textavg_2

gen socialnetavg_2 = ((screentime_6_wkdy_hr + screentime_6_wkdy_min) * 5 + (screentime_12_wknd_hr + screentime_12_wknd_min) *2)/7
label variable socialnetavg_2 "Average screen time on texting on a cell phone, tablet, or computer (e.g. GChat, Whatsapp, etc.) at Year 2"
summ socialnetavg_2

gen vidchatavg_2 = ((screentime_8_wkdy_hr + screentime_8_wkdy_min) * 5 + (screentime_14_wknd_hr + screentime_14_wknd_min) *2)/7
label variable vidchatavg_2 "Average screen time on video chat (Skype, Facetime, etc.) at Year 2"
summ vidchatavg_2

gen internetavg_2 = ((screentime_9_wkdy_hr + screentime_9_wkdy_min) * 5 + (screentime_15_wknd_hr + screentime_15_wknd_min) *2)/7
label variable internetavg_2 "Average screen time on searching or browsing the internet (e.g., using Google) that is not for school at Year 2"
summ internetavg_2

egen screentimetotal_2 = rowtotal(tvavg_2 - internetavg_2)
label variable screentimetotal_2 "Total average screen time at Year 2"
summ screentimetotal_2

// save "ABCD_Edith Files\ScreenTime\Working Folder\DataFiles\Draft\Screen_Time_Year2_draft.dta", replace //

// use "ABCD_Edith Files\ScreenTime\Working Folder\DataFiles\Draft\Screen_Time_Year2_draft.dta", clear //

foreach var of varlist screentime_smqa1 - screentime_smqa6 {
	recode `var' (777=.)
}
egen smaddiction = rowtotal(screentime_smqa1 - screentime_smqa6)
label variable smaddiction "Social media addiction scale score"

foreach var of varlist screentime_vgaq1 screentime_vgaq2 screentime_vgaq3 - screentime_vgaq6 {
	recode `var' (777=.)
}
egen vgaddiction = rowtotal(screentime_vgaq1 screentime_vgaq2 screentime_vgaq3 - screentime_vgaq6) 
label variable vgaddiction "Video game addiction score"

foreach var of varlist screentime_phone1 - screentime_phone5 screentime_phone6 - screentime_phone8 screentime_phone_scale {
	recode `var' (777=.)
}
egen phone_mscore = rowmean(screentime_phone1 - screentime_phone5 screentime_phone6 - screentime_phone8)
label variable phone_mscore "Mean score of cell phone using"

save "ABCD_Edith Files\ScreenTime\Working Folder\DataFiles\Cleaned\Screen_Time_Year2_only.dta", replace


//######################### Wide format datafile ########################//
use "ABCD_Edith Files\ScreenTime\Working Folder\DataFiles\Draft\Screen_Time_draft4.0.dta", clear

// Converting min into hrs:
foreach var of varlist screentime_1_wkdy_min screentime_2_wkdy_min screentime_3_wkdy_min screentime_4_wkdy_min screentime_5_wkdy_min screentime_6_wkdy_min screentime_8_wkdy_min screentime_9_wkdy_min screentime_7_wknd_min screentime_8_wknd_min screentime_9_wknd_min screentime_10_wknd_min screentime_11_wknd_min screentime_12_wknd_min screentime_14_wknd_min screentime_15_wknd_min {
	recode `var'(15=.25) (30=.5) (45=.75)
}

// Screentime variables recoding:
gen tvavg = ((screentime_1_wkdy_hr + screentime_1_wkdy_min) * 5 + (screentime_7_wknd_hr + screentime_7_wknd_min))/7
label variable tvavg "Average screen time on TV shows or movies"
summ tvavg

gen vidavg = ((screentime_2_wkdy_hr + screentime_2_wkdy_min) * 5 + (screentime_8_wknd_hr + screentime_8_wknd_min))/7
label variable vidavg "Average screen time on watching videos (such as YouTube)"
summ vidavg

gen vidgames_single_avg = ((screentime_3_wkdy_hr + screentime_3_wkdy_min) * 5 + (screentime_9_wknd_hr + screentime_9_wknd_min))/7
label variable vidgames_single_avg "Average screen time on single-player video games on a computer, console, phone or other device (Xbox, Play Station, iPad)"
summ vidgames_single_avg

gen vidgames_multi_avg = ((screentime_4_wkdy_hr + screentime_4_wkdy_min) * 5 + (screentime_10_wknd_hr + screentime_10_wknd_min))/7
label variable vidgames_multi_avg "Average screen time on multiplayer video games on a computer, console, phone or other device (Xbox, Play Station, iPad)"
summ vidgames_multi_avg

gen textavg = ((screentime_5_wkdy_hr + screentime_5_wkdy_min) * 5 + (screentime_11_wknd_hr + screentime_11_wknd_min))/7
label variable textavg "Average screen time on texting on a cell phone, tablet, or computer (e.g. GChat, Whatsapp, etc.)"
summ textavg

gen socialnetavg = ((screentime_6_wkdy_hr + screentime_6_wkdy_min) * 5 + (screentime_12_wknd_hr + screentime_12_wknd_min))/7
label variable socialnetavg "Average screen time on texting on a cell phone, tablet, or computer (e.g. GChat, Whatsapp, etc.)"
summ socialnetavg

gen vidchatavg = ((screentime_8_wkdy_hr + screentime_8_wkdy_min) * 5 + (screentime_14_wknd_hr + screentime_14_wknd_min))/7
label variable vidchatavg "Average screen time on video chat (Skype, Facetime, etc.)"
summ vidchatavg

gen internetavg = ((screentime_9_wkdy_hr + screentime_9_wkdy_min) * 5 + (screentime_15_wknd_hr + screentime_15_wknd_min))/7
label variable internetavg"Average screen time on searching or browsing the internet (e.g., using Google) that is not for school"
summ internetavg

egen screentimetotal = rowtotal(tvavg - internetavg)
label variable screentimetotal "Total average screen time"
summ screentimetotal

foreach var of varlist screentime_smqa1 - screentime_smqa6 {
	recode `var' (777=.)
}
egen smaddictiontotal = rowtotal(screentime_smqa1 - screentime_smqa6)
label variable smaddictiontotal "Total social media addiction scale score"

foreach var of varlist screentime_vgaq1 screentime_vgaq2 screentime_vgaq3 - screentime_vgaq6 {
	recode `var' (777=.)
}
egen vgaddictiontotal = rowtotal(screentime_vgaq1 screentime_vgaq2 screentime_vgaq3 - screentime_vgaq6) 
label variable vgaddictiontotal "Total video game addiction score"

foreach var of varlist screentime_phone1 - screentime_phone5 screentime_phone6 - screentime_phone8 screentime_phone_scale {
	recode `var' (777=.)
}
egen phone_mscore = rowmean(screentime_phone1 - screentime_phone5 screentime_phone6 - screentime_phone8)
label variable phone_mscore "Mean score of cell phone using"

drop interview_date

keep subjectkey - sex event - phone_mscore screentime_phone_scale


// Wide format:
reshape wide interview_age sex screentime_phone_scale tvavg - phone_mscore, i(subjectkey) j(event)

sort subjectkey

save "ABCD_Edith Files\ScreenTime\Deliverable\DataFiles\Year2_Screen_Time (ABCD 4.0_wide).dta", replace


// Saving the codebook:
// Installing the function codebookout: ssc install codebookout //
codebookout "ABCD_Edith Files\ScreenTime\Working Folder\Files\Screen_Time4.0_wide_codebook.xlsx", replace

