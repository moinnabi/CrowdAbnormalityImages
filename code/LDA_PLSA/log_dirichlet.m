function L = log_dirichlet( H, A);
%
% L = log_dirichlet( H, A);
%
% H ( k x N) : N k-dimensional distributions - NOTE: have to be LOGS of normalized distribution values !!!
% A ( k x C) : parameters of C Dirichlets with dimension k
% 
% L ( C x N) : log-likelihoods under the different Dirichlets

N = size(H,2);

L = (A-1)' * H;
L = L + repmat( gammaln(sum(A,1)') - sum( gammaln(A),1)', 1, N);
