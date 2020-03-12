/***********************************************************************************/
/* Program Name: geocodeLocation                                                   */
/* Date Created: 12/15/2015                                                        */
/* Author: 	Manuel Figallo                                                         */
/* Purpose: Given a list of addresses, provide the lat and long                    */
/*                                                                                 */
/* ------------------------------------------------------------------------------- */
/*                                                                                 */
/* Input(s):  SrcDSName - The source dataset name containing addresses that require*/
/*                        geocoding                                                */
/*            SrcVarName (optional) - The variable name in the source dataset that */
/*                        contains all addresses.  By default, it is "location"    */
/*            TargetDSName (optional) - The target dataset name containing the     */
/*                        addresses geocoded.  By default, it                      */
/*                        is "work.R_locations_geocoded"                           */
/* Output(s): sas7bdat with addresses and their lat and long                       */
/*                                                                                 */
/* ---------------------THE SECTION BELOW IS FOR FUTURE ENHANCEMENTS-------------- */
/* Date Modified: TBD                                                              */
/* Modified by: TBD                                                                */
/* Reason for Modification: TBD                                                    */
/* Modification Made: TBD                                                          */
/***********************************************************************************/

%macro geocodeLocation(SrcDSName=, SrcVarName=, TargetDSName=);
	%if &SrcDSName= %then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide the Source Dataset Name.;

			%return;
		%end;

	%if &SrcVarName eq %then
		%do;
			%LET SrcVarName=location;
		%end;

	%if &TargetDSName eq %then
		%do;
			%LET TargetDSName=r_locations_geocoded;
		%end;

	data   _null_;
		call  symput( "numlocations" ,trim(left(numlocations)));
		stop;
		set  &SrcDSName  nobs=numlocations;
	run;

	%put &numlocations;

	/* Create empty results table */
	proc sql noprint;
		create table &TargetDSName 
			(
			ID char ( 200 ),
			address char ( 200 ),
			status char ( 2 ),
			formatted_address char ( 80 ),
			lat char ( 11 ),
			lng char ( 11 ),
			partial_match char ( 5 ),
			location_type char (30)
			)
		;
	quit;

	%do i=1 %to &numlocations;

		data _null_;
			nrec = &i;
			set	&SrcDSName point=nrec;
			call symputx('id',id);
			call symput('a1',translate(trim(&SrcVarName),'+',' '));
			call symput('add',trim(&SrcVarName));
			stop;
		run;

		filename y url "https://maps.google.com/maps/api/geocode/xml?key=AZZZzaSyCuazr6_lRO5R1t2KiNNcxM5kkRPfQUp5o&address=&a1.%nrstr(&sensor=true)";
		filename Googlexm 'C:\SAS\code\macros\GITHUB\geocodeLocation\geoCoding_GoogleXML.xml';

		data _null_;
			infile y lrecl= 32000 pad;
			input;
			file Googlexm;
			put _infile_;

			*******XML code;
		run;

		filename  SXLEMAP 'C:\SAS\code\macros\GITHUB\geocodeLocation\geoCoding_GoogleXML.map';
		libname   Googlexm xml xmlmap=SXLEMAP access=READONLY;

		data results;
			*mf
			*format date Date9.;
			address=symget( 'add' );
			ID=symget( 'ID' );
			set Googlexm.result;
		run;

		********Add to the Dataset to hold all geocoded lat and lng;
		data &TargetDSName;
			set &TargetDSName results;
		run;

		data _null_;
			time_wait = sleep(2);

			******Sleep 2 seconds;
		run;

	%end;

	/*use proc datasets to delete ds	*/
	proc datasets lib=work nolist;
		delete results;
	quit;

%mend geocodeLocation;
