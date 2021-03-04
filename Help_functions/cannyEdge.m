function [ EdgeMap ] = cannyEdge(I,hsize,SIGMA,neighbourhoodLocalMax,T2,T1)
%Canny Edge Detector - Detects the edges of a (greyscale) image
%   The optimal edge detector under three conditions:
%    * Maximum SNR of the result
%    * Optimal localization
%    * Minimal number of multiple response errors (the same edge is
%      detected several times).


%% 1. Filter the image with a Gaussian filter

HSIZE = [hsize hsize];
h = fspecial('gaussian',HSIZE,SIGMA);
Ifilt = imfilter(I,h,'replicate','same','conv');

%% 2. Define the gradient magnitude and gradient direction of the result

h = fspecial('sobel')*(-1);
gradientmagnitude = sqrt(imfilter(Ifilt,h,'replicate','same','conv').^2+imfilter(Ifilt,h','replicate','same','conv').^2);
gradientdirection = atan(imfilter(Ifilt,h','replicate','same','conv')./imfilter(Ifilt,h,'replicate','same','conv'));

%% 3. Non-maxima suppression

gradientmagnitude = [zeros(neighbourhoodLocalMax,size(gradientmagnitude,2)); gradientmagnitude; zeros(neighbourhoodLocalMax,size(gradientmagnitude,2))];
gradientmagnitude = [zeros(size(gradientmagnitude,1),neighbourhoodLocalMax) gradientmagnitude zeros(size(gradientmagnitude,1),neighbourhoodLocalMax)];

gradientdirection = [zeros(neighbourhoodLocalMax,size(gradientdirection,2)); gradientdirection; zeros(neighbourhoodLocalMax,size(gradientdirection,2))];
gradientdirection = [zeros(size(gradientdirection,1),neighbourhoodLocalMax) gradientdirection zeros(size(gradientdirection,1),neighbourhoodLocalMax)];

EdgeMapDir = zeros(size(gradientmagnitude));

for i = neighbourhoodLocalMax+1:size(gradientmagnitude,1)-neighbourhoodLocalMax
    for j = neighbourhoodLocalMax+1:size(gradientmagnitude,2)-neighbourhoodLocalMax
        temp = zeros(2*neighbourhoodLocalMax+1,1);
        temp(1) = gradientmagnitude(i,j);
        if (pi/8 <= gradientdirection(i,j) && gradientdirection(i,j) < 3*pi/8) || (-7*pi/8 >= gradientdirection(i,j) && gradientdirection(i,j) > -5*pi/8)
            for k = 1:neighbourhoodLocalMax
                temp(2*k) = gradientmagnitude(i+k,j+k);
                temp(2*k+1) = gradientmagnitude(i-k,j-k);
            end
            if gradientmagnitude(i,j) ~= max(temp)
                gradientmagnitude(i,j) = 0;
            end
            EdgeMapDir(i,j) = 1;
        elseif (3*pi/8 <= gradientdirection(i,j) && gradientdirection(i,j) < 5*pi/8) || (-5*pi/8 >= gradientdirection(i,j) && gradientdirection(i,j) > -3*pi/8)
            if gradientmagnitude(i,j) ~= max(gradientmagnitude(i,j-neighbourhoodLocalMax:j+neighbourhoodLocalMax))
                gradientmagnitude(i,j) = 0;
            end
            EdgeMapDir(i,j) = 2;
        elseif (5*pi/8 <= gradientdirection(i,j) && gradientdirection(i,j) < 7*pi/8) || (-3*pi/8 >= gradientdirection(i,j) && gradientdirection(i,j) > -1*pi/8)
            for k = 1:neighbourhoodLocalMax
                temp(2*k) = gradientmagnitude(i+k,j-k);
                temp(2*k+1) = gradientmagnitude(i-k,j+k);
            end
            if gradientmagnitude(i,j) ~= max([gradientmagnitude(i,j) gradientmagnitude(i+1,j-1) gradientmagnitude(i-1,j+1) gradientmagnitude(i+2,j-2) gradientmagnitude(i-2,j+2)])
                gradientmagnitude(i,j) = 0;
            end
            EdgeMapDir(i,j) = 3;
        else % -pi/8 to pi/8, 7pi/8 to 9pi/8 (-7pi/8)
            if gradientmagnitude(i,j) ~= max(gradientmagnitude(i-neighbourhoodLocalMax:i+neighbourhoodLocalMax,j))
                gradientmagnitude(i,j) = 0;
            end
            EdgeMapDir(i,j) = 0;
        end
    end
end

EdgeMap_ = gradientmagnitude(neighbourhoodLocalMax+1:size(gradientmagnitude,1)-neighbourhoodLocalMax,neighbourhoodLocalMax+1:size(gradientmagnitude,2)-neighbourhoodLocalMax);
EdgeMapDir = EdgeMapDir(neighbourhoodLocalMax+1:size(gradientmagnitude,1)-neighbourhoodLocalMax,neighbourhoodLocalMax+1:size(gradientmagnitude,2)-neighbourhoodLocalMax);

%% 4. Thresholding with hysteresis

EdgeMap = zeros(size(EdgeMap_));
for i = 1:size(EdgeMap_,1)
    for j = 1:size(EdgeMap_,2)
        if EdgeMap_(i,j) > T1
            switch EdgeMapDir(i,j)
                case 0
                    i_it = 1;
                    j_it = 0;
                case 1
                    i_it = 1;
                    j_it = -1;
                case 2
                    i_it = 0;
                    j_it = 1;
                case 3
                    i_it = 1;
                    j_it = 1;
                otherwise
                    error('Error in cannyEdge: direction not possible')
            end
            i_ = i;
            j_ = j;
            while EdgeMap_(i_,j_) > T2
                EdgeMap(i_,j_) = 1;
                i_ = i_ + i_it;
                j_ = j_ + j_it;
                if i_ > size(EdgeMap_,1) || i_ < 1 || j_ > size(EdgeMap_,2) || j_ < 1
%                         warning('i_ or j_ out of bounds')
                    break;
                end
            end
            i_ = i;
            j_ = j;
            while EdgeMap_(i_,j_) > T2
                EdgeMap(i_,j_) = 1;
                i_ = i_ - i_it;
                j_ = j_ - j_it;
                if i_ > size(EdgeMap_,1) || i_ < 1 || j_ > size(EdgeMap_,2) || j_ < 1
%                         warning('i_ or j_ out of bounds')
                    break;
                end
            end
        end
    end
end

end

