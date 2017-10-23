function [VP,group1,group2,group3] = vpt_detection(filename, graph)

clc;
close all;

%% Read image
I1 = imread('images/input/3_001.jpg');
I2 = imread('images/input/3_002.jpg');
i1 = rgb2gray(I1);
i2 = rgb2gray(I2);
points1 = corner(i1,'MinimumEigenvalue',50000);
points2 = corner(i2,'MinimumEigenvalue',50000);
[features1, valid_points1] = extractFeatures(i1, points1);
[features2, valid_points2] = extractFeatures(i2, points2);
indexPairs = matchFeatures(features1, features2);
matchedPoints1 = valid_points1(indexPairs(:, 1), :);
matchedPoints2 = valid_points2(indexPairs(:, 2), :);
%% Finding vanishing points
[VP,g1,g2,g3] = vpt_detection('images/input/3_001.jpg',false);

%% RansacH

[ H, inliers_pt1,inliers_pt2,out_pt1,out_pt2] = ransacH( matchedPoints1,matchedPoints2 );
fprintf('Inliers features num: %f\n', length(inliers_pt1));
planes1 = inliers_pt1;

[ H1, inliers_pt11,inliers_pt22,out_pt11,out_pt22] = ransacH( out_pt1,out_pt2 );
planes2 = inliers_pt11;

[rectI] = applyH(I1, H);

%% Convex hull
K = convhull(planes1(:,1),planes1(:,2));
K1 = convhull(planes2(:,1),planes2(:,2));

%% Plotting

figure(2);
subplot(2,2,1);
imshow(rectI);
subplot(2,2,2);
C = imfuse(I2,rectI,'blend','Scaling','joint');
imshow(C);
t = mean(pt2-pt1,1);
tI2 = imtranslate(I2,[-t(1) t(2)]);
J = imfuse(tI2,rectI,'blend','Scaling','joint');
subplot(2,2,3);
imshow(J);

figure(3)
ax = axes;
% showMatchedFeatures(I1,I2,inliers_pt1,inliers_pt2,'montage','Parent',ax);
hold on;
plot(planes1(K,1),planes1(K,2),'r-',planes1(:,1),planes1(:,2),'b*','LineWidth',2);
plot(planes2(K1,1),planes2(K1,2),'r-',planes2(:,1),planes2(:,2),'b*','LineWidth',2);

plot(g1(:,[1 2])', g1(:,[3 4])','r','LineWidth',1);
plot(g2(:,[1 2])', g2(:,[3 4])','g','LineWidth',1);
plot(g3(:,[1 2])', g3(:,[3 4])','b','LineWidth',1);

end
