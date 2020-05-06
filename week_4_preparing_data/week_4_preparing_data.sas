
********************************************************
** Using the DATA Step to Create a SAS Data Set *****
*****************************************************

* From existing you create a new data;

DATA output-table;
    SET input-table;
RUN;


* SET input-table --- is the existing table

* if the output-table exist, it will overwrite it;


* Ex. To create myclass new table from class table in the sashelp library;

data myclass;
    set sashelp.class;
run; 

* myclass is the exact copy of class table;


****************************************************
** Question 4.01     *******************************
****************************************************

* 1. Which DATA step creates a permanent output data set?;
 ~~~~~;
data out.storm_new;
    set pg1.storm_summary;
run;


* No;
data out.storm_new;
    set pg1.storm_summary;
run;

* N0;
data out.storm_new;
    set pg1.storm_summary;
run;


**************************************************
**** DATA Step Processing       *****************
*************************************************;

* When you run a data step, there are 2 phases:
* 1. Compilation
    * - Check syntax for errors
    * - identify column attributes
    * - Establish new table metadata

* 2. Execution
    * Read and write data
    * Perform data manipulations, calculations, and so on.
    * it is like loop.
        * 1. Read a row from the input table
        * 2. Sequebtially process statements
        * 3. At RUN, write the row to the output table.
        * 4. Loop back to the top and read the next row from the input table.;

        data myclass;
            set sashelp.class
            ...other statements...
        run;

****************************************
** Question 4.02
******************************************

* 1. Which data sources can be referenced by using a library in the SET statement? Select all that apply.
    * SAS tables ~
    * comma-delimited files
    * Excel spreadsheets ~


*******************************************
** Demo: Working with the DATA Step 
**************************************;
DATA output-table;
    SET input-table;
    WHERE expression;
RUN;


data myclass;
    set sashelp.class;
    where Age >= 15;
run; 

* DROP col-name <col-name>;
* KEEP col-name <col-name>;

data myclass;
    set sashelp.class;
    where Age >= 15;
    KEEP Name Age Height;
run; 


data myclass;
    set sashelp.class;
    where Age >= 15;
    * KEEP Name Age Height;
    DROP Sex Weight;
run; 



DATA output-table;
   SET input-table;
    FORMAT col-name format; ---permanently assign a format to acolumn
run;



data myclass;
    set sashelp.class;
    format Height 4.1 Weight 3.;
run; 


**********************
** Activity 4.03 ******
***********************

* 1. Write a DATA step that reads the pg1.storm_summary table and creates 
* an output table named Storm_cat5 as a permanent table in the EPG194/output folder.

* 2. Include only Category 5 storms (MaxWindMPH greater than or equal to 156) with StartDate on or after 01JAN2000.

* 3. Add a statement to include the following columns in the output data: Season, Basin, Name, Type, and MaxWindMPH.

How many Category 5 storms have there been since January 1, 2000? Note: Type a number for your answer.;

libname out "path-to-EPG194/output";
data out.storm_cat5;
    set pg1.storm_summary;
    where StartDate>="01jan2000"d and MaxWindMPH>=156; 
    keep Season Basin Name Type MaxWindMPH; 
run;


*****************************************************
* Level 1 Practice: Creating a SAS Table
****************************************************

* The pg1.eu_occ SAS table contains monthly occupancy rates for European 
    * countries from January 2004 through September 2017. If necessary, start SAS Studio before you begin.

* Reminder: If you restarted your SAS session, you must run the libname.sas program 
* in the EPG194 folder to define the PG1 library.

***********************************************************;
*  LESSON 4, PRACTICE 1                                   *;
*    a) Open the PG1.EU_OCC table and examine the column  *;
*       names and values.                                 *;
*    b) Modify the code to create a temporary table named *;
*       EU_OCC2016 and read PG1.EU_OCC.                   *;
*    c) Complete the WHERE statement to select only the   *;
*       stays that were reported in 2016. Notice that     *;
*       YearMon is a character column and the first four  *;
*       positions represent the year.                     *;
*    d) Complete the FORMAT statement in the DATA step to *;
*       apply the COMMA17. format to the Hotel,           *;
*       ShortStay, and Camp columns.                      *;
*    e) Complete the DROP statement to exclude Geo from   *;
*       the output table.                                 *;
***********************************************************;

