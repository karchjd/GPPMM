fullmodel = gp_modelLGCM(false);
fullmodel.name = 'Full Model';
p = 5;
N = 30;

[X,Y] = gp_simulatePanel(fullmodel,N,[1 100],p);

fullmodel.X=X;
fullmodel.Y=Y;

%stupid model
redModel =[];
redModel.name = 'Reduced Model';
redModel.meanf = @meanConst;
redModel.covf = @covConst;
redModel.lik = @likGauss;
redModel.hyp.cov = 1;
redModel.hyp.mean = 1;
redModel.hyp.lik = 1;
redModel.X = X;
redModel.Y = Y;

%run
options.folds = 5;
out = gp_CV({fullmodel, redModel},options);
gp_printCV(out);