function [x] = world2img(X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name        : world2img 
% Description : Project points in 3D space to 2dIage plane
%
%   Input   :  X-points in 3D space
%   Output  :  x- points in image plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Device Intrinsic parameters matrtix
K = [525 0 319.5; 0 -525 239.5; 0 0 1];

x = K*X;

% Homogenize the final coordinates
x = bsxfun(@times,x',1./x(3,:)')';