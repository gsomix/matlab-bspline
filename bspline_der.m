function [ df ] = bspline_der( x, j, d, t )

if t(j + d +1) == t(j)
    df = zeros(size(x));
    
elseif t(j) < t(j + d) && t(j + 1) == t(j + 1 +d)    
    df = bspline( x, j, d, t, d - 1 ) / (t(j + d)- t(j));
    
elseif t(j) == t(j + d) && t(j + 1) < t(j + 1 +d)
    df = -bspline( x, j + 1, d, t, d - 1 ) / (t(j + 1 + d) - t(j + 1));
    
else 
    tmp1 =  bspline( x, j, d, t, d - 1 ) / (t(j + d)- t(j));
    tmp2 = -bspline( x, j + 1, d, t, d - 1 ) / (t(j + d +1)- t(j + 1));
    df = tmp1 + tmp2;
end

df = d * df;