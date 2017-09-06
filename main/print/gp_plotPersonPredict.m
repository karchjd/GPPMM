function [line,dots]=gp_plotPersonPredict(res,latent)
if nargin<2
    latent = false;
end
%stolen from demoRegression
z = res.Xpred;
if ~latent
m = res.muPred;
s2 = res.varPred;
else 
m = res.muLa;
s2 = res.varLa;
end
f = [m+2*sqrt(s2); flipdim(m-2*sqrt(s2),1)];
if s2>0
    fill([z; flipdim(z,1)], f, [7 7 7]/8);
end
hold on;
line = plot(z, m, 'LineWidth', 3); 
dots = plot(res.Xtrain, res.Ytrain, 'o', 'MarkerSize', 7,'color','black','MarkerFaceColor',[.7 .7 .7]);
if isfield(res,'Xtest')
    plot(res.Xtest, res.Ytest, 'square', 'MarkerSize', 7,'color','black','MarkerFaceColor',[.7 .7 .7]);
end
xlim([min(z) max(z)]);
xTicks = get(gca,'XTick');
end