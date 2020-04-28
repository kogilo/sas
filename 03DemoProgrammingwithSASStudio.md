# Demo: Programming with SAS Studio

## To browsee Data 
 - select `libray`
 - In the `SASHELP` sub-library there are a collection of sample 
 - select the `class` table 


 - Select the `New` option and `New SAS Program` to open code editor Or Press ` F4 `

* This code reads that SASHELP.CLASS table and creates a copy called myclass.


```{sas} 

data myclass;
    set sashelp.class;
run;

```




* print it 

proc print data = myclass;
run;


### Which tab do you select to see if SAS issued any errors, warnings, or notes when it processed your code?

#### LOG

 - we will see the response happened when we run the code, Like errors or warrinings and Notes
 

 #### Results
 - the report or the output we need.
 #### Output Date 
 - Display the table we created 
 - You can minimize the size of the colomns by right click and Select `size, grid columns to content`
 - Or select `perference` and mark `size, grid columns to content`


 ## Let go back to code:
 - you can select the code and run it alone.


 ### How can we look at more than one item at the same time?
 * Drag and Drop Results. You will see the partation of the window.


 ## SAS Program Structure

 * DATA STEP
    - Read data from source 
    data myclass;
        set sashelp.class;
        heightcm=height*2.54;
    run;
 * PROC STEP
    - processes a sas table 
    proc print data=myclass;
    run;

    proc means data=myclass;
        var age heightcm;
    run;


## Statments

- global statements 
- do not need a run statment after them.


     TITLE ....;
        OPTIONS...;
    LIBNAME...;



***********************************************************;
*  Activity 1.03                                          *;
*    1) View the code. How many steps are in the program? 3*;
*    2) How many statements are in the PROC PRINT step?  4 *;
*    3) How many global statements are in the program? 3   *;
*    4) Run the program and view the log.                 *;
*    5) How many observations were read by the PROC PRINT *;
*       step?   11                                          *;
***********************************************************;

data mycars;
	set sashelp.cars;
	AvgMPG=mean(mpg_city, mpg_highway);
run;

title "Cars with Average MPG Over 35";
proc print data=mycars;
	var make model type avgmpg;
	where AvgMPG > 35;
run;

title "Average MPG by Car Type";
proc means data=mycars mean min max maxdec=1;
	var avgmpg;
	class type;
run;

title;


## SAS Program Syntax

data myclass; set sashelp.class;run;
proc print data=myclass;run;

# The same as 

data myclass; 
    set sashelp.class;
run;

proc print data=myclass;
run;


## commnets 

/* students under 13 yo */   ---multiple linees  COMMAND + /
data under13;
    set sashelp.class;
    where Age < 13 ;
    *drop Height Weight;  --- to comment out single line
run;


## Demo: Understanding SAS Program Syntax


## Demo: Finding and Resolving Syntax Errors
* syntax errors 
    - misspelled keywords
    - unmatched quotation marks
    - missing semicolon
    - invalid options 
    - missing semicolon 

* You can recognize the syntax error by looking at the key word. If it is not highlighted, check it.
* After you run the program, see the LOG. some keyword involve with errors will be underlined.
* Then read the error carefully.


***********************************************************;
*  Activity 1.04                                          *;
*    1) Format the program to improve the spacing. What   *;
*       syntax error is detected? Fix the error and run   *;
*       the program.                                      *;
*    2) Read the log and identify any additional syntax   *;
*       errors or warnings. Correct the program and       *;
*       format the code again.                            *;
*    3) Add a comment to describe the changes that you    *;
*       made to the program.                              *;
*    4) Run the program and examine the log and results.  *;
*       How many rows are in the canadashoes data?        *;
***********************************************************;

data canadashoes set sashelp.shoes;
	where 
		region="Canada;
	Profit=Sales-Returns;run;

prc print data=canadashoes;run;



