data EU_OCC2016 ;
	set PG1.EU_OCC ;
	where YearMon >=2016M01.d and YearMon<="2016M12"d;
	format Hotel ShortStay Camp COMMA17. ;
	drop Geo;

run;


* Correction ;

data eu_occ2016;
    set pg1.eu_occ;
    where YearMon like "2016%";
    format Hotel ShortStay Camp comma17.;
    drop geo;
run;




*************************************************
* Level 2 Practice: Subsetting by Multiple 
* Conditions and Creating a Sorted SAS Table
****************************************************;

* The np_species table includes one row for each species that is found in each national park. If necessary, start SAS Studio before you begin.

* Reminder: If you restarted your SAS session, you must run the libname.sas program in the EPG194 folder.

* Open a new program window and write a DATA step to read the pg1.np_species table and create a new permanent table named fox. Write the new table to the EPG194/output folder.
* Include only the rows where Category is Mammal and Common_Names includes Fox.
* Exclude the Category, Record_Status, Occurrence, and Nativeness columns from the output data.
* Submit the program.
* Notice that Fox Squirrels are included in the output table. Add a condition in the WHERE statement to exclude rows that include Squirrel.
* Submit the program and verify the results.
* Sort the fox table by Common_Names.
* What is the value of Common_Names in row one?;

    
libname out "/home/u48576857/EPG194/output";

data out.fox;
    set pg1.np_species;
    where Category='Mammal' and Common_Names like '%Fox%' 
        and Common_Names not like '%Squirrel%';    
    drop Category Record_Status Occurrence Nativeness;
run;

proc sort data=out.fox;
    by Common_Names;
run;
***********************************************
** Demo: Using Expressions to Create New Columns
*************************************************;

DATA output-table;
    SET input-table;
run;

* To create New column;

DATA output-table;
    SET input-table;
    new-column = expression;
run;

* Ex;

data cars_new;
    set sashelp ne "USA";
    Profit = MSRP - Invoice;
    Source = "Non-US Cars";
    format Profit dollar10.;
    keep Make Model MSRP Invoice Profit Source;
run;

***********************************************************;
*  Demo                                                   *;
*    1) Add an assignment statement to convert Basin to   *;
*       all uppercase letters using the UPCASE function.  *;
*    2) Add an assignment statement to convert Name to    *;
*       proper case using the PROPCASE function.          *;
*    3) Add an assignment statement to create Hemisphere, *;
*       which concatenates Hem_NS and Hem_EW using the    *;
*       CATS function.                                    *;
*    4) Add an assignment statement to create Ocean,      *;
*       which extracts the second letter of Basin using   *;
*       the SUBSTR function. Highlight the DATA step and  *;
*       run the selected code.                            *;
***********************************************************;

data storm_new;
	set pg1.storm_summary;
	drop Type Hem_EW Hem_NS MinPressure Lat Lon;
	*Add assignment statements;
    MaxWindKM=MaxWindMPH*1.60934;
    format MaxWindKM 3.;
    StormType = "Tropical Storm";
run;


***********************************************************;
*    Activity 4.04                                        *;
* Open p104a04.sas from the activities folder and perform *;
* the following tasks:                                    *;
* 1. Add an assignment statement to create StormLength    *;
*    that represents the number of days between           *;
*    StartDate and EndDate.                               *;
* 2.  Run the program.                                    *;
* In 1980, how many days did the storm named Agatha       *;
*  last? Note: Type a number for your answer.             *;
***********************************************************;


***********************************************************;
*  LESSON 4, PRACTICE 4                                   *;
*    a) Create a new column named SqMiles by multiplying  *;
*       Acres by .0015625.                                *;
*    b) Create a new column named Camping as the sum of   *;
*       OtherCamping, TentCampers, RVCampers, and         *;
*       BackcountryCampers.                               *;
*    c) Format SqMiles and Camping to include commas and  *;
*       zero decimal places.                              *;
*    d) Modify the KEEP statement to include the new      *;
*       columns. Run the program.                         *;
***********************************************************;

data np_summary_update;
	set pg1.np_summary;
	keep Reg ParkName DayVisits OtherLodging Acres SqMiles Camping;	
	*Add assignment statements;
	SqMiles = Acres *.0015625;
	Camping = OtherCamping + TentCampers + RVCampers + BackcountryCampers;
	format SqMiles comma.;
	
run;

