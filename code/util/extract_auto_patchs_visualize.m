

patch_size=140;
image_dims = [3 3];

for cluster_idx=1:kmeans_size
    visualize_patch_no = cluster_idx;
    fig = figure;
    image_out = visualize_patches( HOG_Index, lables, visualize_patch_no, patch_size, image_dims );
    hog_out = visualize_HOGs( HOG_feats, lables, visualize_patch_no, image_dims, feat_size );
    imshow([image_out,repmat(hog_out*256,[1 1 3])]);
    print(fig,strcat('img_',num2str(cluster_idx)),'-dpng');
    close;
end