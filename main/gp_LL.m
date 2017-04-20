function out = gp_LL(models,~)
NModel = numel(models);
%assert that all models use the same X and Y
for i=1:NModel
     if i==1
        X = models{1}.X;
        Y = models{1}.Y;
     else
        assert(isequal(models{i}.X,X));
        assert(isequal(models{i}.Y(~isnan(Y)),Y(~isnan(Y))));
     end
end

for i=1:NModel
    %if models were not run yet run them
    if ~isfield(models{i},'mllHist')
        models{i} = gpPanel(models{i});
    end
    %save space
    if i~=1
        models{1}.X = [];
        models{2}.Y = [];
    end
end
out = models;
end