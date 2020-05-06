

**************************************;
* Using Titles and Footnotes          *;
***************************************;

TITLE n "title-text";
FOOTNOTE n "footnote-teext";


* Eg;

title1 "Class Report";
title2 "All Students";
footnote1 "Report Generated on 01SEP2018";


proc print data=pg1.class_birthdate;
run;


* To Clears titles and footnotes;

TITLE;
FOOTNOTE;

title; footnote;
proc means data=sashelp.heart;
    var height weight;
run; 



title; footnote;
ods noproctitle;
proc means data=sashelp.heart;
    var height weight;
run; 

********************;
*  Activity 5.01   *;
*******************;

**************************************************;
* The first TITLE2 statement appears above the    *;
* PROC MEANS report. The second TITLE2 statement   *;
* replaces the first TITLE2 statement for the PROC  *;
* FREQ report;

title "Storm Analysis";
title2 "Summary Statistics for MaxWind and MinPressure";
proc means data=pg1.storm_final;
   var MaxWindMPH MinPressure;
run;
title2 "Frequency Report for Basin";
proc freq data=pg1.storm_final;
   tables BasinName;
run; 



**********************************************************;
* Using Macro Variables and Functions in Titles          *;
* and Footnotes;                                         *;
**********************************************************;


Macro Variables
     %   &

TITLE<n> "title-text";

* Eg;

%let age=13;
title1 "Class Report";
title2 "Age=&age";
footnote1 "School Use Only";

proc proc data=pg1.class_birthdate;
    where age=&age;
run;

title;
footnote;

**********************************;
* Activity 5.02                  *;
**********************************;

%let oc=Atlantic;
ods noproctitle;
title 'Storm Analysis';
title2 "&oc Ocean";

proc means data=pg1.storm_final;
     where Ocean="&oc";
     var MaxWindMPH MinPressure;
run;

ods proctitle;
title;

*******************************************;
*   Applying Temporary Labels to Columns  *;
*******************************************;
proc means data=sashelp.cars; 
    where type = "Sedan";
    var MSRP MPG_Highway;
run;




LABEL co-name="label-text";
proc means data=sashelp.cars;
    where type="Sedan";
    var MSRP MPG_Highway;
    label MSRP="Manufacturer Suggested Retail Price"
            MPG_Highway="Highway Miles per Gallon";
run;


*******************************;
* Segmenting Reports          *;
******************************;

BY Variable(s);

* To do;
    * sort data first using same BY-column;
proc sort data=sashelp.cars
        out=cars_sort;
    by Origin;
run;

proc freq data=cars_sort;
    by Origin;
    tables type;
run; 


**********************************************;
*  Demo: Enhancing Reports                   *;
**********************************************;
***********************************************************;
*  Enhancing Reports                                      *; 
***********************************************************;
*  Syntax and Example                                     *;
*                                                         *;
*    TITLEn "title-text";                                 *;
*    FOOTNOTEn "footnote-text";                           *;
*		                                                  *;
*    LABEL col-name="label-text"                          *;
*          col-name="label-text";                         *;
*                                                         *;
*    Grouped Reports (sort first):                        *;
*    PROC procedure-name;                                 *;
*        BY col-name;                                     *; 
*    RUN;                                                 *;
***********************************************************;

***********************************************************;
*  Demo                                                   *;
*    1) Add a PROC SORT step before PROC PRINT to sort    *;
*       PG1.STORM_FINAL by BasinName and descending       *;
*       MaxWindMPH. Create a temporary table named        *;
*       STORM_SORT. Filter the rows to include only       *;
*       MaxWindMPH>156.                                   *;
*    2) Modify the PROC PRINT step to read the STORM_SORT *;
*       table and group the report by BasinName.          *;
*    3) Add the following title: Category 5 Storms. Clear *;
*       the title for future results.                     *;
*    4) Add labels for the following columns and ensure   *;
*       that PROC PRINT displays the labels:              *;
*       MaxWindMPH => Max Wind (MPH)                      *;
*       MinPressure => Min Pressure                       *;
*       StartDate => Start Date                           *;
*       StormLength => Length of Storm (days)             *;
*    5) Add the NOOBS option in the PROC PRINT statement  *;
*       to suppress the OBS column. Highlight the demo    *;
*       program and run the selected code.                *;
***********************************************************;

