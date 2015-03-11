
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
HOG_feats = [];

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
        featureVector = reshape(featureVector, 1, numel(featureVector));
        HOG_Index = [HOG_Index ; cellstr(patch_table{img_no,1}), rect(pacth_no,:)];
        HOG_features = [HOG_features ; featureVector];
        HOG_feats = [HOG_feats ; reshape(feat,1,numel(feat))];
    end
    reverseStr = repmat(sprintf('\b'), 1, length(num2str(img_no-1)));
    fprintf(1,strcat(reverseStr,'%d'),img_no);
end
fprintf('\n');

hog_size = size(feat,3);
feat_size = size(feat);
save('HOG_features','HOG_features','HOG_feats','HOG_Index','feat_size','hog_size');


[lables] = kmeans(HOG_features,kmeans_size);

patch_distribution = get_labe_distribution( lables, kmeans_size );
visualize_patch_no = 4;
patch_size=30;
image_dims = [20 10];
image_out = visualize_patches( HOG_Index, lables, visualize_patch_no, patch_size, image_dims );
hog_out = visualize_HOGs( HOG_feats, lables, visualize_patch_no, image_dims, feat_size );
imshow(image_out);



