

clear all;
resize_dim = 70;
kmeans_size = 10;

load ('features/caffe_patch/patch_table');
load ('features/caffe_patch/Caffe_features');

[lables] = kmeans(Caffe_feats,kmeans_size);
patch_distribution = get_labe_distribution( lables, kmeans_size );