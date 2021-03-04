function [data_index_out] = neighborhoodFilter(data_index,target_index,index_img,neighborhood)
%neighborhoodFilter Filters out already used images in neighborhood
%   Filters out already used images in neighborhood.
%   Output data_index_out contains only the image indices of images not yet in the
%   neighbourhood
[ind_h,ind_w]             = size(index_img);
[h,w]                     = ind2sub([ind_h,ind_w],target_index);
h_ind1                    = max([1,h-neighborhood]);        % Defining bounds of neighbourhood
h_ind2                    = min([ind_h,h+neighborhood]);    % Defining bounds of neighbourhood
w_ind1                    = max([1,w-neighborhood]);        % Defining bounds of neighbourhood
w_ind2                    = min([ind_w,w+neighborhood]);    % Defining bounds of neighbourhood
ind                       = ind_h * ((w_ind1:w_ind2)-1) + (h_ind1:h_ind2)';
indexes                   = index_img(ind(:));              % Retreive indices of imgs used in neighbourhood
data_index_out            = data_index(~sum(reshape(data_index,1,[])==reshape(indexes,[],1)));
                                                            % Scrap from data_index all elements that are also in indices
end

