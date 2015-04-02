

clear all;
kmeans_size = 20;

load ('features/caffe_patch/patch_table');
load ('features/caffe_patch/Caffe_features');
image_count = size(patch_table,1);
index_vector_labels_per_image = zeros(image_count,kmeans_size);

[lables] = kmeans(Caffe_feats,kmeans_size);
%patch_distribution = get_labe_distribution( lables, kmeans_size );

%% Builup an index binary vector image/lable
for img_idx=1:image_count
    img_name = patch_table{img_idx,1};
    patch_idns = find(ismember(Caffe_Index (:,1),img_name));
    patch_lables = unique(lables(patch_idns));
    index_vector_labels_per_image(img_idx,patch_lables)=1;
end


similarity_matrix = zeros(image_count,image_count);

for img_idx=1:image_count
    for img_idx2=1:image_count
        %% All similarites (Include non-member of clusters)
        similarity_matrix(img_idx,img_idx2)= sum(index_vector_labels_per_image(img_idx,:)== index_vector_labels_per_image(img_idx2,:));
        %% Being in the same clusters (only ANDs)
        %similarity_matrix(img_idx,img_idx2)= sum(index_vector_labels_per_image(img_idx,:) & index_vector_labels_per_image(img_idx2,:));
    end
end

test_train = choose_test_train_sets(similarity_matrix,'greedy');
show_pairs( patch_table(:,1), test_train );