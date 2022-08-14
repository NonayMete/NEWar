% Workspace_calculations.m 
%
% This file will approximate the workspace of a rigid manipulator.
% The approximation is accomplished by iterating varying the 
% input angles and then plotting the cooresponding output positions.


function Workspace_calculations

% Define constants
X = 1;
Y = 2;
Z = 3;
MIN = 1;
MAX = 2;

DOF = 5;

% Define the range for the input vector(s), t
r = 5*ones(DOF,1);
 
t(1,:) = linspace(0, 2*pi ,r(1));
t(2,:) = linspace(0, 2*pi ,r(2));
t(3,:) = linspace(0, 2*pi ,r(3));
t(4,:) = linspace(0, 2*pi ,r(4));
t(5,:) = linspace(0, 2*pi ,r(5));


% Define link parameters

Ls = 2;
Li = 1;

% Davinit-Hartenburg
d = [0; 0; Ls; 0; Li];
a = [0; 0;  0; 0;  0];
p = [2/3*pi; -2/3*pi; 2/3*pi; -2/3*pi; 0];



% Calculate the workspace positions

i = ones(DOF,1);
tp = zeros(DOF,1);


while (sum(i>zeros(length(i),1)))
    for j=1:DOF
        tp(j) = t(j,i(j));
    end
    ind = sub2indV(r,i);
    P(:,ind) = A(tp, d, a, p );
    i = Iterate(i,r);
end

%sort(P');

% Plot results
figure
axis square
hold on

plot3( P(X,:), P(Y,:), P(Z,:), 'b.' );





    
function [i] = Iterate(i,r)

i(1) = i(1)+1;
j = 1;
while ( i(j) > r(j) )
    if (j>=length(i))
        i = zeros(length(i),1);
        break;
    end
    i(j) = 1;
    i(j+1) = i(j+1)+1;
    j = j+1;
end





function [r] = FindClosest(r,t,d,a,p,delta,DOF)

p_min = 99999999999;
i_min = -1;

for (i=1:DOF)
    tp = t;
    tp(i) = tp(i)+delta;
    del = norm(r - A(tp,d,a,p));
    if (del<p_min)
        i_min = i;
    end
end

tp = t;
tp(i_min) = tp(i_min)+delta;
r = A(tp,d,a,p);



function [r] = FindFarthest(r,t,d,a,p,delta,DOF)

p_max = 0;
i_max = -1;

for (i=1:DOF)
    tp = t;
    tp(i) = tp(i)+delta;
    del = norm(r - A(tp,d,a,p));
    if (del>p_max)
        i_max = i;
    end
end

tp = t;
tp(i_max) = tp(i_max)+delta;
r = A(tp,d,a,p);




% Calculate a DH iteration

function [A] = DH(t,d,a,p)

A = Rz(t)*Tz(d)*Tx(a)*Rx(p);




% Calculate successive rotations about z

function [P] = A(t,d,a,p)

A = eye(4,4);

for i=1:length(d)
    A = A*DH(t(i),d(i),a(i),p(i));
end

P = A(1:3,4);





% Rotation about z axis followed by translation along z

function [A] = Rz(t)

A = [cos(t), -sin(t), 0, 0;
     sin(t),  cos(t), 0, 0;
          0,       0, 1, 0;
          0,       0, 0, 1];


function [A] = Rx(t)

A = [1,      0,       0, 0;
     0, cos(t), -sin(t), 0;
     0, sin(t),  cos(t), 0;
     0,      0,       0, 1];
 
 
function [A] = Ry(t)

A = [ cos(t), 0, sin(t), 0;
           0, 1,      0, 0;
     -sin(t), 0, cos(t), 0;
           0, 0,      0, 1];
       
       
function [A] = Tz(L)

A = [1,0,0,0;
     0,1,0,0;
     0,0,1,L;
     0,0,0,1];
 
 function [A] = Tx(L)
 
 A = [1,0,0,L;
      0,1,0,0;
      0,0,1,0;
      0,0,0,1];
  
  
  
  function [sub] = ind2subV(size,ind)
  sub = 1;
  
  
  
  
  function ind = sub2indV(dim,sub)
  
  ind = sub(1);
  for i=2:length(sub);
      ind = ind + prod(dim(1:(i-1)))*(sub(i)-1);
  end
  
  
  