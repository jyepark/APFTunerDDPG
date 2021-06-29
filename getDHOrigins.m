function [o1, o2] = getDHOrigins(q)
    c1 = cos(q(1));
    s1 = sin(q(1));
    c12 = cos(q(1)+q(2));
    s12 = sin(q(1)+q(2));

    o1 = [c1; s1];
    o2 = [c1+c12; s1+s12];
end