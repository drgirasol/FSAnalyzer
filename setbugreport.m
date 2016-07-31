function [ pool ] = setbugreport( pool )
pool.BR.version = 'V 0.9';
[~, pool.BR.hostname] = system('hostname');
url =java.net.URL('http://gmail.com');
try
link = openStream(url);
parse = java.io.InputStreamReader(link);
snip = java.io.BufferedReader(parse);
if ~isempty(snip)
    pool.BR.netflag = 1;
else
    pool.BR.netflag = 0;
end
catch exception
    pool.BR.netflag = 0;
    return;
end
mail = 'fsanalyzerbugreport@gmail.com';
psswd = 'jubixhfhbeegchwb';
%psswd = '18ea97fa5c8b7e3164b28eb56b8a124d';
host = 'smtp.gmail.com';
port  = '465';
setpref( 'Internet','E_mail', mail );
setpref( 'Internet', 'SMTP_Server', host );
setpref( 'Internet', 'SMTP_Username', mail );
setpref( 'Internet', 'SMTP_Password', psswd );
props = java.lang.System.getProperties;
props.setProperty( 'mail.smtp.user', mail );
props.setProperty( 'mail.smtp.host', host );
props.setProperty( 'mail.smtp.port', port );
props.setProperty( 'mail.smtp.starttls.enable', 'true' );
props.setProperty( 'mail.smtp.debug', 'true' );
props.setProperty( 'mail.smtp.auth', 'true' );
props.setProperty( 'mail.smtp.socketFactory.port', port );
props.setProperty( 'mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory' );
props.setProperty( 'mail.smtp.socketFactory.fallback', 'false' );
end