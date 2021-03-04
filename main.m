clear
close all
clc
clear RoughFilter;

%% Initializations
addpath(genpath(pwd))
filterType = 'MSE';
% Options:
    % 'MSE'
    % 'Hist'
    % 'OCCD'
    % 'Edge'
colorSpace = 'RGB';
% Options:
    % 'LAB'
    % 'RGB'
refImg = 'LENA.jpg';

%% Load in big image

switch colorSpace
    case 'LAB'
        load('train_lab.mat','data')                 % Load in cifar100 dataset
        %data = reshape(rgb2lab(reshape(im2double(data),32,[],3)),[],3072,1);
        big = rgb2lab(im2double(imread(refImg)));    % Load in the big image (make sure it's in rgb format)
    case 'RGB'
        load('train.mat','data')
        big = im2double(imread(refImg));
        data = im2double(data);
end

%% Determine small image size 
s_h = 32;                                           % Dimensions of a single small image
s_w = 32;                                           %

%% Resize database
if (s_h~=32 || s_w~=32)
    data = dataRescale(data,32,32,s_h,s_w);         % Rescale the database if necessary
end

%% Convert big image to tons of small images
[big_small,nmbr_h,nmbr_w] = big2small(big,s_h,s_w); % Partition the big image into a set of smaller images; saved in cifar format

%% Convert big_small to an image in small
bs_h         = size(big_small,1);                   % Find dimensions of how many subimages there are
new_big      = zeros(bs_h,size(big_small,2));       % Initialize the eventual result mosaic image; cifar format
data_index   = 1:size(data,1);                      % Index mapping for database imgs
index_img    = zeros(nmbr_h,nmbr_w);                % Saving what image we placed where
neighborhood = 7;                                   % Radius of the square neighborhood for nonreocurring images

tic
f = waitbar(0,'Constructing Mosaic...');
for index = 1:bs_h
    %% First rough filter using mean
    target                          = big_small(index,:);
    neighborhood_index              = neighborhoodFilter(data_index,index,index_img,neighborhood);
    rough_index                     = RoughFilter(target,data,neighborhood_index,500,'fast');
    switch filterType
        case 'MSE'
            Filter_index            = MSEFilter(target,data,rough_index,1,'MSE');
        case 'Hist'
            Filter_index            = HistFilter(target,data,rough_index,1,'intersection');
        case 'OCCD'
            Filter_index            = OCCDFilter(target,data,rough_index,1,'std',colorSpace,s_h,s_w);
        case 'Edge'
            Filter_index            = EdgeFilter(target,data,rough_index,1,'RGB','intersection',colorSpace);
        otherwise
            error(['main: ' filterType ' is not a valid filter option!'])
    end
    new_big(index,:)                = data(Filter_index,:);
    index_img(index)                = Filter_index;
    waitbar(index/(bs_h),f);
end
close(f);
toc

figure
switch colorSpace
    case 'LAB'
        new_big_show = lab2rgb(small2big(new_big,s_h,s_w,nmbr_h));
    case 'RGB'
        new_big_show = small2big(new_big,s_h,s_w,nmbr_h);
end
imshow(new_big_show);

%% Closure
rmpath(genpath(pwd))
%% Sources:

% Cifar database:   Alex Krizhevsky. "Learning Multiple Layers of Features from Tiny Images", 2009
% OCCD method:      Aleksandra Mojsilovic and Jianying Hu. "A method for color content matching of images." Multimedia and Expo, 2000. ICME 2000. 2000 IEEE International Conference on. Vol. 2. IEEE, 2000.
% Canny Edge method: Adrian Munteanu, Quentin Bolsee, Athanasia Symeonidou, "Image Processing Excercises 2018", §4.1.6, 2018