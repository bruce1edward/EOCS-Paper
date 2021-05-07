function [] = experiment_ISD_block(seed)
rng(seed)
addpath('../functions')  
load('../data/ISD/Italian_survey_data_linkage.mat');X_link = X;X = X(:,1);Y_link = Y;Y = Y(:,1);
g_ID = findgroups(X_link(:,2),X_link(:,3),X_link(:,4),X_link(:,5),X_link(:,6));%numel(unique(g_ID))/numel(Y)
% Data generator block
P = data_generator_block(numel(Y), g_ID);
[B,Q,G] = generate_B_Q(numel(Y), g_ID);
K_n = sum(P ~= 1:numel(Y))/numel(Y);
Y_permuted = Y(P);
[n,d] = size(X);
[n,m] = size(Y);
X = [ones(n,1) X];
X_wo = X(:,2:end);
X_centered = X_wo - repmat(mean(X_wo,1), [n 1]);
d = d + 1;
%Naive
beta_naive = X\Y_permuted;
%Oracle
beta_oracle = X\Y;
%Robust
beta_robust = robustfit(X_wo,Y_permuted,'huber');
%EM Block
iter = 200; mcmc_steps = 2000; burn_steps = 500;
[beta_EM_block, sigma_sq_EM_block] = EM_mal_Block(Y_permuted, X, iter, mcmc_steps, burn_steps, 0, beta_naive, g_ID);
%EM 
iter = 200; mcmc_steps = 4000; burn_steps = 2000; order = 1:n; 
[beta_EM, sigma_sq_EM] = EM_mal_tricks(Y_permuted, X, iter, mcmc_steps, burn_steps, 0, beta_naive, order);
%Mixture
Y_permuted1 = Y_permuted - mean(Y_permuted);control = "robust";
[beta_mixture, alpha_mixture, sigma_mixture] = fit_mixture(X_centered, Y_permuted1, control);
beta_mixture = [mean(Y_permuted - X_wo*beta_mixture) ; beta_mixture];
%LL
uni_g_ID = unique(g_ID);Y_Centered_Q = zeros(numel(uni_g_ID),1);X_centered_Q = zeros(numel(uni_g_ID),d-1);
for g = 1:numel(uni_g_ID)
index_g = find(g_ID == uni_g_ID(g));
Y_Centered_Q(g) = mean(Y_permuted1(index_g));
X_centered_Q(g,:) = mean(X_centered(index_g,:),1);
end
beta_LL = X_centered_Q\Y_Centered_Q;
beta_LL = [mean(Y_permuted - X_wo*beta_LL) ; beta_LL];
%Chamber
beta_C = (X'*Q*X)\(X'*Y_permuted);
%DA
order = 1:n; iter = 200; theta = 0;m = 40;mcmc_steps = 2000;
beta_DA = mean(EM_DA_mallow_dia(Y_permuted, X, order, mcmc_steps, m, iter, theta),1);
beta_DA = beta_DA';
%DA block
iter = 200; theta = 0;m = 40;mcmc_steps = 1000;
beta_DA_block = mean(EM_DA_mallow_block(Y_permuted, X, mcmc_steps, m, iter, theta, g_ID),1);
beta_DA_block = beta_DA_block';
%LL_Chamber
Q1 = (1 - K_n - K_n/(n-1)) * eye(n) + (K_n/(n-1)) * ones(n);
QX = Q1*X;
beta_LL_noninf = QX\Y_permuted;
%Chamber
beta_C_noninf = (X'*QX)\(X'*Y_permuted);

error_est = [norm(beta_naive - beta_oracle)/norm(beta_oracle), norm(beta_robust  - beta_oracle)/norm(beta_oracle), norm(beta_mixture  - beta_oracle)/norm(beta_oracle), norm(beta_EM  - beta_oracle)/norm(beta_oracle), norm(beta_DA  - beta_oracle)/norm(beta_oracle),norm(beta_LL_noninf  - beta_oracle)/norm(beta_oracle),norm(beta_C_noninf  - beta_oracle)/norm(beta_oracle), norm(beta_EM_block  - beta_oracle)/norm(beta_oracle),norm(beta_DA_block  - beta_oracle)/norm(beta_oracle),norm(beta_LL  - beta_oracle)/norm(beta_oracle),norm(beta_C  - beta_oracle)/norm(beta_oracle)];
r_square = 1 - [norm(Y - X*beta_naive)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_robust)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_mixture)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_EM)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_DA)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_LL_noninf)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_C_noninf)^2/norm(Y- mean(Y))^2,norm(Y - X*beta_EM_block)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_DA_block)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_LL)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_C)^2/norm(Y- mean(Y))^2];
save(['ISD/results_experiment_ISD_' num2str(seed) '.mat'],'error_est','r_square','K_n');
end