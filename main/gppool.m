%
% Gaussian Process inference and prediction for a pooled sample.
% gppool(...) is a wrapper function for gp(...) from GPML for MATLAB
% Gppool takes matrices X and Y with columns corresponding to multiple
% time series and rows corresponding to time points. Gppool allows
% inference of parameters over the set of time series under the assumption
% that the time series were collected independently but from the same
% generating process.
%
%
% (c) 09/2013 Andreas Brandmaier
%       (brandmaier@mpib-berlin.mpg.de)
%    08/2015 Julian Karch
%       (karch@mpib-berlin.mpg.de)
%
% Example usage (Inference):
%
% hyp = minimize(hyp, @gppool, -10000, 
%    @infExact, meanfunc, covfunc, likfunc, x, y);
%
%
%TODO: test case
function [varargout] = gppool(hyp, inf, meanfunc, covfunc, likfunc, X, Y)


for i = 1:numel(Y);
    
    % obtain measurements "y" and time points "x" of i-th time series
    x = X{i};
    y = Y{i};
    
    % remove NaN values
    x = x(~isnan(x));
    y = y(~isnan(y));
    
    % evaluate marginal likelihood of y give x and model
    [lik,dlik] = gp(hyp, inf, meanfunc, covfunc, likfunc, x, y);
    
    % sum up loglikelihood and derivatives
    if (i == 1)
        liksum = lik;
        dliksum = dlik;
    else
     liksum = liksum + lik;
     fields = fieldnames(dlik);

     for j=1:numel(fields)
       dliksum.(fields{j}) = dliksum.(fields{j}) + dlik.(fields{j}); 
     end        
    end
    
    
end

% prepare result for returning
if (nargout == 1)
   varargout = {liksum}; 
else
    varargout = {liksum, dliksum};
end

end
