%get confidence interval for latent growth curve model
function [SEMname,toSEM,toGP] = gp_transformLGCMCI(name,index,arErr) 
     if nargin <3
         arErr = false;
     end
     if strcmp(name,'mean')
        switch index
            case 1
                SEMname= 'muI';
            case 2
                SEMname = 'muS';
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
                SEMname= 'varI';
            case 2
                SEMname = 'varS';
            case 3
                SEMname= 'covIS';
                toSEM = @jl_ID;
                toGP = @jl_ID;
            case 4
                if ~arErr
                    error('Invalid index %d',index);
                else
                    SEMname = 'rho'
                    toSEM=@(x)exp(x);
                    toGP=@(x)log(x);
                end
            case 5
                if ~arErr
                    error('Invalid index %d',index);
                else
                    SEMname= 'noise';
                end
            otherwise
                error('Invalid index %d',index);
        end
    elseif strcmp(name,'lik') && ~arErr
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