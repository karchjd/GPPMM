function K = covCorrFast(hyp, x, z, i)

% Linear covariance function. The covariance function is parameterized as:
%
% k(x^p,x^q) = x^p'*x^q
%
% The is one hyperparameter:
%
% hyp = []
%
% 
%
% Copyright (c) by Julian Karch, 2015
%
% See also COVFUNCTIONS.M.
if nargin<2, K = 1; return; end                  % report number of parameters
if nargin<3, z = []; end                                   % make sure, z exists
xeqz = numel(z)==0; dg = strcmp(z,'diag') && numel(z)>0;        % determine mode
s2 = hyp;
% compute inner products
if dg                                                               % vector kxx
  K = s2*(x+x);
else
  if xeqz                                                 % symmetric matrix Kxx
    K = s2*vektorAddition(x,x);
  else                                                   % cross covariances Kxz
    K = s2*vektorAddition(x,z);
  end
end

if nargin>3                                                        % derivatives
  if i==1
    K = K/s2;
  else
    error('Unknown hyperparameter')
  end
end
end

function K=vektorAdditionNaive(x,y) %make quicker
    n = size(x,1);
    ns = size(y,1);
    K = nan*zeros(n,ns);
    for i=1:n
        for j=1:ns
            K(i,j) = x(i)+y(j);
        end
    end
end

function K=vektorAddition(x,y) %make quicker
    n = size(x,1);
    ns = size(y,1);
    K = repmat(x,1,ns);
    K = K+repmat(y',n,1);
end
