function interval = gp_confidenceInterval(model,name,index,toSEM,toGP,siglevel,approx)
    if nargin<4
        toSEM = @jl_ID;
        toGP = @jl_ID;
    end
    %kind of ugly because we check a function by checking only one point
    if isequal(toGP,@gp_backward) || isequal(log(10),toGP(10)) 
        compareF = @(x)x>0; %positive parameters
        coef =1;
    elseif isequal(toGP,@jl_ID)
        compareF = @(x) true; %we dont care parameters
        coef =1;
    elseif isequal(toGP(-2),gp_backward(-1/-2/2))
        compareF = @(x)(x)<0; %negative parameters
        coef = -1;
    else
        error('unkown to function');
    end
    
    if nargin<6 %stupid matlab
        siglevel = 0.05;
    end
    
    if nargin<7 %stupid matlab
        approx = false;
    end
    
    %create new model with delta prior on parameter
    %starting value is ml estimate for this parameter
    
    %create restriced model
    modelnew = gp_addRes(model,name,index,model.mlHyp.(name)(index));
    
    %fake run
    modelnew.hyp = model.mlHyp;
    modelnew = gpPanel(modelnew,0);
    
    %increase and decrease settings
    deltas = [1 0.1 0.01 0.001];
    numit = 5;
    
    %helpers for the loop
    opers = {@(x)-x,@(x)+x};
    names = {'lb','ub'};
    modes = {'Decrease' 'Increase'};
    
    %approx block
    if ~approx
        repLimit = inf;
    else
        repLimit = 3; 
    end
    
    %latent Growth block
    lcm = jl_inCellMess(@covCorr,model.covf);
    
    
    for i=1:2
        fprintf('%s\n',modes{i});
        tmodelnew=modelnew; %start both the lower and the upper bound estimates at the ml estimate
        for delta = deltas
            semVal=coef;
            while gp_LR(model,tmodelnew)>=siglevel && compareF(semVal)
                %change parameter
                fprintf('delta= %f\n',delta);
                semVal = toSEM(tmodelnew.hyp.(name)(index))+opers{i}(delta);
                fprintf('Current value for %s.%d %.2f\n',name,index,semVal);
                if compareF(semVal)
                    tmodelnew.hyp.(name)(index)= toGP(semVal);
                    %check if other parameters have to be changed too
                    %for the parameter set to be valid
                    if lcm && strcmp(name,'cov')
                        maxCovariance = sqrt(gp_forward(tmodelnew.hyp.cov(1)))*sqrt(gp_forward(tmodelnew.hyp.cov(2)));
                        validCov = abs(tmodelnew.hyp.cov(3)) <= maxCovariance;
                        if ~validCov
                            warning('You use functionality that assumes your model is LGCM');
                            if index<3
                                tmodelnew.hyp.cov(3)=maxCovariance-0.0001;
                                fprintf('Setting back covariance\n');
                            else
                                tmodelnew.hyp.cov(1)=gp_backward(abs(tmodelnew.hyp.cov(3))^2/gp_forward(tmodelnew.hyp.cov(2))+0.0001);
                                fprintf('Setting back intercept variance\n');
                            end
                            assert(isreal(tmodelnew.hyp.cov));
                        end
                    end
                    %evaluate the changed parameter at the last (constraint) ml
                    %estimate
                    tmodelnew=gpPanel(tmodelnew,0);
                    tmodelnew.hyp = tmodelnew.mlHyp;
                    tmodelnew.mllHist = [tmodelnew.mllHist NaN];
                    
                    %if the ml at this estimate is already good enough skip to
                    %the next step otherwise loop until it is good enought or
                    %until convergence is reached
                    reps = 0;
                    while gp_LR(model,tmodelnew)<siglevel && numel(tmodelnew.mllHist) > 1 && (reps < repLimit)
                        tmodelnew=gpPanel(tmodelnew,numit);
                        tmodelnew.hyp=tmodelnew.mlHyp; %start at current value
                        reps = reps + numel(tmodelnew.mllHist)-1;
                        fprintf('Interation %d of %d\n',reps,repLimit);
                    end
                else
                    fprintf('skipped because variance para was %.2f\n',semVal);
                end
            end
            if  delta~=deltas(end)
                tmodelnew.hyp.(name)(index)=toGP(semVal-opers{i}(delta)); %revert last delta step
            end
            %assert that LR test fails
            tmodelnew.mll = model.mll;
            assert(gp_LR(model,tmodelnew)>=siglevel);
        end
        %limit found
        eval([names{i} '=tmodelnew.hyp.(name)(index);']);
    end
    interval = toSEM([lb ub]);
end