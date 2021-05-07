function [] = experiment_END_block(seed)
rng(seed)
addpath('../functions') 
%Data(Blocking)
data = readtable('../data/END/elnino_l.csv','ReadVariableNames',false);
Y = data(2:end,11);X = data(2:end,[8:10 12]);lat_lon = data(2:end,[6 7]);
Y = Y{:,:};X = X{:,:};lat_lon = lat_lon{:,:};
Y = cellfun(@str2num,Y);X = cellfun(@str2num,X);lat_lon = cellfun(@str2num,lat_lon);
[n,d] = size(X);[n,m] = size(Y);X = [ones(n,1) X];d = d + 1;
X_wo = X(:,2:end);X_centered = X_wo - repmat(mean(X_wo,1), [n 1]);
g_ID = findgroups(lat_lon(:,1),lat_lon(:,2));%numel(unique(g_ID))/numel(Y)
% Data generator block
P = data_generator_block(numel(Y), g_ID);
K_n = sum(P ~= 1:numel(Y))/numel(Y);
Y_permuted = Y(P);
%Naive
beta_naive = X\Y_permuted;
%Oracle
beta_oracle = X\Y;
%Mixture
Y_permuted1 = Y_permuted - mean(Y_permuted);control = "robust";
[beta_mixture, alpha_mixture, sigma_mixture] = fit_mixture(X_centered, Y_permuted1, control);
beta_mixture = [mean(Y_permuted - X_wo*beta_mixture) ; beta_mixture];
%EM Block
iter = 200; mcmc_steps = 2000; burn_steps = 500;
[beta_EM_block, sigma_sq_EM_block] = EM_mal_Block(Y_permuted, X, iter, mcmc_steps, burn_steps, 0, beta_naive, g_ID);
%EM 
iter = 50; mcmc_steps = 80000; burn_steps = 40000; order = 1:n; 
[beta_EM, sigma_sq_EM] = EM_mal_tricks(Y_permuted, X, iter, mcmc_steps, burn_steps, 0, beta_naive, order);
%LL
uni_g_ID = unique(g_ID);X_centered_Q = zeros(n,d-1);
for g = 1:numel(uni_g_ID)
index_g = find(g_ID == uni_g_ID(g));
Q_g = ones(numel(index_g),n)*(K_n/(n-1));
for gg = 1:numel(index_g)
    Q_g(gg,index_g(gg)) = 1 - K_n;
end
X_centered_Q(index_g,:) = Q_g*X_centered;
end
beta_LL = X_centered_Q\Y_permuted1;
beta_LL = [mean(Y_permuted - X_wo*beta_LL) ; beta_LL];
%Chamber
beta_C = (X_centered'*X_centered_Q)\(X_centered'*Y_permuted1);
beta_C = [mean(Y_permuted - X_wo*beta_C) ; beta_C];
%DA
order = 1:n; iter = 200; theta = 0;m = 40;mcmc_steps = 8000;
beta_DA = mean(EM_DA_mallow_dia(Y_permuted, X, order, mcmc_steps, m, iter, theta),1);
beta_DA = beta_DA';
%DA block
iter = 200; theta = 0;m = 40;mcmc_steps = 1000;
beta_DA_block = mean(EM_DA_mallow_block(Y_permuted, X, mcmc_steps, m, iter, theta, g_ID),1);
beta_DA_block = beta_DA_block';

error_est = [norm(beta_naive - beta_oracle)/norm(beta_oracle), norm(beta_robust  - beta_oracle)/norm(beta_oracle), norm(beta_mixture  - beta_oracle)/norm(beta_oracle), norm(beta_EM  - beta_oracle)/norm(beta_oracle), norm(beta_DA  - beta_oracle)/norm(beta_oracle),norm(beta_LL_noninf  - beta_oracle)/norm(beta_oracle),norm(beta_C_noninf  - beta_oracle)/norm(beta_oracle), norm(beta_EM_block  - beta_oracle)/norm(beta_oracle),norm(beta_DA_block  - beta_oracle)/norm(beta_oracle),norm(beta_LL  - beta_oracle)/norm(beta_oracle),norm(beta_C  - beta_oracle)/norm(beta_oracle)];
r_square = 1 - [norm(Y - X*beta_naive)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_robust)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_mixture)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_EM)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_DA)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_LL_noninf)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_C_noninf)^2/norm(Y- mean(Y))^2,norm(Y - X*beta_EM_block)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_DA_block)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_LL)^2/norm(Y- mean(Y))^2, norm(Y - X*beta_C)^2/norm(Y- mean(Y))^2];
save(['END\results_experiment_END_' num2str(seed) '.mat'],'error_est','r_square','K_n');
end
