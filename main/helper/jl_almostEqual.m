function res = jl_almostEqual(a,b,e)
    if nargin<3
        e = 0.000011111111111111;
    end
    res = a+e>=b & a-e <= b;
end
