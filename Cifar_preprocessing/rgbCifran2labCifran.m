function [] = rgbCifran2labCifran()
%rgbCifran2labCifran Converts the database to lab space
%   Converts the cifran database 2 labspace
addpath(genpath(pwd))
load train.mat data
N       = size(data,2);
data    = cat(3,data(:,1:N/3),data(:,(1:N/3)+N/3),data(:,(1:N/3)+2*N/3));
data    = rgb2lab(data);
data    = cat(2,data(:,:,1),data(:,:,2),data(:,:,3));
data    = single(data);
save train_lab.mat data
rmpath(genpath(pwd))
end
