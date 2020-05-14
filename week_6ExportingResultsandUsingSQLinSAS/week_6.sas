****************************;
*   Exporting Data         *;
****************************;

PROC EXPORT DATA=input-table OUTFILE="output-file"
                <DMBS=identifier><REPLACE>;
RUN;


* <DMBS=identifier> 
    - How to format the output;
    - CSV, TAB, DLM, XLSX,...;

* Example;

proc export data=sashelp.cars 
    outfile="s:/workshop/output/cars.txt"
    dbms=tab replace;
run;



************************************************;
* Demo: Exporting Data to an Excel Workbook    *;
************************************************;

* eg;
libname myxl XLSX "&outpath/cars.xlsx";

data myxl.asiacars;
    set sashelp.cars;
    where origin="Asia";
run;

libname myxl clear;



***********************************************************;
*  Demo                                                   *;
*    1) Examine the DATA and PROC MEANS steps and         *;
*       identify the temporary SAS tables that will be    *;
*       created. Highlight the demo program and run the   *;
*       selected code.                                    *;
*    2) Add a LIBNAME statement to create a library named *;
*       xlout that points to an Excel file named          *;
*       SOUTHPACIFIC.XLSX in the OUTPUT folder of the     *;
*       course data.                                      *;
*    3) Modify the DATA and PROC steps to write output    *;
*       tables to the xlout library.                      *;
*    4) Add a LIBNAME statement to clear the xlout        *;
*       libref. Highlight the demo program and run the    *;
*       selected code.                                    *;
*    5) Open Excel if it is available. Open the           *;
*       SOUTHPACIFIC.XLSX workbook and confirm that the   *;
*       data is contained in the worksheets that are      *;
*       named South_Pacific and Season_Stats.             *;
***********************************************************;

libname xlout xlsx "&outpath/southpacific.xlsx";
data xlout.South_Pacific;
	set pg1.storm_final;
	where Basin="SP";
run;

proc means data=pg1.storm_final noprint maxdec=1;
	where Basin="SP";
	var MaxWindKM;
	class Season;
	ways 1;
	output out=xlout.Season_Stats n=Count mean=AvgMaxWindKM max=StrongestWindKM;
run;

libname xlout clear;



* Then run and download it;

***********************************************************;
*  Activity 6.03                                          *;
*    1) Complete the LIBNAME statement using the XLSX     *;
*       engine to create an Excel workbook named          *;
*       storm.xlsx in the output folder.                  *;
*    2) Modify the DATA step to write the storm_final     *;
*       table to the storm.xlsx file.                     *;
*    3) After the DATA step, write a statement to clear   *;
*       the library.                                      *;
*    4) Run the program and view the log to confirm that  *;
*       storm.xlsx was exported with 3092 rows.           *;
*    5) If possible, open the storm.xlsx file. How do     *;
*       dates appear in the storm_final workbook?         *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    OPTIONS VALIDVARNAME=V7;                             *;
*    LIBNAME libref xlsx "path/file.xlsx";                *;
*     <use libref for output table(s)>                    *;
*    LIBNAME libref CLEAR;                                *; 
***********************************************************;



libname xl_lib xlsx "&outpath/storm.xlsx";

data xl_lib.storm_final;
    set pg1.storm_final;
    drop Lat Lon Basin OceanCode;
run;

libname xl_lib clear;


********************************************;
* Using the SAS Output Delivery System     *;
********************************************;


* SAS procedure => output object => ODS destinations (XLSX, RTF, PPTX, PDF );


ODS <destination> <destination-specifications>;
/* SAS code that produce output */

ODS <destination> CLOSE;

* Ex;

ods csvall file="&outpath/cars.csv";
proc print data=sashelp.cars noobs;
    var Make Model Type MSRP MPG_City MPG_Hightway;
    format MSRP dollar8.;
run;
ods csvall close; 


*******************************************;
* Demo: Exporting Results to Excel        *;
*******************************************;

ODS EXCEL FILE="filename.xlsx" STYLE=style 
            OPTION(SHEET_NAME+'label');

/* SAS code that produce output */

ODS EXCEL CLOSE;



