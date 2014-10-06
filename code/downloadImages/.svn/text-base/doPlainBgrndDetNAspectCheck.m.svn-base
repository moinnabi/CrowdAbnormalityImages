function keepinds = doPlainBgrndDetNAspectCheck(ids, arthresh)

%arthresh = 0.4;
keepinds = zeros(length(ids),1);
for i=1:length(ids)
    try        
        im = rgb2gray(color(uint8(imread(ids{i}))));
        [ht, wd, dp] = size(im);
        %im = rgb2gray(color(uint8(warped{i})));
        %disp('build histogram of  of only the corner portions of the image -- dealing with plain bgrnd is tricky see bottle, bicyce images'); keyboard;
        hval = imhist(im);
        if sum(hval(end-3:end)) < 0.25*numel(im)    % looks like not plain bgrnd            
            if ht/wd > arthresh && wd/ht > arthresh           % looks like good aspect ratio image
                keepinds(i) = 1;
            end
        end                
    catch
        disp(['  cant load this image ' num2str(i)]);
    end    
end
