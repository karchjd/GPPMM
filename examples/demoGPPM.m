%%settings
rng(12320);
nPers = 1000;
nTime = 10;

muI = 100;
muS = -5;
varI = 2;
varS = 3;
covIS = 0.5;
noise = 1;

%%generate LGCM
lgcm = gp_modelLGCM(muI,muS,varI,varS,covIS,noise);
lgcm.X = repmat(1:nTime,nPers,1);
lgcm.X = lgcm.X + randn(nPers,nTime);  %add random noise to create unequal
                                       %measurement time points within and
                                       %between
lgcm.Y = nan*zeros(size(lgcm.X));

%%for every person generate data according to the model
for i=1:nPers
    lgcm.Y(i,:) = gp_simulateModel(lgcm,lgcm.X(i,:));
end

%run ML estimation
lgcmFit = gpPanel(lgcm,5); %number of iterations set to 5 for speed here,
                           %defaul valued recommended for real data

%make Person specific predictions for person indexed by 1
predsIndi = gp_personPredict(lgcmFit,1,(-3:0.1:3)');
gp_plotPersonPredict(predsIndi,true);

%compare estimates to true values
fprintf('muI TRUE: %.2f vs Estimate: %.2f \n',muI,lgcmFit.mlHyp.mean(1));
fprintf('muS TRUE: %.2f vs Estimate: %.2f \n',muS,lgcmFit.mlHyp.mean(2));
fprintf('varI TRUE: %.2f vs Estimate: %.2f \n',varI,gp_forward(lgcmFit.mlHyp.cov(1)));
fprintf('varS TRUE: %.2f vs Estimate: %.2f \n',varS,gp_forward(lgcmFit.mlHyp.cov(2)));
fprintf('covIS TRUE: %.2f vs Estimate: %.2f \n',covIS,lgcmFit.mlHyp.cov(3));
fprintf('noise TRUE: %.2f vs Estimate: %.2f \n',noise,gp_forward(lgcmFit.mlHyp.lik(1)));