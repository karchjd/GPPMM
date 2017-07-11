%Latent Growth Curve Model
function model = gp_modelLGCM(muI, muS,varI,varS,covIS,noise)
    %structure
    model.meanf = {@meanSum,{@meanConst,@meanLinear}};
    model.covf = {@covSum,{@covConst,{@covScale {@covLIN}},@covCorr}};
    model.lik = @likGauss;
    
    if nargin<1
        %some starting values that work
        muI = 1;
        muS = 0;
        varI=1;
        varS=1;
        covIS=0.5;
        noise = 1;
    end
    
    hyp.mean = [muI;muS];
    hyp.cov = [gp_backward(varI);gp_backward(varS);covIS];
    hyp.lik = gp_backward(noise);
    model.hyp = hyp;
end
