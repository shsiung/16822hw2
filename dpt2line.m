function [ dist ] = dpt2line( line,pt )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
x1 = line(1);
y1 = line(3);
x2 = line(2);
y2 = line(4);

dist = abs((y2-y1)*pt(1)-(x2-x1)*pt(2)+x2*y1-y2*x1)/sqrt((y2-y1)^2+(x2-x1)^2);

end

