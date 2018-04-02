/***********************************************************************************/
/* Program Name: extractRegulationsResource                                        */
/* Date Created: 12/15/2015                                                        */
/* Author: 	Manuel Figallo                                                         */
/* Purpose: extract several comments from Regulations.gov                          */
/*                                                                                 */
/* ------------------------------------------------------------------------------- */
/*                                                                                 */
/* Input(s): remoteURL is the REST Query for regulations.gov                       */
/*           localDataset is the dataset with all comments from the REST query     */
/* Output(s): sas7bdat with all the comments                                       */
/*                                                                                 */
/* ---------------------THE SECTION BELOW IS FOR FUTURE ENHANCEMENTS-------------- */
/* Date Modified: TBD                                                              */
/* Modified by: TBD                                                                */
/* Reason for Modification: TBD                                                    */
/* Modification Made: TBD                                                          */
/***********************************************************************************/
options noquotelenmax;

%macro extractRegulationsResource(remoteURL=, localDataset=);
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

			/* Keeping these variables for output */
			dcl nvarchar(128) agencyAcronym;
			dcl nvarchar(128) commentDueDate;
			dcl nvarchar(128) commentStartDate;

			/* commentText is a very large text field */
			dcl nvarchar(32767) commentText;
			dcl nvarchar(32767) docketId;
			dcl nvarchar(32767) docketTitle;
			dcl nvarchar(32767) documentId;
			dcl nvarchar(32767) postedDate;
			dcl nvarchar(32767) title;

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

					if (token eq 'agencyAcronym') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							agencyAcronym=token;
						end;

					if (token eq 'commentDueDate') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							commentDueDate=token;
						end;

					if (token eq 'commentStartDate') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							commentStartDate=token;
						end;

					if (token eq 'commentText') then
						do;
							/* read the next value into the large commentText variable */
							j.getNextToken( rc, token, tokenType, parseFlags);

							/* when done reading all values we want, OUTPUT record */
							commentText=token;
						end;

					if (token eq 'docketId') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							docketId=token;
						end;

					if (token eq 'docketTitle') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							docketTitle=token;
						end;

					if (token eq 'documentId') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							documentId=token;
						end;

					if (token eq 'postedDate') then
						do;
							j.getNextToken( rc, token, tokenType, parseFlags);
							postedDate=token;
						end;

					if (token eq 'title') then
						do;
							j.getNextToken( rc, title, tokenType, parseFlags);
							output;
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

					if (token = 'documents') then
						parseMessages();
				end;
			end;

			method term();
				rc = j.destroyParser();
			end;

		enddata;
	run;

		quit;

%mend extractRegulationsResource;