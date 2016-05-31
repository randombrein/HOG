function [overlay]=drawframe(I,x1,y1,x2,y2)
%
% drawframe - function to overlay image with frames defined with two corner points
%
% Inputs:
%   I: Image to be processed
%   x1: top-left point x pos. of the frame
%   y1: top-left point y pos. of the frame
%   x2: bottom-right point x pos. of the frame
%   y2: bottom-right point y pos. of the frame
%
% Outputs:
%   overlay: overlay image with frames drawed
%
% File: drawframe.m
% Author: Evren KANALICI
% Date: 15/05/2016
% Computer Eng. - Computer Vision, Spring '16
% Yildiz Technical University
%
rows=size(I,1); % row count
cols=size(I,2); % column count

% x-positions & y-positions to iterate
xs=[x1:x2, ones(1,y2-y1)*(x2), x1:x2, ones(1,y2-y1)*x1];
ys=[ones(1,x2-x1)*y1, y1:y2, ones(1,x2-x1)*(y2), y1:y2];
assert(size(xs,2)==size(ys,2));


% IF any frame that does not fit inside the image THEN no-op
if any(xs>=rows) || any(ys>=cols) || any(xs<=1) || any(ys<=1)
    overlay=I;
    % fprintf('[%d,%d %d%,d] frame that does not fit inside the image\n',x1,y1,x2,y2);
    return
end

% iterate and mark
for i=1:size(xs,2)
    I(xs(i),ys(i))=1; % white pixels for overlay
end

overlay=I;
