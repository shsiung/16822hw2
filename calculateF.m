function [ bestF, bestErr, bestEpipole] = calculateF( pt1, pt2, H)

iterNum = 500;
bestErr = 100*length(pt1);
for p = 1:iterNum
    err = 0;
    pts = randi(length(pt1),2,1);

    pts1 = pt1(pts,:);
    pts2 = pt2(pts,:);

    e1 = cross(H*[pts1(1,:) 1]',[pts2(1,:) 1]');
    e2 = cross(H*[pts1(1,:) 1]',[pts2(2,:) 1]');
    e = cross(e1,e2);
    e = e./e(3);
    F=skewsym3(e) * H;
    F=F./F(3,3);
    
    err1 = [pt2'; ones(1,length(pt2))]'*F*[pt1';ones(1,length(pt1))];
    err = sum(sum(err1));

    if (abs(err) < bestErr)
        bestErr = abs(err);
        bestF = F;
        bestEpipole = e;
    end
end

end
