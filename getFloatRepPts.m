function [p1, p2] = getFloatRepPts(o1, o2, pt)
    lstart1 = [0; 0];
    lend1 = o1;
    lstart2 = o1;
    lend2 = o2;
    % compute line vector of each links
    lvec1 = lstart1 - lend1;
    lvec2 = lstart2 - lend2;
    % compute vector from obstacle point to joints
    pvec1 = pt - lend1;
    pvec2 = pt - lend2;

    % dot products of the vectors
    out1 = dot(pvec1,lvec1,1);
    inn1 = dot(lvec1,lvec1,1);
    out2 = dot(pvec2,lvec2,1);
    inn2 = dot(lvec2,lvec2,1);

    if out1 <= 0
        p1 = lend1;
    elseif inn1 <= out1
        p1 = lstart1;
    else
        p1 = lend1 + (out1/inn1)*lvec1;
    end
    if out2 <= 0
        p2 = lend2;
    elseif inn2 <= out2
        p2 = lstart2;
    else
        p2 = lend2 + (out2/inn2)*lvec2;
    end

end