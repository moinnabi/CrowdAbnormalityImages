function [ patch_distribution ] = get_labe_distribution( samples_lables, cluster_size )
% Get disribution of patches through the clusters
%   samples_lables = vector of lables as big as samples count with
%   correspond assigned label to each sample
%   cluster_size = int value for number of clusters
    
    
    patch_distribution = [(1:cluster_size)', zeros(cluster_size,1)];
    for i=1:cluster_size
        patch_distribution (i,2)=size(find(samples_lables==i),1);
    end
    
end

