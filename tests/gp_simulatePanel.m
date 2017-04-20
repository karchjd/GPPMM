function [X,Y] = gp_simulatePanel(model,N,Xrange,p)
X = nan*zeros(N,p);
Y = nan*zeros(N,p);
%if model has likelihood
if isfield(model,'lik') && isequal(model.lik,@likGauss);
    model.covf = {@covSum {model.covf @covNoise}};
    model.hyp.cov(end+1) = model.hyp.lik;
end
for i=1:N
    X(i,:)= Xrange(1) + (Xrange(2)-Xrange(1)).*rand(1,p);
    Y(i,:) = gp_simulate(model.meanf,model.covf,model.hyp,X(i,:)');
end
end