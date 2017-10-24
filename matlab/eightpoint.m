function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup

% Normalization factor T
T=[1/M 0  0;
   0 1/M  0;
   0   0  1];

n_pts1 = [pts1 ones(size(pts1,1),1)]';
n_pts1 = T*n_pts1;
n_pts1 = repmat(n_pts1',1,3);

n_pts2 = [pts2 ones(size(pts2,1),1)]';
n_pts2 = T*n_pts2;
n_pts2 = repelem(n_pts2',1,3);

% Construct A matrix
A = n_pts1.*n_pts2;

% Solve for F
[~,~,V] = svd(A);
F = V(:,end);
F = reshape(F,3,3)';

% Singularity constraint
[UF, WF, VF] = svd(F);
WF(3,3) = 0;
F = UF * WF * VF';

% unnormalized
F = T' * F * T;

% Refine answer
F = refineF(F,pts1,pts2);
F = F/norm(F);

%save('q2_1.mat','F','M','pts1','pts2')

end