proc sort data=pg1.storm_final out=storm_sort;
    by BasinName descending MaxWindMPH;
    where MaxWindMPH > 156;
run;

title "Category 5 Storms";
proc print data=pg1.storm_sort label noobs;
	var Season Name MaxWindMPH MinPressure StartDate StormLength;
    by BasinName;
    label MaxWindMPH="Max Wind (MPH)"
          MinPressure="Min Pressure"
          StartDate="Start Date"
          StormLength="Length of Storm (days)";
run;

title;



******************************************;
* Applying Permanent Labels to Columns   *;
******************************************;

data cars_update;
    set sashelp.cars;
    keep Make Model Type MSRP AvgMPG;
    AvgMPG=mean(MPG_Highway, MPG_City);
    label MSRP="Manufacturer Suggested Retail Price"
         AvgMPG="Average Miles per Gallon";
run;

proc contents data=cars_update;
run;



**************************************;
*   Activity 5.03                    *;
**************************************;

* Open p105a04.sas from the activities folder and perform the following tasks:

    * Modify the LABEL statement in the DATA step to label the Invoice column as Invoice Price.
    * Run the program. Notice that the labels appear in the PROC MEANS report but not in the PROC PRINT report.
    * What option do you need to add to display labels in the PROC PRINT report?;


***********************************************************;
*  Activity 5.04                                          *;
*    1) Modify the LABEL statement in the DATA step to    *;
*       label the Invoice column as Invoice Price.        *;
*    2) Run the program. Why do the labels appear in the  *;
*       PROC MEANS report but not in the PROC PRINT       *;
*       report? Fix the program and run it again.         *;
***********************************************************;

data cars_update;
    set sashelp.cars;
	keep Make Model MSRP Invoice AvgMPG;
	AvgMPG=mean(MPG_Highway, MPG_City);
	label MSRP="Manufacturer Suggested Retail Price"
          AvgMPG="Average Miles per Gallon"
          Invoice="Invoice Price";
run;

proc means data=cars_update min mean max;
    var MSRP Invoice;
run;

proc print data=cars_update label;
    var Make Model MSRP Invoice AvgMPG;
run;




*************************************************;
* Demo: Creating Frequency Reports and Graphs   *;
*************************************************;

proc freq data=sashelp.heart;
    tables Chol_Status;
run;



proc freq data=sashelp.heart <proc option>;
    tables Chol_Status / option;
run; 




* DEMO;
proc freq data=pg1.storm_final;
	tables BasinName Season;
run;


proc freq data=pg1.storm_final order=freq nlevels;
	tables BasinName Season;
run;



proc freq data=pg1.storm_final order=freq nlevels;
	tables BasinName Season / nocum;
run;



proc freq data=pg1.storm_final order=freq nlevels;
	tables BasinName Season StartDate / nocum;
run;


proc freq data=pg1.storm_final order=freq nlevels;
	tables BasinName Season StartDate / nocum;
    format StartDate monname.;
run;



ods graphics on;
proc freq data=pg1.storm_final order=freq nlevels;
	tables BasinName StartDate / nocum plots=freqplot(orient=horizontal scale=percent);
    format StartDate monname.;
run;



ods graphics on;
ods noproctitle;
title "Frequency Retail for Basin and Storm Month";
proc freq data=pg1.storm_final order=freq nlevels;
	tables BasinName StartDate / nocum plots=freqplot(orient=horizontal scale=percent);
    format StartDate monname.;
    label BasinName="Basin"
    StartDate="Storm Month";
run;
title;


*********************************;
*     Activity 5.04             *;
*********************************;

* 1. Create an output table named storm_count by completing the OUT= option in the TABLES statement.
* 2. Run the program.;
* Which data values are included in the output table, and which statistics are calculated?;

***********************************************************;
*  Activity 5.05                                          *;
*    1) Create an output table named STORM_COUNT by       *;
*       completing the OUT= option in the TABLES          *;
*       statement.                                        *;
*    2) Run the program. Which data values are included   *;
*       in the output table? Which statistics are         *;
*       included?                                         *;
*    3) Put StartDate and BasinName in separate TABLES    *;
*       statements. Add the OUT= option in each           *;
*       statement, and name the tables MONTH_COUNT and    *;
*       BASIN_COUNT.                                      *;
*    4) Run the program and examine the two tables. Which *;
*       month has the highest number of storms?           *;
***********************************************************;


