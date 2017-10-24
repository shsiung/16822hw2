function [M2, Pout] = findM2(F, pts1, pts2, K1, K2)

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
    [P, ~] = triangulate(pts1,pts2,M1',M2_temp');
    P = [P'; ones(1,length(P))]';
    pt_test = P(1,:)';
    PT_test2 = M2_temp*pt_test;
    PT_test1 = M1*pt_test;

    % Test to see whether this point is in both camera views
    if (PT_test2(3)> 0 && PT_test1(3) > 0)
        M2 = M2_temp;
        Pout = P;
        break;
    end;
    
end

end

