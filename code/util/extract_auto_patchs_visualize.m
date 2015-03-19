

patch_size=100;
image_dims = [3 3];

for cluster_idx=1:kmeans_size
    visualize_patch_no = cluster_idx;
    fig = figure;
    image_out = visualize_patches( Caffe_Index, lables, visualize_patch_no, patch_size, image_dims );
    %hog_out = visualize_HOGs( HOG_feats, lables, visualize_patch_no, image_dims, feat_size );
    %imshow([image_out,repmat(hog_out*256,[1 1 3])]);
    imshow(image_out);
    print(fig,strcat('img_caffe_60K_',num2str(cluster_idx)),'-dpng');
    close;
end

patch_image_distribution = get_image_per_lable(patch_table(:,1),lables,Caffe_Index,kmeans_size);
save('patch_image_distribution_60','patch_image_distribution');