function test_train = choose_test_train_sets( similarity_matrix, method )
%Make datset include N/2 pairs images that are more similar toghether
%   Input:
%   similarity_matrix : NxN matrix where N is the number of images in
%   Dataset
%   method : method to choose similar pairs ('greedy', ?)

    img_count = size(similarity_matrix,1);
    test_train = zeros(floor(img_count/2),2);
    
    if ~exist('method','var')
        method = 'greedy';
    end
    
    if (strcmp(method,'greedy'))
        mxx = max (similarity_matrix);
        mxx = [mxx ; 1:img_count];
        [~,I]=sort(mxx(1,:),'descend');
        mxx=mxx(:,I);
        
        pair_idx=1;
        
        for img_idx=1:img_count
            if (find(test_train==mxx(2,img_idx)))
               continue;
            end
            test_train (pair_idx,1) = mxx(2,img_idx);
            test_train (pair_idx,2) = find_pair_image_greedy(similarity_matrix(mxx(2,img_idx),:), mxx(1,img_idx), test_train);
            pair_idx = pair_idx +1;
        end
        
    end
    

end

    function sample_idx = find_pair_image_greedy(similarity_vector, similarity_score, test_train)
        
         if (similarity_score ==0)
             sample_idx = 0;
             return;
         end
        
        candidate_list = find(similarity_vector==similarity_score);
        if size(candidate_list,2)>0
            for candidate_idx=1:size(candidate_list,2)
               if (find(test_train==candidate_list(candidate_idx)))
                    continue;
               end
               sample_idx = candidate_list(candidate_idx);
               return;
                
            end
        end
        sample_idx = find_pair_image_greedy(similarity_vector, similarity_score-1, test_train);
    end

