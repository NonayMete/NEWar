% Plotframe.m
% function frame = plotframe(T, xname, yname, zname, s)
% where:	s is the s arg to 'plot' like 'b-'
%			T is the 4x4 matrix representing the coordinate frame
%			xname, yname, zname are the labels to be attached to the axes
% NB:	(frame is in format: XoYoZ)

function frame = plotframe(T, xname, yname, zname, s)

length = 0.15;

base = [length,0,0,0,0;
        0,0,length,0,0;
        0,0,0,0,length;
        1,1,1,1,1];

frame = T * base;

if nargin < 5, s = 'b-'; end

%	Draw frame with one line.
h = plot3(frame(1,:), frame(2,:), frame(3,:), s);
set(h,'handlevisibility','off');

%	Label axes
h = text(frame(1,1), frame(2,1), frame(3,1), xname);
set(h,'handlevisibility','off');
h = text(frame(1,3), frame(2,3), frame(3,3), yname);
set(h,'handlevisibility','off');
h = text(frame(1,5), frame(2,5), frame(3,5), zname);
set(h,'handlevisibility','off');

