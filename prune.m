function [in, out] = prune(pt, lines)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
in = [];
out = [];  
numInliers = 0;
for i = 1:length(lines)
    if (getVPDist(lines(i,:),pt) < 1)
        numInliers = numInliers+ 1;
        in = [in; i];
    else
        out = [out; i];
    end
end

end

