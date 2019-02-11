%macro loadDS2CAS(SrcLibDS=, SrcPath=, CASHost=, CASPort=, CASLib=, ACTION=);
%if %INDEX(&SrcLibDS,.)=0 %then
		%do;
			%LET SrcLibDS=%sysfunc(catt(work., &SrcLibDS));
			%PUT &SrcLibDS;		
%end;

%if &SrcLibDS= %then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide SOURCE LIB.DS name.;

			%return;
%end;
%put &SrcLibDS;
%put &SrcLibDS;

%let SRC_DS=%scan(&SrcLibDS, -1, .);
%put &SRC_DS;
%put &SRC_DS;

%let SRC_LIB=%scan(&SrcLibDS, 1, .);
%put &SRC_LIB;
%put &SRC_LIB;

%if &SRC_LIB=work %then
		%do;
			%put WORK PATH WILL BE SET.;
			%put &SrcPath;
			%put &SrcPath;
			%let SRC_LIB2=work2;
%end;

%if &CASHost= %then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide CAS HOST.;
			%return;
%end;
%if &CASPort= %then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide CAS PORT.;

			%return;
%end;
%if &CASLib= %then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide CAS LIBRARY.;

			%return;
%end;

%if &ACTION= %then
		%do;
		/*
			%LET ACTION=replace;
		*/
			%LET ACTION=promote;
			%PUT &SrcLibDS;		
%end;



%let CAS_DS_QUOTED=%unquote(%str(%"&SRC_DS%"));
%put &CAS_DS_QUOTED;
%put &CAS_DS_QUOTED;

options cashost=&CASHost casport=&CASPort;
cas;

cas mySession sessopts=(caslib=casuser timeout=1800 locale="en_US");

%if &SRC_LIB=work %then
		%do;
	libname &SRC_LIB2 &SrcPath;
	libname mycaslib cas caslib=casuser;
%end;
%else %do;
	libname &SRC_LIB &SrcPath;
	libname mycaslib cas caslib=casuser;
%end;


proc cas;
/*check if table already exists in caslib*/
table.tableExists result=r / caslib=&CASLib name=&CAS_DS_QUOTED;
run;

/*if table already exists then drop it*/
if r.exists then do;
   table.dropTable / caslib=&CASLib name=&CAS_DS_QUOTED; 
end;
run;
quit;


proc casutil;
load data=&SrcLibDS outcaslib=&CASLib
casout=&CAS_DS_QUOTED &ACTION;
run;
quit;

%mend loadDS2CAS;
