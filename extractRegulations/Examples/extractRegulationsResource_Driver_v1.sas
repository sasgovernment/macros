options noxwait mprint mlogic sasautos=(sasautos,
"C:\SAS\code\macros\GITHUB\extractRegulations");


%let myremoteURL1=%NRSTR("http://api.data.gov/regulations/v3/documents.json?api_key=znwx4UsdfdsUTsdfsdfsdfjJr&countsOnly=0&encoded=1&dktid=FDA-2015-N-0540&rpp=1000&po=1");
%let mylocalDataset1=test1;		
%extractRegulationsResource(remoteURL=&myremoteURL1, localDataset=&mylocalDataset1)	


