%transform Growth Curve Model to variance version
function paras = gp_transformLGCM(hyp)
    paras.muI = hyp.mean(1);
    paras.muS = hyp.mean(2);
    paras.varI =  gp_forward(hyp.cov(1));
    paras.varS = gp_forward(hyp.cov(2));
    paras.covIS = hyp.cov(3);
    paras.noise = gp_forward(hyp.lik(1));
end