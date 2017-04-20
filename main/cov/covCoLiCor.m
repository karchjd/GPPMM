function K = covCoLiCor(hyp, x, z, i)

% covariance function for a constant function. The covariance function is
% parameterized as:
%
% k(x^p,x^q) = s2;
%
% The scalar hyperparameter is:
%
% hyp = [ log(sqrt(s2)) ]
%
% Copyright (c) by Carl Edward Rasmussen and Hannes Nickisch, 2010-09-10.
%
% See also COVFUNCTIONS.M.

if nargin<2, K = 3; return; end                  % report number of parameters
if nargin<3, z = []; end                                   % make sure, z exists
xeqz = isempty(z); dg = strcmp(z,'diag');                       % determine mode

co = exp(2*hyp(1));
lin = exp(2*hyp(2)); %change to achieve numerical identity with default version
cor = hyp(3);
n = size(x,1);

if nargin<4
    if dg                                                               % vector kxx
        K = co*ones(n,1)+ lin*sum(x.*x,2)+cor*(x+x);
    else
        if xeqz                                                 % symmetric matrix Kxx
            K = co*ones(n)+ lin*(x*x')+cor*vektorAddition(x,x);
        else                                                   % cross covariances Kxz
            K = co*ones(n,size(z,1))+lin*(x*z')+cor*vektorAddition(x,z);
        end
    end

else% derivatives
    assert(~dg && xeqz)
  if i==1
    K = 2*co*ones(n);
  elseif i==2
    K = 2*lin*(x*x');
  elseif i==3
    K=vektorAddition(x,x); %change to achieve numerical identity
  else
    error('Unknown hyperparameter')
  end
end

function K=vektorAddition(x,y) %make quicker
    n = size(x,1);
    ns = size(y,1);
    K = repmat(x,1,ns);
    K = K+repmat(y',n,1);
end
end