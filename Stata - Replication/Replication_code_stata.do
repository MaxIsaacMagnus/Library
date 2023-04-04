

	clear all
	set more off
	cd "C:\Users\Max\Documents\Topics in econometrics\Replication\jpepublic"
	
	
** Table 2 - randomization of treatment **

******************************************************************************
	
	use "jperandomizationdata", clear
	est clear

** Audit **
	probit audit zpop totalmesjid totalallocation z4RABnumsubproj zpercentpoorpra zdistancekec zkadesedyears zkadesage zkadesbengkoktotal podeszhill, cluster(kecnum)
	margins, dydx(*) atmeans post	
	est sto re1
	testparm *
	estadd scalar p_value = r(p)

** Invitations **
	probit undfpm zpop totalmesjid totalallocation z4RABnumsubproj zpercentpoorpra zdistancekec zkadesedyears zkadesage zkadesbengkoktotal podeszhill, cluster(kecnum)
	margins, dydx(*) atmeans post
	est sto re2
	testparm *
	estadd scalar p_value = r(p)	
	
** Comments conditonal on invitations **
	probit fpm zpop totalmesjid totalallocation z4RABnumsubproj zpercentpoorpra zdistancekec zkadesedyears zkadesage zkadesbengkoktotal podeszhill if undfpm == 1, cluster(kecnum)
	margins, dydx(*) atmeans post
	est sto re3
	testparm *
	estadd scalar p_value = r(p)

** Actual Invitations **
	probit und zpop totalmesjid totalallocation z4RABnumsubproj zpercentpoorpra zdistancekec zkadesedyears zkadesage zkadesbengkoktotal podeszhill, cluster(kecnum)
	margins, dydx(*) atmeans post
	est sto re4
	testparm *
	estadd scalar p_value = r(p)
	
	esttab re1 re2 re3 re4 using table2.rtf,replace se label compress cells(b(star fmt(3)) se(par fmt(3))) scalar(p_value) title("Table 2: Relationship between Treatments and village characteristics") mtitles("Audits" "Invitations" "Comments (conditional on invitations)" "Actual Invitations") addnote("Results reported are marginal effects from Probit regressions. Robust standard errors are in parentheses, adjusted for clustering at the subdistrict level.")  starlevels(* 0.1 ** 0.05 *** 0.01)
	
	est clear


******************************************************************************

** Table 3 - summary statistics **

******************************************************************************

	use "jperoaddata.dta", clear
	
	eststo sum1: estpost sum totalprojusd sharetotalroad sharetotalancil sharetotalother shareroadsand shareroadrock shareroadtop shareroadburuh shareroadother lndiffeall4 lndiffeall4mainancil lndiffeall3mat lndiffeburuh if lndiffeall4mainancil != .
	
	esttab sum1 using table3.rtf, replace cells("mean(fmt(3)) sd(fmt(3))") nostar nonumber label title("Table 3: Summary Statistics") mtitles("Summary Statistics") addnote("Statistics shown are means, with standard deviations. Data on expenditures are taken from the 538 villages for which percent missing in road and ancillary projects could be calculated. Exchange rate is Rp. 9,000 = US$1.00.")
	
	


******************************************************************************

** Table 4 - audit results **

******************************************************************************

