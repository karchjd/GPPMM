%get confidence interval for latent growth curve model
function [SEMname,toSEM,toGP] = gp_transformExpSE(name,index,SE) 
     if strcmp(name,'mean')
        switch index
            case 1
                SEMname= 'muI';
            otherwise
                error('Invalid index %d',index);
        end
        toSEM = @jl_ID;
        toGP = toSEM;
    elseif strcmp(name,'cov')
        toSEM = @gp_forward;
        toGP = @gp_backward;
        switch index
            case 1
                SEMname = 'a';
                if SE
                    toGP =  @(x) gp_backward(-1/x/2);
                    toSEM = @(x) -1./(2*gp_forward(x));
                else
                    toGP = @(x) log (-1./x);
                    toSEM = @(x)-1./exp(x);
                end
            case 2
                SEMname = 'var';
            case 3
                SEMname= 'varI';
            otherwise
                error('Invalid index %d',index);
        end
    elseif strcmp(name,'lik')
        if index==1
            SEMname='noise';
            toSEM = @gp_forward;
            toGP = @gp_backward;
        else
            error('Invalid index %d',index);
        end
    else
        error('Invalid name %s',name);
    end
end