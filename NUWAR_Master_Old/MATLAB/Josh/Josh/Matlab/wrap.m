%function wrap(p,m)
%
%forms a convex polygon, with edges m, around a set of points, p.


function t = wrap(p1,p2)
t = linspace(0,2*pi)';

p1 = zeros(length(t),2);
p2 = [cos(t),sin(t)];
plot(p2)

t = theta(p1,p2);






% return the pseudoangle between the line from p1 to (infinity, p1.y)
% and the line form p1 to p1.


function t = theta(p1,p2)

X = 1;
Y = 2;


dx = p2(X) - p1(X);
dy = p2(Y) - p1(Y);
if (dx == 0.0) & (dy == 0.0)
    t = -1; %error
else
    t = dy/(abs(dx) + abs(dy));
    if dx < 0.0
        t = 2.0 - t
    else if dy <0.0
            t = 4.0 + t;
        end
    end
end

        