% Annotator for Normal/Abnormal Images
% mid-level results just should be saved
% By Moin
close all;	
imtool close all;

normal_flag = 0; % 1 for annotating normal images, 0 for abnormal images
abnormal_patch_flag = 1; % 1 for annotating patch in abnormal image, 0 for annoating point in abnormal images

folder = '/home/moin/GitHub/CrowdAbnormalityImages/code/'; % directory of images
baseFileName = 'test.jpg'; % name of images
fullFileName = fullfile(folder, baseFileName);
grayImage = imread(fullFileName);
[rows columns numberOfColorBands] = size(grayImage);
imshow(grayImage, []);
set(gcf, 'Position', get(0,'Screensize'));
set(gcf,'name','click on abnormal region','numbertitle','off')
%
DlgH = gcf;
H = uicontrol('Style', 'PushButton', 'String', 'Break', 'Callback', 'delete(gcbf)'); % stop with Esc and Button

if normal_flag
    [xc yc] = ginput(1);
    xc_old = xc;
    yc_old = yc;
    while (ishandle(H))
        [xc yc] = ginput(1)
        sprintf('(x,y)=(%.1f,%.1f)',xc,yc)
        hold on;
        plot([xc,xc_old],[yc,yc_old],'--rs','LineWidth',4,'Color','g','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','red');
        xc_old = xc;
        yc_old = yc;
        %% "xc" & "yc" sholuld be saved in a variable.
    end
end;
    
if abnormal_patch_flag
    while (ishandle(H))
        rect = getrect;
        sprintf('(BoundingBox)=(%.1f,%.1f,%.1f,%.1f)',rect(1),rect(2),rect(3),rect(4))
        rectangle('Position',rect,'EdgeColor',[round(rand) round(rand) round(rand)],'LineWidth',3,'LineStyle','--')
        %% "rect" sholuld be saved in a variable.
    end
else
    while (ishandle(H))
        [xc yc] = ginput(1)
        sprintf('(x,y)=(%.1f,%.1f)',xc,yc)
        hold on;
        plot(xc,yc,'Marker','o','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','g');
        %% "xc" & "yc" sholuld be saved in a variable.
    end
end