title "Frequency Report for Basin and Storm Month";

proc freq data=pg1.storm_final order=freq noprint;
    tables StartDate / out=month_count;
    tables BasinName / out=basin_count;
    format StartDate monname.;
run;


********************************************;
* Demo: Creating Two-Way Frequency Reports *;
********************************************;

PROC FREQ DATA = input-table <option>;
    TABLES col-name*col-name </option>;
run; 


* Eg;

proc freq data=sashelp.heart;
    tables BP_Status*Chol_Status;
run;



***********************************************************;
*  Demo (Highlight the PROC FREQ step and run             *;
*        the selected code after each step.)              *;
*    1) Highlight the PROC FREQ step, run the selected    *;
*       code, and examine the default results.            *;
*    2) Add the NOPERCENT, NOROW, and NOCOL options in    *;
*       the TABLES statement.                             *;
*    3) Delete the options in the TABLES statement and    *;
*       add the CROSSLIST option.                         *;
*    4) Change the CROSSLIST option to the LIST option in *;
*       the TABLES statement.                             *;
*    5) Delete the previous options and add               *;
*       OUT=STORMCOUNTS. Add NOPRINT to the PROC FREQ     *;
*       statement to suppress the report.                 *;
***********************************************************;


proc freq data=pg1.storm_final;
	tables BasinName*StartDate;
	format StartDate monname.;
	label BasinName="Basin"
		  StartDate="Storm Month";
run;


proc freq data=pg1.storm_final;
	tables BasinName*StartDate / norow nocol NOPERCENT;
	format StartDate monname.;
	label BasinName="Basin"
		  StartDate="Storm Month";
run;


* CROSSLIST;

proc freq data=pg1.storm_final;
	tables BasinName*StartDate / CROSSLIST;
	format StartDate monname.;
	label BasinName="Basin"
		  StartDate="Storm Month";
run;


* LIST;

proc freq data=pg1.storm_final;
	tables BasinName*StartDate / LIST;
	format StartDate monname.;
	label BasinName="Basin"
		  StartDate="Storm Month";
run;


* output tablees and no result b/c noprint;

proc freq data=pg1.storm_final noprint;
	tables BasinName*StartDate / out=stromcounts;
	format StartDate monname.;
	label BasinName="Basin"
		  StartDate="Storm Month";
run;



********************************************************;
* Level 1 Practice: Creating One-Way Frequency Reports  *;
* Write a PROC FREQ step to analyze rows from pg1.np_species as follows:

Use the TABLES statement to generate a frequency table for Category.
Use the NOCUM option to suppress the cumulative columns.
Use the ORDER=FREQ option in the PROC FREQ statement to sort the results by descending frequency.
Use Categories of Reported Species as the report title.
Submit the program and review the results.
What percent of the species are Fungi? Note: For your answer, type exactly what you see for the column value.
*********************************************************;


title1 "Categories of Reported Species";
proc freq data=pg1.np_species order=freq;
    tables Category / nocum;
run;


ods graphics on;
ods noproctitle;
title1 "Categories of Reported Species";
title2 "in the Everglades";
proc freq data=pg1.np_species order=freq;
    tables Category / nocum plots=freqplot;
    where Species_ID like "EVER%" and 
          Category ne "Vascular Plant";
run;
title;


***************************************************************;
* Level 2 Practice: Creating Two-Way Frequency Reports        *;
***************************************************************

The pg1.np_codelookup table is primarily used to look up a park name or park code. 
However, the table also includes columns for the park type and park region. Use this table to analyze the frequency of park types by the various regions. If necessary, start SAS Studio before you begin.

Reminder: If you restarted your SAS session, you must run the libname.sas program in the EPG194 folder.

* Open a new program window and write a PROC FREQ step to analyze rows from pg1.np_codelookup.
* Generate a two-way frequency table for Type by Region.
* Exclude any park type that contains the word Other.
* The levels with the most rows should come first in the order.
* Suppress the display of column percentages.
* Use Park Types by Region as the report title.
* Submit the program and review the results.
* What are the top three park types based on total frequency count?;

