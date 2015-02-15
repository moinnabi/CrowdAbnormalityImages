%% Annotator for Normal/Abnormal Images
% mid-level results just should be saved
% By Moin
% Edited by Mahdyar. Add read data and strore annotation modules.



%% Initialization and set data base/annotation parameters
close all;	
imtool close all;

img_folder = ''; % directory of images
annotation_file='an_table.mat'; % annotation tags table
output_xml_file='annotation2.xml';
img_namel_field_idx=1;  % index of Image_name field in tags table
normal_field_idx=5;     % index of normal field in tags table
abnormal_field_idx=4;   % index of abnormal field in tags table
noisy_field_idx=3;      % index of noisy field in tags table * noisy_field_idx * shows valid/inavlid data:
                        % 1 value valid data image to annotaite
                        % 0 value invalid data image exclude from annotaition
lq_field_idx=6;         % index of low_quality field in tags table

load(annotation_file);
an_table(cellfun(@isempty,an_table)) = {0};
valid_data = sum(cell2mat(an_table(:,noisy_field_idx)));
annotation_table = cell(valid_data,3);
annotation_idx=1;
hf = figure('units','normalized','outerposition',[0 0 1 1]);

try
[ an_tabletmp ] = xml_read_annotation( output_xml_file );
start_idx =  find(strcmp(strrep(an_table(:,1),'/','\'), strrep(an_tabletmp{size(an_tabletmp,1),1},'/','\')))+1;
annotation_table(1:size(an_tabletmp,1),:)=an_tabletmp;
annotation_idx=size(an_tabletmp,1)+1;
catch
   start_idx =1;  
end

for img_idx=start_idx:size(an_table,1)
    
    if an_table{img_idx,noisy_field_idx} ==1
        continue;
    end
    if (an_table{img_idx,normal_field_idx} ==1)
        normal_flag = 1; % 1 for annotating normal images, 0 for abnormal images
        abnormal_patch_flag = 0; % 1 for annotating patch in abnormal image, 0 for annoating point in abnormal images
        tag = 'normal';
    else
        normal_flag = 0; % 1 for annotating normal images, 0 for abnormal images
        abnormal_patch_flag = 1; % 1 for annotating patch in abnormal image, 0 for annoating point in abnormal images
        tag = 'abnormal';
    end
    
    set(hf,'CurrentCharacter','0');
    points = [];
    baseFileName = an_table{img_idx,img_namel_field_idx}; % name of images
    fullFileName = fullfile(img_folder, baseFileName);
    grayImage = imread(fullFileName);
    [rows, columns, numberOfColorBands] = size(grayImage);

    hf; imshow(grayImage,'InitialMagnification','fit');
         
    if normal_flag
        [xc yc] = ginput(1);
        points = [{xc yc }];
        xc_old = xc;
        yc_old = yc;
        hold on;
        plot(xc,yc,'rs','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','red');
        while (1)
            x = double(get(hf,'CurrentCharacter'));
            if x==27 || x==113
                break;
            end
            [xc yc] = ginput(1);
            points = [points ; {xc yc }];
            sprintf('(x,y)=(%.1f,%.1f)',xc,yc)
            hold on;
            plot([xc,xc_old],[yc,yc_old],'--rs','LineWidth',4,'Color','g','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','red');
            xc_old = xc;
            yc_old = yc;
        end
    end;



    if abnormal_patch_flag
        while (1)
            [xc yc] = ginput(1)
            x = double(get(hf,'CurrentCharacter'));
            if x==27 || x==113
                break;
            end
            points = [points ; {xc yc }];
            sprintf('(x,y)=(%.1f,%.1f)',xc,yc)
            hold on;
            plot(xc,yc,'rs','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','red');
            xc_old = xc;
            yc_old = yc;
        end
    end;
    

    
    if x==113
       break;
    end
    
    clf(hf);
    annotation_table(annotation_idx,:)=[fullFileName, tag, {points} ];
    xml_write_annotation_file( annotation_table, output_xml_file, annotation_idx );
    annotation_idx = annotation_idx +1 ;
    
end

%xml_write_annotation_file( annotation_table, output_xml_file, annotation_idx );
close all;