%(Matrix(n-1)+4Matrix(n)+Matrix(n+1))/6
n=size(timetheta(:,2:4));
n=n(1);
mtr1th=timetheta(:,2);
mtr2th=timetheta(:,3);
mtr3th=timetheta(:,4);
mtr1p=timepos(:,2);
mtr2p=timepos(:,3);
mtr3p=timepos(:,4);

wp1t=[];
wp2t=[];
wp3t=[];
wp1p=[];
wp2p=[];
wp3p=[];
for ct = 2:n-1
    wp1t=[wp1t;(mtr1th(ct-1)+(4*mtr1th(ct))+mtr1th(ct+1))/6];
    wp2t=[wp2t;(mtr2th(ct-1)+(4*mtr2th(ct))+mtr2th(ct+1))/6];
    wp3t=[wp3t;(mtr3th(ct-1)+(4*mtr3th(ct))+mtr3th(ct+1))/6];
    wp1p=[wp1p;(mtr1p(ct-1)+(4*mtr1p(ct))+mtr1p(ct+1))/6];
    wp2p=[wp2p;(mtr2p(ct-1)+(4*mtr2p(ct))+mtr2p(ct+1))/6];
    wp3p=[wp3p;(mtr3p(ct-1)+(4*mtr3p(ct))+mtr3p(ct+1))/6];
end

spline1th=[wp1t,wp2t,wp3t];
spline1p=[wp1p,wp2p,wp3p];

splineth1=timetheta(1,2:4);
splinep1=timepos(1,2:4);
splineth2=timetheta(n,2:4);
splinep2=timepos(n,2:4);

spline1th=[splineth1;spline1th;splineth2];
spline1th=[timetheta(:,1),spline1th];
spline1p=[splinep1;spline1p;splinep2];
spline1p=[timetheta(:,1),spline1p];