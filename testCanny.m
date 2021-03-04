close all

addpath(genpath(pwd))

% load('train.mat')
% 
% pic = getSingleImage(data,123,32,32);
% pic = im2double(pic);
% pic = rgb2gray(pic);

lena = im2double(imread('Big3.jpg'));
lena = rgb2gray(lena);

T1 = 0.5;
T2 = 0.2;
edgemap = cannyEdge(lena,5,sqrt(2),1,T2,T1);

% figure
% subplot(1,3,1)
% imshow(edgemap(:,:,1));
% subplot(1,3,2)
% imshow(edgemap(:,:,2));
% subplot(1,3,3)
% imshow(edgemap(:,:,3));

figure
subplot(1,2,1)
imshow(edgemap);
subplot(1,2,2)
imshow(edge(lena,'canny',[T2 T1],sqrt(2)));

rmpath(genpath(pwd))