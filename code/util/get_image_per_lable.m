function [ patch_image_distribution ] = get_image_per_lable( image_list, lables, feat_index, lable_no )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

patch_image_distribution = zeros(lable_no, size(image_list,1)+1);

for i=1:lable_no
    patch_image_distribution(i,1)=i;
    image_list_sample=find(lables==i);
    unique_index=unique(feat_index(image_list_sample));
    img_list = ismember(image_list,unique_index)';
    patch_image_distribution(i,2:end)=img_list;
end


end