* Missing expenditures in roads, row 1
	est clear

	qui eststo r1c1: reg lndiffeall4 if audit==0
	qui eststo r1c2: reg lndiffeall4 if audit==1
	qui eststo r1c3: reg lndiffeall4 audit und fpm, cluster(kecnum)
	qui eststo r1c5: areg lndiffeall4 audit und fpm, cluster(kecnum) absorb(z7enumcode)
	qui eststo r1c7: areg lndiffeall4 audit und fpm, cluster(kecnum) absorb(auditstratnum)
	esttab r1c1 r1c2 r1c3 r1c5 r1c7 using table4a.rtf,replace se p label compress keep(audit _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 4:Audits: Main theft results") mtitles("Control mean" "Treatment mean: audits" "Audit effect" "Audit effect" "Audit effect") addnote("Audit effect, standard errors, and p-values are computed by estimating eq. (1). Robust standard errors are in parentheses, allowing for clustering by subdistrict (to account for clustering of treatment by subdistrict).") starlevels(* 0.1 ** 0.05 *** 0.01)

* Missing expenditures in road and ancillary projects, row 2
	est clear

	qui eststo r2c1: reg lndiffeall4mainancil if audit==0
	qui eststo r2c2: reg lndiffeall4mainancil if audit==1
	qui eststo r2c3: reg lndiffeall4mainancil audit und fpm, cluster(kecnum)
	qui eststo r2c5: areg lndiffeall4mainancil audit und fpm, cluster(kecnum) absorb(z7enumcode)
	qui eststo r2c7: areg lndiffeall4mainancil audit und fpm, cluster(kecnum) absorb(auditstratnum)
	esttab r2c1 r2c2 r2c3 r2c5 r2c7 using table4b.rtf,replace se p label compress keep(audit _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 4:Audits: Main theft results") mtitles("Control mean" "Treatment mean: audits" "Audit effect" "Audit effect" "Audit effect") addnote("Audit effect, standard errors, and p-values are computed by estimating eq. (1). Robust standard errors are in parentheses, allowing for clustering by subdistrict (to account for clustering of treatment by subdistrict).") starlevels(* 0.1 ** 0.05 *** 0.01)

* Missing expenditures for materials in roads, row 3
	est clear

	qui eststo r3c1: reg lndiffeall3mat if audit==0
	qui eststo r3c2: reg lndiffeall3mat if audit==1
	qui eststo r3c3: reg lndiffeall3mat audit und fpm, cluster(kecnum)
	qui eststo r3c5: areg lndiffeall3mat audit und fpm, cluster(kecnum) absorb(z7enumcode)
	qui eststo r3c7: areg lndiffeall3mat audit und fpm, cluster(kecnum) absorb(auditstratnum)
	esttab r3c1 r3c2 r3c3 r3c5 r3c7 using table4c.rtf,replace se p label compress keep(audit _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 4:Audits: Main theft results") mtitles("Control mean" "Treatment mean: audits" "Audit effect" "Audit effect" "Audit effect") addnote("Audit effect, standard errors, and p-values are computed by estimating eq. (1). Robust standard errors are in parentheses, allowing for clustering by subdistrict (to account for clustering of treatment by subdistrict).") starlevels(* 0.1 ** 0.05 *** 0.01)

* Missing expenditures in unskilled labor, row 4
	est clear

	qui eststo r4c1: reg lndiffeburuh if audit==0
	qui eststo r4c2: reg lndiffeburuh if audit==1
	qui eststo r4c3: reg lndiffeburuh audit und fpm, cluster(kecnum)
	qui eststo r4c5: areg lndiffeburuh audit und fpm, cluster(kecnum) absorb(z7enumcode)
	qui eststo r4c7: areg lndiffeburuh audit und fpm, cluster(kecnum) absorb(auditstratnum)
	esttab r4c1 r4c2 r4c3 r4c5 r4c7 using table4d.rtf,replace se p label compress keep(audit _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 4:Audits: Main theft results") mtitles("Control mean" "Treatment mean: audits" "Audit effect" "Audit effect" "Audit effect") addnote("Audit effect, standard errors, and p-values are computed by estimating eq. (1). Robust standard errors are in parentheses, allowing for clustering by subdistrict (to account for clustering of treatment by subdistrict).") starlevels(* 0.1 ** 0.05 *** 0.01)


*** Note: it looks very messy some of these commands where I use the estout packeage. But here I created four separate tables, which I manually combined in word, to get one that looks fairly presentable. I was unsure how I could create table 4 by using only one esttab command. You will see the same sort of mess in the commands for table 11 and table 12.


******************************************************************************

** Table 6 **

******************************************************************************

	est clear
	
* Column 1
eststo m1: areg stdz12scorefisikboth stdz13scorefisik stdz13scoreadmin, absorb(kecnum) vce(cluster kecnum)
* Column 2
eststo m2: areg stdz12scoreadminboth stdz13scorefisik stdz13scoreadmin, absorb(kecnum) vce(cluster kecnum)
* Column 3
eststo m3: areg lndiffeall4 stdz13scorefisik stdz13scoreadmin, absorb(kecnum) vce(cluster kecnum)
* Column 4
eststo m4: areg lndiffeall4mainancil stdz13scorefisik stdz13scoreadmin, absorb(kecnum) vce(cluster kecnum)
* Column 5
eststo m5: areg lndiffeburuh stdz13scorefisik stdz13scoreadmin, absorb(kecnum) vce(cluster kecnum)
* Column 6
eststo m6: areg lndiffeall3mat stdz13scorefisik stdz13scoreadmin, absorb(kecnum) vce(cluster kecnum)


	esttab m1 m2 m3 m4 m5 m6 using table6.rtf,replace se label mtitle("Engineering team physical score" "Engineering team admin score" "Percent missing in road" "Percent missing in road and ancillary" "Percent missing in materials" "Percent missing in unskilled labor") nocons compress cells(b(star fmt(3)) se(par fmt(3))) stats(N r2, fmt(a3 2) labels("Observations" "R-squared")) title("Table 6: Relationship between auditor findings and survey team findings") mtitles addnote("Robust standard errors are in parentheses, adjusted for clustering at the subdistrict level. Auditor scores refer to the results from the final BPKP audits; engineering team scores refer to the results from the engineering team that was sent to estimate missing expenditures. The results from the engineeringteam were not share with the BPKP audit team. All specifications include subdistrict fixed effects, which therefore hold constant both the BPKP audit teams and the engineering teams. For both physical and administrative scores, scores are normalized to have mean zero and standard deviation one.") starlevels(* 0.1 ** 0.05 *** 0.01)




******************************************************************************

** Table 8 **

******************************************************************************

	use "jpehouseholddata.dta", clear
	
	est clear
	
** LPM regression **
* column 1
	eststo m1: areg zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditzknowsfamilygovt zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm

* column 2	
	eststo m2: areg zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditzknowsfamilyH zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm

* column 3
	eststo m3: areg zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditactivitiesnumberpercapita zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum) 
	estadd ysumm

* column 4
	eststo m4: areg zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditzknowsfamilygovt auditzknowsfamilyH auditactivitiesnumberpercapita zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm

*******************************************************************
** Table 8 - robustness check: not related to heads and nepotism **
*******************************************************************
	
* Gen norelated variable and interaction term for norelated and audit

	gen norelated = 1 if zknowsfamilyH==0 & zknowsfamilygovt==0
	replace norelated = 0 if zknowsfamilyH==1 | zknowsfamilygovt==1
	la var norelated "Not related to village/project head"
	gen auditnorelated = audit*norelated
	la var auditnorelated "Audit * Not related to village/project head"

* column 5: Audit * Norelated interaction included
	eststo m5: areg zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditnorelated zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap norelated i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm
		
	
	esttab m1 m2 m3 m4 m5 using table8.rtf, replace se label nomtitles cells(b(star fmt(3)) se(par fmt(3))) keep(audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditzknowsfamilygovt auditzknowsfamilyH auditactivitiesnumberpercapita auditnorelated norelated) stats(N r2 ymean, fmt(a3 2) labels("Observations" "R-squared" "Mean dependent variable")) title("Table 8: Nepotism") addnote("Data are taken from the household survey. Each observation represents one household. Results come from estimating eq. (3), where the dependent variable is a dummy for whether a household member worked on the road project. Estimation is done by OLS with stratum fixed effects. Robust standard errors are in parentheses, adjusted for clustering at subdistrict level. Social activities refers to the number of social activities adult household members participated in during the last month. All specifications include controls for invitations and invitations plus comment form treatments, age and gender of respondent, mean adult education in the household, predicted household income, and dummies for type of household sampled.") starlevels(* 0.1 ** 0.05 *** 0.01)

	
***********************************************************
** Also check if probit actually gives similar estimates **
***********************************************************

** Probit regression **
* column 1
	est clear
	qui probit zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditzknowsfamilygovt zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap i.zrespondtype i.auditstratnum, cluster(kecnum)
	margins, dydx(*) atmeans post
	est sto p1

* column 2	
	qui probit zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditzknowsfamilyH zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap i.zrespondtype i.auditstratnum, cluster(kecnum) 
	margins, dydx(*) atmeans post
	est sto p2

* column 3
	qui probit zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditactivitiesnumberpercapita zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap i.zrespondtype i.auditstratnum, cluster(kecnum) 
	margins, dydx(*) atmeans post
	est sto p3
	
* column 4
	qui probit zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditzknowsfamilygovt auditzknowsfamilyH auditactivitiesnumberpercapita zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap i.zrespondtype i.auditstratnum, cluster(kecnum) 
	margins, dydx(*) atmeans post
	est sto p4
	
* column 5	
	qui probit zhhworkedwageanyhh audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditnorelated norelated zage zfemale und fpm zavgadultedyearsinhh zlhhexpcap i.zrespondtype i.auditstratnum, cluster(kecnum) 
	margins, dydx(*) atmeans post
	est sto p5
	
	esttab p1 p2 p3 p4 p5 using table8b.rtf, replace se label r2 nomtitles cells(b(star fmt(3)) se(par fmt(3))) keep(audit zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita auditzknowsfamilygovt auditzknowsfamilyH auditactivitiesnumberpercapita auditnorelated norelated) stats(N r2, fmt(a3 2) labels("Observations" "R-squared")) title("Table 8b: Nepotism: Probit") addnote("Check note for table 8. Probit estimates of table 8 that checked for nepotism. Robust standard errors are in parentheses, adjusted for clustering at subdistrict level. R-squared was not successfully included in this table unfortunately. Otherwise, all controls and interactions remain the same as in table 8. ") starlevels(* 0.1 ** 0.05 *** 0.01)



******************************************************************************

** Table 9 **

******************************************************************************

	use "jpemeetingdata.dta", clear

	est clear
	eststo m1: areg totaltanyone und fpm musdpj2 musdpj3 if musdpj1 | musdpj2 | musdpj3, cluster(desaid) absorb(kecnum)
	estadd ysumm
	test und=fpm
	estadd scalar p_value = r(p)

	eststo m2: areg totaltperson und fpm musdpj2 musdpj3 if musdpj1 | musdpj2 | musdpj3, cluster(desaid) absorb(kecnum)
	estadd ysumm
	test und=fpm
	estadd scalar p_value = r(p)

	eststo m3: areg totalttalk und fpm musdpj2 musdpj3 if musdpj1 | musdpj2 | musdpj3, cluster(desaid) absorb(kecnum)
	estadd ysumm
	test und=fpm
	estadd scalar p_value = r(p)

	eststo m4: areg totalttalktperson und fpm musdpj2 musdpj3 if musdpj1 | musdpj2 | musdpj3, cluster(desaid) absorb(kecnum)
	estadd ysumm
	test und=fpm
	estadd scalar p_value = r(p)
	
	esttab m1 m2 m3 m4 using table9.rtf, replace se label nocons cells(b(star fmt(2)) se(par fmt(2)))  stats(N r2 ymean, fmt(a3 2 2) labels("Observations" "R-squared" "Mean dependent variable")) scalar(p_value) title("Table 9: Participation") addnote("Results come from estimating eq. (1), with the dependent variables the participation variables shown in the first row. Data are taken from the meeting survey. Each observation is a single village meeting. Stratum (subdistrict) fixed effects are included; since audit is constant within a subdistrict, the audit variable is automatically captured by the stratum fixed effect. Robust standard errors are in parentheses, adjusted for clustering at the village level.") starlevels(* 0.1 ** 0.05 *** 0.01)
	
	
******************************************************************************

** Table 10 **

******************************************************************************

	use "jpeproblemdata.dta", clear
	
	est clear
	eststo m1: areg numprobs und fpm musdpj2 musdpj3 if musdpj1 | musdpj2 | musdpj3, cluster(desaid) absorb(kecnum)
	estadd ysumm
	test und=fpm
	estadd scalar p_value = r(p)
	
	eststo m2: areg anypeny und fpm musdpj2 musdpj3 if musdpj1 | musdpj2 | musdpj3, cluster(desaid) absorb(kecnum)
	estadd ysumm
	test und=fpm
	estadd scalar p_value = r(p)
	
	eststo m3: areg anysevere und fpm musdpj2 musdpj3 if musdpj1 | musdpj2 | musdpj3, cluster(desaid) absorb(kecnum)
	estadd ysumm
	test und=fpm
	estadd scalar p_value = r(p)
	
	esttab m1 m2 m3 using table10.rtf, replace se label nocons cells(b(star fmt(3)) se(par fmt(3)))  stats(N r2 ymean, fmt(a3 2 2) labels("Observations" "R-squared" "Mean dependent variable")) scalar(p_value) title("Table 10: Participation: Impact on meetings") addnote("Results come from estimating eq. (1), with the dependent variables the participation variables shown in the first row. Data are taken from the meeting survey. Each observation is a single village meeting. Serious response is defined as agreeing to replace a supplier or village office, agreeing that money should be returned, agreeing to an internal village investigation, asking for help from district project officials, or requesting an external audit. Estimation is by OLS. Robust standard errors are in parentheses, adjusted for clustering by village.") starlevels(* 0.1 ** 0.05 *** 0.01)

	
	
******************************************************************************

** Table 11 **

******************************************************************************

* Main results from invitations and invitations plus comments
	use "jperoaddata.dta", clear
	
** Panel A. Invitations	
* Missing expenditures in roads, row 1

	est clear
	qui eststo r1c1: reg lndiffeall4 if fpm==0 & und==0
	qui eststo r1c2: reg lndiffeall4 if und==1
	qui eststo r1c2b: reg lndiffeall4 if fpm==1
	qui eststo r1c3: reg lndiffeall4 audit und fpm, vce(cluster kecnum)
	qui eststo r1c5: areg lndiffeall4 audit und fpm, cluster(kecnum) absorb(z7enumcode)
	qui eststo r1c7: areg lndiffeall4 und fpm, absorb(kecnum) r

	esttab r1c1 r1c2 r1c3 r1c5 r1c7 using table_11a1.rtf,replace se p label compress keep(und _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 11: Panel A invitations: Participation main theft results") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Missing expenditures in road and ancillary projects, row 2
	qui eststo r2c1: reg lndiffeall4mainancil if fpm==0 & und==0
	qui eststo r2c2: reg lndiffeall4mainancil if und==1
	qui eststo r2c2b: reg lndiffeall4mainancil if fpm==1
	qui eststo r2c3: reg lndiffeall4mainancil audit und fpm, vce(cluster kecnum)
	qui eststo r2c5: areg lndiffeall4mainancil audit und fpm, cluster(kecnum) absorb(z7enumcode)
	qui eststo r2c7: areg lndiffeall4mainancil und fpm, absorb(kecnum) r

	esttab r2c1 r2c2 r2c3 r2c5 r2c7 using table_11a2.rtf,replace se p label compress keep(und _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 11: Panel A invitations: Participation main theft results") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)
	
* Missing expenditures for materials in roads, row 3
	qui eststo r3c1: reg lndiffeall3mat if fpm==0 & und==0
	qui eststo r3c2: reg lndiffeall3mat if und==1
	qui eststo r3c2b: reg lndiffeall3mat if fpm==1
	qui eststo r3c3: reg lndiffeall3mat audit und fpm, vce(cluster kecnum)
	qui eststo r3c5: areg lndiffeall3mat audit und fpm, cluster(kecnum) absorb(z7enumcode)
	qui eststo r3c7:areg lndiffeall3mat und fpm, absorb(kecnum) r

	esttab r3c1 r3c2 r3c3 r3c5 r3c7 using table_11a3.rtf,replace se p label compress keep(und _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 11: Panel A invitations: Participation main theft results") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Missing expenditures in unskilled labor, row 4	
	qui eststo r4c1: reg lndiffeburuh if fpm==0 & und==0
	qui eststo r4c2: reg lndiffeburuh if und==1
	qui eststo r4c2b: reg lndiffeburuh if fpm==1
	qui eststo r4c3: reg lndiffeburuh audit und fpm, vce(cluster kecnum)
	qui eststo r4c5: areg lndiffeburuh audit und fpm, cluster(kecnum) absorb(z7enumcode)
	qui eststo r4c7: areg lndiffeburuh und fpm, absorb(kecnum) r

	esttab r4c1 r4c2 r4c3 r4c5 r4c7 using table_11a4.rtf,replace se p label compress keep(und _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 11: Panel A invitations: Participation main theft results") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)


** Panel B
* Missing expenditures in roads, row 1
	esttab r1c1 r1c2b r1c3 r1c5 r1c7 using table_11b1.rtf,replace se p label compress keep(fpm _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 11: Panel B invitations plus comments") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Missing expenditures in road and ancillary projects, row 2	
	esttab r2c1 r2c2b r2c3 r2c5 r2c7 using table_11b2.rtf,replace se p label compress keep(fpm _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 11: Panel B invitations plus comments") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Missing expenditures for materials in roads, row 3
	esttab r3c1 r3c2b r3c3 r3c5 r3c7 using table_11b3.rtf,replace se p label compress keep(fpm _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 11: Panel B invitations plus comments") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Missing expenditures in unskilled labor, row 4
	esttab r4c1 r4c2b r4c3 r4c5 r4c7 using table_11b4.rtf,replace se p label compress keep(fpm _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 11: Panel B invitations plus comments") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") addnote("See the note to table 4. Results come from estimating eq. (1), a regression of the dependent variable on a dummy for audit treatment, invitations treatment, and invitations plus comment forms treatments. Each Invitations effect and invitations plus comments effect comes from a separate regression, with the dependent variable listedin the row and the fixed effects specification listed in the column heading. Robust standard errors are in parentheses. Regressions without stratum fixed effects include a variable for audits and allow for clustering of standard errors by subdistrict.") starlevels(* 0.1 ** 0.05 *** 0.01)
est clear


*** Note: see the note below table 4 if you're confused about the commands for this table.



******************************************************************************

** Table 12 **

******************************************************************************

* Main results from invitations and invitations plus comments, while distinguishing between school distribution´/ village head distribution.

* generate interaction terms
	gen undsd = und*sd
	gen fpmsd = fpm*sd
	gen undnosd = und*!sd
	gen fpmnosd = fpm*!sd
	
	est clear

	eststo cmeanroad: reg lndiffeall4 if und==0 & fpm==0
	eststo tmeanroad: reg lndiffeall4 if undnosd==1
	eststo tmeanroad2: reg lndiffeall4 if undsd==1
	eststo tmeanroad3: reg lndiffeall4 if fpmnosd==1
	eststo tmeanroad4: reg lndiffeall4 if fpmsd==1
	eststo noferoad: reg lndiffeall4 audit undnosd undsd fpmnosd fpmsd, cluster(kecnum)
	eststo engferoad: areg lndiffeall4 audit undnosd undsd fpmnosd fpmsd, cluster(kecnum) absorb(z7enumcode)
	eststo strferoad: areg lndiffeall4 undnosd undsd fpmnosd fpmsd, absorb(kecnum) r

	eststo cmeananc: reg lndiffeall4mainancil if und==0 & fpm==0
	eststo tmeananc: reg lndiffeall4mainancil if undnosd==1
	eststo tmeananc2: reg lndiffeall4mainancil if undsd==1
	eststo tmeananc3: reg lndiffeall4mainancil if fpmnosd==1
	eststo tmeananc4: reg lndiffeall4mainancil if fpmsd==1
	eststo nofeanc: reg lndiffeall4mainancil audit undnosd undsd fpmnosd fpmsd, cluster(kecnum)
	eststo engfeanc: areg lndiffeall4mainancil audit undnosd undsd fpmnosd fpmsd, cluster(kecnum) absorb(z7enumcode)
	eststo strfeanc: areg lndiffeall4mainancil undnosd undsd fpmnosd fpmsd, absorb(kecnum) r

** Panel A: invitations
* Row 1
	esttab cmeanroad tmeanroad noferoad engferoad strferoad using table_12a1.rtf,replace se p label compress keep(undnosd _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 12: Panel A invitations: invitations distributed via neighborhood heads") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Row 2
	esttab cmeananc tmeananc nofeanc engfeanc strfeanc using table_12a2.rtf,replace se p label compress keep(undnosd _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 12: Panel A invitations: invitations distributed via neighborhood heads") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Row 3
	esttab cmeanroad tmeanroad2 noferoad engferoad strferoad using table_12a3.rtf,replace se p label compress keep(undsd _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 12: Panel A invitations: invitations distributed via schools") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Row 4
	esttab cmeananc tmeananc2 nofeanc engfeanc strfeanc using table_12a4.rtf,replace se p label compress keep(undsd _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 12: Panel A invitations: invitations distributed via schools") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)


** Panel B: invitations plus comments
* Row 1
	esttab cmeanroad tmeanroad3 noferoad engferoad strferoad using table_12b1.rtf,replace se p label compress keep(fpmnosd _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 12: Panel B invitations plus comments: invitations comments forms distributed via neighborhood heads") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Row 2
	esttab cmeananc tmeananc3 nofeanc engfeanc strfeanc using table_12b2.rtf,replace se p label compress keep(fpmnosd _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 12: Panel B invitations plus comments: invitations comments forms distributed via neighborhood heads") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Row 3
	esttab cmeanroad tmeanroad4 noferoad engferoad strferoad using table_12b3.rtf,replace se p label compress keep(fpmsd _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 12: Panel B invitations plus comments: invitations comments forms distributed via neighborhood heads") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") starlevels(* 0.1 ** 0.05 *** 0.01)

* Row 4
	esttab cmeananc tmeananc4 nofeanc engfeanc strfeanc using table_12b4.rtf,replace se p label compress keep(fpmsd _cons) cells(b(star fmt(3)) se(par fmt(3)) p(fmt(3))) title("Table 12: Panel B invitations plus comments: invitations comments forms distributed via neighborhood heads") mtitles("Control mean" "Treatment mean" "Treatment effect" "Treatment effect" "Treatment effect") addnote("See the note to table 11. Treatment effects and p-values are computed from a regression of the dependent variable on a dummy for audit treatment and four dummies for the participation treatments interacted with distribution mechanism. Percent missing equals log reported value - log actual value.") starlevels(* 0.1 ** 0.05 *** 0.01)
	est clear



******************************************************************************
	
** Extension 1 - Nepotism with bottom-up monitoring **

******************************************************************************

******************************************************	
** Table 14 - nepotism for participation monitoring **
******************************************************

	use "jpehouseholddata.dta", clear

	
** with two separate bottom-up variables
	gen undknowsfamilygovt = und*zknowsfamilygovt
	gen undknowsfamilyH = und*zknowsfamilyH
		
	gen fpmknowsfamilygovt = fpm*zknowsfamilygovt
	gen fpmknowsfamilyH = fpm*zknowsfamilyH
	
	est clear
	eststo m1: areg zhhworkedwageanyhh audit und fpm zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita undknowsfamilygovt zage zfemale zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm
	
	eststo m2: areg zhhworkedwageanyhh audit und fpm zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita undknowsfamilyH zage zfemale zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm

	eststo m3: areg zhhworkedwageanyhh audit und fpm zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita fpmknowsfamilygovt zage zfemale zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm
	
	eststo m4: areg zhhworkedwageanyhh audit und fpm zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita fpmknowsfamilyH zage zfemale zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm
	
	esttab m1 m2 m3 m4 using table14.rtf, replace se label nomtitles cells(b(star fmt(3)) se(par fmt(3))) keep(und fpm zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita undknowsfamilygovt undknowsfamilyH fpmknowsfamilygovt fpmknowsfamilyH) stats(N r2 ymean, fmt(a3 2) labels("Observations" "R-squared" "Mean dependent variable")) title("Table 14: Nepotism with grassroot monitoring") addnote("Data are taken from the household survey. Each observation represents one household. Results come from estimating eq. (3), where the dependent variable is a dummy for whether a household member worked on the road project. Estimation is done by OLS with stratum fixed effects. Robust standard errors are in parentheses, adjusted for clustering at subdistrict level. All specifications include controls for audit form treatments, age and gender of respondent, mean adult education in the household, predicted household income, and dummies for type of household sampled.") starlevels(* 0.1 ** 0.05 *** 0.01)
	
*********************************************************************
** Table 15 - Nepotism for participation monitoring, one combined variable for monitoring
*********************************************************************

** create the combined bottom-up monitoring variable, that is interacted with Village head and also Project head family member
	gen undfpmknowsfamilygovt = undfpm*zknowsfamilygovt
	gen undfpmknowsfamilyH = undfpm*zknowsfamilyH
	
	est clear
	eststo undfpm1: areg zhhworkedwageanyhh audit undfpm zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita undfpmknowsfamilygovt zage zfemale zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm
	
	eststo undfpm2: areg zhhworkedwageanyhh audit undfpm zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita undfpmknowsfamilyH zage zfemale zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm
	
	eststo undfpm3: areg zhhworkedwageanyhh audit undfpm zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita undfpmknowsfamilygovt undfpmknowsfamilyH zage zfemale zavgadultedyearsinhh zlhhexpcap i.zrespondtype, cluster(kecnum) absorb(auditstratnum)
	estadd ysumm
	
	esttab undfpm1 undfpm2 undfpm3 using table15.rtf, replace se label nomtitles cells(b(star fmt(3)) se(par fmt(3))) keep(undfpm zknowsfamilygovt zknowsfamilyH activitiesnumberpercapita undfpmknowsfamilygovt undfpmknowsfamilyH) stats(N r2 ymean, fmt(a3 2) labels("Observations" "R-squared" "Mean dependent variable")) title("Table 15: Nepotism with only one grassroot monitoring variable") addnote("Data are taken from the household survey. Each observation represents one household. Results come from estimating eq. (3), where the dependent variable is a dummy for whether a household member worked on the road project. Estimation is done by OLS with stratum fixed effects. Robust standard errors are in parentheses, adjusted for clustering at subdistrict level. All specifications include controls for audit form treatments, age and gender of respondent, mean adult education in the household, predicted household income, and dummies for type of household sampled.") starlevels(* 0.1 ** 0.05 *** 0.01)


	
	
	
	
	
******************************************************************************

** Extension 2 - Romano-Wolf multiple hypothesis correction **

******************************************************************************


******************************* Table 4 **************************************

	use "jperoaddata.dta", clear

	
***** Specification 1 - nofixed effects
* no controls (reported in Appendix A)
rwolf lndiffeall4 lndiffeall4mainancil lndiffeall3mat lndiffeburuh, indepvar(audit) method(regress) graph reps(1000) nodots holm cluster(kecnum)

* controlling for invitations and invitations plus comments
rwolf lndiffeall4 lndiffeall4mainancil lndiffeall3mat lndiffeburuh, indepvar(audit) method(regress) controls(und fpm) graph reps(1000) nodots holm cluster(kecnum)

* using 3 independent variables, no controls (reported in Appendix A)
rwolf lndiffeall4 lndiffeall4mainancil lndiffeall3mat lndiffeburuh, indepvar(audit und fpm) method(regress) graph reps(1000) nodots holm cluster(kecnum)


***** Specification 2 - engineer fixed effects
* no controls (reported in Appendix A)
rwolf lndiffeall4 lndiffeall4mainancil lndiffeall3mat lndiffeburuh, indepvar(audit) method(areg) graph reps(1000) nodots holm cluster(kecnum) absorb(z7enumcode) 

* controlling for invitations and invitations plus comments
rwolf lndiffeall4 lndiffeall4mainancil lndiffeall3mat lndiffeburuh, indepvar(audit) method(areg) controls(und fpm) graph reps(1000) nodots holm cluster(kecnum) absorb(z7enumcode) 

* using 3 independent variables, no controls (reported in Appendix A)
rwolf lndiffeall4 lndiffeall4mainancil lndiffeall3mat lndiffeburuh, indepvar(audit und fpm) method(areg) graph reps(1000) nodots holm cluster(kecnum) absorb(z7enumcode) 
