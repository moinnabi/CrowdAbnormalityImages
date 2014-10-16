function [ mean_batch ] = mean_images( batch_images )
%-----------------------------------------------------------------------
% Calculate mean of input batch images. Images should be in the same size.
% 
% Input:
%   - batch_images:  3D matrix with (Y_size, X_size, Images_No)
%
% Output:
%   - mean_batch: 2D matrix (Y_size, X_size), mean of input images
%
%--------------- Dev: Mahdyar 17-Oct-2014 ------------------------------

[y_dim, x_dim, no_images] = size(batch_images);

img_len=(x_dim*y_dim);
vector_type = class(batch_images);
temp = zeros(no_images,img_len,vector_type);

for i=1:no_images
   temp(i,:)=reshape(batch_images(:,:,i),1,img_len);
end
   mean_batch = reshape(mean(temp),y_dim,x_dim);
end

