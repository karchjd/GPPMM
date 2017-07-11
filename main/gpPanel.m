% gpPanel   Fits a Gaussian Process Panel Model
%   
%   fitmodel = gpPanel(model,numit) returns a fitted model
%   
%   Parameters:
%       model: Gaussian Process Panel model 
%       numit: number of iterations, optional
%   A Gaussian Process Panel model is a structure with the following
%   required fields:
%       meanf: the mean function
%       covf: the covariance function
%       lik: the likelihood function (optional)
%       hyp: a structure with starting values for all parameters
%           hyp.mean a vector of starting values for the mean parameters
%           hyp.cov a vector of starting values for the mean parameters
%           hyp.lik a vector of starting values for the likelihood
%           parameters
%       X: a Nx1 cell  arrary containing the predictors, N are the number
%       of persons the cell entry{X} contains a T_ixP matrix, where T_i are the
%       number of obsered time points for person i and P the number of predictors per timepoint
%       Y: a Nx1 cell  arrary containing the to be modeled data. The cell
%       entry{X} contains a T_ix1 vector of observations

function model = gpPanel(model,numit)
    if nargin<2
         numit = 100000000000000; %set iterations to max if not supplied
    end
    %get rid of the standard noise gaussian process in the likelihood
    %function, if no likelihood is specified
    if ~isfield(model,'lik')
        model.lik = [];
    end
    if isempty(model.lik) 
        model.prior.lik = {@priorDelta};
        model.hyp.lik = -Inf;
        model.inf = {@infPrior,@infExact,model.prior};
    end
    %default
    if ~isfield(model,'inf')
        model.inf = @infExact;
    end
    %convert matrix intputs into cell representation
    X = model.X;
    Y = model.Y;
    if ~iscell(X)
        X = mat2cell(X,ones(size(X,1),1),size(X,2));
        X = cellfun(@(x)x',X,'UniformOutput',false);
    end
    if ~iscell(Y)
        Y = mat2cell(Y,ones(size(Y,1),1),size(Y,2));
        Y = cellfun(@(x)x',Y,'UniformOutput',false);
    end
    
    %handle missing values
    X = cellfun(@(x,y)x(~isnan(y)),X,Y,'UniformOutput',false);
    Y = cellfun(@(x,y)y(~isnan(y)),X,Y,'UniformOutput',false);
    model.X = X;
    model.Y = Y;
    
    [model.mlHyp,mllHist] = minimize(model.hyp, @gppool, numit, model.inf, model.meanf, model.covf, model.lik, model.X, model.Y);
    
    model.mll = mllHist(end);
    model.mllHist=mllHist;
end