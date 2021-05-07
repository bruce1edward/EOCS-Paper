rng(1)
addpath('../functions') 
data = readtable('../data/CPS/fakedata.csv','ReadVariableNames',false);
%------------------------Data preparation
Y = data(2:end,2);X = data(2:end,3:8);zipcode = data(2:end,9);
Y = Y{:,:};X = X{:,:};zipcode = zipcode{:,:};
Y = cellfun(@str2num,Y);X = cellfun(@str2num,X);zipcode = cellfun(@str2num,zipcode);
%hot encoding
cat = unique(X(:,5));
[n,d] = size(X);
[n,m] = size(Y);
for i = 1:numel(cat)-1
    X(:,d+i) = X(:,5) == cat(i+1);
end
temp1 = X(:,6);
X(:,5:6) = [];
X = [X temp1];
X = [ones(n,1) X];
[n,d] = size(X);
X_wo = X(:,2:end);
X_centered = X_wo - repmat(mean(X_wo,1), [n 1]);
%---------------------------------------------------------------------
% Data generator block
g_ID = findgroups(zipcode);
P = data_generator_block(numel(Y), g_ID);
[B,Q,G] = generate_B_Q(numel(Y), g_ID);
Y_permuted = Y(P);
%Naive
beta_naive = X\Y_permuted;
%Oracle
beta_oracle = X\Y;
%LL
Y_permuted1 = Y_permuted - mean(Y_permuted);
uni_g_ID = unique(g_ID);Y_Centered_Q = zeros(numel(uni_g_ID),1);X_centered_Q = zeros(numel(uni_g_ID),d-1);
for g = 1:numel(uni_g_ID)
index_g = find(g_ID == uni_g_ID(g));
Y_Centered_Q(g) = mean(Y_permuted1(index_g));
X_centered_Q(g,:) = mean(X_centered(index_g,:),1);
end
beta_LL = X_centered_Q\Y_Centered_Q;
beta_LL = [mean(Y_permuted - X_wo*beta_LL) ; beta_LL];

%create the x and y for the figure
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