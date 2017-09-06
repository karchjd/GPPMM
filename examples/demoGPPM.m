%%settings
rng(10130);
nPers = 100;
nTime = 10;

%%generate LGCM
lgcm = gp_modelLGCM(58,-1,258,0.4,0,10);
lgcm.X = randn(nPers,nTime);  %random observation time points for everybody
lgcm.Y = nan*zeros(size(lgcm.X));

%%for every person generate data according to the model
for i=1:nPers
    lgcm.Y(i,:) = gp_simulateModel(lgcm,lgcm.X(i,:));
end

%run ML estimation
lgcmFit = gpPanel(lgcm);

%make Person specific predictions for person indexed by 1
predsIndi = gp_personPredict(lgcmFit,1,(-3:0.1:3)');
gp_plotPersonPredict(predsIndi,true);