* In 1980, how many days did the storm named Agatha       *;
*  last? Note: Type a number for your answer. ;

data storm_length;
     set pg1.storm_summary;
     drop Hem_EW Hem_NS lat lon;
     StormLength = EndDate-StartDate;
run;

*      6 ;

************************************************;
* Using Numeric Functions to Create Columns    *;
************************************************;

f(.) -- function(argument1, argument2,...);

* Function can be use in assignment statement ;

DATA output-table;
    SET input-table;
    new-column = function(arguments);
run;

* see more on documentation;


* Common Numeric Functions     What it Does;
SUM (num1, num2, ...)	       Returns the sum of nonmissing arguments.
MEAN (num1, num2, ...)	       Returns the arithmetic mean (average) of nonmissing arguments.
MEDIAN (num1, num2, ...)	   Returns the median value of nonmissing arguments.
RANGE (num1, num2, ...)	       Returns the range of the nonmissing values.
MIN (num1, num2, ...)	       Returns the smallest nonmissing value from a list of arguments.
MAX (num1, num2, ...)	       Returns the largest value from a list of arguments.
N (num1, num2, ...)	           Returns the number of nonmissing numeric values.
NMISS (num1, num2, ...)	       Returns the number of null and SAS missing numeric values.



***********************************************************;
*  Activity 4.05                                          *;
*    1) Open the PG1.STORM_RANGE table and examine the    *;
*       columns. Notice that each storm has four wind     *;
*       speed measurements.                               *;
*    2) Create a new column named WindAvg that is the     *;
*       mean of Wind1, Wind2, Wind3, and Wind4.           *;
*    3) Create a new column WindRange that is the range   *;
*       of Wind1, Wind2, Wind3, and Wind4.                *;
***********************************************************;

data storm_wingavg;
	set pg1.storm_range;
	*Add assignment statements;
    WindAvg = mean(Wind1, Wind2, Wind3, Wind4);
    WindRange = range(Wind1, Wind2, Wind3, Wind4);

run;


* What is the WindRange value in row 1?;  15



**********************************************************************;
* SAS has many functions you can use to manipulate character columns.*;
* The arguments include one or more character columns in your data.  *;
* These are a few of the many character functions you can use:       *;
**********************************************************************;

************************************************************;
* Character Function	                     What it Does;
UPCASE (char) 
LOWCASE(char)	Changes letters in a character string to uppercase or lowercase;

PROPCASE (char,<delimiters>)	  Changes the first letter of each word to uppercase and other letters to lowercase;

CATS (char1, char2, ...)	       Concatenates character strings and removes leading and trailing blanks from each argument;

SUBSTR (char, position, <length>)	Returns a substring from a character string;



* Demo: Using Character Functions


***********************************************************;
*  Demo                                                   *;
*    1) Add an assignment statement to convert Basin to   *;
*       all uppercase letters using the UPCASE function.  *;
*    2) Add an assignment statement to convert Name to    *;
*       proper case using the PROPCASE function.          *;
*    3) Add an assignment statement to create Hemisphere, *;
*       which concatenates Hem_NS and Hem_EW using the    *;
*       CATS function.                                    *;
*    4) Add an assignment statement to create Ocean,      *;
*       which extracts the second letter of Basin using   *;
*       the SUBSTR function. Highlight the DATA step and  *;
*       run the selected code.                            *;
***********************************************************;

data storm_new;
	set pg1.storm_summary;
	drop Type Hem_EW Hem_NS MinPressure Lat Lon;
	*Add assignment statements;
    Basin=upcase(Basin);
    Name = propcase(Name);
    Hemisphere=cats(Hem_NS, Hem_EW);
    Ocean=substr(Basin, 2,1);

run;

*******************************
* Activity 4.06
* Open p104a06.sas from the activities folder and perform the following tasks:

***********************************************************;
*  Activity 4.06                                          *;
*    1) Add a WHERE statement that uses the SUBSTR        *;
*       function to include rows where the second letter  *;
*       of Basin is P (Pacific ocean storms).             *;
*    2) Run the program and view the log and data. How    *;
*       many storms were in the Pacific basin?            *;
***********************************************************;

data pacific;
	set pg1.storm_summary;
	drop Type Hem_EW Hem_NS MinPressure Lat Lon;
	*Add a WHERE statement that uses the SUBSTR function;
    where 
run;



