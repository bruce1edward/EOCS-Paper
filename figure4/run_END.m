rng(1)
addpath('../functions') 
data = readtable('../data/END/elnino_l.csv','ReadVariableNames',false);
%------------------------------Data preparation
Y = data(2:end,11);X = data(2:end,[8:10 12]);lat_lon = data(2:end,[6 7]);
Y = Y{:,:};X = X{:,:};lat_lon = lat_lon{:,:};
Y = cellfun(@str2num,Y);X = cellfun(@str2num,X);lat_lon = cellfun(@str2num,lat_lon);
index = datasample(1:numel(Y),floor(0.1*numel(Y)),'Replace',false);
Y = Y(index);X = X(index,:);lat_lon = lat_lon(index,:);[n,d] = size(X);[n,m] = size(Y);
X = [ones(n,1) X];d = d + 1;
X_wo = X(:,2:end);X_centered = X_wo - repmat(mean(X_wo,1), [n 1]);
g_ID = findgroups(lat_lon(:,1),lat_lon(:,2));%numel(unique(g_ID))/numel(Y)
% -----------------------------Data generator block
P = data_generator_block(numel(Y), g_ID);
[B,Q,G] = generate_B_Q(numel(Y), g_ID);
Y_permuted = Y(P);
%Naive
beta_naive = X\Y_permuted;
sigma_sq_naive = norm(Y_permuted - X*beta_naive)^2/n;
r_sq_naive = 1 - norm(Y - X*beta_naive)^2/norm(Y - mean(Y))^2;
residual_variance_naive = norm(Y - X*beta_naive)^2/(n-3);
%Oracle
beta_oracle = X\Y;
%Mixture
Y_permuted1 = Y_permuted - mean(Y_permuted);control = "robust";
%LL
uni_g_ID = unique(g_ID);Y_Centered_Q = zeros(numel(uni_g_ID),1);X_centered_Q = zeros(numel(uni_g_ID),d-1); Q_X_centered = zeros(n,d-1);
for g = 1:numel(uni_g_ID)
index_g = find(g_ID == uni_g_ID(g));
Y_Centered_Q(g) = mean(Y_permuted1(index_g));
X_centered_Q(g,:) = mean(X_centered(index_g,:),1);
Q_X_centered(index_g,:) = (ones(numel(index_g))/numel(index_g))*X_centered(index_g,:);
end
beta_LL = X_centered_Q\Y_Centered_Q;
beta_LL = [mean(Y_permuted - X_wo*beta_LL) ; beta_LL];

%Create X and Y for the figure
fit_oracle = X*beta_oracle;
fit_naive = X*beta_naive;
Y_LL = Y;
for i = 1:G
    index1 = find(B(i,:) == 1);
    Pi_hat1 = E_Pi3(X(index1,:),Y(index1),beta_LL);
    tt = Y_LL(index1);
    Y_LL(index1) = tt(Pi_hat1);
end
fit_LL = X*(X\Y_LL);
p_res = sort(abs(Y - fit_oracle));
mismatch_before = sort(abs(Y - Y_permuted));
mismatch_after = sort(abs(Y - Y_LL));