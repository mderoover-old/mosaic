function [index_out] = HistFilter(target,data,index,N,quality)
%HistFilter Histogram filter
%   Finds the N closest images in RGB space using histograms of color occurrence.

binsedges = linspace(0,1,257);

target = reshape(target,1,size(target,2)/3,3);
targetR = target(:,:,1);
targetG = target(:,:,2);
targetB = target(:,:,3);
target_histR = histcounts(targetR,binsedges,'Normalization','probability');
target_histG = histcounts(targetG,binsedges,'Normalization','probability');
target_histB = histcounts(targetB,binsedges,'Normalization','probability');

data = data(index,:);
for i = 1 : size(data,1)
    currImg = data(i,:);
    currImg = reshape(currImg,1,size(currImg,2)/3,3);
    currImgR = currImg(:,:,1);
    currImgG = currImg(:,:,2);
    currImgB = currImg(:,:,3);
    currImg_histR = histcounts(currImgR,binsedges,'Normalization','probability');
    currImg_histG = histcounts(currImgG,binsedges,'Normalization','probability');
    currImg_histB = histcounts(currImgB,binsedges,'Normalization','probability');
    
    errorR = abs(target_histR - currImg_histR);
    errorG = abs(target_histG - currImg_histG);
    errorB = abs(target_histB - currImg_histB);

    switch quality
        case 'intersection'
            totalError = errorR + errorG + errorB;
            values(i) = sum( totalError );
        case 'euclidian'
            totalError = sqrt(errorR.^2 + errorG.^2 + errorB.^2);
            values(i) = sum( totalError );
        otherwise
            error(['HistFilter: ',quality,' isnt a possible quality'])
    end
end

[~,I]       = sort(values);
I           = I(1:N);
index_out   = index(I);

end
