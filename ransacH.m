function [ bestH,best1,best2,fout1,fout2] = ransacH( matchedPoints1,matchedPoints2 )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

iterNum =500;
bestH = 0;
best1 = [];
best2 = [];
for p = 1:iterNum
    %fprintf('Iteration %f\n', p);
    numInliers = 0;
    inliers1 = [];
    inliers2 = [];
    out1 = [];
    out2 = [];
    pts = randi(length(matchedPoints1),4,1);

    pts1 = matchedPoints1(pts,:);
    pts2 = matchedPoints2(pts,:);
    H = dlt_homography(pts1,pts2)';
    
    inliers1 = [];
    inliers2 = [];
    for i = 1:length(matchedPoints1)
        match_pt = H*[matchedPoints1(i,:) 1]';
        match_pt = match_pt/match_pt(3);
        pt = matchedPoints2(i,:);
        if (sqrt((match_pt(1)-pt(1))^2 + (match_pt(2)-pt(2))^2) < 3)
            inliers1 = [inliers1; 
                             matchedPoints1(i,:)];
            inliers2 = [inliers2; 
                             matchedPoints2(i,:)];
            numInliers = numInliers + 1;
        else
            out1 = [out1; 
                             matchedPoints1(i,:)];
            out2 = [out2; 
                             matchedPoints2(i,:)];
        end
       
    end
    %fprintf('Num inliers %f\n', length(inliers1));
    if (numInliers > length(best1))
        bestH = H;
        best1 = inliers1;
        best2 = inliers2;
        fout1 = out1;
        fout2 = out2;
    end
end

% Isolating inlier correspondences
inlier_corr = zeros(length(best1),2,2);
for i=1:length(best1)
    inlier_corr(i,:,1) = best1(i,:);
    inlier_corr(i,:,2) = best2(i,:);
end

% LevMar Optimization
ydata = zeros(1,length(best1));
hoptim = lsqcurvefit(@myfun,bestH,inlier_corr,ydata);

%Reassigning the H matrix
bestH = hoptim./hoptim(3,3);

end


function [ ydata ] = myfun( x, xdata )
%MYFUN LevMar cost calculator

ydata = zeros(1,length(xdata));
for i = 1:length(xdata)
        
        temp1 = x*[xdata(i,1,1); xdata(i,2,1); 1];
        temp1 = temp1/temp1(3);
        
        temp2 = x\[xdata(i,1,2); xdata(i,2,2); 1];
        temp2 = temp2/temp2(3);
        
        error1 = sum(abs([xdata(i,1,2); xdata(i,2,2); 1] - temp1));
        error2 = sum(abs([xdata(i,1,1); xdata(i,1,2); 1] - temp2));

        ydata(i) = error1+error2;
end

end
