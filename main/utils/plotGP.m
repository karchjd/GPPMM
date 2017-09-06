%plot a gaussian Process
function plotGP(meanF,covarianceF,hyp,X,meanErrorF,covErrorF)
    if nargin < 5
        cmode = false;
        inum = 1;
    else
        cmode = true;
        figure;
        tmp = gca;
        cmatrix = tmp.ColorOrder;
        close;
        rng(10)
        inum=2;
    end
    for i=1:inum
        hold on;
        if ~cmode
            y=gp_simulate(meanF,covarianceF,hyp,X);
            plot(X,y,'LineWidth',2');     
            
        else
            [y,latent] = gp_simulate(meanF,covarianceF,hyp,X,meanErrorF,covErrorF,i*2);
            plot(X,y,'color',cmatrix(i,:),'LineWidth',2');
            plot(X,latent,'color',cmatrix(i,:),'LineWidth',2','LineStyle','--');
        end
    end
    hold off
    % fix colors
    t = gca;
    
end

