function [distance]=hogdistance(descA, descB)
%
% hogdistance - computes Euclidian distance between two HOG descriptions
% Input
%   descA: HOG description vector
%   descB: HOG description vector
% Output
%   distance: distance between two HOG description vectors.
%
% File: hogdistance.m
% Author: Evren KANALICI
% Date: 15/05/2016
% Computer Eng. - Computer Vision, Spring '16
% Yildiz Technical University
%
[nhist, qnum]=size(descA);
[nhistB, qnumB]=size(descB);
assert(nhist==nhistB && qnum==qnumB); % assert sizes are eqaul

% calculate euclidian distance between histograms for each patch
d=0;
for i=1:nhist
    d = d + sqrt(sum((descA(i,:)-descB(i,:)).^2));
end

distance=d;
end
