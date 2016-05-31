function [retval]=gradhistintegral(img,qnum)
%
% gradimageintegral - computes gradient histogram integral image
%
% Inputs:
%   img: original gray-value image to process
%   qnum: number of gradient orientations bins
%
% Outputs:
%   retval: weighted integral gradient image of histograms
%
% File: gradhistintegral.m
% Author: Evren KANALICI
% Date: 15/05/2016
% Computer Eng. - Computer Vision, Spring '16
% Yildiz Technical University
%

[nrow, ncol] = size(img);

% calculate gradients
DX = diff(img,1,1);      % derivative on x-axis
DX = [zeros(1,ncol);DX]; % insert zero-row
DY = diff(img,1,2);      % derivative on y-axis
DY = [zeros(nrow,1) DY]; % insert zero-col

% gradient magnitudes
Igradmag = sqrt(DX .^2 + DY .^2);

% gradient phases
DX(DX==0) = eps('double'); % before atan calc.
Igradphase = atan(DY ./ DX);
[nnan, ~] = size(find(isnan(Igradphase)));
assert(nnan==0); % assert no NaN available

%%%
% quantize gradient orientations (generate binary gradient histograms)
%%%
Ij = zeros(nrow,ncol,qnum);
for r=1:nrow
    for c=1:ncol
        Ij(r,c,:) = quantize(qnum, Igradphase(r,c));
    end
end

%%%
% weight gradient orientations with magnitudes
%%%
Ij_weighted = zeros(nrow,ncol,qnum);
for q=1:qnum
    Ij_weighted(:,:,q) = Ij(:,:,q).*Igradmag;
end

retval = cumsum(cumsum(Ij_weighted,1),2); % integral of gradient histograms

end


function [q]=quantize(qnum,phase)
%
% quantize - quantize gradient orientations to histogram (binary histogram)
%
% Inputs:
%   qnum: number of bins for histogram
%   phase: gradient orientation in rads. (could be negative)
%
% Ouputs:
%   q: quantized histogram of orientations (1D array of qnum size)
%

% compute orientation layers I1...n such that Ij has values 1 for all image pixels
% with gradient orientation j and zeros otherwise
h = zeros(1, qnum);

% normalize phase (negative and zero values)
if phase<0
    phase=phase+pi;
elseif phase==0
    phase=eps; 
end

step=pi/qnum; % step size of histogram
h(ceil(phase/step))=1; % place phase in histogram

q = h;

end
