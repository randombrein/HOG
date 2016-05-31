% Implementation of a variant of Histograms of Oriented Gradients (HOG) object detector
% by Dalal&Trigggs.[1] Computing HOG algorithm efficiently using integral gradient images,
% which are analogous to the standard integral image (Viola&Jones, Section 2).[2]
%
% 1 - Read images (template & match)
% 2 - Calculate gradient histogram integrals & HOG distances
% 3 - Outline images with frames
%
% File: test_script.m
% Author: Evren KANALICI
% Date: 15/05/2016
% Computer Eng. - Computer Vision, Spring '16
% Yildiz Technical University
%
%

%% 1 - Read images (template & match)
RGBt = imread('car1.png');
It = im2double(rgb2gray(RGBt)); % template image
RGBm = imread('car2.png');
Im = im2double(rgb2gray(RGBm)); % match image

subplot(2,2,1);
imshow(RGBt);
title('template image');
subplot(2,2,2);
imshow(RGBm);
title('match image');
subplot(2,2,3);
imshow(It);
subplot(2,2,4);
imshow(Im);


%% 2 - Calculate gradient histogram integrals & HOG distances
QNUM=9; % number of orientatition quantization bins
NX=4; % number of x-subpatches in a window frame
NY=4; % number of y-subpatches in a window frame
TPATCH=[98 50 98+24 50+24]; % template patch frame (handled manually)
STEPSIZE=4; % step size for scanning

%------------------------------------------------------
tic; 

patch=TPATCH;
ghistintegral=gradhistintegral(It,QNUM); % template-image gradient hist. integral
hog_template=hogintegral(ghistintegral,patch,NX,NY); % template-image HOG desc.

ghistintegral=gradhistintegral(Im,QNUM); % match-image gradient hist. integral

[nrow, ncol] = size(Im);
rlen = patch(3)-patch(1); % window frame row lenght
clen = patch(4)-patch(2); % window frame col. lenght

%%%
% scan match image with STEPSIZE
%%%
rs=1:STEPSIZE:nrow-rlen;
cs=1:STEPSIZE:ncol-clen;
ds=zeros(size(rs,2),size(cs,2)); % HOG distances
for r=rs
    for c=cs
        patch=[r c r+rlen c+clen]; % scanning frame (constant size)

        % match-image HOG desc.
        hog=hogintegral(ghistintegral,patch,NX,NY);

        % HOG-distances for current frame
        ds(ceil(r/STEPSIZE),ceil(c/STEPSIZE))=hogdistance(hog,hog_template);
    end
end

timespent = toc;
%------------------------------------------------------

% print min. HOG distance
fprintf('- min. HOG distance [STEPSIZE:%d]: %.4f\n',STEPSIZE,min(min(ds)));
fprintf('- time spent: %.4f\n', timespent);


%% 3 - Outline images with frames
HOGTHRS=11; % histogram distance threshold

% outline template patch
overlay = drawframe(It,TPATCH(1),TPATCH(2),TPATCH(3),TPATCH(4));
subplot(1,2,1);
imshow(overlay);
title('template image');

[ix,iy]=find(ds<HOGTHRS); % indices for below threshold
n=size(ix,1);

% outline matched patches that below threshold
overlay=Im;
for i=1:n
    % overlay patches which hogdistance are below HOGTHRS
    x1=(ix(i)-1)*STEPSIZE+1;
    y1=(iy(i)-1)*STEPSIZE+1;
    overlay=drawframe(overlay,x1,y1,x1+rlen,y1+clen);
end

fprintf('#%d patches found [HOG dist. threshold=%.2f]\n',n,HOGTHRS);
subplot(1,2,2);
imshow(overlay);
title('match image');

