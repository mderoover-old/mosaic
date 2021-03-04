function [index_out] = EdgeFilter(target,data,index,N,quality,errorquality,colorSpace)
%EDGEDETECTION Edge Comparison
%   Finds the N closest images in RGB space using the edge properties.

if colorSpace ~= 'RGB'
    error('EdgeFilter: specified colorspace not supported!')
end

hsize = 5;
SIGMA = sqrt(2);
neighbourhoodLocalMax = 1;
T2 = 0.2;
T1 = 0.5;

switch quality
    
    case 'RGB'  %best?

        target = reshape(target,sqrt(size(target,2)/3),sqrt(size(target,2)/3),3);
        target_edge(:,:,1) = cannyEdge(target(:,:,1),hsize,SIGMA,neighbourhoodLocalMax,T2,T1);
        target_edge(:,:,2) = cannyEdge(target(:,:,2),hsize,SIGMA,neighbourhoodLocalMax,T2,T1);
        target_edge(:,:,3) = cannyEdge(target(:,:,3),hsize,SIGMA,neighbourhoodLocalMax,T2,T1);

        data = data(index,:);
        for i = 1 : size(data,1)
            currImg = data(i,:);
            currImg = reshape(currImg,sqrt(size(currImg,2)/3),sqrt(size(currImg,2)/3),3);
            currImg_edge(:,:,1) = cannyEdge(currImg(:,:,1),hsize,SIGMA,neighbourhoodLocalMax,T2,T1);
            currImg_edge(:,:,2) = cannyEdge(currImg(:,:,2),hsize,SIGMA,neighbourhoodLocalMax,T2,T1);
            currImg_edge(:,:,3) = cannyEdge(currImg(:,:,3),hsize,SIGMA,neighbourhoodLocalMax,T2,T1);

            error_(:,:,1) = abs(target_edge(:,:,1) - currImg_edge(:,:,1));
            error_(:,:,2) = abs(target_edge(:,:,2) - currImg_edge(:,:,2));
            error_(:,:,3) = abs(target_edge(:,:,3) - currImg_edge(:,:,3));

            switch errorquality
                case 'intersection'
                    totalError = sum(error_,3);  % R+G+B errors
                    values(i) = sum(sum(totalError));
                case 'euclidian'
                    totalError = sqrt(sum(error_.^2,3)); % sqrt(R^2 + G^2 + B^2)
                    values(i) = sum(sum(totalError));
                otherwise
                    error_(['EdgeDetection: ',quality,' isnt a possible quality'])
            end
        end

    case 'gray' %converts RGB images to grayscale by eliminating the
                %hue and saturation information while retaining the
                %luminance.
                
                %fast?
        
        target = rgb2gray(reshape(target,sqrt(size(target,2)/3),sqrt(size(target,2)/3),3));
        target_edge = cannyEdge(target,hsize,SIGMA,neighbourhoodLocalMax,T2,T1);

        data = data(index,:);
        for i = 1 : size(data,1)
            currImg = data(i,:);
            currImg = rgb2gray(reshape(currImg,sqrt(size(currImg,2)/3),sqrt(size(currImg,2)/3),3));
            currImg_edge = cannyEdge(currImg,hsize,SIGMA,neighbourhoodLocalMax,T2,T1);
            error_ = abs(target_edge - currImg_edge);
            values(i) = sum(sum(error_));
        end

end

[~,I]       = sort(values);
I           = I(1:N);
index_out   = index(I);

end

%         case 'Edge'
%             Filter_index            = EdgeFilter(target,data,rough_index,1,'RGB','intersection',colorSpace);

