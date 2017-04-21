% GP_ADDRES   Add parameter restriction
%   
%   gp_addRes(model,fname,index,value) returns a restricted model
%   
%   Parameters:
%       model: Gaussian Process Panel model 
%       fname: Name of the parameter type to restrict ('mean','cov','lik')
%       index: Index of the parameter
%       value: Value to restrict parameter to
%   ones.
function model = gp_addRes(model,fname,index,value)
    if ~isfield(model,'prior')|| ~isfield(model.prior,fname)
        model.prior.(fname)= cell(1,numel(model.hyp.(fname))); 
    end
    model.prior.(fname){index} = @priorDelta;
    model.hyp.(fname)(index) = value;
    model.inf = {@infPrior,@infExact,model.prior};
end