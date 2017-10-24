% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, p1, p2, R and P to q2_5.mat
function M2 = findM2()

corr = load('../data/some_corresp.mat');
pts1 = corr.pts1;
pts2 = corr.pts2;

q2_1 = load('q2_1.mat');
F = q2_1.F;

Ks = load('../data/intrinsics.mat');
K1 = Ks.K1;
K2 = Ks.K2;

E = essentialMatrix(F,K1,K2);
M1 = [eye(3,3) zeros(3,1)];
M1 = K1*M1;

M2s = camera2(E);

% Since only the correct camera pairs will
% have points X in view, we just need to tets
% one point to see whether it is in view
% to find the correct camera pair.
for i = 1 : 4
    M2_temp = M2s(:,:,i);
    M2_temp = K2*M2_temp;
    [P, ~] = triangulate(M1,pts1,M2_temp,pts2);

    pt_test = P(1,:)';
    PT_test2 = M2_temp*pt_test;
    PT_test1 = M1*pt_test;

    % Test to see whether this point is in both camera views
    if (PT_test2(3)> 0 && PT_test1(3) > 0)
        M2 = M2_temp;
        break;
    end;
    
end

save('q2_5.mat','M2','pts1','pts2','P');

end

