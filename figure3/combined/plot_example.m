figure
hold on 
p1 = plot(x_K_n, y_R_sq_ISD(:,1), 'r-o', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'r');
p2 = plot(x_K_n, y_R_sq_ISD(:,2), 'b-^', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'b');
p3 = plot(x_K_n, y_R_sq_ISD(:,3), 'k-s', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'k');
p4 = plot(x_K_n, y_R_sq_ISD(:,4), 'g-d', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'g');
p5 = plot(x_K_n, y_R_sq_ISD(:,5), 'm-+', 'LineWidth', 1.5, 'MarkerSize',11, 'MarkerFaceColor', 'm');
p6 = plot(x_K_n, y_R_sq_ISD(:,6), 'c-x', 'LineWidth', 1.5, 'MarkerSize',11, 'MarkerFaceColor', 'c');
xlabel('k/n', 'FontSize', 14)
%ylabel('Relative Estimation Errors', 'FontSize', 14)
xticks(x_K_n)
grid on
set(gcf, 'Color', 'w');
fig = gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8;
fig.Position(4)         = 7;
hold off
