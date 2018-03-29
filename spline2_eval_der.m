function [ z_x, z_y ] = spline2_eval_der( x, y, c, d, knots_x, knots_y )

x_size = size(x);
x = x(:);
y = y(:);

xmin = knots_x(1);
xmax = knots_x(end);
tx = [repmat(xmin, [1, d]), knots_x, repmat(xmax, [1, d])];

ymin = knots_y(1);
ymax = knots_y(end);
ty = [repmat(ymin, [1, d]), knots_y, repmat(ymax, [1, d])];

ncoeff_x = numel(knots_x) + d - 1;
ncoeff_y = numel(knots_y) + d - 1;
Bx = zeros(numel(x), ncoeff_x*ncoeff_y);
By = zeros(numel(x), ncoeff_x*ncoeff_y);



bspline_der_x = zeros(numel(x), ncoeff_x);
bspline_der_y = zeros(numel(x), ncoeff_y);
bspline_x = zeros(numel(x), ncoeff_x);
bspline_y = zeros(numel(x), ncoeff_y);
parfor j = 1 : ncoeff_x
	bspline_der_x(:, j) = bspline_der(x, j, d, tx);
	bspline_x(:, j) = bspline(x, j, d, tx, d);
end
parfor k = 1 : ncoeff_y
	bspline_der_y(:, k) = bspline_der(y, k, d, ty);
	bspline_y(:, k) = bspline(y, k, d, ty, d);
end	


for j = 1 : ncoeff_x
    for k = 1 : ncoeff_y
        Bx(:, (j - 1)*ncoeff_y + k) = bspline_der_x(:, j).*bspline_y(:, k);
        By(:, (j - 1)*ncoeff_y + k) = bspline_x(:, j).*bspline_der_y(:, k);
    end
end

z_x = Bx*c;
z_y = By*c;

z_x = reshape(z_x, x_size);
z_y = reshape(z_y, x_size);