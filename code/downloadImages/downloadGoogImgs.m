function downloadGoogImgs(inpfname, downdir) %, numImages, maxImgReSize, weirdAspectThresh)

try

%if isdeployed, samapi = str2num(samapi); end
%if isdeployed, maxImgReSize = str2num(maxImgReSize); end
%if isdeployed, weirdAspectThresh = str2num(weirdAspectThresh); end
%weirdAspectThresh = 0.4;


disp(['downloadGoogImgs(''' inpfname ''',''' downdir ''')' ]);

conf = voc_config('paths.model_dir', 'blah');
numImages =  conf.threshs.numImgsToDwnldFrmGoog;
maxImgReSize = conf.threshs.maxImgSize;
weirdAspectThresh = conf.threshs.weirdAspectThresh;
minNumImgs = conf.threshs.minNumImgsDownloadCheck;
samapi =  conf.threshs.samapi;

[~, phrasenames] = system(['cat ' inpfname]);
phrasenames = regexp(phrasenames, '\n', 'split');
phrasenames(cellfun('isempty', phrasenames)) = [];
numcls = numel(phrasenames);
disp(['To process ' num2str(numcls) ' ngrams']);

%mymatlabpoolopen;      

resdir = downdir;
mymkdir([resdir '/done']);
myRandomize;
list_of_ims = randperm(numcls);
for f = list_of_ims
    if (exist([resdir '/done/' num2str(f) '.lock'],'dir') || exist([ resdir '/done/' num2str(f) '.done'],'dir') )
        continue;
    end
    if mymkdir_dist([resdir '/done/' num2str(f) '.lock']) == 0
        continue;
    end
                
    ngramPhraseName2 = strrep(phrasenames{f}, ' ', '_');
    thisdowndir = [downdir '/' ngramPhraseName2 '/'];    
    
    diary([downdir '/' ngramPhraseName2 '_diaryoutput.txt']);
    disp(['Processing ngram ' phrasenames{f}]);  
    
    if ~exist([thisdowndir '/done.done'], 'dir')
    %if ~exist([thisdowndir '/done.done'], 'dir')                    
          
        disp(' downloading images');
        if samapi
            filenameWithPath=which('samGoogDownload.sh');       %'/projects/grail/santosh/objectNgrams/code/downloadImages/samGoogDownload.sh '
            dwncmd = [filenameWithPath ' ' ...
                thisdowndir ' ' '''' phrasenames{f} '''' ' ' num2str(numImages) ' 20 on itp:photo,ic:color, 5 10'];
            [~, b] = system(dwncmd);            
        else
            filenameWithPath=which('googleimages_dsk.py');      %/projects/grail/santosh/objectNgrams/code/downloadImages/googleimages_dsk.py
            dwncmd = ['python ' filenameWithPath ' ' ...
                thisdowndir ' ' '''' 'url' '''' ' ' '''' phrasenames{f} ''''];
            [~, b] = system(dwncmd);
            %movefile([thisdowndir '/' phrasenames{f} '/*'], [thisdowndir '/']);            
        end        
        
        ignoredir = [thisdowndir '/ignore/']; mymkdir(ignoredir);
        
        disp(' chking if all images are valid; if so, resize');
        ids = mydir([thisdowndir '/*.*'], 1);       % doing *.* to handle different types (bmp, png, etc) images        
        if length(ids) > minNumImgs                        
            disp(' resizing images');
            %resizeGoogImages(ids, maxImgReSize);
            for i=1:length(ids)     % removing parfor as i want this too be slow so that download requests arent bombarded  
                try
                    im = imread(ids{i});
                    [ht, wd, dp] = size(im);
                    if ht/wd > weirdAspectThresh && wd/ht > weirdAspectThresh           % looks like good aspect ratio image
                        im = imresize(im, maxImgReSize/max(size(im,1),size(im,2)), 'bilinear');
                        imwrite(im, [strtok(ids{i}, '.') '.jpg']);
                    else
                        disp(['  bad aspet ratio' ids{i}]);
                        [a, b] = system(['mv ' ids{i} ' ' ignoredir '/']);
                    end
                catch
                    disp(['  cant load this image ' ids{i} ' ; ignoring it']);
                    [a, b] = system(['mv ' ids{i} ' ' ignoredir '/']);  % mv instead of delete as it has other important .* files (.urls etc)
                end
            end
                        
            disp([' total of ' num2str(length(mydir([thisdowndir '/*.jpg']))) ' valid images']); 
            
            disp(' writing done file');
            mymkdir([thisdowndir '/done.done']);
        else
            %disp('some issue here'); keyboard;
            % for compiled applications, keyboard doesnt work, so just quit
            % by removing lock file (some other machine will process it)
            [~, hname] = system('hostname');
            disp(['  not able to download on machine ' hname(1:end-1)]);
            rmdir([resdir '/done/' num2str(f) '.lock']);      
            disp('  sleeping for 10 minutes...');
            pause(600);     
            disp('  done sleeping, will try another image now');   
            continue;      
        end           
    end
    diary off;  
    
    mymkdir([resdir '/done/' num2str(f) '.done']);
    rmdir([resdir '/done/' num2str(f) '.lock']);
end

catch
    disp(lasterr); keyboard;
end
