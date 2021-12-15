PROC IMPORT DATAFILE='/home/u45871880/high_school_modified.csv'
	DBMS=CSV
	OUT=data;
	GETNAMES=YES;
RUN;


/* Hipotezė apie krypties koeficientų lygybę*/
PROC GLM DATA=data; CLASS combined;
MODEL result = combined daily_study_hours*combined attendance*combined / SS3; 
RUN;


/* Hipotezė apie faktorių sąveikos nebuvimą*/
PROC GLM DATA=data; CLASS parental_education test_prep_course;
MODEL result = parental_education test_prep_course parental_education*test_prep_course daily_study_hours attendance / SS3; 
RUN;



/* Modelio prielaidos */
/* Vidurkių palyginimai */
PROC GLM DATA=data plots=ALL;
CLASS parental_education test_prep_course;
MODEL result = parental_education test_prep_course daily_study_hours attendance / SS3; 
LSMEANS parental_education / stderr pdiff adjust=bon;
OUTPUT out=res residual=liekanos;
RUN;


/* Normalumo testas */
PROC UNIVARIATE data=res normal;
VAR liekanos;
RUN;


/* Dispersijų lygybėstestas */
PROC GLM DATA=data plots=none;
CLASS combined;
MODEL result = combined;
MEANS combined / HOVTEST=levene(type=abs);
RUN;


