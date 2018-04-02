options noxwait mprint mlogic sasautos=(sasautos,
"C:\SAS\code\macros\GITHUB\extractRegulations",
"C:\SAS\code\macros\GITHUB\importDataFile");

/*Example 1:*/
/*CHANGE API KEY IN HTTP CALL INSIDE OF CSV*/
%let my_csv_file1="C:\SAS\code\macros\GITHUB\extractRegulations\Examples\data\REGULATIONS_CMS_COMMENTS.csv";
%let my_dsout1=work.REGULATIONS_COMMENTS;
%importDataFile(FilePath=&my_csv_file1, DSOut=&my_dsout1)

data work.REGULATIONS_COMMENTS2;
	set work.REGULATIONS_COMMENTS;
	targets=CATT("_",_n_,"_");
run;

%let myAPIList=work.REGULATIONS_COMMENTS2;
%extractManyRegulationsResource(APIList=&myAPIList)	




/*Example 1_1:*/
/*CHANGE API KEY IN HTTP CALL INSIDE OF CSV*/
%let my_csv_file1_1="C:\SAS\code\macros\GITHUB\extractRegulations\Examples\data\REGULATIONS_COMMENTS.csv";
%let my_dsout1_1=work.REGULATIONS_COMMENTS;
%importDataFile(FilePath=&my_csv_file1_1, DSOut=&my_dsout1_1)

data work.REGULATIONS_COMMENTS2;
	set work.REGULATIONS_COMMENTS;
	targets=CATT("_",_n_,"_");
run;

%let myAPIList1_1=work.REGULATIONS_COMMENTS2;
%extractManyRegulationsResource(APIList=&myAPIList1_1)	


/*Example 2:*/
%let my_csv_file2="C:\SAS\code\macros\GITHUB\extractRegulations\Examples\data\OPIOID_REGULATIONS_COMMENTS.csv";
%let my_dsout2=work.OPIOID_REGULATIONS_COMMENTS;
%importDataFile(FilePath=&my_csv_file2, DSOut=&my_dsout2)

data work.OPIOID_REGULATIONS_COMMENTS2;
	set work.OPIOID_REGULATIONS_COMMENTS;
	targets=CATT("_",_n_,"_");
run;

%let myAPIList=work.OPIOID_REGULATIONS_COMMENTS2;
%extractManyRegulationsResource(APIList=&myAPIList)	

/*
libname fin1 "C:\SAS\code\macros\GITHUB\extractRegulations\Examples\data";
*/
data work.OPIOID_REGULATIONS_DATA1;
	set _1_ _2_ _3_;
run;
