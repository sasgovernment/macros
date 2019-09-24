/***********************************************************************************/
/* Program Name: extractRegulationsResourceMeta                                    */
/* Date Created: 07/15/2019                                                        */
/* Author: 	Manuel Figallo                                                         */
/* Purpose: extract comment Metadata from Regulations.gov                          */
/*                                                                                 */
/* ------------------------------------------------------------------------------- */
/*                                                                                 */
/* Input(s): remoteURL is the REST Query for regulations.gov                       */
/*           localDataset is the dataset with metadata from the REST query         */
/* Output(s): sas7bdat with all the metadata                                       */
/*                                                                                 */
/* ---------------------THE SECTION BELOW IS FOR FUTURE ENHANCEMENTS-------------- */
/* Date Modified: TBD                                                              */
/* Modified by: TBD                                                                */
/* Reason for Modification: TBD                                                    */
/* Modification Made: TBD                                                          */
/***********************************************************************************/
options noquotelenmax;

%macro extractRegulationsResourceMeta(remoteURL=, localDataset=);
	%if &remoteURL= %then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide an HTTP location.;

			%return;
		%end;

	%if &localDataset= %then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide an destination location on your C: drive, S: drive, etc.;

			%return;
		%end;

	%let remoteURL2 = %QSYSFUNC(TRANWRD(&remoteURL, %str(%"), %str(%')));
	%put &remoteURL2;
	%put &remoteURL2;
	%put &remoteURL2;
	%put &remoteURL2;

	proc ds2;

		data &localDataset (overwrite=yes);
			/* Global package references */
			dcl package json j();

			dcl nvarchar(128) agency;
			dcl nvarchar(128) agencyAcronym;
			dcl nvarchar(128) docketId;
			dcl nvarchar(128) numberOfComments;
			dcl nvarchar(128) parentAgency;
			dcl nvarchar(128) parentAgencyAcronym;
			dcl nvarchar(128) rin;
			dcl nvarchar(32767) title;
			dcl nvarchar(32767) type;


			/* these are temp variables */
			dcl varchar(3276700) character set utf8 response;
			dcl int rc;
			drop response rc;

			method parseMessages();
				dcl int tokenType parseFlags;
				dcl nvarchar(32767) token;
				rc=0;

				do while (rc=0);
					j.getNextToken( rc, token, tokenType, parseFlags);

					if (token eq 'agency') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							agency=token;
						end;
					
					if (token eq 'agencyAcronym') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							agencyAcronym=token;
						end;

					if (token eq 'docketId') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							docketId=token;
						end;

					if (token eq 'numberOfComments') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							numberOfComments=token;
						end;

					if (token eq 'parentAgency') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							parentAgency=token;
						end;

					if (token eq 'parentAgencyAcronym') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							parentAgencyAcronym=token;
						end;

					if (token eq 'rin') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							rin=token;
						end;

					if (token eq 'title') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							title=token;
							put 'title=' token;

						end;

					if (token eq 'type') then
						do;
							j.getNextToken( rc, type, tokenType, parseFlags);
							if tokenType=256 then output;
							put 'type=' type;
						end;
				end;

				return;
			end;

			method init();
				dcl package http webQuery();
				dcl int rc tokenType parseFlags;
				dcl nvarchar(32767) token;
				dcl integer i rc;

				/* create a GET call to the API                                         */
				webQuery.createGetMethod(&remoteURL2);

				/* execute the GET */
				webQuery.executeMethod();

				/* retrieve the response body as a string */
				webQuery.getResponseBodyAsString(response, rc);
				rc = j.createParser( response );

				do while (rc = 0);
					j.getNextToken( rc, token, tokenType, parseFlags);

					if (token = '{') then
						parseMessages();
				end;
			end;

			method term();
				rc = j.destroyParser();
			end;

		enddata;
	run;

		quit;
%mend extractRegulationsResourceMeta;
