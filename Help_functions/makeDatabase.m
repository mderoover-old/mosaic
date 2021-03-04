function [] = makeDatabase(dest_name,h,w,type)
%makeDatabase Create database
%   Create a databse from all source images in the dource_directory. Images
%   are rescaled to h x w. Type can be 'rgb' or 'lab'.
addpath(genpath(pwd))

selpath         = uigetdir([],'Choose the map with all images');    % Open window to select path
dinfo           = dir(selpath);                                     % Get dir info
image_paths     = {dinfo.name};                                     % Get names of all files
image_paths     = strcat(selpath,'/',image_paths);                  % Create paths
image_paths     = image_paths(contains(image_paths,'.jpg')...       % Only accept jpg images
                             |contains(image_paths,'.png'));        % Or png images
data            = zeros(size(image_paths,2),h*w*3);                 % Initialize data

f = waitbar(0,'Preparing for world domination...');
for i = 1:size(data,1)
    switch type
        case 'rgb'
            img = im2double(imread(image_paths{i}));                % Read in image, suppose it is rgb format
            img = imresize(img,[h,w]);                              % Rescale image
            data(i,:) = reshape(permute(img,[2 1 3]),1,h*w*3,1);    % Write to data
        case 'lab'
            img = im2double(imread(image_paths{i}));                % Read in image, suppose it is rgb format
            img = rgb2lab(imresize(img,[h,w]));                     % Rescale and convert to lab space
            data(i,:) = reshape(permute(img,[2 1 3]),1,h*w*3,1);    % Write to data
        otherwise
            error('Type isnt supported')
    end
    waitbar(i/size(data,1),f);
end
close(f);
save(dest_name,'data');
rmpath(genpath(pwd))
end

