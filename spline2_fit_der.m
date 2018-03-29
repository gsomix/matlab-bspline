function [ c ] = spline2_fit_der( x, y, zx, zy, d, knots_x, knots_y, lambda)
%lambda --- регуляризующий параметр, например 0.005
if nargin < 8
	lambda = 0;
end

x=x(:);
y=y(:);
zx=zx(:);
zy=zy(:);

xmin = knots_x(1);
xmax = knots_x(end);
tx = [repmat(xmin, [1, d]), knots_x, repmat(xmax, [1, d])];

ymin = knots_y(1);
ymax = knots_y(end);
ty = [repmat(ymin, [1, d]), knots_y, repmat(ymax, [1, d])];

nc_x = numel(knots_x) + d - 1;
nc_y = numel(knots_y) + d - 1;
Bx = zeros(numel(x), nc_x*nc_y);
By = zeros(numel(x), nc_x*nc_y);


bspline_der_x = zeros(numel(x), nc_x);
bspline_der_y = zeros(numel(x), nc_y);

bspline_x = zeros(numel(x), nc_x);
bspline_y = zeros(numel(x), nc_y);

for j = 1 : nc_x
	bspline_der_x(:, j) = bspline_der(x, j, d, tx);
	bspline_x(:, j) = bspline(x, j, d, tx, d);
end

for k = 1 : nc_y
	bspline_der_y(:, k) = bspline_der(y, k, d, ty);
	bspline_y(:, k) = bspline(y, k, d, ty, d);
end	

for j = 1 : nc_x
    for k = 1 : nc_y
        Bx(:, (j - 1)*nc_y + k) = bspline_der_x(:, j).*bspline_y(:, k);
        By(:, (j - 1)*nc_y + k) = bspline_x(:, j).*bspline_der_y(:, k);
    end
end

%c = (Bx'*Bx+By'*By )\(Bx'*zx + By'*zy);
c = (Bx'*Bx + By'*By + lambda*eye(nc_x*nc_y)) \ (Bx'*zx + By'*zy);

%minimax
%c=fminimax(@(c1)abs(Bx*c1-zx)+abs(By*c1-zy), c);


