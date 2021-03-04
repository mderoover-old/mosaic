function [IND] = CBsub2ind(SUB,CBlength,s_h,s_w)
%CBsub2ind CB subscript to index mapping
%   Maps every subscript triplet in the CB space to a unique index,
%   indicating the color;
%   Input is Cifar notation, output is row vector that stores image
%   row-major order, but has 1/3 of the Cifar notation length
IND = zeros(1,size(SUB,2)/3);
for i = 1 : length(IND)
    IND(i) = sub2ind([CBlength,CBlength,CBlength],SUB(i),SUB(i+s_h*s_w),SUB(i+2*s_h*s_w));
end
end

