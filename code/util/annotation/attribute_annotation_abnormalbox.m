%% Draw patche box around Abnormality Centers
% By Mahdyar


%% Initialization and set data base/annotation parameters
clear all;
close all;	
imtool close all;

img_folder = ''; % directory of images
annotation_xml_file='annotation.xml';
output_patches_file='patches.mat';
img_namel_field_idx=1;  % index of Image_name field in annotation table
normal_field_idx=2;     % index of normal field in annotation table
points_field_idx=3;     % index of set points field in annotation table

[ an_table ] = xml_read_annotation( annotation_xml_file );
valid_data = sum(strcmp(an_table(:,2),'abnormal'));
patch_table = cell(valid_data,2);

annotation_idx=1;
hf = figure('units','normalized','outerposition',[0 0 1 1]);

%% Select Abnormal images from annotation table to extract patches
for img_idx=1:size(an_table,1)
    
    % check if selected image is abnormal
    if strcmp(an_table{img_idx,normal_field_idx},'normal') ==1
        continue;
    end
    
    
    points = [];
    baseFileName = an_table{img_idx,img_namel_field_idx}; % name of images
    fullFileName = fullfile(img_folder, baseFileName);
    grayImage = imread(fullFileName);
    [rows, columns, numberOfColorBands] = size(grayImage);
    hf; imshow(grayImage,'InitialMagnification','fit');
    
    % Show abnormality center points from annotation_table
    xc = cell2mat(an_table{img_idx,points_field_idx}(:,1));
    yc = cell2mat(an_table{img_idx,points_field_idx}(:,2));
    hold on;
    plot(xc,yc,'rs','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','red');
    set(hf,'CurrentCharacter','0');
    x = double(get(hf,'CurrentCharacter'));
    
    % Select patches around the center points
    while (1)
        
         x = double(get(hf,'CurrentCharacter'));
         if x==113
            break;
         end
         
         rect = getrect;
         if rect(3)==0 || rect(4)==0
             break;
         end
         points = [points ; {rect(1) rect(2) rect(3) rect(4) }];
         sprintf('(BoundingBox)=(%.1f,%.1f,%.1f,%.1f)',rect(1),rect(2),rect(3),rect(4));
         hold on;
         rectangle('Position',rect,'EdgeColor',[round(rand) round(rand) round(rand)],'LineWidth',3,'LineStyle','--'); 
    end
    
    if x==113
       break;
    end
    %% Save Data
    patch_table(annotation_idx,:)=[fullFileName, {points} ];
    annotation_idx = annotation_idx +1 ;
    save('output_patches_file','patch_table');
end

save('output_patches_file','patch_table');
close all;