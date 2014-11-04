function [model, gammas, E,F] = LDA_variational_inference( counts, T, options);
%
% [model, gammas, E] = LDA_variational_inference( counts, T,options);
%
% counts (W x D)      : matrix with in each column the counts for one of the D documents of each of the W words in the lexicon.
% T (scalar)          : number of topics
%
% options.min_change (scalar)   : minimum relative change in the free-energy to continue EM iterations (defaults to 1e-4)
% options.plot (scalar)         : if non-zero plot estimates as learning proceeds (defaults to 0)
% options.model (structure)     : previously learned model structure (defaults to randomly initialized model)
% options.learn_topics (scalar) : if 0, then topics are not updated (defaults to 1)
% options.learn_alpha (scalar)  : if 0, then alpha (parameter of topic dirichlet) is not updated (defaults to 1)
% options.learn_eta (scalar)    : if 0, then eta (parameter of word dirichlet) is not updated (defaults to 1)
% options.var_beta (scalar)     : if 0, then point-estimate for beta (ie non-smooth LDA) (defaults to 1)
% options.var_gamma (scalar)    : if 0, then point-estimate for theta is used (defaults to 1)
% options.alpha_sym (scalar)    : if 1, then prior over theta's is symmetric (defaults to 1)
% options.eta_sym (scalar)      : if 1, then prior over beta's is symmetric  (defaults to 1)
% options.mask (T x D)          : binary matrix, documents may only use topics with non-zero value in mask (defaults to all 1's matrix)
%
% note 1: if var_beta=0 and var_gamma=0 than the PLSA model is obtained.
% note 2: if point-estimates for gamma (beta) are used then alpha (eta) is not estimated to avoid values < 1 
%
% Performs variational inference in LDA / PLSA models
% For explanation of variables see D. M. Blei, A. Y. Ng, and M. I. Jordan. Latent Dirichlet allocation, in Journal of Machine Learning Research , 3, 993-1022, 2003.
%
% For bugs / questions / etc email to verbeek@inrialpes.fr
%
% Variational distribution: q(theta,beta,z) = q(z) q(theta) q(beta)
%
% J.J. Verbeek, INRIA Rhone-Alpes, aug 2006.
%

if ~exist('options'); options=[];end
[model, options, gammas] = init(counts, T, options);

% run inference
tim  = 0;
iter = 0;
done = 0;
while ~done; iter= iter+1;tic;
    
   exp_theta = gammas.ex .* options.mask;
   sum_posts = eps + exp_theta .* (  model.beta.ex' * (counts./( model.beta.ex*exp_theta +eps)) );
   if ~options.var_gamma
        gammas.dp = normalize( sum_posts + repmat( model.alpha - 1, 1, model.D) ,1 );
        gammas.el = log( gammas.dp );
   else
        gammas.dp = sum_posts + repmat( model.alpha,     1, model.D);
        gammas.el = digamma( gammas.dp ) - repmat( digamma ( sum( gammas.dp, 1 ) ), T, 1); 
   end
   gammas.ex = exp( gammas.el );
    
   [F_new,E] =  LDA_F(counts,model, gammas,options); F(iter) = F_new/model.total;

   if options.learn_topics; 
        exp_theta   = gammas.ex .* options.mask;
        sum_posts   = eps + model.beta.ex .* ( (counts ./ ( model.beta.ex*exp_theta +eps ) ) * exp_theta' );      
        if ~options.var_beta;
            model.beta.dp = normalize( sum_posts + repmat( model.eta-1 , 1, T ), 1 );
            model.beta.el = log( model.beta.dp );
        else
            model.beta.dp = eps + sum_posts  + repmat( model.eta, 1, T);            
            model.beta.el = digamma(model.beta.dp) - repmat(digamma(sum(model.beta.dp,1)),model.W,1);
        end
        model.beta.ex = exp( model.beta.el );
   end
   if options.learn_alpha; model.alpha = fit_dirichlet_variational( model.alpha, mean(gammas.el,2),     options.alpha_sym ); end;
   if options.learn_eta;   model.eta   = fit_dirichlet_variational( model.eta,   mean(model.beta.el,2), options.eta_sym   ); end;
	
    tim = tim + toc;

    if iter>1; rel_ch = (F(iter)-F(iter-1)) / abs(mean(F(iter-1:iter))); else; rel_ch = 1;end
    if (rel_ch < options.min_change) & (iter> 5); done=1;end
    fprintf('%3d: F = %f   Relative change: %f   Average time per iteration %.2f sec. \n', iter, F(iter),rel_ch, tim/iter );
        
    if options.plot>0; 
        set(gcf,'Name',sprintf('Inference iteration %d',iter-1));
        n_plots = 3;
        subplot(n_plots,1,1);image(64* normalize(gammas.dp,1)); colorbar;title('Topics-Document estimate');
        subplot(n_plots,1,2);imagesc(normalize( model.beta.dp,1)'); colorbar;title('Words-Topic estimate');
        subplot(n_plots,1,3);plot(F(1:iter),'.-')
        drawnow;
    end;    

end;   
