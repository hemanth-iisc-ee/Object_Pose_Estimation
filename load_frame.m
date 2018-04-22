function [ X, I, I_lab] = load_frame( img_path, pc_path, seg_mask_path, sd, se)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name        : load_frame 
% Description : function to load a frame from dataset
%              (URL= https://www.dtic.ua.es/~agarcia/projects/multisensor_dataset)
%
%   Input   :   img_path = path to the color image
%               pc_path = path to the point cloud file
%               seg_mask_path = path to object segmentation mask file
%               sd = seg mask dilation structuring elemnt (morphological operation)
%               se = seg mask erosion structuring elemnt
%
%   Output  :   X = 3D coordinates of scanned points
%               I_lab = normalized image pixel intensities in LAB space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = imread(img_path);% Read image
pc = pcread(pc_path);% read point cloud
mask = dlmread(seg_mask_path);% read object segmentation mask
mask = mask(2:end,:);
% object mask preprocessing
mask = imdilate(mask,sd);% Dilation
mask = imerode(mask,se);% erosion

[r,c,~] = size(I);
n = r*c;

tmp = reshape(mask,[n,1]);
idx = find(tmp ~= 0)';

X = pc.Location; % extract only to pixel coordinates 
X = permute(X,[2,1,3]);
    
X = reshape(X,[n,3])';
idx = setdiff(idx,intersect(idx,find(isnan(sum(X)))));   
    
X = double(X(:,idx));

I_lab = reshape(rgb2lab(I),[n,3])';% convert to LAB space
I_lab = double(I_lab(:,idx))/255;% Normalize

end

