function K = covSumFast(cov, hyp, x, z, i)

% covSum - compose a covariance function as the sum of other covariance
% functions. This function doesn't actually compute very much on its own, it
% merely does some bookkeeping, and calls other covariance functions to do the
% actual work.
%
% Copyright (c) by Carl Edward Rasmussen & Hannes Nickisch 2010-09-10.
%
% See also COVFUNCTIONS.M.

if ~isempty(cov)==0, error('We require at least one summand.'), end
j=[1 1 1];
% j = nan*zeros(numel(cov),1);
% for ii = 1:numel(cov)                        % iterate over covariance functions
%     f = cov{ii}; 
%     if iscell(f)
%         j(ii) = feval(f{:});
%     else
%         j(ii) = f();
%     end                           % collect number hypers
% end

nHyp = sum(j);
if nargin<3                                        % report number of parameters
  K = sum(j);
  return;
end
if nargin<4, z = []; end                                   % make sure, z exists

v = nan*zeros(nHyp);% v vector indicates to which covariance parameters belong
counter = 1;
for ii = 1:length(cov) 
    v(counter:(counter+j(ii)-1)) = ii*ones(j(ii),1); 
    counter = counter + j(ii);
end

if nargin<5                                                        % covariances
  K = 0; if nargin==3, z = []; end                                 % set default
  for ii = 1:length(cov)                      % iteration over summand functions
    f = cov(ii); if iscell(f{:}), f = f{:}; end % expand cell array if necessary
    K = K + feval(f{:}, hyp(v==ii), x, z);              % accumulate covariances
  end
else                                                               % derivatives
  if i<=length(v)
    vi = v(i);                                       % which covariance function
    j = sum(v(1:i)==vi);                    % which parameter in that covariance
    f  = cov(vi);
    if iscell(f{:}), f = f{:}; end         % dereference cell array if necessary
    K = feval(f{:}, hyp(v==vi), x, z, j);                   % compute derivative
  else
    error('Unknown hyperparameter')
  end
end