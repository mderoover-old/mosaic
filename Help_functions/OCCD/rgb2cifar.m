function [Cifar] = rgb2cifar(RGB)
%RGB2Cifar Changes the format of an image from RGB to Cifar
%   Changes the format of an image from RGB to Cifar

h = size(RGB,1);
w = size(RGB,2);

Cifar = zeros(1,w*h*3);

for r = 1 : h
    Cifar(1+(r-1)*w : (r-1)*w+w) = RGB(r,:,1);
    Cifar(1+(r-1)*w+w*h : (r-1)*w+w*h+w) = RGB(r,:,2);
    Cifar(1+(r-1)*w+2*w*h : (r-1)*w+2*w*h+w) = RGB(r,:,3);
end

end

