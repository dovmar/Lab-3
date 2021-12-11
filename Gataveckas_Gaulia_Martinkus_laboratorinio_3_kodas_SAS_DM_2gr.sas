PROC IMPORT DATAFILE='/home/u45871880/high_school_modified.csv'
	DBMS=CSV
	OUT=data;
	GETNAMES=YES;
RUN;


/* Hipotezė apie krypties koeficientų lygybę*/
PROC GLM DATA=data; CLASS parental_education;
MODEL result = parental_education daily_study_hours attendance
daily_study_hours*parental_education attendance*parental_education / SS3; 
RUN;



/* Modelio prielaidos */
/* Vidurkių palyginimai */
PROC GLM DATA=data plots=ALL;
 CLASS parental_education;
MODEL result = parental_education daily_study_hours attendance / SS3; 
LSMEANS parental_education / stderr pdiff adjust=bon;
RUN;



