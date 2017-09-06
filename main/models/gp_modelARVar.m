%see also gs_ARModel, for the prototype a lot of this was developed there
function model = gp_modelARVar(var)
    %mean and cov function
    meanf = {@meanConst};
    if var
    covf = {@covProd {{@covMaterniso 1},@covSEiso}};
    hyp.cov = [gp_backward(1),log(100),gp_backward(1),log(100)];
    else
        covf={@covMaterniso 1};
        hyp.cov = [gp_backward(1),log(100)];
    end
    hyp.mean = 3;
    
    model.meanf= meanf;
    model.covf = covf;
    model.hyp = hyp;
    model.lik = @likGauss;
    model.hyp.lik = gp_backward(1);
    
end
