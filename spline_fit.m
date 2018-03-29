function [ c ] = spline_fit( x, y, d, knots, lambda)
%lambda --- регуляризующий параметр, например 0.005
if nargin < 5
	lambda = 0;
end

xmin = knots(1);
xmax = knots(end);
t = [repmat(xmin, [1, d]), knots, repmat(xmax, [1, d])];

ncoeff = numel(knots) + d - 1;
B = zeros(numel(x), ncoeff);
for j = 1 : ncoeff
    B(:, j) = bspline(x, j, d, t, d);
end

%c = (B'*B)\(B'*y);
if lambda ~= 0
	c = (B'*B + lambda*eye(ncoeff))\(B'*y);
else
	c = B\y; 
end

