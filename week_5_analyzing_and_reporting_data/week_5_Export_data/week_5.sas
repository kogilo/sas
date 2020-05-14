************************************;
* Exporting Data                   *;
************************************;


PROC EXPORT DATA=input-table OUTFILE="output-file"
        <DBMS=identifier><REPLACE>;
RUN;

<DBMS=identifier> -- how to format the output;
                        CSV, TAB, DLM, XLSX, ...


* Ex;

proc export data=sashelp.cars
        outfile="s:/workshop/output/cars.txt"
        dbms=tab replace;
run;


* Activity 6.01 

* Complete the PROC EXPORT step to read the pg1.storm_final SAS table and create 
* a comma-delimited file named storm_final.csv. Use &outpath to provide the path to the file.

* Run the program and check the log.
* How many records were written to the storm_final.csv file?

* Note: If you want to view the CSV file, right-click storm_final.csv 
* in the output folder and select View File as Text.;


proc export data=pg1.storm_final
     outfile="&outpath/storm_final.csv"
     dbms=csv replace;
run; 


