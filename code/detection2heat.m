function [heat] = detection2heat(img_test,patches,ap_scores,display_flg)

[im_h, im_w, ~] = size(img_test);
heat = zeros(im_h,im_w);
for i = 1 : size(heat,1)
    for j = 1 : size(heat,2)
        for k = 1 : size(patches,2)
            %k = 1;
            if (j >= patches{k}(1) && j <= patches{k}(3) ) && ( i >= patches{k}(2) && i <= patches{k}(4) )
                heat(i,j) = heat(i,j) + ap_scores{k};
            end
        end
    end
end
%contourf(flipud(heat),'DisplayName','heat');figure(gcf)
if display_flg
    h_fg = imagesc(img_test); set(gca,'xtick',[],'ytick',[]); saveas(h_fg,'fg.jpg'); B_tmp = imread('fg.jpg'); B = imresize(B_tmp, [im_h im_w]);
    tempo = heat'; %tempo = fliplr(tempo);
    h_bg = imagesc(tempo'); set(gca,'xtick',[],'ytick',[]) %axis off; set(h,'edgecolor','none');
    saveas(h_bg,'bg.jpg'); F_tmp = imread('bg.jpg'); F = imresize(F_tmp, [im_h im_w]);
    close all;

    display_img1_on_img2(F, B, 0.5); figure(gcf);
end