function [ H ] = dlt_homography(pt1,pt2)
% Calculate homography from simple 4-point DLT algorithm
A = [];
for i = 1:4
   A = [A; 
        -pt1(i,1) -pt1(i,2) -1 0 0 0  pt1(i,1)*pt2(i,1) pt1(i,2)*pt2(i,1) pt2(i,1);
        0 0 0  -pt1(i,1) -pt1(i,2) -1 pt1(i,1)*pt2(i,2) pt1(i,2)*pt2(i,2) pt2(i,2)];
end
[~,~,V] = svd(A);
H = reshape(V(:,end),3,3);

end

