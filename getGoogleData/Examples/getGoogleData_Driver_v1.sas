options noxwait mprint mlogic sasautos=(sasautos,
"C:\SAS\code\macros\GITHUB\getGoogleData");

%getGoogleData(remoteURL="https://sheets.googleapis.com/v4/spreadsheets/1Vr33lGSLI6-Ikf7P4e_nHWWDUh5RTHqk2gf-AfWNhPM/values/Sheet1!A1:D99000?key=AIzaSyDVT2n_p2nbVIJaG6nLhiDh3-O5ayxcaNU", 
localDataset=mygoogle1)
