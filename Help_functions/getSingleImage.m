function [image] = getSingleImage(images,index,s_h,s_w)
%getSingleImage Get a single image
%   Get a single Image out of a series of images in cifar notation.
%   Output image is in standard matlab RGB format
[M,~] = size(images);
if(index>M)
   error('GetSingleImage: index out of range');
end
image = permute(reshape(images(index,:),s_h,s_w,3),[2 1 3]);
end

