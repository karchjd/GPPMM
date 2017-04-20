function A = meanConstLinear(hyp, x, i)

% Linear mean function. The mean function is parameterized as:
%
% m(x) = sum_i a_i * x_i;
%
% The hyperparameter is:
%
% first constant then linear
%
% Copyright (c) by Carl Edward Rasmussen and Hannes Nickisch, 2010-01-10.
%
% See also MEANFUNCTIONS.M.

if nargin<2, A = 2; return; end             % report number of hyperparameters 
[n,D] = size(x);
if any(size(hyp)~=[D+1,1]), error('Exactly D+1 hyperparameters needed.'), end
c = hyp(1);
a = hyp(2:end);
if nargin==2
  A = x*a+c*ones(size(x,1),1);                                                       % evaluate mean
else
  if i==1
      A = ones(size(x,1),1);
  elseif i<=D+1
    A = x(:,i-1);                                                     % derivative
  else
    A = zeros(n,1);
    error('Hello');
  end
end