%% Initializations
clear
close all
clc
addpath(genpath(pwd))
load('train_lab.mat','data')                        % Load in cifran100 dataset

%% Test

target  = data(1,:);
index   = 1:size(data,1);
N = 5;

tic
index_rough_best = MSEFilter(target,data,index,N,'fast');
toc

tic
index_rough_fast = MSEFilter(target,data,index,N,'slow');
toc

% tic
% index_rough_poor = RoughFilter(target,data,index,N,'poor');
% toc

h = 32;
w = 32;
figure()
subplot(3,N+1,1)
showImageCifar(target,1,h,w);
subplot(3,N+1,1+N+1)
showImageCifar(target,1,h,w);
subplot(3,N+1,1+2*(N+1))
showImageCifar(target,1,h,w);
for i = 2:N+1
    subplot(3,N+1,i)
    showImageCifar(data(index_rough_best,:),i-1,h,w);
    subplot(3,N+1,i+N+1)
    showImageCifar(data(index_rough_fast,:),i-1,h,w);
    subplot(3,N+1,i+2*(N+1))
    showImageCifar(data(index_rough_fast,:),i-1,h,w);
end

%% Closure
rmpath(genpath(pwd))