***********************************************************;
*  Exporting Results to Excel                             *;
***********************************************************;
*  Syntax and Example                                     *;
*                                                         *;
*    ODS EXCEL FILE="filename.xlsx" <STYLE=style>         *;
*              <OPTIONS (SHEET_NAME='label')>;            *;
*        /* SAS code that produces output */              *;
*    ODS EXCEL OPTIONS (SHEET_NAME='label');              *;
*        /* SAS code that produces output */              *;
*    ODS EXCEL CLOSE;                                     *;
***********************************************************;

***********************************************************;
*  Demo                                                   *;
*  1) Add an ODS statement to create an Excel file named  *;
*     wind.xlsx in the output folder of the course files. *;
*     Close the excel desination at the end of the        *;
*     program. Highlight the demo program and run the     *;
*     selected code.                                      *;
*  2) Open the Excel file.                                *;
*     * SAS Studio: Navigate to the output folder in the  *;
*       Files and Folders section of the navigation pane. *;
*       Select wind.xlsx click Download.                  *;
*     * Enterprise Guide: Click the Results -> Excel tab  *;
*     and click Download.                                 *;
*  3) Examine the Excel workbook. Notice the light blue   *;
*     background in the results generated by the default  *;
*     style. Also notice the default spreadsheet names.   *;
*     Close the Excel file.                               *;
*  4) Examine the available style options.                *;
*     * SAS Studio: Submit the following program:         *;
*        proc template;                                   *;
*            list styles;                                 *;
*        run;                                             *;
*     * Enterprise Guide: Select Tools -> Style Manager.  *;
*  5) Change the style by adding the STYLE=SASDOCPRINTER  *;
*     option in the first ODS statement.                  *;
*  6) Use the SHEET_NAME= option on the first ODS EXCEL   *;
*     statement to name the first worksheet Wind Stats.   *;
*     Add another ODS EXCEL statement with the SHEET_NAME=*;
*     option before the second TITLE statement and SGPLOT *;
*     step. Name the second worksheet Wind Distribution.  *;
*     Highlight the demo program and run the selected     *;
*     code. Open the Excel file to view the results.      *;
***********************************************************;

*Add ODS statement; 

title "Wind Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final min mean median max maxdec=0;
    class BasinName;
    var MaxWindMPH;
run;

title "Distribution of Maximum Wind";
proc sgplot data=pg1.storm_final;
    histogram MaxWindMPH;
    density MaxWindMPH;
run; 
title;  
ods proctitle;
*Add ODS statement;






*Add ODS statement; 
ods excel file="&outpath/wind.xlsx";
title "Wind Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final min mean median max maxdec=0;
    class BasinName;
    var MaxWindMPH;
run;

title "Distribution of Maximum Wind";
proc sgplot data=pg1.storm_final;
    histogram MaxWindMPH;
    density MaxWindMPH;
run; 
title;  
ods proctitle;
*Add ODS statement;

ods excel close;


* Add styles;

proc template;
    list styles;
run;


*Add ODS statement; 
ods excel file="&outpath/wind.xlsx" style=sasdocprinter
            options(SHEET_NAME='Wind Stats');
title "Wind Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final min mean median max maxdec=0;
    class BasinName;
    var MaxWindMPH;
run;

ods excel option(sheet_name='Wind Distribution');
title "Distribution of Maximum Wind";
proc sgplot data=pg1.storm_final;
    histogram MaxWindMPH;
    density MaxWindMPH;
run; 
title;  
ods proctitle;
*Add ODS statement;

ods excel close;




***********************************************************;
*  Activity 6.04                                          *;
*    1) Add ODS statements to create an Excel file named  *;
*       pressure.xlsx in the output folder. Be sure to    *;
*       close the ODS location at the end of the program. *;
*       Run the program and open the Excel file.          *;
*       * SAS Studio: Navigate to the output folder in    *;
*       the Files and Folders section of the navigation   *;
*       pane. Select pressure.xlsx and click Download.    *;
*       * Enterprise Guide: Click the Results - Excel tab *;
*       and click Download.                               *;
*    2) Add the STYLE=ANALYSIS option in the first ODS    *;
*       EXCEL statement. Run the program again and open   *;
*       the Excel file.                                   *;
***********************************************************;

*Add ODS statement;
ods excel file="&outpath/pressure.xlsx" style=ANALYSIS;

