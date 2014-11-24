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
patch_table = cell(size(an_table,1),2);

annotation_idx=1;

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
    imshow(grayImage, []);
    set(gcf, 'Position', get(0,'Screensize'));
    set(gcf,'name','Draw rectangle around the red points','numbertitle','off')
    DlgH = gcf;
    H = uicontrol('Style', 'PushButton', 'String', 'Break', 'Callback', 'cla(gcbf)'); % stop with Esc and Button WTF??????
    
    % Show abnormality center points from annotation_table
    xc = cell2mat(an_table{:,points_field_idx}(:,1));
    yc = cell2mat(an_table{:,points_field_idx}(:,2));
    hold on;
    plot(xc,yc,'rs','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','red');
    
    % Select patches around the center points
    while (ishandle(H))
         rect = getrect;
         points = [points ; {rect(1) rect(2) rect(3) rect(4) }];
         sprintf('(BoundingBox)=(%.1f,%.1f,%.1f,%.1f)',rect(1),rect(2),rect(3),rect(4))
         rectangle('Position',rect,'EdgeColor',[round(rand) round(rand) round(rand)],'LineWidth',3,'LineStyle','--')
    end
    
    patch_table(annotation_idx,:)=[fullFileName, {points} ];
    annotation_idx = annotation_idx +1 ;
end

save('output_patches_file','patch_table');