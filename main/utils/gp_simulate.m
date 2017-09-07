%Simulate from a gp Model
function [y,latent]=gp_simulate(meanF,covarianceF,hyp,X,errorM,errorCov,seed)
    X = X';
    if nargin <5
        mode = false;
        mtdix = true(numel(hyp.mean),1);  
        ctdix = true(numel(hyp.cov),1);
    else
        mode = true;
        %%find out which hyperparameters belong to which function
        D = size(X,2);
        mtdix = 1:eval(feval(meanF{:}));
        ctdix = 1:eval(feval(covarianceF{:}));
    end
    if ~iscell(meanF)
        meanF = {meanF};
    end
    if ~iscell(covarianceF)
        covarianceF = {covarianceF};
    end
    %calculate mean and covariance for the Xs
    meanV = feval(meanF{:},hyp.mean(mtdix),X);
    covM = feval(covarianceF{:},hyp.cov(ctdix),X);
    if nargin==7
        rng(seed);
    end
    y=mvnrnd(meanV,covM);
    if mode
        latent=y;
        medix = setdiff(1:numel(hyp.mean),mtdix);
        cedix = setdiff(1:numel(hyp.cov),ctdix);
        meanVErr = feval(errorM{:},hyp.mean(medix),X);
        covMErr = feval(errorCov{:},hyp.cov(cedix),X);
        err = mvnrnd(meanVErr,covMErr);
        y = latent + err;
    end
end

