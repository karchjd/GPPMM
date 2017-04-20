function resM = gp_LCGFit(simDataPath,p,resPath)


%% define model
 if isdeployed || ~ismac()
     fast = 2; %because on the grid there only exists the fast version which 
               %uses the same functions as the slow version on my computer
 else
     fast = 0;
 end
model = gp_modelLGCM(fast);
p=str2double(p);
tmp = functions(model.covf);
fprintf('Using %s\n',tmp.function);

%get data
inData = load(simDataPath);
Y = inData(:,2:(p+1)); %measurements
X = inData(:,(p+2):end); %definition variables
model.X=X;
model.Y=Y;

%run
%profile off
% profile on
tstart =tic();
runFull = gpPanel(model);
speed = toc(tstart);
% profile viewer
%%remember and transform to R meaning
resM=gp_transformLGCM(runFull.mlHyp);
resM.m2ll = 2*runFull.mll;
resM.speed = speed;
runTimes = gp_getRunTimes(runFull);
f = fieldnames(runTimes);
for i = 1:length(f)
    resM.(f{i}) = runTimes.(f{i});
end
resM.data=X(1,1);
save(resPath,'resM','-v7');
fprintf('Succesfully saved\n');
end
