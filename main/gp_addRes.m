%add parameter restriction of the form $\theta_i=c$
function model = gp_addRes(model,fname,index,value)
    if ~isfield(model,'prior')|| ~isfield(model.prior,fname)
        model.prior.(fname)= cell(1,numel(model.hyp.(fname))); 
    end
    model.prior.(fname){index} = @priorDelta;
    model.hyp.(fname)(index) = value;
    model.inf = {@infPrior,@infExact,model.prior};
end