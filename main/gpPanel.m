%git a Gaussian Process Panel Model
function model = gpPanel(model,numit) %model needs meanf, covf, hyp, X, Y as fields, might have lik
    if nargin<2
         numit = 100000000000000;
    end
    %get rid of the standard noise gaussian process in the likelihood
    %function
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
    global runTime;
    %code for runTime analysis
    runTime.implied.time=0;
    runTime.implied.count=0;
    runTime.grad.time=0;
    runTime.grad.count=0;
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
    model.runTime = runTime;
end