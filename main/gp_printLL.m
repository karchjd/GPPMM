function gp_printLL(LLres)
%get negative log liklihoods and number of parameters
minusLLs = nan*zeros(numel(LLres),1);
nPar = minusLLs;
for i=1:numel(LLres)
    if isequal(LLres{i}.inf,@infExact)
        corTerm = 0;
    elseif isequal({@infPrior,@infExact},LLres{i}.inf(1:2))
        %count priors
        prior = LLres{i}.inf{3};
        fnames=fieldnames(prior)';
        corTerm =0;
        for fname=fnames
            ptmp = prior.(fname{1}); %cell for this particular aspect
            tndelta = sum(cellfun(@(x) ~isempty(x),ptmp));
            corTerm = corTerm+tndelta;
        end
    end
    
    minusLLs(i)= [LLres{i}.mll];
    tnPar =0;
    fnames = fieldnames(LLres{i}.hyp);
    for j=1:numel(fnames)
        tnPar = tnPar + numel(LLres{i}.hyp.(fnames{j}));
    end
    nPar(i) = tnPar-corTerm;
end
%minus two = log likelihood
minusTwoLLs = 2*minusLLs;

%compute AIC
AICs = minusTwoLLs + 2*nPar;

%compute BIC
N = size(LLres{1}.Y,1);
BICs = minusTwoLLs + nPar*log(N);


%nice output
fprintf('\n');
for crit={'AIC' 'BIC'}
    crit = crit{1};
    vals = eval([crit 's']);
    [~,index] = sort(vals);
    for i=1:2
        mString = {'winner', 'second'};
        %fprintf('The %s %s was %s with %f\n',crit,mString{i},LLres.{index(i)}.name,vals(index(i));
        fprintf('The %s %s was %s with %.2f and %d paramaters\n',crit,mString{i},LLres{index(i)}.name,vals(index(i)),nPar(index(i)));
    end
    fprintf('%s difference: %.3f\n',crit,vals(index(2))/vals(index(1)));
    fprintf('\n');
end
end