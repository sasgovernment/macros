/***********************************************************************************/
/* Program Name: extractManyRegulationsResource                                    */
/* Date Created: 12/15/2015                                                        */
/* Author: 	Manuel Figallo                                                         */
/* Purpose: extracts a list of MANY comments from Regulations.gov                  */
/*                                                                                 */
/* ------------------------------------------------------------------------------- */
/*                                                                                 */
/* Input(s): APIList is a dataset with a list of HTTP API calls and                */
/*           corresponding output datasets                                         */
/* Output(s): sas7bdat with all the comments                                       */
/*                                                                                 */
/* ---------------------THE SECTION BELOW IS FOR FUTURE ENHANCEMENTS-------------- */
/* Date Modified: TBD                                                              */
/* Modified by: TBD                                                                */
/* Reason for Modification: TBD                                                    */
/* Modification Made: TBD                                                          */
/***********************************************************************************/
options noquotelenmax;

%macro extractManyRegulationsResource(APIList=);
	%if &APIList= %then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide list of APIs.;

			%return;
		%end;

	data _null_;
		length macrocall5 $2000.;
		set &APIList end=final;
		macrocall5=catt('%nrstr(%extractRegulationsResource(remoteURL=%NRSTR(', sources, '), localDataset=', targets , '))');
		call execute (macrocall5);
	run;

%mend extractManyRegulationsResource;