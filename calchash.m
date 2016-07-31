function [ md5 ] = calchash( pool )
fn = [];
for i=1:1:length(pool.filename)
    fn = strcat(fn,pool.filename{i});
end
fn = strcat(fn,num2str(pool.minTH));
md5 = hash(fn,'MD5');
end