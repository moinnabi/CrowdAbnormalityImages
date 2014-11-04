function [F, E] = LDA_F(data, model, gammas, options)

E = sum( data.*log( eps + model.beta.ex * gammas.ex  ),1) ;

if ~options.var_gamma
    E = E + log_dirichlet( gammas.el , model.alpha );
else
    E = E - KL_Dirichlet( gammas, model.alpha )';		
end
    
if ~options.var_beta
    KL = -sum(log_dirichlet( model.beta.ex, model.eta));
else
    KL = sum( KL_Dirichlet( model.beta, model.eta ) );    % entropy and exp. logl. of word_topic distributions
end

F  = - KL + sum( E );
