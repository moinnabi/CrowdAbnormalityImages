function [ image_out ] = visualize_patches( HoG_index, HoG_lables, visualize_patch_no, patch_size, image_dims )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    x_dim=image_dims(1)*patch_size;
    y_dim=image_dims(2)*patch_size;
    clo1 = uint8([255 255 0]);
    clo2 = uint8([0 255 255]);
    clo3 = uint8([255 0 0]);
    clo4 = uint8([0 255 0]);
    
    
    
    image_out=uint8(zeros(x_dim,y_dim,3));
    sample_no=1;
    image_list=find(HoG_lables==visualize_patch_no);
    unique_index=unique(HoG_index(image_list));
    nbColors= size(unique_index,1);
    cmap = hsv(nbColors)*255;
       
    
    for row=1:image_dims(2)
        for col=1:image_dims(1)
            rectangle = int32([2 2 patch_size-2 patch_size-2]);
            start_idx_x= ((col-1)*patch_size)+1;
            end_idx_x=start_idx_x+patch_size-1;
            start_idx_y=((row-1)*patch_size)+1;
            end_idx_y=start_idx_y+patch_size-1;
            if (sample_no<size(image_list,1)+1)
                img = HoG_index{image_list(sample_no),1};
                col_idx = find(ismember(unique_index(:,1),img));
                shapeInserter = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','CustomBorderColor',cmap(col_idx,:), 'LineWidth', 2);
                img = imread(HoG_index{image_list(sample_no),1});
                rect= HoG_index{image_list(sample_no),2};
                patch = imresize(imcrop(img, rect), [patch_size patch_size]);
                patch = step(shapeInserter, patch, rectangle);
                image_out(start_idx_x:end_idx_x,start_idx_y:end_idx_y, 1:3) = patch;
            end
            sample_no = sample_no + 1; 
        end
    end
end

