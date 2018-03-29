function bspline_show( x, d, knots )

xmin = knots(1);
xmax = knots(end);
t = [repmat(xmin, [1, d]), knots, repmat(xmax, [1, d])];

ncoeff = numel(knots) + d - 1;
figure; hold all
for j = 1 : ncoeff
    plot(x, bspline(x, j, d, t, d));
end

figure; hold all
for j = 1 : ncoeff
    plot(x, derBspline(x, j, d, t));
end