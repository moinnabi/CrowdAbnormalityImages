function [ imagelist ] = generate_image_list( dataroot, just_root )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[subfolders_names,subfolders_num] = list_dir(dataroot,'*',true);
imagelist=[];
if just_root
    img_root= dataroot;
    [names,num] = list_dir(img_root,'*.jpg');
    imagelist = strcat(img_root,names);
else
    for i=1:subfolders_num
        img_root= strcat(dataroot,char(subfolders_names(i)),'/');
        [names,num] = list_dir(img_root,'*.jpg');
        imagelist = [imagelist ; strcat(img_root,names)];
    
    end
end

