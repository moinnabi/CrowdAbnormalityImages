function [ patch_table ] = extract_raw_patchs_auto( xml_file_name, visualization )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


img_folder = '';

min_patch_tr=70;
max_patch_tr=70;

img_namel_field_idx=1;  % index of Image_name field in annotation table
normal_field_idx=2;     % index of normal field in annotation table
points_field_idx=3;     % index of set points field in annotation table

no_of_rects = 1;

[ annotation_table ] = xml_read_annotation( xml_file_name );
%patch_table = cell(valid_data,3);

patch_table = {};


for img_idx=1:size(annotation_table,1)
    
    if strcmp(annotation_table{img_idx,normal_field_idx},'normal') ==1
        continue;
    end
    if size(annotation_table{img_idx,points_field_idx},1)<1
        continue;
    end

    
    rect = [];
    baseFileName = annotation_table{img_idx,img_namel_field_idx}; % name of images
    fullFileName = fullfile(img_folder, baseFileName);
    fullFileName = strrep(fullFileName, '\', '/');
    grayImage = imread(fullFileName);
    [rows, columns, numberOfColorBands] = size(grayImage);

    
    if (visualization)
    close all;
    hf = figure('units','normalized','outerposition',[0 0 1 1]);
    hf; imshow(grayImage,'InitialMagnification','fit');
    end
    
    rng(0,'twister');
    a = (min(rows,columns)/10)+min_patch_tr;
    b = (max(rows,columns)/10)+max_patch_tr;
    patch_sizes = (b-a).*rand(no_of_rects,1) + a;
    
    % Show abnormality center points from annotation_table
    xc = cell2mat(annotation_table{img_idx,points_field_idx}(:,1));
    yc = cell2mat(annotation_table{img_idx,points_field_idx}(:,2));
    
    for pt_no=1:size(xc,1)
        rect = [rect ; repmat(xc(pt_no),size(patch_sizes,1),1)-patch_sizes/2 repmat(yc(pt_no),size(patch_sizes,1),1)-patch_sizes/2 patch_sizes patch_sizes];
    end
    
    if (visualization)
        hold on;
        plot(xc,yc,'rs','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','red');
    
        hold on;
        for rect_no=1:size(rect,1)
            rectangle('Position',rect(rect_no,:),'EdgeColor',[round(rand) round(rand) round(rand)],'LineWidth',3,'LineStyle','--'); 
        end
        waitforbuttonpress;
    end
    
%     for i=1:size(rect,1)
%         patch_table = [patch_table ; cellstr(strrep(fullFileName, '\', '/')),rect(i,:) ];
%     end
    patch_table = [patch_table ; cellstr(strrep(fullFileName, '\', '/')),rect ];
end

fprintf(1,'Done..\n');

end

