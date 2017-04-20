%transform Growth Curve Model to variance version
function paras = gp_transformAR(hyp)
    toPhi = @(x) exp(-1/exp(x));
    toSigma = @(var1,phi) exp(2*var1)*(1-phi^2); 
    paras.phi = toPhi(hyp.cov(1));
    paras.c = (1-paras.phi)*hyp.mean;
    paras.sigma = toSigma(hyp.cov(2),paras.phi);
end