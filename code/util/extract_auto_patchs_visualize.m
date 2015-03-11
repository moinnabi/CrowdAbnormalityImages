


visualize_patch_no = 10;
image_dims = [8 6];
image_out = visualize_patches( HOG_Index, lables, visualize_patch_no, patch_size, image_dims );
hog_out = visualize_HOGs( HOG_feats, lables, visualize_patch_no, image_dims, feat_size );
imshow([image_out,repmat(hog_out*256,[1 1 3])]);
