%see also gs_ARModel, for the prototype a lot of this was developed there
function model = gp_modelAR(meanS,sphi,slik,ssigma)
    %mean and cov function
    meanf = @meanConst;
    covf = {@covMaterniso 1};
    
    %convert values from SEM meaning
    hyp.mean = meanS;
    
    %cov
    fromPhi = @(x) -log(log(1/x));
    fromSigma = @(sigma,phi) log(-sigma/(-1+phi^2))/2;
    
        
    if slik~=0
        hyp.lik = gp_backward(slik);
        model.lik = @likGauss;
    end
    sell = fromPhi(sphi);
    hyp.cov = [sell fromSigma(ssigma,sphi)];
    
    model.meanf= meanf;
    model.covf = covf;
    model.hyp = hyp;
    
end
