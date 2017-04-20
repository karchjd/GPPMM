fullmodel = gp_modelLGCM(0);
p = 3;
N = 10;
ctTimes = [false,true];
for i=1:2
    
    %call R here
    eval(sprintf('!unset DYLD_LIBRARY_PATH; Rscript LR_SEM.R %i %i %i',p,N,ctTimes(i)))
    
    %get data
    inData = load('data.csv');
    if ctTimes(i)
        Y = inData(:,1:p); %measurements
        X = inData(:,(p+1):end); %definition variables
    else
        Y = inData; %measurements
        X = repmat(0:(p-1),N,1); %time
    end
    
    fullmodel.X=X;
    fullmodel.Y=Y;
    
    %run Full
    runFull = gpPanel(fullmodel);
    
    %run red
    redModel = gp_addRes(fullmodel,'cov',3,0);
    runRed = gpPanel(redModel);
    
    %LR Test
    [pVal,ddf,LR] = gp_LR(runFull,runRed);
     
    %get SEM stuff
    SEMs = load('Rres.mat');
    SEMs.resfull.mlPar=SEMs.resfullmlPar;
    SEMs.resred.mlPar=SEMs.resredmlPar;
    
    %compare parameter estiamtes
    gp_compareModels(SEMs.resfull,runFull)
    gp_compareModels(SEMs.resred,runRed);
    
    %compare LR Test Results
    assert(jl_almostEqual(SEMs.resLR.p,pVal))
    
    %%compare confidence interval results
    CIs = SEMs.CIs;
    %compare first mean value and first variance value
    cfgs(1).cName = 'mean';
    cfgs(1).index = 1;
    cfgs(2).cName = 'cov';
    cfgs(2).index = 1;
    %compare one other random parameter
    allNames = {'mean' 'cov'};
    rcName = allNames{randi(2)};
    if strcmp(rcName,'mean')
        rindex = 2;
    else %cov
        rindex = randi(3)+1;
    end
    cfgs(3).cName = rcName;
    cfgs(3).index = rindex;

    %%compare
    for j=1:numel(cfgs)
        cName = cfgs(j).cName;
        index = cfgs(j).index;
        [SEMname,toSEM,toGP] = gp_transformLGCMCI(cName,index);
        interval=gp_confidenceInterval(runFull,cName,index,toSEM,toGP,0.05,true);
        assert(all(jl_almostEqual(CIs.(SEMname)([1 3])',interval,0.1))||any(isnan(CIs.(SEMname)))); %ugly but meh
    end
end