title "Minimum Pressure Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final mean median min maxdec=0;
    class BasinName;
    var MinPressure;
run;

title "Correlation of Minimum Pressure and Maximum Wind";
proc sgscatter data=pg1.storm_final;
	plot minpressure*maxwindmph;
run;
title;  

*Add ODS statement;

ods proctitle;

ods excel close;


*******************************************************;
* Exporting Results to PowerPoint and Microsoft Word  *;
*******************************************************;

ODS PowerPoint File="filename.pptx" Style=style;
/* SAS code that produces output*/
ODS PowerPoint Close;





ODS RTF File="filename.rtf" STARTAGE=NO;
/* SAS code that produces output*/
ODS RTF Close;






***********************************************************;
*  Activity 6.05                                          *;
*    1) Run the program and open the pressure.pptx file.  *;
*    2) Modify the ODS statements to change the output    *;
*       destination to RTF. Change the style to sapphire. *;
*    3) Run the program and open the pressure.rtf file.   *;
*    4) Add the STARTPAGE=NO option in the first ODS RTF  *;
*       statement to eliminate the page break.            *;
*    5) Rerun the program and examine the results in      *;
*       Microsoft Word.                                   *;
***********************************************************;

ods powerpoint file="&outpath/pressure.pptx" style=powerpointlight;

title "Minimum Pressure Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final mean median min maxdec=0;
    class BasinName;
    var MinPressure;
run;

title "Correlation of Minimum Pressure and Maximum Wind";
proc sgscatter data=pg1.storm_final;
	plot minpressure*maxwindmph;
run;
title;  

ods powerpoint close;


*    2) Modify the ODS statements to change the output    *;
*       destination to RTF. Change the style to sapphire. *;

ods RTF file="&outpath/pressure.rtf" style=sapphire;

title "Minimum Pressure Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final mean median min maxdec=0;
    class BasinName;
    var MinPressure;
run;

title "Correlation of Minimum Pressure and Maximum Wind";
proc sgscatter data=pg1.storm_final;
	plot minpressure*maxwindmph;
run;
title;  

ods rtf close;


*4) Add the STARTPAGE=NO option in the first ODS RTF  *;
*       statement to eliminate the page break.;




ods RTF file="&outpath/pressure.rtf" style=sapphire STARTAGE=NO;

title "Minimum Pressure Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final mean median min maxdec=0;
    class BasinName;
    var MinPressure;
run;

title "Correlation of Minimum Pressure and Maximum Wind";
proc sgscatter data=pg1.storm_final;
	plot minpressure*maxwindmph;
run;
title;  

ods rtf close;



**********************************;
* Demo: Exporting Results to PDF *;
**********************************;

ODS FILE="filename.pdf" STYLE=style
        STARTPAGE=NO PDFTOC=n;
ODS PROCLABEL 'label';
/* SAS code that produces output */
ODS PDF CLOSE; 




***********************************************************;
*  Exporting Results to PDF                               *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    ODS PDF FILE="filename.xlsx" STYLE=style             *;
*            STARTPAGE=NO PDFTOC=1;                       *;
*    ODS PROCLABEL "label";                               *;
*        /* SAS code that produces output */              *;
*    ODS PDF CLOSE;                                       *;
***********************************************************;

***********************************************************;
*  Demo                                                   *;
*    1) Run the program and open the PDF file to examine  *;
*       the results. Notice that bookmarks are created,   *;
*       and they are linked to each procedure's output.   *;
*    2) Add the STARTPAGE=NO option to eliminate page     *;
*       breaks between procedures. Add the STYLE=JOURNAL  *;
*       option.                                           *;
*    3) To customize the PDF bookmarks, add the PDFTOC=1  *;
*       option to ensure that bookmarks are expanded only *;
*       one level when the PDF is opened. To customize    *;
*       the bookmark labels, add the ODS PROCLABEL        *;
*       statement before each PROC with custom text. Run  *;
*       the program and open the PDF file.                *;
***********************************************************;

ods pdf file="&outpath/wind.pdf";
ods noproctitle;

title "Wind Statistics by Basin";
proc means data=pg1.storm_final min mean median max maxdec=0;
    class BasinName;
    var MaxWindMPH;
run;

