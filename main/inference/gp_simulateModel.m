function Y =  gp_simulateModel(model,X)
    if isfield(model,'lik') && isequal(model.lik,@likGauss);
        model.covf = {@covSum {model.covf @covNoise}};
        model.hyp.cov(end+1) = model.hyp.lik;
    end
    Y = gp_simulate(model.meanf,model.covf,model.hyp,X);
end