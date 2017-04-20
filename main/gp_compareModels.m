function gp_compareModels(SEM,GP)
%compare likelihoods
assert(jl_almostEqual(SEM.m2ll,GP.mll*2));

%compare parameter estimates
gppars = gp_transformLGCM(GP.mlHyp);
fnames = fieldnames(gppars);
for fname=fnames'
    tfname = fname{1}; % stupid matlab
    assert(jl_almostEqual(gppars.(tfname),SEM.mlPar.(tfname)));
end

end