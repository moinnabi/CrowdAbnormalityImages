% Demo For Abnormality in Images

% Addpath
addpath('downloadImages/')

% Data Collection
%querynames = {'Crowd','Crowd Peace','Crowd Normal','Crowd Humanity','Crowd Abnormal','Crowd Fight','Crowd Protest','Crowd Danger', 'Crowd Struggle'};
%querynames = {'Crowd Club','Crowd Party','Crowd People','Crowd Stage','Crowd Concert','Crowd HD','Crowd City'};
querynames = {'Crowd China','Crowd Army','Crowd Stadium','crowd Attack','crowd Gathering','concert crowd fight metallica','Crowd Rome','Crowd Egypt' ...
    'Stadium Brazil Fight','Protest Iran','Crowd Hong Kong','Protest Hong Kong','Marathon Crowd','Time Square Crowd','Manhatan Crowd','Florida Crowd' ...
    'Crowd India','Metro Crowd','Crowd Fest','Crowd Metro Attack','Israeli Crowd','Mecca Crowd','Mina Mecca Crowd','Carnival Crowd','Dehli crowd' ...
    'Terror Crowd','Metro Bomb Crowd','Metro Terror Crowd','London Crowd','Paris Crowd','Brazil Crowd','Spain Crowd','Munich Crowd','Oktoberfest Crowd' ...
    'Cow Spain Crowd','Gay Crowd','Celebration Crowd','Guard Protest'};


datadir = '../data';
weirdAspectThresh = 0.4;
maxImgReSize = 1000;



for f = 1:size(phrasenames,2)
    phrasenames = querynames{f}(find(~isspace(querynames{f})))
    thisdowndir = [datadir '/' phrasenames '/']; 
    filenameWithPath=which('googleimages_dsk.py');      %code/downloadImages/googleimages_dsk.py
    dwncmd = ['python ' filenameWithPath ' ' ...
        thisdowndir ' ' '''' 'url' '''' ' ' '''' querynames{f} ''''];
    [~, b] = system(dwncmd);
    
    
%end


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
            if ht/wd > weirdAspectThresh && wd/ht > weirdAspectThresh && ht>600 && wd > 800          % looks like good aspect ratio image
                im = imresize(im, maxImgReSize/max(size(im,1),size(im,2)), 'bilinear');
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
    %mkdir([thisdowndir '/done.done']);
%end
end