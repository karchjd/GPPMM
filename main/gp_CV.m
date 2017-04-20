
function out = gp_CV(models,options)
NModel = numel(models);
folds = options.folds;
%assert that all models use the same X and Y
for i=1:NModel
     if i==1
        X = models{1}.X;
        Y = models{1}.Y;
     else
        if iscell(X)
            assert(numel(X)==numel(Y));
            for j=1:numel(X)
                assert(isequal(models{i}.X{j}(~isnan(X{j})),X{j}(~isnan(X{j}))));
                assert(isequal(models{i}.Y{j}(~isnan(Y{j})),Y{j}(~isnan(Y{j}))));
            end
        else
        assert(isequal(models{i}.X(~isnan(X)),X(~isnan(X))));
        assert(isequal(models{i}.Y(~isnan(Y)),Y(~isnan(Y))));
        models{i}.X = [];
        models{i}.Y = [];
        end
     end
end
model = gpPanel(models{1},0);
X = model.X;
Y = model.Y;
NData = numel(model.Y);
tmp = repmat(1:folds,1,ceil(NData/folds));
foldAsso = tmp(randperm(NData));
logl = nan*zeros(NModel,folds); %log likelihood out of sample
for i=1:NModel
    for fold=1:folds
        %get training and test set
        model = models{i};
        train = model;
        test = model;
        testInd = foldAsso==fold;
        train.X = X(~testInd);
        train.Y = Y(~testInd);
        test.X = X(testInd);
        test.Y = Y(testInd);
        %compute maximum likelihood parameter
        trainFit = gpPanel(train);
        test.hyp = trainFit.mlHyp;
        testRes = gpPanel(test,0);
        logl(i,fold)=testRes.mll;
    end
end
out.folddet = logl;
out.sum = sum(logl,2);
out.models = models;
out.X = X;
out.Y = Y;
out.folds = foldAsso;
[~,out.winner] = min(out.sum); 
end