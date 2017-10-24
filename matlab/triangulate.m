function [ P, error ] = triangulate( M1, p1, M2, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations
%       See Szeliski Chapter 7 for ideas
%
% Ks = load('../data/intrinsics.mat');
% K1 = Ks.K1;
% K2 = Ks.K2;

p1 = [p1, ones(length(p1),1)];
p2 = [p2, ones(length(p2),1)];

%Linear Triangulation
P = zeros(size(p1,1),4);
for i = 1 : size(p1,1)
    pt1 = p1(i,:);
    pt2 = p2(i,:);
    A = [pt1(1)*M1(3,:)-M1(1,:); ...
         pt1(2)*M1(3,:)-M1(2,:); ...
         pt2(1)*M2(3,:)-M2(1,:); ...
         pt2(2)*M2(3,:)-M2(2,:)];
    [~,~,V] = svd(A);
    P(i,:) = V(:,end)'/V(end,end);
end
p1_proj = M1*P';
p1_proj = bsxfun (@rdivide, p1_proj, p1_proj(3,:));

p2_proj = M2*P';
p2_proj = bsxfun (@rdivide, p2_proj, p2_proj(3,:));

error = norm(p1' - p1_proj)^2+norm(p2'-p2_proj)^2;

end
