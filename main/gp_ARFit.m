function resM = gp_ARFit(simDataPath,p,resPath)


%% define model
model = gp_modelAR(1,0.8,0,0.1); %same starting values as the sem i am using
p=str2double(p);

%get data
inData = load(simDataPath);
Y = inData; %measurements
X = 1:numel(Y); %definition variables
model.X=X;
model.Y=Y;

%run
tstart =tic();
runFull = gpPanel(model);
speed = toc(tstart);
% profile viewer
%%remember and transform to R meaning
resM=gp_transformAR(runFull.mlHyp);
resM.m2ll = 2*runFull.mll;
resM.speed = speed;
runTimes = gp_getRunTimes(runFull);
f = fieldnames(runTimes);
for i = 1:length(f)
    resM.(f{i}) = runTimes.(f{i});
end
resM.data=Y(1,1);
save(resPath,'resM','-v7');
fprintf('Succesfully saved\n');
feval(runFull.meanf, runFull.mlHyp.mean, X')
end
