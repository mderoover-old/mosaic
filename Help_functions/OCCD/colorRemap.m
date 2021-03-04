function [quant_remap_indx] = colorRemap(D,quant_indx,s_h,s_w)
%colorRemap Remaps colors of an image to perceptually dominant colors
%   Takes as input the quantized index image matrices (and their dimensions)
%   and gives as output the quantized index matrix where speckle colors have
%   been remapped to dominant colors of the image;
%   D is the size of the DxD occurence neighbourhood

quant_remap_indx = reshape(quant_indx,[s_h,s_w]).';
quant_colors_indx  = unique(quant_remap_indx);
nmbr_quant_colors  = length(quant_colors_indx);

H = zeros(nmbr_quant_colors,nmbr_quant_colors);                   % Neighbourhood Color Histogram Matrix
% H[i,j] is the number of times a pixel having color j appears in the D×D
% (D is a small number, typically 3-5) neighborhood of a pixel having color i,
% divided by the total number of pixels in the D×D neighborhoods of pixels having color i.

for r = 1 + floor(D/2) : size(quant_remap_indx,1) - floor(D/2)
    for c = 1 + floor(D/2) : size(quant_remap_indx,2) - floor(D/2)
        centerColor = ismember(quant_colors_indx , quant_remap_indx(r,c) );
        centerColor = find(centerColor,1);
        for r_d = r - floor(D/2) : r + floor(D/2)
            for c_d = c - floor(D/2) : c + floor(D/2)
                for j = 1 : nmbr_quant_colors
                    if quant_remap_indx(r_d,c_d) == quant_colors_indx(j,:)
                        H(centerColor,j) = H(centerColor,j) + 1;
                    end
                end
            end
        end
    end
end

for i = 1 : size(H,1)
    rowmax = max(H(i,:));
    k = find(H(i,:)==rowmax);
    if length(k) ~= 1                                       % catch for when multiple maxs in H
        if not(isequal(ismember(k,i),zeros(1,length(k))))   % check if one of the maxs corresponds to color itself
            k = i;                                          % if so: take this index
        else
            [~,mini] = min(abs(k-i));                       % if not: take index closest to color itself
            k = k(mini);
        end
    end
    if k ~= i % i is a speckle color, occuring mostly in the neighbourhood of k -> replace color i by color k
        for r = 1 : size(quant_remap_indx,1)
            for c = 1 : size(quant_remap_indx,2)
                if quant_remap_indx(r,c) == quant_colors_indx(i)
                quant_remap_indx(r,c) = quant_colors_indx(k);
                end
            end
        end
    end
end
end