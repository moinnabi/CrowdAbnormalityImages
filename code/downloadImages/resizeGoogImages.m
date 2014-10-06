function resizeGoogImages(ids, imgSize)

%imgSize = 500;

parfor i=1:length(ids)
    try
        im = imread(ids{i});
        % need to keep at imgSize pixels rather than thumbnails as detectors like it so
        im = imresize(im, imgSize/max(size(im,1),size(im,2)), 'bilinear');
        imwrite(im, ids{i});
    catch
        disp(['  cant load this image ' num2str(i) ' ; deleting it']);
        system(['rm ' ids{i}]);
    end
end

%{
for i=1:length(ids)
    try
        im = imread(ids{i});
        % need to keep at 500 pixels rather than thumbnails as detectors like it so
        im = imresize(im, 500/max(size(im,1),size(im,2)), 'bilinear');
        imwrite(im, ids{i});
    catch
        disp(['  cant load this image ' num2str(i) ' ; deleting it']);
        system(['rm ' ids{i}]);
    end
end
%}
