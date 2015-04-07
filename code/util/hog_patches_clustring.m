

%% Initialization
clear all;
close all;
kmeans_size = 20;
images_save_path = 'Documentation/SimilarityHogBox/';
% First time Run kmeans for clustering samples
run_kmeans = false;
load ('features/hog_patch/patch_table');
load ('features/hog_patch/HOG_features');

image_count = size(patch_table,1);
index_vector_labels_per_image = zeros(image_count,kmeans_size);
index_vector_labels_per_image_hist = zeros(image_count,kmeans_size);

%% Kmeans clustring
if run_kmeans
    [lables] = kmeans(HOG_features,kmeans_size);
    save('features/hog_patch/lables','lables');
else
    load('features/hog_patch/lables');
end
%patch_distribution = get_labe_distribution( lables, kmeans_size );

%% Builup an index binary vector image/lable
for img_idx=1:image_count
    img_name = patch_table{img_idx,1};
    patch_idns = find(ismember(HOG_Index (:,1),img_name));
    if size(unique(lables(patch_idns)),1)<2
        lable_hist = [ 0 , unique(lables(patch_idns))];
        [patch_count,patch_lables]=hist(lables(patch_idns), lable_hist);
        patch_count = patch_count(2);
        patch_lables = patch_lables (2);
    else
        [patch_count,patch_lables]=hist(lables(patch_idns), unique(lables(patch_idns)));
    end
    index_vector_labels_per_image_hist(img_idx,patch_lables) = patch_count ;
    index_vector_labels_per_image(img_idx,patch_lables)=1;
end


similarity_matrix = zeros(image_count,image_count);

for img_idx=1:image_count
    for img_idx2=1:image_count
        %% All similarites (Include non-member of clusters)
        similarity_matrix(img_idx,img_idx2)= sum(index_vector_labels_per_image(img_idx,:)== index_vector_labels_per_image(img_idx2,:));
        %% Being in the same clusters (only ANDs)
        %similarity_matrix(img_idx,img_idx2)= sum(index_vector_labels_per_image(img_idx,:) & index_vector_labels_per_image(img_idx2,:));
        %% Use Intersection 
        %similarity_matrix(img_idx,img_idx2)= sum(min(index_vector_labels_per_image_hist(img_idx,:),index_vector_labels_per_image_hist(img_idx2,:)));
    end
end

test_train = choose_test_train_sets(similarity_matrix,'greedy');
show_pairs(patch_table(:,1), test_train, HOG_Index, lables, images_save_path);