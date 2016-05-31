function [hog]=hogintegral(ghistintegral,frame,nx,ny)
%
% hogintegral - computes HOG descriptors for given hist. interal image window
%
% Inputs:
%   ghistintegral: 3-D integral gradient histogram image 
%   bbox: image window represented as [x1 y1 x2 y2]
%   nx,ny: number of (equal-size) descriptor cells along x and y window dimensions
%
% Outputs:
%   hog: concat'ed 1D vector of HOG descriptions.
%
% File: hogintegral.m
% Author: Evren KANALICI
% Date: 15/05/2016
% Computer Eng. - Computer Vision, Spring '16
% Yildiz Technical University
%

% frame positions
x1=frame(1);
y1=frame(2);
x2=frame(3);
y2=frame(4);

% subpatch width & height
xstep = (x2-x1)/nx;
ystep = (y2-y1)/ny;

qnum=size(ghistintegral, 3); % bin size
desc=zeros(nx,ny, qnum); % HOG description matrix

for r=0:nx-1
    for c=0:ny-1
        % subpatch positions for integral image calculation
        p11 = [x1+(r+0)*xstep   y1+(c+0)*ystep];
        p12 = [x1+(r+0)*xstep   y1+(c+1)*ystep];
        p21 = [x1+(r+1)*xstep   y1+(c+0)*ystep];
        p22 = [x1+(r+1)*xstep   y1+(c+1)*ystep];

        % calculate histogram for the subpatch (using integral image)
        hist=ghistintegral(p11(1), p11(2), :) + ghistintegral(p22(1), p22(2), :) ...
                - ghistintegral(p12(1), p12(2), :) - ghistintegral(p21(1), p21(2), :);

        % L2-normalized histogram
        desc(r+1,c+1,:)=hist/norm(hist(:,:));
    end
end

% convert description to 1D of histograms (nx,ny,qnum) -> (nx*ny,qnum)
hog=reshape(desc,size(desc,1)*size(desc,2),size(desc,3));
