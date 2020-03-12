options FULLSTIMER noxwait mprint mlogic sasautos=(sasautos,
"C:\SAS\code\macros\v0_0_1_paM1",
"C:\SAS\code\macros\v0_0_1_paM1\geo");

libname tmp1 'C:\SAS\code\macros\GITHUB\geocodeLocation\Examples\data';


/*Example 1 - Basic*/
%let mySrcDSName=tmp1.locations;
%geocodeLocation(SrcDSName=&mySrcDSName)

/*Example 2 - Custom TargetDSName*/
%let mySrcDSName=tmp1.locations;
%geocodeLocation(SrcDSName=&mySrcDSName, TargetDSName=work.MYOUTPUT)

%let mySrcDSName=tmp1.locations;
%geocodeLocation(SrcDSName=&mySrcDSName, TargetDSName=tmp1.MYOUTPUT)


/*Example 3 - Custom SrcVarName and TargetDSName*/
%let mySrcDSName=tmp1.locations2;
%geocodeLocation(SrcDSName=&mySrcDSName, SrcVarName=location2, TargetDSName=tmp1.MYOUTPUT2)

