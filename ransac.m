function [ bestVp ] = ransac(lines)
iterNum = 50000;
bestVp = 0;
for p = 1:iterNum
    numInliers = 0;
    line1 = 0;
    line2 = 0;
    while(line1 == line2)
        line1 = randi(length(lines));
        line2 = randi(length(lines));
    end

    lines1 = lines(line1,:);
    lines2 = lines(line2,:);
    p11 = [lines1(1); lines1(2); 1];
    p12 = [lines1(3); lines1(4); 1];
    p21 = [lines2(1); lines2(2); 1];
    p22 = [lines2(3); lines2(4); 1];

    l1 = cross(p11,p12);
    l1 = l1/l1(3);
    l2 = cross(p21,p22);
    l2 = l2/l2(3);
    vp = cross(l1,l2);
    vp = vp/vp(3);
    
    for i = 1:length(lines)
        if (dpt2line(lines(i,:),vp) < 20)
            numInliers = numInliers+1;
        end
    end
    
    if (numInliers > bestVp)
        bestVp = vp;
    end
end

end