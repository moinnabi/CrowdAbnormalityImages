
clear all;
resize_dim = 30;
kmeans_size = 10;


output_patches_file='patch_table.mat';
annotation_xml_file = 'annotation2.xml';
%load ('patch_table');
[ patch_table ] = extract_raw_patchs_auto( annotation_xml_file, false );

save(output_patches_file,'patch_table');


HOG_features = [];
HOG_Index = [];

fprintf(1,'Claculate HoG Fetures (image count %d) current: ',size (patch_table,1));
for img_no=1:size (patch_table,1)
    img = imread(patch_table{img_no,1});
    rect= patch_table{img_no,2};
    for pacth_no=1:size(rect,1)
        pactch = imresize(imcrop(img, rect(pacth_no,:)), [resize_dim resize_dim]);
        %[featureVector, hogVisualization] = extractHOGFeatures(pactch);
        pactch = im2double(pactch);
        feat = features(pactch, 8);
        featureVector = invertHOG(feat);
        featureVector = reshape(featureVector, 1,size(featureVector,1)*size(featureVector,1));
        HOG_Index = [HOG_Index ; cellstr(patch_table{img_no,1}), rect(pacth_no,:)];
        HOG_features = [HOG_features ; featureVector];
    end
    reverseStr = repmat(sprintf('\b'), 1, length(num2str(img_no-1)));
    fprintf(1,strcat(reverseStr,'%d'),img_no);
end

hog_size = size(feat,3);
save('HOG_features','HOG_features','HOG_Index','hog_size');


[lables] = kmeans(HOG_features,kmeans_size);

visualize_patch_no = 4;
patch_size=30;
image_dims = [20 20];
image_out = visualize_patches( HOG_Index, lables, visualize_patch_no, patch_size, image_dims );
imshow(image_out);



