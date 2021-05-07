MSE_beta = reshape(mean(error_est,1),[numel(K_n),4]);
R_sq = reshape(mean(r_square,1),[numel(K_n),4]);
figure
hold on 
p1 = plot(K_n, MSE_beta(:,1), 'r-o', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'r');
p2 = plot(K_n, MSE_beta(:,2), 'b-^', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'b');
p3 = plot(K_n, MSE_beta(:,3), 'k-s', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'k');
p4 = plot(K_n, MSE_beta(:,4), 'g-d', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'g');
%p5 = plot(K_n, MSE_beta(:,5), 'm-p', 'LineWidth', 1.5, 'MarkerSize',6, 'MarkerFaceColor', 'm');
%p6 = plot(K_n, MSE_beta(:,6), 'c-h', 'LineWidth', 1.5, 'MarkerSize',6, 'MarkerFaceColor', 'c');
xlabel('k/n')
ylabel('Relative estimation errors')
%yticks([0 : 0.25 :2])
xlim([0.15 max(K_n)])
xticks(K_n)
%title([' \beta_{0} = ' num2str(b0) ' , ' ' ||\beta^*||_{2} = ' num2str(b)])
lh = legend([p1 p2 p3 p4], {'naive', 'robust', 'mixture','EM'}, 'location', [0.7233 0.2281 0.1696 0.1750]);
lh.NumColumns = 1;
lh.FontSize = 10;
lh.ItemTokenSize = [30 70]; 
%pos_leg = get(lh,'Position');
legend('boxoff')
text(0.175,0.75,'ISD')
grid on
set(gcf, 'Color', 'w');
fig = gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8;
fig.Position(4)         = 7;
hold off

export_fig('ISD_est.pdf')
%export_fig('CPS_est.pdf')

figure
hold on 
p1 =  plot(K_n, R_sq(:,1), 'r-o', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'r');
p2 = plot(K_n, R_sq(:,2), 'b-^', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'b');
p3 = plot(K_n, R_sq(:,3), 'k-s', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'k');
p4 = plot(K_n, R_sq(:,4), 'g-d', 'LineWidth', 1.5, 'MarkerSize',9, 'MarkerFaceColor', 'g');
%p5 = plot(K_n, R_sq(:,5), 'm-p', 'LineWidth', 1.5, 'MarkerSize',6, 'MarkerFaceColor', 'm');
%p6 = plot(K_n, R_sq(:,6), 'c-h', 'LineWidth', 1.5, 'MarkerSize',6, 'MarkerFaceColor', 'c');
xlabel('k/n')
ylabel('R^2')
%yticks([0 : 0.25 :2])
xlim([0.15 max(K_n)])
xticks(K_n)
%title([' \beta_{0} = ' num2str(b0) ' , ' ' ||\beta^*||_{2} = ' num2str(b)])
lh = legend([p1 p2 p3 p4], {'naive', 'robust', 'mixture','EM'}, 'location', [0.7233 0.6656 0.1696 0.1750]);
lh.NumColumns = 1;
lh.FontSize = 10;
lh.ItemTokenSize = [30 70];  
legend('boxoff')
%pos_leg = get(lh,'Position');
text(0.175,0.44,'ISD')
grid on
set(gcf, 'Color', 'w');
fig = gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8;
fig.Position(4)         = 7;
hold off

export_fig('ISD_r_sq.pdf')
%export_fig('CPS_r_sq.pdf')