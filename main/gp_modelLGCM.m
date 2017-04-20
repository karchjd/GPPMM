%Latent Growth Curve Model
function model = gp_modelLGCM(fast)
    if nargin < 1
        fast = false;
    end
    if fast
        covSumV = @covSumFast;
        mSum = @meanSumFast;
    else
        covSumV = @covSum;
        mSum = @meanSum;
    end
        covCo = @covConst;
        covLI = @covLIN;
        covCor = @covCorr;
        mConst = @meanConst;
    %mean and cov function
    meanf ={mSum,{mConst @meanLinear}};
    covf = {covSumV, {covCo, {@covScale {covLI}} , covCor}};
    if fast==2
        meanf = @meanConstLinear;
        covf = @covCoLiCor;
    end
    lik = @likGauss;
    
    %same starting values as the SEM I am using
    muI = 1;
    muS = 0;
    hyp.mean = [muI;muS];
    
    varI=1;
    varS=1;
    covIS=0.5;
    noise = 1;
    hyp.cov = [gp_backward(varI);gp_backward(varS);covIS];
    hyp.lik = gp_backward(noise);
    
    model.meanf= meanf;
    model.covf = covf;
    model.lik = lik;
    model.hyp = hyp;
end
