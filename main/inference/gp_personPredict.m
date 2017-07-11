    %{
    gp_personPredict is a method that given a fitted GPPM panel returns the
    predictive distribution given this model for person i at the values of IVs
    contained in the matrix X
    @param model the fitted GPPM model
    @param i index of the person for which the prediction is performed
    @param X matrix that contains the values of IVs in its rows
    @return struct with two fields: muPred predictive mean for every point
                                    varPred predictive covariance matrix for all points
    %}
    function out = gp_personPredict(model,i,X,noTrain)
    if nargin>3
        testSet = ismember(model.X{i},noTrain);
    else
        testSet = false(size(model.X{i},1),1);
    end
    Xtrain = model.X{i}(~testSet);
    Ytrain = model.Y{i}(~testSet);
    Xtest = model.X{i}(testSet);
    Ytest = model.Y{i}(testSet);
    Xpred = X;
    if (~isempty(Xtrain))
        %conditional
        [out.muPred,out.varPred, out.muLa, out.varLa]=gp(model.mlHyp, @infExact, model.meanf, model.covf, model.lik, Xtrain, Ytrain, Xpred);

    else
        %unconditional
        out.muPred= feval(model.meanf{:},model.mlHyp.mean,Xpred);
        out.muLa = out.muPred;
        out.varLa = diag(feval(model.covf{:},model.mlHyp.cov,Xpred));
        if ~isempty(model.lik)
            out.varPred = out.varLa + gp_forward(model.mlHyp.lik);
        else
            %latent does not exist
            out.varPred = out.varLa;
            out.varLa =[];
            out.muLa = [];
        end
    end
    out.Xtrain=Xtrain;
    out.Ytrain=Ytrain;
    out.Xpred = Xpred;
    if ~isempty(Xtest)
        out.Xtest=Xtest;
        out.Ytest=Ytest;
    end
    end