**************************************************************;
* SAS date functions are incredibly helpful for creating and manipulating SAS dates.
* These functions extract information from the SAS date column or value provided in  *;
* the argument:


* Date Function            	What it Does;
MONTH (SAS-date)	       Returns a number from 1 through 12 that represents the month;
YEAR (SAS-date)	           Returns the four-digit year;
DAY (SAS-date)             Returns a number from 1 through 31 that represents the day of the month;
WEEKDAY (SAS-date)	       Returns a number from 1 through 7 that represents the day of the week (Sunday=1);
QTR (SAS-date)	           Returns a number from 1 through 4 that represents the quarter;


* These functions enable you to create SAS date values from the arguments.;

* Date Function         	         What it Does;
TODAY ()	                         Returns the current date as a numeric SAS date value (no argument is required ;
                                     because the function reads the system clock) ;
MDY (month, day, year)	             Returns a SAS date value from numeric month, day, and year values;
YRDIF(startdate, enddate, 'AGE')	 Calculates a precise age between two dates;


* Demo: Using Date Functions;

***********************************************************;
*  Using Date Functions                                   *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*  Date function examples:                                *;
*    YEAR (SAS-date)                                      *;
*    MONTH (SAS-date)                                     *;
*    DAY (SAS-date)                                       *;
*    WEEKDAY (SAS-date)                                   *;
*    TODAY ()                                             *;
*    MDY (month, day, year)                               *;
*    YRDIF (startdate, enddate, 'AGE')                    *;
***********************************************************;

***********************************************************;
*  Demo                                                   *;
*    1) Create the column YearsPassed and use the YRDIF   *;
*       function. The difference in years should be based *;
*       on each Date value and today's date.              *;
*    2) Create Anniversary as the day and month of each   *;
*       storm in the current year.                        *;
*    3) Format YearsPassed to round the value to one      *;
*       decimal place, and Date and Anniversary as        *;
*       MM/DD/YYYY. Highlight the DATA step and run the   *;
*       selected code.                                    *;
***********************************************************;

data storm_new;
	set pg1.storm_damage;
	drop Summary;
	*Add assignment and FORMAT statements;
    YearsPassed=yrdif(Date,today(), "age");
    Anniversary=mdy(month(Date), day(Date), year(today()));
    format YearsPassed 4.1 Date Anniversary mmddyy10.;
run;


***********************************************************;
*  LESSON 4, PRACTICE 4                                   *;
*    a) Create a new column named SqMiles by multiplying  *;
*       Acres by .0015625.                                *;
*    b) Create a new column named Camping as the sum of   *;
*       OtherCamping, TentCampers, RVCampers, and         *;
*       BackcountryCampers.                               *;
*    c) Format SqMiles and Camping to include commas and  *;
*       zero decimal places.                              *;
*    d) Modify the KEEP statement to include the new      *;
*       columns. Run the program.                         *;
***********************************************************;

data np_summary_update;
	set pg1.np_summary;
	keep Reg ParkName DayVisits OtherLodging Acres;	
	*Add assignment statements;


run;



************************************************************;
* Level 2 Practice: Creating New Columns with Character    *;
*  and Date Functions                                   ****;
************************************************************;


data eu_occ_total;
    set pg1.eu_occ;
    Year=substr(YearMon,1,4);
    Month=substr(YearMon,6,2);
    ReportDate=MDY(Month,1,Year);
    Total=sum(Hotel,ShortStay,Camp);
    format Hotel ShortStay Camp Total comma17.
           ReportDate monyy7.;
    keep Country Hotel ShortStay Camp ReportDate Total;
run;
  

  ********************************************************
  * Demo: Conditional Processing with IF-THEN            *
  ********************************************************;

  IF expression1 THEN statement1;
  IF expression2 THEN statement2;


* Eg;

data cars2;
    set sashelp.cars;
    if MSRP<30000 then Cost_Group=1;
    if MSRP >30000 then Cost_Group=2;
    keep Make Model Type MSRP Cost_Group;
run;


***********************************************************;
*  Demo                                                   *;
*    1) Create a column named PressureGroup that is based *;
*       on the following assignments:                     *;
*       MinPressure<=920 => 1                             *;
*       MinPressure>920 => 0                              *;
*    2) Highlight the DATA step, run the selected code,   *;
*       and examine the data. What value is assigned      *;
*       to PressureGroup when MinPressure is missing?     *;
*    3) Add a new IF-THEN statement before the existing   *;
*       IF-THEN statements to assign PressureGroup=. if   *;
*       MinPressure is missing.                           *;
*    4) Highlight the DATA step and run the selected      *;
*       code. What value is assigned to PressureGroup?    *;
***********************************************************;

