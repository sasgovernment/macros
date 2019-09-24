/***********************************************************************************/
/* Program Name: extractRegulationsPDF                                             */
/* Date Created: 07/12/2019                                                        */
/* Author: 	Manuel Figallo                                                         */
/* Purpose: extract comment PDFs from Regulations.gov                              */
/*                                                                                 */
/* ------------------------------------------------------------------------------- */
/*                                                                                 */
/* Input(s): PDFDirectory is the output directory                       		   */
/*           DocID is the docket ID         									   */
/*           CNT is the attachment count         								   */
/*           HTTP_SLEEP is the sleep time to accomodate HTTP request intervals     */
/* Output(s): sas7bdat with all the metadata                                       */
/*                                                                                 */
/* ---------------------THE SECTION BELOW IS FOR FUTURE ENHANCEMENTS-------------- */
/* Date Modified: TBD                                                              */
/* Modified by: TBD                                                                */
/* Reason for Modification: TBD                                                    */
/* Modification Made: TBD                                                          */
/***********************************************************************************/
%macro extractRegulationsPDF(PDFDirectory=, DocID=, CNT=, HTTP_SLEEP=);

%macro extractRegulationsPDF1(PDFDir=, PDFFile=, DKTID=, ATTACHMENT_NUM=);

	%if &HTTP_SLEEP eq %then %do;
		%LET HTTP_SLEEP=FALSE;
	%end;
	

%let myAPI_KEY="YOUR_API_KEY_HERE";
%let myAPI_KEY2=%sysfunc(tranwrd(%quote(&myAPI_KEY),%str(%"),%str( )));
%put &myAPI_KEY2;

%let PDFDir=&PDFDir;
%put &PDFDir;
%let PDFDir2=%sysfunc(tranwrd(%quote(&PDFDir),%str(%"),%str( )));
%put &PDFDir2;

%let PDFFile=&PDFFile;
%put &PDFFile;
%let PDFFile2=%sysfunc(tranwrd(%quote(&PDFFile),%str(%"),%str( )));
%put &PDFFile2;

%let PDFDirFile=%SYSFUNC(CATT(&PDFDir2, &PDFFile2));
%put &PDFDirFile;
%let PDFDirFile_Q=%unquote(%str(%"&PDFDirFile%"));
%put &PDFDirFile_Q;

%put &DKTID;
%put &ATTACHMENT_NUM;


filename resp &PDFDirFile_Q;
proc http 

   url="https://api.data.gov/regulations/v3/download?api_key=&&myAPI_KEY2&documentId=&&DKTID&attachmentNumber=&&ATTACHMENT_NUM&contentType=pdf"
   ct="application/pdf" 
   out=resp;
run;
%mend extractRegulationsPDF1;


%let PDFFile1=&DocID;                                                                                                       
%put &PDFFile1;                                                                                                                      
%let PDFFile2=%sysfunc(tranwrd(%quote(&PDFFile1),%str(-),%str(_)));                                                                     
%put &PDFFile2;                                                                                                                         
%let PDFFile3="&PDFFile2%NRSTR(_&&i)..pdf";                                                                                           
%put %superq(PDFFile3);  

%do i = 1 %to &CNT;
	%extractRegulationsPDF1(PDFDir=&PDFDirectory, 
				       PDFFile=%superq(PDFFile3),
					   DKTID=&DocID,
					   ATTACHMENT_NUM=&i
						)
	%IF &HTTP_SLEEP=TRUE %THEN %DO;
		/*
		%let slept= %SYSFUNC(sleep(10));
		*/
		%let slept= %SYSFUNC(sleep(15));
	%END;
%end;
%mend extractRegulationsPDF;
