function [] = reconstruction(filename1,filename2)
%Good pairs: 1_002, 1_004/ 3_001, 3_002
clc;
close all;

%% Read image
I1 = imread(filename1);
I2 = imread(filename2);
i1 = rgb2gray(I1);
i2 = rgb2gray(I2);
points1 = corner(i1,'MinimumEigenvalue',500000);
points2 = corner(i2,'MinimumEigenvalue',500000);
[features1, valid_points1] = extractFeatures(i1, points1);
[features2, valid_points2] = extractFeatures(i2, points2);
indexPairs = matchFeatures(features1, features2);
matchedPoints1 = valid_points1(indexPairs(:, 1), :);
matchedPoints2 = valid_points2(indexPairs(:, 2), :);

%% Part I --
% RansacH and Find planes
[ H, inliers_pt1,inliers_pt2,out_pt1,out_pt2] = ransacH( matchedPoints1,matchedPoints2 );
fprintf('Inliers features num: %f\n', length(inliers_pt1));
plane1 = inliers_pt1;
ch1 = convhull(plane1(:,1),plane1(:,2));
IN = inpolygon(out_pt1(:,1),out_pt1(:,2),plane1(ch1,1),plane1(ch1,2));

[H1, inliers_pt11,inliers_pt22,out_pt11,out_pt22] = ransacH( out_pt1(~IN,:),out_pt2(~IN,:));
plane2 = inliers_pt11;
ch2 = convhull(plane2(:,1),plane2(:,2));
plane1_mask = poly2mask(plane1(ch1,1),plane1(ch1,2),size(I1,1),size(I1,2));
plane2_mask = poly2mask(plane2(ch2,1),plane2(ch2,2),size(I1,1),size(I1,2));
plane1_mask = repmat(plane1_mask,1,1,3);
plane2_mask = repmat(plane2_mask,1,1,3);

figure(1)
imshowpair(immultiply(I1,plane1_mask), immultiply(I1,plane2_mask), 'montage')
%% Part II - 
% Finding vanishing points
[VP,g1,g2,g3] = vpt_detection(filename1,false);

matched1 = [inliers_pt1; inliers_pt11];
matched2 = [inliers_pt2; inliers_pt22];
[ F, Ferr, epipole ] = calculateF( [inliers_pt11], [inliers_pt22], H);
F = refineF(F,matched1,matched2);
fprintf('Best Err: %f\n', Ferr);
[K] = calculateK(VP);
[M2 worldP] = findM2(F, matched1, matched2, K, K);

figure(4)
ax = axes;
showMatchedFeatures(I1,I2,inliers_pt1,inliers_pt2,'montage','Parent',ax);
hold on;
plot(plane1(ch1,1),plane1(ch1,2),'r-',plane1(:,1),plane1(:,2),'b*','LineWidth',2);
plot(plane2(ch2,1),plane2(ch2,2),'r-',plane2(:,1),plane2(:,2),'b*','LineWidth',2);

plot(g1(:,[1 2])', g1(:,[3 4])','r','LineWidth',2);
plot(g2(:,[1 2])', g2(:,[3 4])','g','LineWidth',2);
plot(g3(:,[1 2])', g3(:,[3 4])','b','LineWidth',2);


%% Plotting 3D planes
M1 = [eye(3,3) zeros(3,1)];
M1 = K*M1;

[X,Y] = meshgrid(1:size(I1,2),1:size(I1,1));
imageCoord = [X(:), Y(:)];
imageCoord = imageCoord(1:50:end,:);
imageInPlane1 = inpolygon(imageCoord(:,1),imageCoord(:,2),plane1(ch1,1),plane1(ch1,2));
imageInPlane2 = inpolygon(imageCoord(:,1),imageCoord(:,2),plane2(ch2,1),plane2(ch2,2));
imCoordP1 =[imageCoord(imageInPlane1,1) imageCoord(imageInPlane1,2)];
imCoordP1 =[imCoordP1'; ones(1,length(imCoordP1))]';

ind1 = sub2ind(size(I1),imCoordP1(:,2),imCoordP1(:,1));
r1 = I1(:,:,1);
r1 = r1(ind1);
g1 = I1(:,:,2);
g1 = g1(ind1);
b1 = I1(:,:,3);
b1 = b1(ind1);

imCoordP12 = (H*imCoordP1')';
imCoordP12 = imCoordP12./imCoordP12(:,3);
imCoordP2 =[imageCoord(imageInPlane2,1) imageCoord(imageInPlane2,2)];
imCoordP2 =[imCoordP2'; ones(1,length(imCoordP2))]';
imCoordP22 = (H1*imCoordP2')';
imCoordP22 = imCoordP22./imCoordP22(:,3);
ind2 = sub2ind(size(I1),imCoordP2(:,2),imCoordP2(:,1));
r2 = I1(:,:,1);
r2 = r2(ind2);
g2 = I1(:,:,2);
g2 = g2(ind2);
b2 = I1(:,:,3);
b2 = b2(ind2);

[imPlane1W, ~] = triangulate(imCoordP1(:,1:2),imCoordP12(:,1:2),M1',M2');
[imPlane2W, ~] = triangulate(imCoordP2(:,1:2),imCoordP22(:,1:2),M1',M2');

figure(6)
subplot(1,3,1)
plot3(worldP(:,1), worldP(:,2), worldP(:,3),'.','MarkerSize',20);
subplot(1,3,2)
[imPlane1W, ~] = triangulate(imCoordP1(:,1:2),imCoordP12(:,1:2),M1',M2');
hold on;
[imPlane2W, ~] = triangulate(imCoordP2(:,1:2),imCoordP22(:,1:2),M1',M2');
scatter3(imPlane1W(:,1), imPlane1W(:,2), imPlane1W(:,3), 20);
scatter3(imPlane2W(:,1), imPlane2W(:,2), imPlane2W(:,3), 20);
subplot(1,3,3)
hold on;
scatter3(imPlane1W(:,1), imPlane1W(:,2), imPlane1W(:,3), 20, double([r1 g1 b1])/256, 'filled');
scatter3(imPlane2W(:,1), imPlane2W(:,2), imPlane2W(:,3), 20, double([r2 g2 b2])/256, 'filled');
set(gca,'Color','k');
end
