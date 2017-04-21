function gp_printCV(cvRes)
    %get second place
    tmp = cvRes.sum;
    tmp(cvRes.winner) = inf;
    [~,secondPlace] = min(tmp);
    likRatio = exp(cvRes.sum(secondPlace) - cvRes.sum(cvRes.winner));
    fprintf('The winner was %s with -2LL %.2f\n',cvRes.models{cvRes.winner}.name,2*cvRes.sum(cvRes.winner));
    fprintf('The winner was %s with -2LL %.2f\n',cvRes.models{secondPlace}.name,2*cvRes.sum(secondPlace));
    fprintf('The difference was %f\n',2*cvRes.sum(secondPlace)-2*cvRes.sum(cvRes.winner));
    %fprintf('The likelihoodratio between the two is %f\n',likRatio); 
end