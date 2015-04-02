function show_pairs( image_list, pair_set )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    hf = figure('units','normalized','outerposition',[0 0 1 1]);
    set(hf,'CurrentCharacter','0');
    for i=1:size(pair_set,1)
        if (sum(pair_set(i,:)==0))
            continue;
        end
        img1 = imread(image_list{pair_set(i,1)});
        img2 = imread(image_list{pair_set(i,2)});
        subplot(1,2,1), subimage(img1);
        subplot(1,2,2), subimage(img2);
        ginput(1);
        x = double(get(hf,'CurrentCharacter'));
        if x==27 || x==113
            close all;
            break;
        end
    end

end

