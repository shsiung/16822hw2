% Q2.7 - Todo:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3

pts1 = load('../data/templeCoords.mat');
pts1 = [pts1.x1, pts1.y1];
F = load('q2_1.mat');
F = F.F;

im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

Ks = load('../data/intrinsics.mat');
K1 = Ks.K1;
K2 = Ks.K2;

M1 = [eye(3,3) zeros(3,1)];
M1 = K1*M1;

M2 = load('q2_5.mat');
M2 = M2.M2;

pts2 = zeros(size(pts1,1),2);

for i = 1 : size(pts1,1)
    [x,y] = epipolarCorrespondence( im1, im2, F, ...
                                       pts1(i,1), pts1(i,2));
    pts2(i,:) = [x,y];
end
[ P, error ] = triangulate( M1, pts1, M2, pts2 );
scatter3(P(:,1),P(:,2),P(:,3));

save('q2_7.mat','F','M1','M2')

