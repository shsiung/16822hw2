%% get image
function [VP,group1,group2,group3] = vpt_detection(filename, graph)
img = imread(filename);

dogimg = dog(img);
% get lines
img_gray = rgb2gray(dogimg);
lines = APPgetLargeConnectedEdges(img_gray, 0.02*sqrt(size(img_gray,1)^2 + size(img_gray,2)^2));

if graph == true
    figure(1), hold off, imshow(img)
end

%% group lines
n_line_group = 3;
kmeans_lines = lines(:,[5 6]);
idx = kmeans(kmeans_lines,n_line_group);
lines1 = lines(idx==1,:);
lines2 = lines(idx==2,:);
lines3 = lines(idx==3,:);

if graph == true
    figure(2), hold off, imshow(img);
    figure(2), hold on, plot(lines1(:, [1 2])', lines1(:, [3 4])','r','LineWidth',3);
    figure(2), hold on, plot(lines2(:, [1 2])', lines2(:, [3 4])','g','LineWidth',3);
    figure(2), hold on, plot(lines3(:, [1 2])', lines3(:, [3 4])','b','LineWidth',3);
end

% %% ransac 
    fprintf('process 1...');
    [pt1, in1, out1] = ransac(lines1);
    fprintf('done\n');
    fprintf('process 2...');
    [pt2, in2, out2] = ransac(lines2);
    fprintf('done\n');
    fprintf('process 3...');
    [pt3, in3, out3] = ransac(lines3);
    fprintf('done\n');
    fprintf('inliers 1: %f, outliers 1: %f\n', length(in1), length(out1));
    fprintf('inliers 2: %f, outliers 2: %f\n', length(in2), length(out2));
    fprintf('inliers 3: %f, outliers 3: %f\n', length(in3), length(out3));
    
%% Plot all 3 infinity points
if graph == true
    figure(3);
    hold on;

    imagesc(img);
    plot(lines1(in1, [1 2])', lines1(in1, [3 4])','r','LineWidth',1);
    plot(lines2(in2, [1 2])', lines2(in2, [3 4])','g','LineWidth',1);
    plot(lines3(in3, [1 2])', lines3(in3, [3 4])','b','LineWidth',1);

    plot(lines1(out1, [1 2])', lines1(out1, [3 4])','y','LineWidth',1);
    plot(lines2(out2, [1 2])', lines2(out2, [3 4])','y','LineWidth',1);
    plot(lines3(out3, [1 2])', lines3(out3, [3 4])','y','LineWidth',1);
    plot(pt1(1),pt1(2),'r.','MarkerSize',30);
    plot(pt2(1),pt2(2),'g.','MarkerSize',30);
    plot(pt3(1),pt3(2),'b.','MarkerSize',30);

    set(gca,'YDir','reverse')

    %% Plot individual point
    figure(4);
    hold on;
    imagesc(img);
    set(gca,'YDir','reverse')
    plot(lines1(in1, [1 2])', lines1(in1, [3 4])','r','LineWidth',1);
    plot(lines2(in2, [1 2])', lines2(in2, [3 4])','g','LineWidth',1);
    plot(lines3(in3, [1 2])', lines3(in3, [3 4])','b','LineWidth',1);

    plot(lines1(out1, [1 2])', lines1(out1, [3 4])','y','LineWidth',1);
    plot(lines2(out2, [1 2])', lines2(out2, [3 4])','y','LineWidth',1);
    plot(lines3(out3, [1 2])', lines3(out3, [3 4])','y','LineWidth',1);
    plot(pt2(1),pt2(2),'g.','MarkerSize',30);

    figure(5);
    hold on;
    imagesc(img);
    set(gca,'YDir','reverse')
    plot(lines1(in1, [1 2])', lines1(in1, [3 4])','r','LineWidth',1);
    plot(lines2(in2, [1 2])', lines2(in2, [3 4])','g','LineWidth',1);
    plot(lines3(in3, [1 2])', lines3(in3, [3 4])','b','LineWidth',1);

    plot(lines1(out1, [1 2])', lines1(out1, [3 4])','y','LineWidth',1);
    plot(lines2(out2, [1 2])', lines2(out2, [3 4])','y','LineWidth',1);
    plot(lines3(out3, [1 2])', lines3(out3, [3 4])','y','LineWidth',1);
    plot(pt1(1),pt1(2),'r.','MarkerSize',30);

    figure(6);
    hold on;
    imagesc(img);
    set(gca,'YDir','reverse')
    plot(lines1(in1, [1 2])', lines1(in1, [3 4])','r','LineWidth',1);
    plot(lines2(in2, [1 2])', lines2(in2, [3 4])','g','LineWidth',1);
    plot(lines3(in3, [1 2])', lines3(in3, [3 4])','b','LineWidth',1);

    plot(lines1(out1, [1 2])', lines1(out1, [3 4])','y','LineWidth',1);
    plot(lines2(out2, [1 2])', lines2(out2, [3 4])','y','LineWidth',1);
    plot(lines3(out3, [1 2])', lines3(out3, [3 4])','y','LineWidth',1);
    plot(pt3(1),pt3(2),'b.','MarkerSize',30);

end

VP = [pt1 pt2 pt3];
group1 = lines1(in1,:);
group2 = lines2(in2,:);
group3 = lines3(in3,:);
end