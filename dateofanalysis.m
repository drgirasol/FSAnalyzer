function [ pool ] = dateofanalysis( pool )
time = clock;
pool.Date = strcat(num2str(time(1,3)),'-',num2str(time(1,2)),'-',num2str(time(1,1)),'_',num2str(time(1,4)),'.',num2str(time(1,5)),'.',num2str(round(time(1,6))),'.');
statusbox(pool,pool.Date);
end