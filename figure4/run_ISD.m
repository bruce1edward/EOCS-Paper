rng(1)
addpath('../functions') 
load('../data/ISD/Italian_survey_data_linkage.mat');X_link = X;X = X(:,1);Y_link = Y;Y = Y(:,1);
%------------------Generating block permutation 
g_ID = findgroups(X_link(:,2),X_link(:,3),X_link(:,4),X_link(:,5),X_link(:,6));%numel(unique(g_ID))/numel(Y)
P = data_generator_block(numel(Y), g_ID);
[B,Q,G] = generate_B_Q(numel(Y), g_ID);
%------------------Data prepartion
Y_permuted = Y(P);
[n,d] = size(X);
[n,m] = size(Y);
X = [ones(n,1) X];
X_wo = X(:,2:end);
X_centered = X_wo - repmat(mean(X_wo,1), [n 1]);
d = d + 1;
%----------------------------------------------------
%Naive
beta_naive = X\Y_permuted;
%Oracle
beta_oracle = X\Y;
%EM_block
iter = 200; mcmc_steps = 2000; burn_steps = 500;
[beta_EM_block, sigma_sq_EM_block] = EM_mal_Block(Y_permuted, X, iter, mcmc_steps, burn_steps, 0, beta_naive, g_ID);

%Creating the x and y for the figure
fit_oracle = X*beta_oracle;
fit_naive = X*beta_naive;
Y_EM_block = Y;
for i = 1:G
    index1 = find(B(i,:) == 1);
    Pi_hat1 = E_Pi3(X(index1,:),Y(index1),beta_EM_block);
    tt = Y_EM_block(index1);
    Y_EM_block(index1) = tt(Pi_hat1);
end
fit_EM_block = X*(X\Y_EM_block);
p_res = sort(abs(Y - fit_oracle));
mismatch_before = sort(abs(Y - Y_permuted));
mismatch_after = sort(abs(Y - Y_EM_block));