data storm_new;
	set pg1.storm_summary;
	keep Season Name Basin MinPressure PressureGroup;
	*Add IF-THEN statements;
    if MinPressure<=920 then PressureGroup=1;
    if MinPressure>920 then PressureGroup=0;
    
run;

* To account for the missing values;

data storm_new;
	set pg1.storm_summary;
	keep Season Name Basin MinPressure PressureGroup;
	*Add IF-THEN statements;
    if MinPressure=. then PressureGroup=.;
    if MinPressure<=920 then PressureGroup=1;
    if MinPressure>920 then PressureGroup=0;
    
run;


* Conditional Processing with IF-THEN/ELSE;
IF expression THEN statement;
ELSE IF expression THEN statement;
ELSE IF expression THEN statement;
ELSE statement;

SAS tests all conditions in sequence.;

data cars2;
    set sashelp.cars;
    if MSRP<20000 then Cost_Group=1;
    else if MSRP<40000 then Cost_Group=2;
    else if MSRP<60000 then Cost_Group=3;
    else Cost_Group=4;
    keep Make Model Type MSRP Cost_Group;
run;


* Compound conditions;

data cars2;
    set sashelp.Cars;
    IF MPG_City>26 and MPG_Highway>30 then Efficiency=1;
    else if MPG_City>20 and MPG_Highway>25 then Efficiency=2;
    else Efficiency=3;
    keep Make Model MPG_City MPG_Highway Efficiency;
run; 



***********************************************************;
*  LESSON 4, PRACTICE 7                                   *;
*    a) Submit the program and view the generated output. *;
*    b) In the DATA step, use IF-THEN/ELSE statements to  *;
*       create a new column, ParkType, based on the value *;
*       of Type.                                          *;
*       NM -> Monument                                    *;
*       NP -> Park                                        *;
*       NPRE, PRE, or PRESERVE -> Preserve                *;
*       NS -> Seashore                                    *;
*       RVR or RIVERWAYS -> River                         *;
*    c) Modify the PROC FREQ step to generate a frequency *;
*       report for ParkType.                              *;
***********************************************************;

data park_type;
	set pg1.np_summary;
	*Add IF-THEN-ELSE statements;
    if Type="NM" then ParkType = "Monument";
    else if Type="NP" then ParkType="Park";
    else if Type="NPRE" and Type="PRE" or Type="PRESERVE" then ParkType="Preserve";
    else if Type ="NS" then ParkType = "Seashore";
    else Type = "RVR" or Type="RIVERWAYS" then ParkType = "River";
run;

proc freq data=park_type;
	tables Type;
run;


data storm_cat;
    set pg1.storm_summary;
    keep Name Basin MinPressure StartDate PressureGroup;
    *add ELSE keyword and remove final condition;
    if MinPressure=. then PressureGroup=.;
    else if MinPressure<=920 then PressureGroup=1;
    else PressureGroup=0;
run;


***************************************************************
* Creating Character Columns with the LENGTH Statement        *;
***************************************************************;

data cars2;
    set sashelp.cars;
    if MSRP<60000 then CarType="Basic";
    else CarType="Luxury";
    keep Make Model MSSRP CarType;

run;

* With defined length;

data cars2;
    set sashelp.cars;
    length CarType $ 6;
    if MSRP<60000 then CarType="Basic";
    else CarType="Luxury";
    keep Make Model MSSRP CarType;

run;


* Activity 4.08;
data storm_summary2;
    set pg1.storm_summary;
    length Ocean $ 8;
    keep Basin Season Name MaxWindMPH Ocean;
    Basin=upcase(Basin);
    OceanCode=substr(Basin,2,1);
    if OceanCode="I" then Ocean="Indian";
    else if OceanCode="A" then Ocean="Atlantic";
    else Ocean="Pacific";
run;




****************************************************;
* Processing Multiple Statements with IF-THEN/DO   *;
***************************************************;

IF expression THEN DO;
    executable statements 
END;
ELSE IF expression THEN DO; 
    executable statements 
END;
ELSE DO;
    executable Statements 
