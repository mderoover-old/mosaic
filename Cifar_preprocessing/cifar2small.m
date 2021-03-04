function [] = cifar2small()
%cifar2small Convert Cifar100
%   Cifar100 has an image on every line. Convert this to a more useful
%   notation having a cell array of small images. And save this to a mat
%   file.
clear
close all
clc
addpath(genpath(pwd))
load('train.mat','data')
data    = im2double(data);
[M,~] = size(data);
small = cell(1,M);
f = waitbar(0,'Converting cifar to cell array...');
for i = 1:M
    temp = reshape(data(i,:)',32,[])';
    small{i} = cat(3,temp(1:32,:),temp(33:64,:),temp(65:96,:));
    waitbar(i/M,f);
end
waitbar(i/M,f,'Saving result, please wait...');
save('cifar100_processed.mat','small');
rmpath(genpath(pwd))
close(f);
end

