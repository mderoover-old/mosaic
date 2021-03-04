function [index_out] = OCCDFilter(target,data,index,N,quality,colorSpace,s_h,s_w)
%OCCDFilter Summary of this function goes here
%   Detailed explanation goes here

%% Initializations

if s_h ~= s_w
    error('OCCDFilter: subimages need to be of square dimensions!')
end

if colorSpace ~= 'RGB'
    error('OCCDFilter: specified colorspace not supported!')
end

target = im2uint8(target);
data = im2uint8(data(index,:));

%% Color Codebook Design - Quantization

CBsize      = 99;                                           % Codebook size - max: 256x256x256 = 16 777 216
quantBins   = nthroot(CBsize,3);                            % Nmbr of quantization bins along each axis
binSize     = round(256/quantBins);                         % Size of each bin
partition   = 0:binSize:255;                                % Partition for the 1D color axes
codebook    = [0 partition(2:end)-round(binSize/2) 255];    % Contains value that each bin wil be mapped to

[target_quant_sub, ~,~] = quantiz(target,partition,codebook);           % Cifar format
target_quant_sub = target_quant_sub+1;                      % Indexing is from 0, 1, 2, ...,N-1 => +1 to allow subscript interpretation

% Mapping of 3D quantized subscripts to a 1D index indicating color in 3D codebook space
target_quant_indx = CBsub2ind(target_quant_sub,length(codebook),s_h,s_w);           % Row-major format

data_quant = zeros(size(data));
data_quant_sub = zeros(size(data));
data_quant_indx = zeros([size(data,1),size(data,2)/3]);
for i = 1 :size(data,1)
    [data_quant_sub(i,:), data_quant(i,:) ,~] = quantiz(data(i,:),partition,codebook);
    data_quant_sub(i,:) = data_quant_sub(i,:)+1;            % Indexing is from 0, 1, 2, ...,N-1 => +1 to allow subscript interpretation
    % Mapping of 3D quantized subscripts to a 1D index indicating color in 3D codebook space
    data_quant_indx(i,:) = CBsub2ind(data_quant_sub(i,:),length(codebook),s_h,s_w); % Row-major format
end


%% Extracting Visually Dominant Colors

% Note: the MH method partitions images in NxN subimages (N~20), since the
% database subimages used in this project are of this order of magnitude, a
% sufficient partition has already been executed and does not need to be
% repeated

D = 5;      % Occurence Neighbourhood

% ----- Target Image Color Remapping ----- %
target_quant_remap_indx = reshape(colorRemap(D,target_quant_indx,s_h,s_w) , [1,s_h*s_w]);

% ----- Data Images Color Remapping ----- %
for i = 1 : size(data,1)
    data_quant_remap_indx(i,:) = reshape(colorRemap(D,data_quant_indx(i,:),s_h,s_w) , [1,s_h*s_w]);
end


%% Optimal Color Composition Distance (OCCD)

% ----- Target QCC definition ----- %
% Color Components Definition
CC_target = makeCC(target_quant_remap_indx); % Color Components list CC = [I,P]; I = CB index, P = area percentage

% Quantized Color Components(Color Unit) Definitions
n = 20;         % number of color units
p = 0.05;       % area percentage of each color unit
binsPerCC_target = ceil(CC_target(:,2)/p);
QCC_target = makeQCC(CC_target,binsPerCC_target,n);
QCC_target_sub = CBind2sub(QCC_target,length(codebook),1,length(QCC_target));
QCC_target_sub = reshape(QCC_target_sub,[],3);

% ----- Data QCC definition ----- %
minMD = inf;    % Definition of single data QCC matrix impossible due to mismatch in dimensions (they all have different amount of colors)
minInd = NaN;   % Min distance and Index cannot be found by sort
for i = 1 : size(data,1)
    CC_data = makeCC(data_quant_remap_indx(i,:));
    binsPerCC_data = ceil(CC_data(:,2)/p);
    QCC_data = makeQCC(CC_data,binsPerCC_data,n);
    QCC_data_sub = CBind2sub(QCC_data,length(codebook),1,length(QCC_data));
    QCC_data_sub = reshape(QCC_data_sub,[],3);
    
    W = sqrt(sum((QCC_target_sub - QCC_data_sub).^2 , 2));
    MD = sum(W);
    if MD < minMD
        minMD = MD;
        minInd = i;
    end
end

index_out = index(minInd);

end