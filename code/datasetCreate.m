function datasetCreate()

% Addpath
addpath('downloadImages/')

%Data Collection
querynames = {'Crowd','Crowd Peace','Crowd Normal','Crowd Humanity','Crowd Abnormal','Crowd Fight','Crowd Protest','Crowd Danger', 'Crowd Struggle', 'Crowd Club','Crowd Party', ...
    'Crowd People','Crowd Stage','Crowd Concert','Crowd HD','Crowd City','Crowd China','Crowd Army','Crowd Stadium','crowd Attack','crowd Gathering', ... 
    'concert crowd fight metallica','Crowd Rome','Crowd Egypt','Stadium Brazil Fight','Protest Iran','Crowd Hong Kong','Protest Hong Kong','Marathon Crowd','Time Square Crowd', ... 
    'Manhatan Crowd','Florida Crowd' ,'Crowd India','Metro Crowd','Crowd Fest','Crowd Metro Attack','Israeli Crowd','Mecca Crowd','Mina Mecca Crowd','Carnival Crowd','Dehli crowd' ...
    'Terror Crowd','Metro Bomb Crowd','Metro Terror Crowd','London Crowd','Paris Crowd','Brazil Crowd','Spain Crowd','Munich Crowd','Oktoberfest Crowd' ...
    'Cow Spain Crowd','Gay Crowd','Celebration Crowd','Guard Protest','High Interaction Crowd','Violence Crowd','Crowd beijing', 'crowd pedestrian', 'crowd exit fest', 'crowd dimension fest', 'crowd unknown fest', 'crowd concert beyonce', ...
    'crowd concert u2', 'crowd movie war', 'crowd movie', 'crowd street performance', 'crowd street', 'crowd top view', 'crowd malaya', ...
    'crowd speech', 'crowd pray', 'crowd vatican', 'crowd smoking', 'crowd running away', 'crowd scared', 'crowd running toward', 'crowd running and screaming', ...
    'crowd running scared', 'crowd laughing','African Crowd','asian crowd','europian crowd','american crowd','beach crowd','university crowd','church crowd','mosque crowd','praying crowd', ...
    'disaster crowd','world war crowd','civil crowd','genocide crowd','ibiza crowd','australian crowd','afghanistan crowd','public crowd','large crowd', ... 
    'massive crowd','cheering crowd','cheering crowd sports','bbc crowd','holland crowd','crazy crowd','surfing crowd','jumping crowd','religious crowd'};


datadir = '../data/datasetClean';
weirdAspectThresh = 0.5;
minImgReSize = 448;
%maxImgReSize = 1792;       %to minimize image if larger than a thershold


for f = 1:size(querynames,2)
    phrasenames = querynames{f}(find(~isspace(querynames{f})))
    %thisdowndir = [datadir '/' phrasenames '/']; % saparati!
    thisdowndir = [datadir '/'];  % tutti-in-sieme!
    
    filenameWithPath=which('googleimages_dsk.py');      %code/downloadImages/googleimages_dsk.py
    dwncmd = ['python ' filenameWithPath ' ' ...
        thisdowndir ' ' '''' 'url' '''' ' ' '''' querynames{f} ''''];
    [~, b] = system(dwncmd);
    
ignoredir = [thisdowndir 'ignore/']; mkdir(ignoredir);

disp(' chking if all images are valid; if so, resize');
ids_temp = dir([thisdowndir '*.*']);       % doing *.* to handle different types (bmp, png, etc) images        
%if length(ids_temp) > 10 % minNumImgs                        
    disp(' resizing images');
    %resizeGoogImages(ids, maxImgReSize);
    for i=3:length(ids_temp)     % removing parfor as i want this too be slow so that download requests arent bombarded  
        try
            ids = [thisdowndir ids_temp(i).name];
            im = imread(ids);
            [ht, wd, dp] = size(im);
            if ht/wd > weirdAspectThresh && wd/ht > weirdAspectThresh           % looks like good aspect ratio image
                if ht < minImgReSize || wd < minImgReSize % || ht > maxImgReSize || wd > maxImgReSize  % to minimize if larger than a Thershold
                    im = imresize(im, minImgReSize/max(size(im,1),size(im,2)), 'bilinear');
                end
                %system('su root');
                imwrite(im, ['..' strtok(ids, '.') '.jpg']);
            else
                disp(['  bad aspet ratio' ids]);
                [a, b] = system(['mv ' ids ' ' ignoredir '/']);
            end
        catch
            disp(['  cant load this image ' ids ' ; ignoring it']);
            [a, b] = system(['mv ' ids ' ' ignoredir '/']);  % mv instead of delete as it has other important .* files (.urls etc)
        end
    end

    disp([' total of ' num2str(length(dir([thisdowndir '/*.jpg']))) ' valid images']); 

    disp(' writing done file');

end

% Rename the images in "dirImg" directory to image000001.jpg
dirImg = '/home/moin/GitHub/CrowdAbnormalityImages/data/datasetClean/';
[ImgNames,num_Img] = list_dir(dirImg,'*.jpg');
for ids = 1:num_Img
    system(['mv ' dirImg ImgNames{ids} ' ' dirImg sprintf('image_%-5.6d', ids) '.jpg' ]);
end
    

%List Images on GitHub
% datadir = '../data/';
% url_base = 'https://raw.githubusercontent.com/moinnabi/CrowdAbnormalityImages/master/data/';
% [FolderNames,num_Folder] = list_dir(datadir,'*');
% ind = 1;
% ImgURL = [];
% for i = 1:num_Folder
%     [FileNames,num_File] = list_dir([datadir,FolderNames{i},'/'],'*.jpg');
%     for j =1:num_File
%         ImgURL{ind} = [url_base,FolderNames{i},'/',FileNames{j}];
%         ind = ind+1;
%     end
% end
% GenerateCSV(ImgURL,[datadir,'ImgURL.csv'])


    