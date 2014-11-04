function D = KL_Dirichlet( q, p ) 
%
% D = KL_Dirichlet( q, p ) 
%
% compute KL divergence D( q || p ) of Dirichlet distributions q and P
%
% J.J. Verbeek, INRIA Rh™ne-Alpes, 2006.
%
% q.dp (T x N)
% q.el (T x N)
% p (T x M)
% D (N x M)
%

[T1, N] = size(q.dp);
[T2, M] = size(p);

if T1 ~= T2; fprintf('--> Dirichlet KL cannot be computed: distributions of different dimensionalities...\n'); D=[]; return;end

q0 = sum(q.dp, 1);
p0 = sum(p, 1);

Gq = gammaln(q.dp);
Gp = gammaln(p);

t1 = repmat( gammaln( q0 )', 1, M ) - repmat( gammaln( p0 ) , N, 1 ); 

t2 = repmat( sum( Gp, 1 )  , N ,1 ) - repmat( sum( Gq, 1 )' , 1, M ); 

t3 = repmat( sum( q.dp .* q.el, 1 )', 1, M )  ;
t3 = t3 - q.el' * p;
           
D = t1 + t2 + t3;