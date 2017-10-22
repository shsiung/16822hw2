%% get image
clf;
clc;
close all;
img = imread('images/input/1_001.jpg');

%% get lines
img_gray = rgb2gray(img);
lines = APPgetLargeConnectedEdges(img_gray, 50);
figure(1), hold off, imshow(img)
figure(1), hold on, plot(lines(:, [1 2])', lines(:, [3 4])','LineWidth',3);

%% group lines
n_line_group = 3;
kmeans_lines = lines(:,[5 6]);
idx = kmeans(kmeans_lines,n_line_group);
figure(2), hold off, imshow(img);

lines1 = lines(idx==1,:);
lines2 = lines(idx==2,:);
lines3 = lines(idx==3,:);

figure(2), hold on, plot(lines1(:, [1 2])', lines1(:, [3 4])','r','LineWidth',3);
figure(2), hold on, plot(lines2(:, [1 2])', lines2(:, [3 4])','g','LineWidth',3);
figure(2), hold on, plot(lines3(:, [1 2])', lines3(:, [3 4])','b','LineWidth',3);


%% ransac
line = lines1(1,:);

pt1 = ransac(lines1);
pt2 = ransac(lines2);
pt3 = ransac(lines3);

figure;
hold on;
plot(pt1(1),pt1(2),'r*','MarkerSize',20);
plot(pt2(1),pt2(2),'g*','MarkerSize',20);
plot(pt3(1),pt3(2),'b*','MarkerSize',20);