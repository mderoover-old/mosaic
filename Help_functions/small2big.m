function [big] = small2big(small,height,width,big_h)
%small2big Covert small 2 big
%   Stich a numch of small images together to form a big image again.
N = size(small,1);
big = zeros(big_h*height,N*width/big_h,3);
[b_h,b_w] = size(big);
index_h = b_h/height;
index_w = b_w/width;
for i = 1:N
    [x,y] = ind2sub([index_h,index_w],i);
    big( (1:height) + (x-1)*height, (1:width) + (y-1)*width ,:) = getSingleImage(small,i,height,width);
end

end

