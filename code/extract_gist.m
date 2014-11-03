% Extracting Gist features. you just need to set images root directory.
% Extracted features will save in 'gists' variable, index of image list 
% will save in 'listing' variable. Finally 'gists' and 'listing' save in
% 'gists-m' file.


% Get Image List
img_root = 'data/datasetClean/';
listing = list_dir(img_root ,'*.jpg'); 
imgs_count = size(listing,1);


% Set Gist Parameters
clear param
%param.imageSize = [256 256]; % it works also with non-square images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;

% Extract Gist Features
gists = zeros(imgs_count, 512);
fprintf(1,'Total Frames : %d Computed Frame No:  ',imgs_count);
for k=1:imgs_count
    img = imread(strcat(img_root,listing{k}));
    [gist, param] = LMgist(img, '', param);
    gists(k,:) = gist;
    print_counter( k );   
end
fprintf('\n');

% Save Data
save('features/gist/gists','gists','listing');