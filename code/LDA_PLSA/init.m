function [model, options, gammas] = init( counts, T, options);

model.T             = T;
[model.W, model.D]  = size( counts );
model.total         = sum(counts(:));

% initialize the options

if ~isfield(options,'min_change');	options.min_change = 1e-4; 	end;
if ~isfield(options,'plot');  		options.plot = 0;           end;

if ~isfield(options,'var_gamma');   options.var_gamma =1;       end;
if ~isfield(options,'alpha_sym');  	options.alpha_sym = 1;		end;
if ~isfield(options,'learn_alpha'); options.learn_alpha=1;      end;

if ~isfield(options,'var_beta');    options.var_beta =1;        end;
if ~isfield(options,'eta_sym');  	options.eta_sym = 1;		end;
if ~isfield(options,'learn_eta');   options.learn_eta=1;        end;

if ~isfield(options,'mask');  		options.mask = ones(model.T,model.D);	end;

if ~isfield(options,'learn_topics');options.learn_topics=1;     end;

if  isfield(options,'model');
    model = options.model;		
    fprintf('--> Initializing from given model, and ');if options.learn_topics==0; fprintf('not ');end;
    fprintf('updating the topics.\n');
end;

if ~options.var_beta;  options.learn_eta=0;  end;
if ~options.var_gamma; options.learn_alpha=0;end;

fprintf('--> LDA variational inference started with %d documents and vocabulary of size %d\n',model.D,model.W);
fprintf('    using %d topics and %f minimal relative change.\n',model.T,options.min_change);
fprintf('--> Total number of words in data: %d (%.2f on average per document)\n\n',model.total, model.total/model.D);

% initialize the gammas
tmp = dirichlet_sample(ones(model.T,1),model.D);
if ~options.var_gamma;    
    gammas.el = log(normalize(tmp,1)+eps);
else
    gammas.dp = normalize(eps+tmp,1)*model.total/model.D;
    gammas.el = digamma( gammas.dp(:,:) ) - repmat( digamma ( sum( gammas.dp(:,:),1) ), model.T, 1);    
end
gammas.ex       = exp( gammas.el );

if ~isfield(options,'model');
    tmp = dirichlet_sample(ones(model.W,1),model.T);
    if ~options.var_beta;
        model.beta.dp = normalize(tmp,1);
        model.beta.el = log(model.beta.dp+eps);
    else
        model.beta.dp = normalize(eps + tmp,1)*model.total/model.T;
        model.beta.el = digamma(model.beta.dp) - repmat( digamma(sum(model.beta.dp,1)) ,model.W,  1);
    end
end
model.beta.ex   = exp( model.beta.el );

model.eta   = ones(model.W,1); % non-informative prior
model.alpha = ones(model.T,1); % non-informative prior            