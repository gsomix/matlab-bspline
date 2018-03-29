function [ y ] = spline_eval( x, c, d, knots )

xmin = knots(1);
xmax = knots(end);
t = [repmat(xmin, [1, d]), knots, repmat(xmax, [1, d])];

ncoeff = numel(knots) + d - 1;
B = zeros(numel(x), ncoeff);
for j = 1 : ncoeff
    B(:, j) = bspline(x, j, d, t, d);
end

y = B*c;

