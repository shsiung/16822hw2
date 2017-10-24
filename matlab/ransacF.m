function [ F ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.X - Extra Credit:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using sevenpoint
%          - using ransac

%     In your writeup, describe your algorith, how you determined which
%     points are inliers, and any other optimizations you made
iter_max = 100;
iter = 0;
err_thresh = 0.002;
num_inliers = 0;

while iter < iter_max    
    rand_pts = randsample(length(pts1),7);
    pt1 = pts1(rand_pts,:);
    pt2 = pts2(rand_pts,:);
    
    curr_F = sevenpoint( pt1, pt2, M );
    
    for i = 1 : length(curr_F)
        mat_curr_F = cell2mat(curr_F(i));
        err =  diag([pts1 ones(length(pts1),1)]...
                     *mat_curr_F...
                     *[pts2 ones(length(pts2),1)]');
        inlier = abs(err)<err_thresh;
        inline_pt1 = pts1(inlier,:);
        inline_pt2 = pts2(inlier,:);
        
        if (size(inline_pt1,1) > 1)
            mat_curr_F = eightpoint(inline_pt1,inline_pt2,M);
            refine_err =  diag([pts1 ones(length(pts1),1)]*mat_curr_F*[pts2 ones(length(pts2),1)]');
            num = sum(abs(refine_err)<err_thresh);

            if num > num_inliers
                F = mat_curr_F;
            end
        end
    end
    iter = iter + 1;
end