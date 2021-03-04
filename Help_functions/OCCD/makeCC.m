function [CC] = makeCC(quant_indx)
%makeCC Creates color component list of a quantized and indexed image
%   Creates color component list of a quantized and indexed image

CC = unique(quant_indx).';
for i = 1 : size(CC,1)
    CC(i,2) = sum(quant_indx(:,:) == CC(i,1)) / numel(quant_indx);
end
end

