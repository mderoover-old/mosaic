function [quant_remap_indx,quant_colors_indx] = colorRemapOld(D,quant,quant_indx,s_h,s_w)
%colorRemap Remaps colors of an image to perceptually dominant colors
%   Takes as input the quantized image matrices (and their dimensions) and
%   gives as output the quantized index matrix where speckle colors have
%   been remapped to dominant colors of the image;
%   D is the size of the DxD occurence neighbourhood

quant_remap        = getSingleImage(quant,1,s_h,s_w);               % RGB format [s_h x s_w x 3]
quant_remap_indx   = getSingleImage(quant_indx,1,s_h,s_w);          % RGB format [s_h x s_w x 3]
quant_colors_indx  = unique(squeeze(reshape(quant_remap_indx,[],1,3)),'rows');
nmbr_quant_colors  = size(quant_colors_indx,1);

H = zeros(nmbr_quant_colors,nmbr_quant_colors);                   % Neighbourhood Color Histogram Matrix
% H[i,j] is the number of times a pixel having color j appears in the D×D
% (D is a small number, typically 3-5) neighborhood of a pixel having color i,
% divided by the total number of pixels in the D×D neighborhoods of pixels having color i.

for r = 1 + floor(D/2) : size(quant_remap,1) - floor(D/2)
    for c = 1 + floor(D/2) : size(quant_remap,2) - floor(D/2)
        centerColor = ismember(quant_colors_indx , squeeze(quant_remap_indx(r,c,:)).' , 'rows');
        centerColor = find(centerColor,1);
        for r_d = r - floor(D/2) : r + floor(D/2)
            for c_d = c - floor(D/2) : c + floor(D/2)
                for j = 1 : nmbr_quant_colors
                    if squeeze(quant_remap_indx(r_d,c_d,:)).' == quant_colors_indx(j,:)
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
    if k ~= i % i is a speckle color, occuring mostly in the neighbourhood of k -> replace color i by color k
        for r = 1 : size(quant_remap_indx,1)
            for c = 1 : size(quant_remap_indx,2)
                if quant_remap_indx(r,c,:) == reshape(quant_colors_indx(i,:),[1,1,3])
                quant_remap_indx(r,c,:) = reshape(quant_colors_indx(k,:),[1,1,3]);
                end
            end
        end
    end
end
end

% ----- Pre Function Code ----- %

% target_remap        = getSingleImage(target_quant,1,s_h,s_w);               % RGB format [s_h x s_w x 3]
% target_remap_indx   = getSingleImage(target_quant_indx,1,s_h,s_w);          % RGB format [s_h x s_w x 3]
% target_colors_indx  = unique(squeeze(reshape(target_remap_indx,[],1,3)),'rows');
% nmbr_target_colors  = size(target_colors_indx,1);
% 
% H = zeros(nmbr_target_colors,nmbr_target_colors);                   % Neighbourhood Color Histogram Matrix
% % H[i,j] is the number of times a pixel having color j appears in the D×D
% % (D is a small number, typically 3-5) neighborhood of a pixel having color i,
% % divided by the total number of pixels in the D×D neighborhoods of pixels having color i.
% 
% for r = 1 + floor(D/2) : size(target_remap,1) - floor(D/2)
%     for c = 1 + floor(D/2) : size(target_remap,2) - floor(D/2)
%         centerColor = ismember(target_colors_indx , squeeze(target_remap_indx(r,c,:)).' , 'rows');
%         centerColor = find(centerColor,1);
%         for r_d = r - floor(D/2) : r + floor(D/2)
%             for c_d = c - floor(D/2) : c + floor(D/2)
%                 for j = 1 : nmbr_target_colors
%                     if squeeze(target_remap_indx(r_d,c_d,:)).' == target_colors_indx(j,:)
%                         H(centerColor,j) = H(centerColor,j) + 1;
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% for i = 1 : size(H,1)
%     rowmax = max(H(i,:));
%     k = find(H(i,:)==rowmax);
%     if k ~= i % i is a speckle color, occuring mostly in the neighbourhood of k -> replace color i by color k
%         for r = 1 : size(target_remap_indx,1)
%             for c = 1 : size(target_remap_indx,2)
%                 if target_remap_indx(r,c,:) == reshape(target_colors_indx(i,:),[1,1,3])
%                 target_remap_indx(r,c,:) = reshape(target_colors_indx(k,:),[1,1,3]);
%                 end
%             end
%         end
%     end
% end