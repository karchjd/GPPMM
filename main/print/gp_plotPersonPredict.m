function gp_plotPersonPredict(res,latent)
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
plot(z, m, 'LineWidth', 2); 
plot(res.Xtrain, res.Ytrain, 'o', 'MarkerSize', 7,'color','black');
xlim([min(z) max(z)]);
xTicks = get(gca,'XTick');
end