options noxwait mprint mlogic sasautos=(sasautos,
"C:\SAS\code\macros\GITHUB\loadDS2CAS");

%loadDS2CAS(SrcLibDS=sashelp.class, 
		    CASHost="111.22.222.222", CASPort=5570, CASLib="Public");
