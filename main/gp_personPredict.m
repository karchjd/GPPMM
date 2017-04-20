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
function out = gp_personPredict(model,i,X)
    Xtrain = model.X{i};
    Ytrain = model.Y{i};
    Xpred = X;
    [out.muPred,out.varPred, out.muLa, out.varLa]=gp(model.mlHyp, @infExact, model.meanf, model.covf, model.lik, Xtrain, Ytrain, Xpred);    
    out.Xtrain=Xtrain;
    out.Ytrain=Ytrain;
    out.Xpred = Xpred;
end