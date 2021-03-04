function [data_out,index_out] = removeRows(data,index,i_array)
%removeRows Remove rows from a matrix
%   Removes a row from a matrix
index_array = ~sum(1:size(data,1) == reshape(i_array,[],1));
data_out    = data(index_array,:);
index_out   = index(index_array);
end

