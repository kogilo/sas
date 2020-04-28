
**************************************
** Exploring Data with Procedures ****
***************************************

* After you access data, the next step is to make ssure that 
* you understand it.
* You can use " PROC CONTENTS" to see the description portion of the table.
    * - PRINT
    * - MEANS
    * - UNIVARIATE
    * - FREQ
* ***************************
*** Activity 3.01 ***********
*****************************
* 1. Learning how to find answers in the SAS documentation is important for you as a programmer. Try it now.

        * 1. Go to support.sas.com/documentation. Click 9.4 after SAS Procedures by Name and Product.
        * 2. Look up the syntax for PROC PRINT (the PRINT Procedure). 
        * 3. Which statement in PROC PRINT selects variables that appear in the report and determines their order?

    * BY 
    * VAR ~
    * ID


**********************************************
*** Demo: Exploring Data with SAS Procedures **
***********************************************
* To print the first 10 rows;

proc print data=pg1.strom_summary (obs=10);
run;

* To limit the columns at print output;
proc print data=pg1.strom_summary (obs=10);
        var Season Name Basin MaxWindMPH MinPressure StartDate Enddate;
run;

* place the cursor after var and go to the table and select the columns name
* and drag and drop them.;

* we see that there are some missing values
* To compute the summary statistics;

proc means data=pg1.strom_summary;
        var MaxWindMPH MinPressure;  * what you want to analyize.
run;


* exanine extreme values;

proc UNIVARIATE data=pg1.strom_summary;
        var MaxWindMPH MinPressure;  * what you want to analyize.
run;


* list unique values and frequencies ;

proc FREQ data=pg1.strom_summary;
        tables Basin Type Season;
run;



**************************************************************
*** Level 1 Practice: Exploring Data with Procedures *********
***************************************************************

* 1. If necessary, start SAS Studio. Open p103p01.sas from the practices folder and do the following:
    * 1. Complete the PROC PRINT statement to list the first 20 observations in pg1.np_summary.
    * 2. Add a VAR statement to include only the following variables: Reg, Type, ParkName, DayVisits, TentCampers, and RVCampers.
    * 3. Highlight the step and run the selected code.
* Do you observe any possible inconsistencies in the data?

***********************************************************;
*  LESSON 2, PRACTICE 1                                   *;
*    a) Complete the PROC PRINT statement to list the     *;
*       first 20 observations in PG1.NP_SUMMARY.          *;
*    b) Add a VAR statement to include only the following *;
*       variables: Reg, Type, ParkName, DayVisits,        *;
*       TentCampers, and RVCampers. Highlight the step    *;
*       and run the selected code.                        *;
*       Do you observe any possible inconsistencies in    *;
*       the data?                                         *;
*    c) Copy the PROC PRINT step and paste it at the end  *;
*       of the program. Change PRINT to MEANS and remove  *;
*       the OBS= data set option. Modify the VAR          *;
*       statement to calculate summary statistics for     *;
*       DayVisits, TentCampers, and RVCampers. Highlight  *;
*       the step and run the selected code.               *;
*       What is the minimum value for tent campers? Is    *;
*       that value unexpected?                            *;
*    d) Copy the PROC MEANS step and paste it at the end  *;
*       of the program. Change MEANS to UNIVARIATE.       *;
*       Highlight the step and run the selected code.     *;
*       Are there negative values for any of the columns? *;
*    e) Copy the PROC UNIVARIATE step and paste it at the *;
*       end of the program. Change UNIVARIATE to FREQ.    *;
*       Change the VAR statement to a TABLES statement to *;
*       produce frequency tables for Reg and Type.        *;
*       Highlight the step and run the selected code.     *;
*       Are there any lowercase codes? Are there any      *;
*       codes that occur only once in the table?          *;
*    f) Add comments before each step to document the     *;
*       program. Save the program as np_validate.sas in   *;
*       the output folder.                                *;
***********************************************************;

proc print data=PG1.np_summary (obs=20);
		var Reg Type ParkName DayVisits TentCampers RVCampers;
run;


proc means data=PG1.np_summary;
		var DayVisits TentCampers RVCampers;
run;


proc UNIVARIATE data=PG1.np_summary;
		var DayVisits TentCampers RVCampers;
run;


proc freq data=PG1.np_summary;
		tables DayVisits TentCampers RVCampers;
run;