title "Distribution of Maximum Wind";
proc sgplot data=pg1.storm_final;
    histogram MaxWindMPH;
    density MaxWindMPH;
run; 
title;  

ods pdf close;




ods pdf file="&outpath/wind.pdf" startpage=no style=journal pdftoc=1;
ods noproctitle;

ods proclabel "Wind Statistics";
title "Wind Statistics by Basin";
proc means data=pg1.storm_final min mean median max maxdec=0;
    class BasinName;
    var MaxWindMPH;
run;

ods proclabel "Wind Distribution";
title "Distribution of Maximum Wind";
proc sgplot data=pg1.storm_final;
    histogram MaxWindMPH;
    density MaxWindMPH;
run; 
title;  

ods pdf close;


*********************************************************************;
* Level 1 Practice: Creating an Excel File Using ODS EXCEL          *;
**********************************************************************;

***********************************************************;
*  LESSON 6, PRACTICE 1                                   *;
*    a) Before the PROC MEANS step, add an ODS EXCEL      *;
*       statement to do the following:                    *;
*       1) Write the output file to                       *;
*          "&outpath/StormStats.xlsx".                    *;
*       2) Set the style for the Excel file to snow.      *;
*       3) Set the sheet name for the first tab to South  *;
*          Pacific Summary.                               *;
*    b) Turn off the procedure titles and report titles   *;
*       at the start of the program. Turn the procedure   *;
*       titles on at the end of the program.              *;
*    c) Immediately before the PROC PRINT step, add an    *;
*       ODS EXCEL statement to set the sheet name to      *;
*       Detail.                                           *;
*    d) At the end of the program, add an ODS EXCEL       *;
*       statement to close the Excel destination.         *;
*    e) Submit the program. If possible, open the         *;
*       StormStats.xlsx workbook in Excel.                *;
***********************************************************;

ods excel file="&outpath/StormStats.xlsx"
    style=snow
    options(sheet_name='South Pacific Summary');
ods noproctitle;

proc means data=pg1.storm_detail maxdec=0 median max;
    class Season;
    var Wind;
    where Basin='SP' and Season in (2014,2015,2016);
run;

ods excel options(sheet_name='Detail');

proc print data=pg1.storm_detail noobs;
    where Basin='SP' and Season in (2014,2015,2016);
    by Season;
run;

ods excel close;
ods proctitle;


***********************************************************;
*  LESSON 6, PRACTICE 2                                   *;
*    a) Modify the program to write the output file to    *;
*       &outpath/ParkReport.rtf. Set the style for the    *;
*       output file to Journal and remove page breaks     *;
*       between procedure results. Suppress the printing  *;
*       of procedure titles.                              *;
*    b) Run the program. Open the output file in          *;
*       Microsoft Word. Notice that the Journal style is  *;
*       applied to the results, but the graph is now gray *;
*       scale instead of color. Also notice that the date *;
*       and time the program ran is printed in the upper  *;
*       right corner of the page. Close Microsoft Word.   *;
*    c) Modify your SAS program so that both tables are   *;
*       created using the Journal style, but the graph is *;
*       created using the SASDOCPRINTER style.            *;
*    d) Add an OPTIONS statement with the NODATE option   *;
*       at the beginning of the program to suppress the   *;
*       date and time in the RTF file. Restore the option *;
*       for future submissions by adding an OPTIONS       *;
*       statement with the DATE option at the end of the  *;
*       program.                                          *;
*    e) Run the program. Open the new output file using   *;
*       Microsoft Word. Ensure that the style for both    *;
*       tables is the same, but that the graph is now     *;
*       displayed in color. Close the report.             *;
***********************************************************;

ods rtf file="&outpath/ParkReport.rtf" style=Journal startpage=no;

ods noproctitle;
options nodate;

title "US National Park Regional Usage Summary";

proc freq data=pg1.np_final;
    tables Region /nocum;
run;

proc means data=pg1.np_final mean median max nonobs maxdec=0;
    class Region;
    var DayVisits Campers;
run;

ods rtf style=SASDocPrinter;

title2 'Day Vists vs. Camping';
proc sgplot data=pg1.np_final;
    vbar  Region / response=DayVisits;
    vline Region / response=Campers;
run;
title;

ods proctitle;
ods rtf close;
options date;




***********************;
*    SQL and SAS      *;
**********************;

