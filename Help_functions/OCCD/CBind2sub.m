function [SUB] = CBind2sub(IND,CBlength,s_h,s_w)
%CBind2sub CB index to subscript mapping
%   Maps every index in the CB space to the corresponding subscripts,
%   indicating the color;
%   Input is row vector that stores image CB indices in row-major order, 
%   output is in Cifar notation (3x length of input)
SUB = zeros(1,length(IND)*3);
for i = 1 : length(IND)
    [SUB(i),SUB(i+s_h*s_w),SUB(i+2*s_h*s_w)] = ind2sub([CBlength,CBlength,CBlength],IND(i));
end
end