title1 'Park Types by Region';
proc freq data=pg1.np_codelookup order=freq;
    tables Type*Region / nocol;
    where Type not like '%Other%';
run;




title1 'Selected Park Types by Region';
ods graphics on;
proc freq data=pg1.np_codelookup order=freq;
    tables Type*Region /  nocol crosslist 
           plots=freqplot(groupby=row scale=grouppercent orient=horizontal);
    where Type in ('National Historic Site', 'National Monument', 'National Park');
run;
title;




*************************************************;
* Demo: Creating a Summary Statistics Report    *;
*************************************************;


PROC MEANS DATA = input-table <stat-list>;
    VAR col-name(s);
    CLASS col-name(s);
    WAYS n;
run;


*run;
proc means data=pg1.storm_final;
    var MaxWindMPH;
run;


* chabge the order;


proc means data=pg1.storm_final mean median min max maxdec=0;
    var MaxWindMPH;
run;


* to calculate values within groups;


proc means data=pg1.storm_final mean median min max maxdec=0;
    var MaxWindMPH;
    class BasinName ;
run;



proc means data=pg1.storm_final mean median min max maxdec=0;
    var MaxWindMPH;
    class BasinName StromType;
run;


* with ways;

proc means data=pg1.storm_final mean median min max maxdec=0;
    var MaxWindMPH;
    class BasinName StromType;
    ways 1;
run;


proc means data=pg1.storm_final mean median min max maxdec=0;
    var MaxWindMPH;
    class BasinName StromType;
    ways 0 1 2;
run;



***********************************************************;
*  Activity 5.06                                          *;
*    1) Add options to include N (count), MEAN, and MIN   *;
*       statistics. Round each statistic to the nearest   *;
*       integer.                                          *;
*    2) Add a CLASS statement to group the data by Season *;
*       and Ocean. Run the program.                       *;
*    3) Modify the program to add the WAYS statement so   *;
*       that separate reports are created for Season and  *;
*       Ocean statistics. Run the program.                *;
*       Which ocean had the lowest mean for minimum       *;
*       pressure?                                         *;
*       Which season had the lowest mean for minimum      *;
*       pressure?                                         *;
***********************************************************;


proc means data=pg1.storm_final maxdec=0 n mean min;
    var MinPressure;
    where Season >=2010;
    class Season Ocean;
    ways 1;
run;

******************************************;
* Creating an Output Summary Table       *;
******************************************;

OUTPUT OUT=output-table <statistic=col-name>;

proc means data=sashelp.heart noprint;
    var Weight;
    class Chol_Status;
    ways 1;
    output out=heart_stats mean=AvgWeight;
run; 




proc means data=pg1.storm_final noprint;
    var MaxWindMPH;
    class BasinName;
    ways 1;
    output out=wind_stats mean=AvgWind max=MaxWind;
run;

* Level 1 Practice: Producing a Descriptive Statistics Report



* The pg1.np_westweather table contains weather-related information for four national parks: Death Valley National Park, Grand Canyon National Park, Yellowstone National Park, and Zion National Park. Use the MEANS procedure to analyze the data in this table.

* Reminder: If you restarted your SAS session, you must run the libname.sas program in the EPG194 folder.

* Create a new program. Write a PROC MEANS step to analyze rows from pg1.np_westweather with the following specifications:

* Generate the mean, minimum, and maximum statistics for the Precip, Snow, TempMin, and TempMax columns.
* Use the MAXDEC= option to display the values with a maximum of two decimal positions.
* Use the CLASS statement to group the data by Year and Name.
* Use Weather Statistics by Year and Park as the report title.
* Submit the program and review the results.
* What is the mean TempMin in DEATH VALLEY, CA US in 2016?

title "Weather Statistics by Year and Park";


title1 'Weather Statistics by Year and Park';
proc means data=pg1.np_westweather mean min max maxdec=2;
    var Precip Snow TempMin TempMax;
    class Year Name;
run;



title1 'Weather Statistics by Year and Park';
proc means data=pg1.np_westweather mean min max maxdec=2;
    var Name Year;
    class Year Name;
    where Precip ne 0;
run;






































































