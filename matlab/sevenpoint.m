% function [ F ] = sevenpoint( pts1, pts2, M )
% % sevenpoint:
% %   pts1 - Nx2 matrix of (x,y) coordinates
% %   pts2 - Nx2 matrix of (x,y) coordinates
% %   M    - max (imwidth, imheight)
% 
% % Q2.2 - Todo:
% %     Implement the sevenpoint algorithm
% %     Generate a matrix F from some '../data/some_corresp.mat'
% %     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat
% 
% %     Write recovered F and display the output of displayEpipolarF in your writeup
% 
% % Normalization factor T
% T=[1/M 0  0;
%    0 1/M  0;
%    0   0  1];
% 
% n_pts1 = [pts1 ones(size(pts1,1),1)]';
% n_pts1 = T*n_pts1;
% n_pts1 = repmat(n_pts1',1,3);
% 
% n_pts2 = [pts2 ones(size(pts2,1),1)]';
% n_pts2 = T*n_pts2;
% n_pts2 = repelem(n_pts2',1,3);
% 
% % Construct A matrix
% A = n_pts1.*n_pts2;
% % Find null space of A
% nullA = null(A);
% F1 = reshape(nullA(:,1),3,3)';
% F2 = reshape(nullA(:,2),3,3)';
% 
% % Solve for alpha
% syms a;
% F = (a)*F1+(1-a)*F2;
% sym2poly(det(F));
% p = roots(sym2poly(det(F)));
% 
% % Check for imaginary numbers
% if (isreal(p(1)) && isreal(p(2)) && isreal(p(3)))
%     F11 = T'*((p(1))*F1+(1-p(1))*F2)*T;
%     F11 = F11/norm(F11);
%     
%     F22 = T'*((p(2))*F1+(1-p(2))*F2)*T;
%     F22 = F22/norm(F22);
%     
%     F33 = T'*((p(3))*F1+(1-p(3))*F2)*T;
%     F33 = F33/norm(F33);
%     F = [mat2cell(F11,3,3),mat2cell(F22,3,3),mat2cell(F33,3,3)];
% else
%     realpart = p == real(p);
%     F = T'*((p(realpart))*F1+(1-p(realpart))*F2)*T;
%     F = F/norm(F);
%     F =  mat2cell(F,3,3);
% end
% 
% %save('q2_2.mat','F','M','pts1','pts2')
% 
% end

function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup

pts1 = pts1/M;
pts2 = pts2/M;
N = size(pts1,1);
T = eye(3)*1/M;
T(3,3) = 1;

tmp = [pts1 ones(N,1)];
A = [bsxfun(@times, pts2(:,1), tmp) bsxfun(@times, pts2(:,2), tmp) tmp];
[~,~,V] = svd(A);

F1 = reshape(V(:,8),3,3)';
F2 = reshape(V(:,9),3,3)';

syms a;
rs = double(solve(det(0 == a*F1 + (1-a)*F2) ,a));

for i =1:3
   if abs(imag(rs(i))) < 0.0001 %isreal(rs(i)) == 1
       F{i} = real(F1*rs(i) + F2*(1-rs(i)));
       F{i} = T'*F{i}*T;
       
      % [U S V] = svd(F{i});
      %  S(3,3) = 0;
      %  F{i} = U*S*V';
       
   end
end


%save('q2_2.mat','F','M','pts1','pts2')

end