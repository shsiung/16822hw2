function [ H ] = dlt_homography( pt1,pt2)
% Calculate homography from simple 4-point DLT algorithm
A = [];
% x = 2*u/w - 1
% y = 2*v/h - 1 


for i = 1:4
   A = [A; 
        -pt1(i,1) -pt1(i,2) -1 0 0 0  pt1(i,1)*pt2(i,1) pt1(i,2)*pt2(i,1) pt2(i,1);
        0 0 0  -pt1(i,1) -pt1(i,2) -1 pt1(i,1)*pt2(i,2) pt1(i,2)*pt2(i,2) pt2(i,2)];
end
[U,S,V] = svd(A);
H = reshape(V(:,end),3,3);

end