* Structured Query Language use:;
    * Prepare data;
    * Aanalyze and report on data;


***********************;
* PROC SQL Syntax    *;
*********************;

PROC SQL;
SELECT clause 
    FROM clause 
        WHERE clause
            ORDER BY clause;
QUIT;



PROC SQL;
SELECT col-name, col-name
    FROM input-table;
QUIT;


proc sql;
select Name, Age, Height, Birthdate format=date9.
    from pg1.class_birthdate;
quit; 





proc sql;
select Name, Age, Height*2.54 as HeightCM format=5.1, Birthdate format=date9.
    from pg1.class_birthdate;
quit; 



***********************************************************;
*  Activity 7.01                                          *;
*    1) What are the similarities and differences in the  *;
*       syntax of the two steps?                          *;
*    2) Run the program. What are the similarities and    *;
*       differences in the results?                       *;
***********************************************************;

title "PROC PRINT Output";
proc print data=pg1.class_birthdate;
	var Name Age Height Birthdate;
	format Birthdate date9.;
run;

* title "PROC SQL Output";
proc sql;
select Name, Age, Height*2.54 as HeightCM format=5.1, Birthdate format=date9.
    from pg1.class_birthdate;
quit;

title;



********************************;
* Filtering and Sorting Output  *;
*********************************;

proc sql;
select Name, Age, Height, Birthdate format=date9.
        from pg1.class_birthdate
        where age > 14;
quit;



***********************************************************;
*  Demo                                                   *;
*    1) Add a SELECT statement to retrieve all columns    *;
*       from PG1.STORM_FINAL. Highlight the step and run  *;
*       the selected code. Examine the log and results.   *;
*    2) Modify the query to retrieve only the Season,     *;
*       Name, StartDate, and MaxWindMPH columns. Format   *;
*       StartDate with MMDDYY10. Highlight the step and   *;
*       run the selected code.                            *;
*    3) Modify Name in the SELECT clause to convert the   *;
*       values to proper case.                            *;
*    4) Add a WHERE clause to include storms during or    *;
*       after the 2000 season with MaxWindMPH greater     *;
*       than 156.                                         *;
*    5) Add an ORDER BY clause to arrange rows by         *;
*       descending MaxWindMPH, and then by Name.          *;
*    6) Add TITLE statements to describe the report.      *;
*       Highlight the step and run the selected code.     *;
***********************************************************;

proc sql;
*Add SELECT statement;
select Season, proccase(Name) as Name,  StartDate format=mmddyy10., MaxWindMPH
    from pg1.storm_final;

quit;




title "International Storms since 2000"
proc sql;
*Add SELECT statement;
select Season, proccase(Name) as Name,  StartDate format=mmddyy10., MaxWindMPH
    from pg1.storm_final
    where MaxWindMPH > 156 and Season > 2000
    order by MaxWindMPH desc, Name;

quit;
title;
 


 ***********************************************************;
*  Activity 7.02                                          *;
*    1) Complete the SQL query to display Event and Cost  *;
*       from PG1.STORM_DAMAGE. Format the values of Cost. *;
*    2) Add a new column named Season that extracts the   *;
*       year from Date.                                   *;
*    3) Add a WHERE clause to return rows where Cost is   *;
*       greater than 25 billion.                          *;
*    4) Add an ORDER BY clause to arrange rows by         *;
*       descending Cost. Which storm had the highest      *;
*       cost?                                             *;
***********************************************************;
*  Syntax                                                 *;
*    PROC SQL;                                            *;
*        SELECT col-name, col-name FORMAT=fmt             *;
*        FROM input-table                                 *;
*        WHERE expression                                 *;
*        ORDER BY col-name <DESC>;                        *;
*    QUIT;                                                *;
*                                                         *;
*    New column in SELECT list:                           *;
*    expression AS col-name                               *;
***********************************************************;

proc sql;
select Event,
       Cost format=dollar16.,  
       year(Date) as Season
    from pg1.storm_damage
    where Cost>25000000000
    order by Cost desc;
quit;


***************************************;
* Creating and Deleting Tables in SQL *;
**************************************;


CREATE TABLE table-name AS;


proc sql;
create table work.myclass as 
    select Name, Age, Height 
        from pg1.class_birthdate
        where age > 14
        order by Height desc;
