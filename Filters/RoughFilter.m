function [index_out] = RoughFilter(target,data,index,N,quality)
%RoughFilter A Rough filter
%   Finds the N closest images in LAB space using only a rough
%   approximation.

persistent per_data;

if(isempty(per_data))
    per_data = mean(reshape(data,[],size(data,2)/3,3),2);
end

switch quality
    case 'best' % Extract image indices based on best match of each individual pixel to target image
        values      = sum(abs(data-target),2);
        values      = values(index); % Scrap values of images already in the neighbourhood
        [~,I]       = sort(values);
        I           = I(1:N);
        index_out   = index(I);
    case 'fast' % Extract image indices based on best match of mean color of each image to target image
        new_target  = reshape(target,1,size(data,2)/3,3);
        target_mean = mean(new_target,2);
        err         = abs(per_data - target_mean);
        values      = sum(err,3);
        values      = values(index);
        [~,I]       = sort(values);
        I           = I(1:N);
        index_out   = index(I);
    otherwise
        error(['RoughFilter: ',quality,' isnt a possible quality'])
end
end

