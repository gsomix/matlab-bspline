function plot_fun2( x, y, z, tlt, xlbl, ylbl, zlbl )

surf(x, y, z, 'EdgeColor', 'flat');
xlabel(xlbl);
ylabel(ylbl);
zlabel(zlbl);
title(tlt, 'FontSize', 14, 'interpreter','latex');
view(2);
colorbar;
