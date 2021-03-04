function [small,nmbr_h,nmbr_w] = big2small(big,height,width)
%big2small Covert big to small
%   Convert the big image to a ton of small images of size height*width.
%   If this doesn't perfectly fit in big then the remaining pixels are
%   discarded.
%   Small output image is in cifar format, every row contains RGB (LAB) vectors of the corresponding sub image of the big input image.
[b_h,b_w,~] = size(big);
big = big(1:height*floor(b_h/height),1:width*floor(b_w/width),:);   % Drop remaining pixels if fit isn't perfect
small = zeros(numel(big)/(height*width*3),(height*width*3));        % cifar format
[b_h,b_w,~] = size(big);
nmbr_h = b_h/height;       % Nmbr of subimages along h direction
nmbr_w = b_w/width;        % Nmbr of subimages along w direction
for i = 1:size(small,1)
    [x,y] = ind2sub([nmbr_h,nmbr_w],i);
    small(i,:) = reshape(  permute(  big( (1:height) + (x-1)*height, (1:width) + (y-1)*width ,:)  ,[2 1 3] ),1,[],1);
end
end

