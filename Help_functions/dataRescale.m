function [data_out] = dataRescale(data,h,w,h_new,w_new)
%dataRescale Rescale data
%   Rescales data in the cifar format
%   Both input and output data have cifar format
N = size(data,1);
data_out = zeros(N,h_new*w_new*3);
f = waitbar(0,'Rescaling the entire database...');
for i = 1:N
   img = imresize(getSingleImage(data,i,h,w),[h_new,w_new]); % RGB format
   data_out(i,:) = reshape(permute(img,[2 1 3]),1,h_new*w_new*3,1); % Reshape to cifar format; permute to cancel permute in getSingleImage
   waitbar(i/N,f);
end
close(f);

end

