function [p,ddf,LR] = gp_LR(modelFull,modelRes,ddf)
if nargin<3
%%check that the models are compatible for LR test
fnames = fieldnames(modelFull)';
fnames = setdiff(fnames,{'mlHyp','inf','prior','hyp','mll','mllHist'});
for fname=fnames
    assert(isequal(modelFull.(fname{1}),modelRes.(fname{1})));
end


assert(isequal({@infPrior,@infExact},modelRes.inf(1:2)));



%get df
redPrior = modelRes.inf{3};
if numel(modelFull.inf)>1 && isequal(modelFull.inf(1:2),{@infPrior,@infExact})
    fullPrior = modelFull.inf{3};
    priors = {redPrior,fullPrior};
    %%check that the reduced model has all the delta priors of the full
    %model
    fnames=fieldnames(fullPrior)';
    for fname=fnames
        for i=1:numel(fullPrior.(fname{1}))
            assert(isequal(func2str(redPrior.(fname{1}){i}),'priorDelta'));
        end
    end
else
    priors = {redPrior};
end


%both models may only have delta priors
for prior=priors
    fnames=fieldnames(prior{1})';
    for fname=fnames
        for entry=prior{1}.(fname{1})
            if ~isempty(entry{1})
                assert(isequal(func2str(entry{1}),'priorDelta'))
            end
        end
    end
end



%%count the elemnets in each prior
ndelta = [0 0];
for i=1:numel(priors)
    fnames=fieldnames(priors{i})';
    for fname=fnames
        ptmp = priors{i}.(fname{1}); %cell for this particular aspect
        tndelta = sum(cellfun(@(x) ~isempty(x),ptmp));
        ndelta(i) = ndelta(i)+tndelta;
    end
end

assert(ndelta(1)>ndelta(2));
ddf = ndelta(1)-ndelta(2);
else
    fprintf('All checks are turned off, make sure that you compare two valid models!!!\n');
end
LR = 2*(modelRes.mll-modelFull.mll);
p = 1-chi2cdf(LR,ddf);
assert(p<=1);
end



