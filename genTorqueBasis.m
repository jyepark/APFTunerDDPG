function BasisVector = genTorqueBasis(obsState)
    d = 0.5;
    rho0 = 0.5;
    of1 = [0; 1];
    of2 = [-1; 1];
    b = [1.2; 0.5];
    %global d rho0
    %global b of1 of2

    % unpack observation
    q = obsState;

    c1 = cos(q(1));
    s1 = sin(q(1));
    c12 = cos(q(1)+q(2));
    s12 = sin(q(1)+q(2));

    o1 = [c1; s1];
    o2 = [c1+c12; s1+s12];

    [p1, p2] = getFloatRepPts(o1, o2, b);

    d1 = o1 - of1;
    normd1 = norm(d1);
    d2 = o2 - of2;
    normd2 = norm(d2);

    xi1 = p1 - b;
    rho1 = norm(xi1);
    xi2 = p2 - b;
    rho2 = norm(xi2);
    
    if normd1 > d
        f1xa = -d*d1(1)/normd1;
        f1ya = -d*d1(2)/normd1;
    else
        f1xa = -d1(1);
        f1ya = -d1(2);
    end
    if rho0 >= rho1
        f1xr = ((1/rho1)-(1/rho0))*xi1(1)/rho1^3;
        f1yr = ((1/rho1)-(1/rho0))*xi1(2)/rho1^3;
    else
        f1xr = 0;
        f1yr = 0;
    end
    if normd2 > d
        f2xa = -d*d2(1)/normd2;
        f2ya = -d*d2(2)/normd2;
    else
        f2xa = -d2(1);
        f2ya = -d2(2);
    end
    if rho0 >= rho2
        f2xr = ((1/rho2)-(1/rho0))*xi2(1)/rho2^3;
        f2yr = ((1/rho2)-(1/rho0))*xi2(2)/rho2^3;
    else
        f2xr = 0;
        f2yr = 0;
    end
    
    BasisVector = [
        -s1*f1xa+c1*f1ya; % * zeta1 = tau_att1(1)
        -p1(2)*f1xr+p1(1)*f1yr; % * eta1 = tau_rep1(1)
        -(s1+s12)*f2xa+(c1+c12)*f2ya; % * zeta2 = tau_att2(1)
        -p2(2)*f2xr+p2(1)*f2yr; % * eta2 = tau_rep2(1)
        -s12*f2xa+c12*f2ya; % * zeta2 = tau_att2(2)
        (-p2(2)+s1)*f2xr+(p2(1)-c1)*f2yr % * eta2 = tau_rep2(2)
    ];
end
    
