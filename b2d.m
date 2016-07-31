% b2d this is a fast way to convert variable sized binary blocks into 
% human-readable format; this is accomplished by a bitwise summary while
% shifting through the byte(s)
function [ intval ] = b2d( x )
intval = sum(x .* 2.^(size(x,2)-1:-1:0));
end