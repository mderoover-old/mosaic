function [] = showImageCifar(data,i,h,w)
%showImageCifar Show image
%   Show image that is saved in cifar notation with index i and width w,
%   height h. Uses lab sapce.
imshow(getSingleImage(data,i,h,w));
end

