function [index_out] = MSEFilter(target,data,index,N,quality)
%MSEFilter Mean squared error filter
%   Finds the N closest images in LAB space using mean square error.
switch quality
    case 'abs'
        values      = sum(abs(data(index,:)-target),2);
        [~,I]       = sort(values);
        I           = I(1:N);
        index_out   = index(I);
    case 'MSE'
        n      = size(data,2);                        % Amount of data points in image
        values = sum((data(index,:)-target).^2,2)/n;  % Calculate mean square error
        [~,I]  = sort(values);                        % Sort the errors
        I      = I(1:N);                              % Find N lowest errors
        index_out   = index(I);                       % Pass the most N most likely images index-wise
    otherwise
        error(['MSEFilter: ',quality,' isnt a possible quality'])
end
end

