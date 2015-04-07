function show_pairs( image_list, pair_set, patch_index, patch_lables, save_path )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    hf = figure('units','normalized','outerposition',[0 0 1 1]);
    set(hf,'CurrentCharacter','0');
    
    nbColors= size(unique(patch_lables),1);
    cmap = hsv(nbColors)*255;

    for i=1:size(pair_set,1)
        if (sum(pair_set(i,:)==0))
            continue;
        end
        img_name1=image_list{pair_set(i,1)};
        img1 = draw_patches_on_image (cmap, img_name1, patch_index, patch_lables);
        img_name2=image_list{pair_set(i,2)};
        img2 = draw_patches_on_image (cmap, img_name2, patch_index, patch_lables);
        subplot(1,2,1), subimage(img1);
        subplot(1,2,2), subimage(img2);
        set(hf,'name',strcat('pair_',num2str(i)));
        print(hf,strcat(save_path,'pair_',num2str(i)),'-dpng');
        ginput(1);
        x = double(get(hf,'CurrentCharacter'));
        if x==27 || x==113
            close all;
            break;
        end
    end
    
end

function image_out = draw_patches_on_image (colors, image_name, patch_index, patch_lables)
    
    img = imread(image_name);
    img_ptch = find(ismember(patch_index (:,1),image_name));
    rect_size = (floor(max(size(img))/500)+1)*2;
    for ptch_idx=1:size (img_ptch,1)
        shapeInserter = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','CustomBorderColor',colors(patch_lables(img_ptch(ptch_idx)),:),'LineWidth',rect_size);
        rect= patch_index{img_ptch(ptch_idx),2};
        rect=int32(rect);
        img = step(shapeInserter, img, rect);
    end
    image_out = img;
end

