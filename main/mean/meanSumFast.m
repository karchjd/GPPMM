function A = meanSumFast(mean, hyp, x, i)

% meanSum - compose a mean function as the sum of other mean functions.
% This function doesn't actually compute very much on its own, it merely does
% some bookkeeping, and calls other mean functions to do the actual work.
%
% m(x) = \sum_i m_i(x)
%
% Copyright (c) by Carl Edward Rasmussen & Hannes Nickisch 2010-08-04.
%
% See also MEANFUNCTIONS.M.

j=[1 1];
nHyp = sum(j);
if nargin<3                                        % report number of parameters
  A = nHyp; 
  return;
end
v = nan*zeros(nHyp);% v vector indicates to which covariance parameters belong
counter = 1;
for ii = 1:length(mean) 
    v(counter:(counter+j(ii)-1)) = ii*ones(j(ii),1); 
    counter = counter + j(ii);
end
[n] = size(x,1);


if nargin==3                                               % compute mean vector
  A = zeros(n,1);                                               % allocate space
  for ii = 1:length(mean)                     % iteration over summand functions
    f = mean(ii); if iscell(f{:}), f = f{:}; end   % expand cell array if needed
    A = A + feval(f{:}, hyp(v==ii), x);                       % accumulate means
  end
else                                                 % compute derivative vector
  if i<=length(v)
    ii = v(i);                                             % which mean function
    j = sum(v(1:i)==ii);                          % which parameter in that mean
    f = mean(ii);
    if iscell(f{:}), f = f{:}; end         % dereference cell array if necessary
    A = feval(f{:}, hyp(v==ii), x, j);                      % compute derivative
  else
    A = zeros(n,1);
  end
end