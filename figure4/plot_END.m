figure
hold on
plot(fit_oracle, fit_naive, 'ko', 'MarkerSize',6, 'MarkerFaceColor', 'k');
xlabel('Fitted Values based on ($\mathbf{X}, \mathbf{Y}^*$)', 'interpreter','latex', 'FontSize', 14)
ylabel('Fitted Values based on $(\mathbf{X}, \mathbf{Y})$', 'FontSize', 14, 'interpreter','latex')
title('w/o correction')
ax = gca;
ax.FontSize = 11; 
lh = refline(1,0);
lh.LineStyle = '--';
lh.LineWidth = 1.5;
lh.Color = [0.5 0.5 0.5];
grid on
set(gcf, 'Color', 'w');
fig = gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8;
fig.Position(4)         = 7;
hold off

%export_fig ISD_PR_1.pdf
%export_fig CPS_PR_1.pdf
export_fig END_PR_1.pdf


figure
hold on
plot(fit_oracle, fit_LL, 'ko', 'MarkerSize',6, 'MarkerFaceColor', 'k'); 
xlabel('Fitted Values based on ($\mathbf{X}, \mathbf{Y}^*$)', 'interpreter','latex', 'FontSize', 14)
ylabel('Fitted Values based on $(\mathbf{X}, \hat{\Pi}\mathbf{Y})$', 'FontSize', 14, 'interpreter','latex')
title('w/ correction')
ax = gca;
ax.FontSize = 11; 
lh = refline(1,0);
lh.LineStyle = '--';
lh.LineWidth = 1.5;
lh.Color = [0.5 0.5 0.5];
grid on
set(gcf, 'Color', 'w');
fig = gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8;
fig.Position(4)         = 7;
hold off

%export_fig ISD_PR_2.pdf
%export_fig CPS_PR_2.pdf
export_fig END_PR_2.pdf

figure
hold on 
p1 = plot(p_res,mismatch_before,'ko', 'MarkerSize',6, 'MarkerFaceColor', 'k');
p3 = plot(p_res,mismatch_after,'r^', 'MarkerSize',6, 'MarkerFaceColor', 'r');
p2 = refline(1,0);
p2.Color = 'k';
set(p2,'LineWidth',1.5)
%lh = legend([p1 p3], {'$|\mathbf{Y}^*- \mathbf{Y}|_{(i)}$', '$|\mathbf{Y}^* - \hat{\Pi}\mathbf{Y}|_{(i)}$'}, 'location', 'northwest', 'interpreter','latex');
%lh.NumColumns = 1;
%lh.FontSize = 15;
%lh.ItemTokenSize = [30 70];  
%legend('boxoff')
ax = gca;
ax.FontSize = 13; 
xlabel('$|\mathbf{Y}^* - \mathbf{X}\hat{\beta}^{oracle}|_{(i)}$', 'interpreter','latex', 'FontSize', 14)
ylabel('Mismatch error', 'FontSize', 14)
grid on
set(gcf, 'Color', 'w');
fig = gcf;
fig.Units               = 'centimeters';
fig.Position(3)         = 8;
fig.Position(4)         = 7;
hold off

%export_fig ISD_PR_3.pdf
%export_fig CPS_PR_3.pdf
export_fig END_PR_3.pdf