quit; 




DROP TABLE table-name;
proc sql;
    drop table work.myclass;
quit;



***********************************************************;
*  Activity 7.03                                          *;
*    1) Modify the query to create a temporary table      *;
*       named TOP_DAMAGE.                                 *;
*    2) Add an additional query in the same PROC SQL step *;
*       to generate a report that lists all the columns   *;
*       for the first 10 storms in the top_damage table.  *;
*    3) Add a TITLE statement before the second query to  *;
*       display the following text: Top 10 Storms by      *;
*       Damage Cost.                                      *;
*    4) How many of the top 10 storms occurred in 2005?   *;
***********************************************************;

proc sql;
create table top_damage as
select Event, 
       Date format=monyy7.,
       Cost format=dollar16.
       from pg1.storm_damage
       order by Cost desc;
title "Top 10 Storms by Damage Cost";
    select *
        from top_damage(obs=10);
quit;



*********************************;
* Creating Inner Joins in SQL  **;
*********************************;

FROM table1 INNER JOIN table2
ON tables.column=table2.column



* equijoin;

proc sql;
select Grade, Age, Teacher 
    from pg1.class_update inner join pg1.class_teachers
    on class_update.Name = class_teachers.Name;
quit;


*****************************************;
* Demo: Joining Tables with PROC SQL  ***;
******************************************;

***********************************************************;
*  Joining Tables with PROC SQL                           *;
***********************************************************;
*  Syntax and Example                                     *;
*                                                         *;
*    PROC SQL;                                            *;
*        SELECT col-name, col-name                        *;
*        FROM input-table1 INNER JOIN input-table2        *;
*        ON table1.col-name=table2.col-name;              *;
*    QUIT;                                                *;
***********************************************************;

proc sql;
select class_update.Name, Grade, Age, Teacher 
    from pg1.class_update inner join pg1.class_teachers
    on class_update.Name=class_teachers.Name;
quit;  

***********************************************************;
*  Demo                                                   *;
*    1) Open PG1.STORM_SUMMARY and PG1.STORM_BASINCODES   *;
*       and compare the columns. Identify the matching    *;
*       column.                                           *;
*    2) Add PG1.STORM_BASINCODES to the FROM clause to    *;
*       perform an inner join on Basin. Remember to       *;
*       qualify the columns as table-name.col-name in the *;
*       ON expression.                                    *;
*    3) Add the BasinName column to the query after       *;
*       Basin. Highlight the step, run the selected code, *;
*       and examine the log. Why does the program fail?   *;
*    4) Modify the query to qualify the Basin column in   *;
*       the SELECT clause. Highlight the step and run the *;
*       selected code.                                    *;
***********************************************************;

proc sql;
select Season, Name, storm_summary.Basin, BasinName, MaxWindMPH
    from pg1.storm_summary inner join pg1.STORM_BASINCODES
    on storm_summary.basin = STORM_BASINCODES.basin
    order by Season desc, Name;
quit;


******************************;
* Using Table Aliases        *;
******************************;


FROM table1 AS alias1 INNER JION table2 AS alias2 



proc sql;
select u.Name, Grade, Age, Teacher 
    from pg1.class_update as u 
        inner join pg1.class_teachers as t 
        on u.Name=t.Name;
quit; 


***********************************************************;
*  Activity 7.04                                          *;
*    1) Define aliases for STORM_SUMMARY and              *;
*       STORM_BASINCODES in the FROM clause.              *;
*    2) Use one table alias to qualify Basin in the       *;
*       SELECT clause.                                    *;
*    3) Complete the ON expression to match rows when     *;
*       Basin is equal in the two tables. Use the table   *;
*       aliases to qualify Basin in the expression. Run   *;
*       the step.                                         *;
***********************************************************;
*  Syntax                                                 *;
*     FROM table1 AS alias1 INNER JOIN table2 AS alias2   *;
*     ON alias1.column = alias2.column                    *;
***********************************************************;


proc sql;
select Season, Name, s.Basin, BasinName, MaxWindMPH 
    from pg1.storm_summary as s 
        inner join pg1.storm_basincodes as b 
        on upcase(s.basin)=b.basin 
    order by Season desc, Name;
quit; 





