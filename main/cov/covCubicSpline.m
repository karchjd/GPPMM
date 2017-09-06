function [K,dK] = covCubicSpline(~, x, z, ~)

%COMMENTS

if nargin<2, K = '0'; return; end                  % report number of parameters
if nargin<3, z = []; end                                   % make sure, z exists
xeqz = isempty(z); dg = strcmp(z,'diag');                       % determine mode

knotlocations = (1:7)/8;
basisFunctions = generateBasisfunctions(knotlocations);
priorCoviarance = computePriorCovariance(basisFunctions,knotlocations);
% compute inner products
if dg                                                               % vector kxx
  for i=1:size(x,1)
      K = computeKernel(x(i),x(i),basisFunctions,priorCoviarance);
  end
else
  if xeqz                                                 % symmetric matrix Kxx
    z=x;
  end
end
K=nan*zeros(size(x,1),size(z,1));
for i=1:size(x,1)
    for h=1:size(z,1)
        K(i,h) = computeKernel(x(i),z(h),basisFunctions,priorCoviarance);
    end
end

if nargin>3                                                        % derivatives
  error('Unknown hyperparameter')
end

if nargout > 1 %compatible with new, unused version of GPPM
  dK = @(Q) dirder(Q,K,x);                        % directional hyper derivative
end
end

function [dhyp,dx] = dirder(Q,K,x)
  dhyp = zeros(0,1); if nargout > 1, dx = zeros(size(x)); end
end


function covari = computeKernel(s,t,basisF,priorC)
    leftVector = nan*zeros(numel(basisF),1);
    rightVector = leftVector;
    for j=1:numel(basisF)
        leftVector(j)=basisF{j}(s);
        rightVector(j)=basisF{j}(t);
    end
    covari = leftVector' * priorC * rightVector;
end 

function basisfunction = rk(x,z)
        basisfunction = ((z-0.5)^2-1/12)*((x-0.5)^2-1/12)/4-((abs(x-z)-0.5)^4-(abs(x-z)-0.5)^2/2+7/240)/24;
end

    function basisfunctions =  generateBasisfunctions(knotloc)
        nKnots = numel(knotloc);
        result = cell(nKnots+2,1);
        result{1} = @(x)1; 
        result{2} = @(x)x;
        for j=1:nKnots
            f=@(x)rk(x,knotloc(j));
            result{j+2} = f;
        end
        basisfunctions = result;
end

function priorCovariance =  computePriorCovariance(basisFunctions,knotlocations)
    S = nan*zeros(numel(basisFunctions));
    S(1:2,:) = 0.00000000;
    S(:,1:2) = 0.00000000;
    S(1,1) = 0.000000001;
    S(2,2) = 0.000000001;
    for j=3:numel(basisFunctions)
        for k=3:numel(basisFunctions)
            S(j,k) = rk(knotlocations(j-2),knotlocations(k-2));
        end
    end
    priorCovariance = inv(S);
end