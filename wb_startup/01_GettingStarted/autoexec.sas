  /*
  Custom Workspace Autoexec file.

  %put &WORKSPACE_PATH; <- the macro variable WORKSPACE_PATH is automatically 
                           defined for you so you can use in SAS Programs.
  */
%let outpath=/workspaces/mainstorage/data;

libname sasfiles "&WORKSPACE_PATH./sasfiles";

/*
delete all files that match pattern. 
store deleted files so you can go back and make sure you didn't accidentally delete anything you wanted;
*/
data deleted_files (keep=fname);
    rc = filename("mydir","&folder_path");
    did = dopen("mydir");
    if did > 0
    then do i = 1 to dnum(did);
    fname = dread(did,i);
    if prxmatch("/sashtml\d{0,2}.htm/", fname) then do;
        rc2 = filename("del", catx("/", "&folder_path", fname));
        rc2 = fdelete("del");
        output;
        end;
    end;
    rc = dclose(did);
run;