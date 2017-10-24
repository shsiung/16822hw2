function [ K ] = calculateK( VP )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

VP1x = VP(1,1);
VP1y = VP(2,1);
VP1z = VP(3,1);
VP2x = VP(1,2);
VP2y = VP(2,2);
VP2z = VP(3,2);
VP3x = VP(1,3);
VP3y = VP(2,3);
VP3z = VP(3,3);

A = [VP1x*VP2x+VP1y*VP2y VP2x*VP1z+VP1x*VP2z VP2y*VP1z+VP1y*VP2z VP1z*VP2z;
     VP1x*VP3x+VP1y*VP3y VP3x*VP1z+VP1x*VP3z VP3y*VP1z+VP1y*VP3z VP1z*VP3z;
     VP2x*VP3x+VP2y*VP3y VP3x*VP2z+VP2x*VP3z VP3y*VP2z+VP2y*VP3z VP2z*VP3z];

[~,~,V] = svd(A);
w_v = V(:,end);
w = [w_v(1) 0 w_v(2);
     0   w_v(1) w_v(3);
     w_v(2) w_v(3) w_v(4)];
 
K = chol(w);
K = inv(K);
K = K./K(3,3);
end

