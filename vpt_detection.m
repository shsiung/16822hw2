%% get image
clf;
clc;
close all;
img = imread('images/input/test1.jpg');

%% get lines
img_gray = rgb2gray(img);
lines = APPgetLargeConnectedEdges(img_gray, 0.025*sqrt(size(img_gray,1)^2 + size(img_gray,2)^2));
figure(1), hold off, imshow(img)
% figure(1), hold on, plot(lines(:, [1 2])', lines(:, [3 4])','LineWidth',3);

%% group lines
n_line_group = 3;
kmeans_lines = lines(:,[5,6]);
idx = kmeans(kmeans_lines,n_line_group);
figure(2), hold off, imshow(img);

lines1 = lines(idx==1,:);
lines2 = lines(idx==2,:);
lines3 = lines(idx==3,:);

figure(2), hold on, plot(lines1(:, [1 2])', lines1(:, [3 4])','r','LineWidth',3);
figure(2), hold on, plot(lines2(:, [1 2])', lines2(:, [3 4])','g','LineWidth',3);
figure(2), hold on, plot(lines3(:, [1 2])', lines3(:, [3 4])','b','LineWidth',3);


%% ransac 
[pt1, in1, out1] = ransac(lines1);
[pt2, in2, out2] = ransac(lines2);
[pt3, in3, out3] = ransac(lines3);

length(in1)
length(in2)
length(in3)

%% Plot all 3 infinity points
figure(3);
hold on;
plot(pt1(1),pt1(2),'r.','MarkerSize',30);
plot(pt2(1),pt2(2),'g.','MarkerSize',30);
plot(pt3(1),pt3(2),'b.','MarkerSize',30);

imagesc(img);
plot(lines1(in1, [1 2])', lines1(in1, [3 4])','r','LineWidth',1);
plot(lines2(in2, [1 2])', lines2(in2, [3 4])','g','LineWidth',1);
plot(lines3(in3, [1 2])', lines3(in3, [3 4])','b','LineWidth',1);

plot(lines1(out1, [1 2])', lines1(out1, [3 4])','y','LineWidth',1);
plot(lines2(out2, [1 2])', lines2(out2, [3 4])','y','LineWidth',1);
plot(lines3(out3, [1 2])', lines3(out3, [3 4])','y','LineWidth',1);
set(gca,'YDir','reverse')

%% Plot individual point
figure(4);
hold on;
plot(pt2(1),pt2(2),'g.','MarkerSize',30);
imagesc(img);
set(gca,'YDir','reverse')
plot(lines1(in1, [1 2])', lines1(in1, [3 4])','r','LineWidth',1);
plot(lines2(in2, [1 2])', lines2(in2, [3 4])','g','LineWidth',1);
plot(lines3(in3, [1 2])', lines3(in3, [3 4])','b','LineWidth',1);

plot(lines1(out1, [1 2])', lines1(out1, [3 4])','y','LineWidth',1);
plot(lines2(out2, [1 2])', lines2(out2, [3 4])','y','LineWidth',1);
plot(lines3(out3, [1 2])', lines3(out3, [3 4])','y','LineWidth',1);

figure(5);
hold on;
plot(pt1(1),pt1(2),'r.','MarkerSize',30);
imagesc(img);
set(gca,'YDir','reverse')
plot(lines1(in1, [1 2])', lines1(in1, [3 4])','r','LineWidth',1);
plot(lines2(in2, [1 2])', lines2(in2, [3 4])','g','LineWidth',1);
plot(lines3(in3, [1 2])', lines3(in3, [3 4])','b','LineWidth',1);

plot(lines1(out1, [1 2])', lines1(out1, [3 4])','y','LineWidth',1);
plot(lines2(out2, [1 2])', lines2(out2, [3 4])','y','LineWidth',1);
plot(lines3(out3, [1 2])', lines3(out3, [3 4])','y','LineWidth',1);

figure(6);
hold on;
plot(pt3(1),pt3(2),'b.','MarkerSize',30);
imagesc(img);
set(gca,'YDir','reverse')
plot(lines1(in1, [1 2])', lines1(in1, [3 4])','r','LineWidth',1);
plot(lines2(in2, [1 2])', lines2(in2, [3 4])','g','LineWidth',1);
plot(lines3(in3, [1 2])', lines3(in3, [3 4])','b','LineWidth',1);

plot(lines1(out1, [1 2])', lines1(out1, [3 4])','y','LineWidth',1);
plot(lines2(out2, [1 2])', lines2(out2, [3 4])','y','LineWidth',1);
plot(lines3(out3, [1 2])', lines3(out3, [3 4])','y','LineWidth',1);