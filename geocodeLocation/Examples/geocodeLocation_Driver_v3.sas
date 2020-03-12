options FULLSTIMER noxwait mprint mlogic sasautos=(sasautos,
"C:\SAS\code\macros\GITHUB\geocodeLocation");

libname tmp1 'C:\SAS\code\macros\GITHUB\geocodeLocation\Examples\data';

/*Example 1 - Basic*/
%let mySrcDSName=tmp1.locations;
%geocodeLocation(SrcDSName=&mySrcDSName)
