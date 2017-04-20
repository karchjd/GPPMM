function res=gp_getRunTimes(model)
    res=[];
    res.expTime=model.runTime.implied.time;
    res.expCount=model.runTime.implied.count;
    res.gradTime=model.runTime.grad.time;
    res.gradCount=model.runTime.grad.count;
end