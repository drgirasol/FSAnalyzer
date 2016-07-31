function sendbugreport( exception,pool )
buttoncontrole( pool,0 )
statusbox(pool,'Undefinded Error occured.');
time = clock;
Date = strcat(num2str(time(1,3)),...
    '-',num2str(time(1,2)),...
    '-',num2str(time(1,1)),...
    '_',num2str(time(1,4)),...
    ':',num2str(time(1,5)),...
    ':',num2str(round(time(1,6))));
Date2 = strcat(num2str(time(1,3)),...
    '-',num2str(time(1,2)),...
    '-',num2str(time(1,1)),...
    '_',num2str(time(1,4)),...
    '.',num2str(time(1,5)),...
    '.',num2str(round(time(1,6))));
putname = strcat(Date2,'_BugReport','.mat');
putpath = strcat(pwd,'\',putname);
save(putpath,'pool');
brSubject = strcat('Bugreport','_',Date);
ErrorMsg = getReport(exception,'extended','hyperlinks','off');
BRgui = bugreportdlg;
BR = get(BRgui.f,'userdata');
userreportTMP = BR.userreport;
userreport = '';
for i=1:size(userreportTMP,1)
    userreport = strcat(userreport,'|||',userreportTMP(i,:));
end
close(BRgui.f);
systeminfo = strcat(pool.BR.version,{' '},'@',pool.BR.hostname);
if pool.debug
    pool.BR.netflag = 0;
    BR.sendFflag = 0;
end
if pool.BR.netflag
    if BR.sendFflag
       sendmail( 'iifsanalyzer@gmail.com', brSubject, [userreport ' ' 'End of Userreport---' ' ' systeminfo ' ' '=Begin of Error Message=' ErrorMsg],putpath);
       statusbox(pool,'A bugreport has been sent with attached dataset.');
    else
        sendmail( 'iifsanalyzer@gmail.com', brSubject, [userreport ' ' 'End of Userreport---' ' ' systeminfo ' ' '=Begin of Error Message=' ErrorMsg]);
        statusbox(pool,'A bugreport has been sent.');
    end
    statusbox(pool,'A bugreport has been saved.');
else
    statusbox(pool,'A bugreport has been saved.');
end
fname = strcat(Date2,'BugReport','.txt');
fid=fopen(fullfile(pwd,fname),'w');
fprintf(fid,'%s\r\n',userreport);
fprintf(fid,'End of Userreport---\r\n\r\n');
fprintf(fid,'%s\r\n\r\n',systeminfo{1});
fprintf(fid,'=Begin of Error Message=\r\n');
fprintf(fid,'%s\r\n',exception.message);
for i=1:length(exception.stack)
    fprintf(fid,'function: %s at %i\r\n',exception.stack(i).name,exception.stack(i).line);
end
fclose(fid);
buttoncontrole( pool,1 )
end