END;



data cars2;
    set sashelp.cars;
    length Cost_Type $ 4;
    if MSRP < 20000 then Cost_Group=1 and Cost_Type="Low";
    else if MSRP<40000 then Cost_Group=2 and Cost_Type="Mid";
    else Cost_Group=3 and Cost_Type="Hight"
run;



* Create Two tables;


data under40 over40;
    set sashelp.cars;
    keep Make Model msrp cost_group;
    if MSRP<20000 then do;
        Cost_Group=1;
        output under40;
    end;
    else if MSRP<40000 then do;
        Cost_Group=2;
        output under40;
    end;
    else do;
        Cost_Group=3;
        output over40;
    end;
run;


***********************************************************;
*  Activity 4.09                                          *;
*    Run the program. Why does the program fail?          *;
***********************************************************;

data girls boys;
    set sashelp.class;
    if sex="F" then do;
		 Gender="Female";
	     output girls;
    end;
    else do;
		 Gender="Male";
		 output boys;
    end;
run;


* Demo: Processing Multiple Statements with IF-THEN/DO



***********************************************************;
*  Demo                                                   *;
*       Modify the IF-THEN statements to use IF-THEN/DO   *;
*       syntax to write rows to either the indian,        *;
*       atlantic, or pacific table based on the value of  *;
*       Ocean. Highlight the DATA step and run the        *;
*       selected code.                                    *;
***********************************************************;

data indian atlantic pacific;
	set pg1.storm_summary;
	length Ocean $ 8;
	keep Basin Season Name MaxWindMPH Ocean;
	Basin=upcase(Basin);
	OceanCode=substr(Basin,2,1);
	*Modify the program to use IF-THEN-DO syntax;
	if OceanCode="I" then do;
        Ocean="Indian" ;
        output indian;
    end;
	else if OceanCode="A" then do;
        Ocean="Atlantic";
        output atlantic;
    end;
	else do;
        Ocean="Pacific";
         output pacific;
    end;
run;



***********************************************************;
*  LESSON 4, PRACTICE 7                                   *;
*    a) Submit the program and view the generated output. *;
*    b) In the DATA step, use IF-THEN/ELSE statements to  *;
*       create a new column, ParkType, based on the value *;
*       of Type.                                          *;
*       NM -> Monument                                    *;
*       NP -> Park                                        *;
*       NPRE, PRE, or PRESERVE -> Preserve                *;
*       NS -> Seashore                                    *;
*       RVR or RIVERWAYS -> River                         *;
*    c) Modify the PROC FREQ step to generate a frequency *;
*       report for ParkType.                              *;
***********************************************************;

data park_type;
    set pg1.np_summary;
    length ParkType $ 8;
    if Type='NM' then ParkType='Monument';
    else if Type='NP' then ParkType='Park';
    else if Type in ('NPRE', 'PRE', 'PRESERVE') then
        ParkType='Preserve';
    else if Type in ('RVR', 'RIVERWAYS') then ParkType='River';
    else if Type='NS' then ParkType='Seashore';
run;

proc freq data=park_type;
    tables ParkType;
run;



* Level 2 Practice: Processing Statements Conditionally with DO Groups;
* Reminder: If you restarted your SAS session, you must run the libname.sas program in the EPG194 folder.

* Write a DATA step to create two temporary tables, named parks and monuments, that are based on the pg1.np_summary table. Read only national parks or monuments from the input table. (Type is either NP or NM.)
* Create a new column named Campers that is the sum of all columns that contain counts of campers. Format the column to include commas.
* When Type is NP, create a new column named ParkType that is equal to Park, and write the row to the parks table. When Type is NM, assign ParkType as Monument and write the row to the monuments table.
* Keep Reg, ParkName, DayVisits, OtherLodging, Campers, and ParkType in both output tables.
* Submit the program and view the output data.
* Which table has the most rows?;


data parks monuments;
    set pg1.np_summary;
    where type in ('NM', 'NP');
    Campers=sum(OtherCamping, TentCampers, RVCampers,
                BackcountryCampers);
    format Campers comma17.;
    length ParkType $ 8;
    if type='NP' then do;
        ParkType='Park';
        output parks;
    end;
    else do;
        ParkType='Monument';
        output monuments;
    end;
    keep Reg ParkName DayVisits OtherLodging Campers ParkType;
run;






