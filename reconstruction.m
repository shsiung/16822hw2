function [] = reconstruction(filename1,filename2)
%Good pairs: 1_002, 1_004/ 3_001, 3_002


clc;
close all;

%% Read image
I1 = imread(filename1);
I2 = imread(filename2);
i1 = rgb2gray(I1);
i2 = rgb2gray(I2);
points1 = corner(i1,'MinimumEigenvalue',100000);
points2 = corner(i2,'MinimumEigenvalue',100000);
[features1, valid_points1] = extractFeatures(i1, points1);
[features2, valid_points2] = extractFeatures(i2, points2);
indexPairs = matchFeatures(features1, features2);
matchedPoints1 = valid_points1(indexPairs(:, 1), :);
matchedPoints2 = valid_points2(indexPairs(:, 2), :);
%% Finding vanishing points
[VP,g1,g2,g3] = vpt_detection(filename1,false);
[VP2,g11,g22,g33] = vpt_detection(filename2,false);

%% RansacH
[ H, inliers_pt1,inliers_pt2,out_pt1,out_pt2] = ransacH( matchedPoints1,matchedPoints2 );
fprintf('Inliers features num: %f\n', length(inliers_pt1));
planes1 = inliers_pt1;
K = convhull(planes1(:,1),planes1(:,2));

IN = inpolygon(out_pt1(:,1),out_pt1(:,2),planes1(K,1),planes1(K,2));

[ H1, inliers_pt11,inliers_pt22,out_pt11,out_pt22] = ransacH( out_pt1(~IN,:),out_pt2(~IN,:) );
planes2 = inliers_pt11;
K1 = convhull(planes2(:,1),planes2(:,2));

[rectI] = applyH(I1, H);
matched1 = [inliers_pt1; inliers_pt11];
matched2 = [inliers_pt2; inliers_pt22];

[ F, Ferr, epipole ] = calculateF( [inliers_pt11], [inliers_pt22], H);
fprintf('Best Err: %f\n', Ferr);


P = [eye(3), zeros(3,1)];
P1 = [skewsym3(epipole)*F, epipole];
worldPoints = triangulate(matched1,matched2,P',P1');

%% Plotting
figure(2);
subplot(2,2,1);
imshow(rectI);
subplot(2,2,2);
C = imfuse(I2,rectI,'blend','Scaling','joint');
imshow(C);
subplot(2,2,3);
imshow(I2);


figure(1)
ax = axes;
showMatchedFeatures(I1,I2,inliers_pt1,inliers_pt2,'montage','Parent',ax);
hold on;
plot(planes1(K,1),planes1(K,2),'r-',planes1(:,1),planes1(:,2),'b*','LineWidth',2);
plot(planes2(K1,1),planes2(K1,2),'r-',planes2(:,1),planes2(:,2),'b*','LineWidth',2);

plot(g1(:,[1 2])', g1(:,[3 4])','r','LineWidth',2);
plot(g2(:,[1 2])', g2(:,[3 4])','g','LineWidth',2);
plot(g3(:,[1 2])', g3(:,[3 4])','b','LineWidth',2);

end
