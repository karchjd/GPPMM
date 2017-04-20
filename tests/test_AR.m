p=10;
%call R here
eval(sprintf('!unset DYLD_LIBRARY_PATH; Rscript SEM_AR.R %i',p));

%call matlab here
dataFile = 'data_AR.csv';
resFile = 'ARMat.mat';
if ismac
    gp_ARFit(dataFile,p,resFile);
else
    fprintf('Runing Compiled');
    system(sprintf('bash ~/mystuff/projects/dissertation/run_gp_ARFit.sh /opt/matlab/interactive %s %i %s',dataFile,p,resFile))
end

%TODO assert that both use the same starting values

%get results
 SEMs = load('ARR.mat');
 GPML = jl_load('ARMat.mat');
% %compare parameter estiamtes
SEMs.resTrue.m2ll=nan;
fnames = {'c','sigma','phi','m2ll'};
for fname=fnames
    tfname = fname{1}; % stupid matlab
    fprintf('%s SEM: %f GPML: %f, TRUE: %f Difference: %f\n relative: %f\n',tfname,SEMs.resMx.(tfname),GPML.(tfname),SEMs.resTrue.(tfname),abs(SEMs.resMx.(tfname)-GPML.(tfname)),GPML.(tfname)/SEMs.resMx.(tfname));
end


