function [B,Q,G] = generate_B_Q(n, blockindex)
% blockindex = g_ID(idx(1:round(0.8*n)));
blockindex_ = unique(blockindex);
G = length(unique(blockindex));
B = zeros(G,n);
Q = zeros(n);
index_ = 1:n;
for g = 1:G       % iterate over group 
    %g = 1;
    %generate permutation 
    index = blockindex == blockindex_(g);
    n_G = sum(index);
    B(g,:) = double(index);
    index__ = index_(index);
    for i = 1:n_G
        for j = 1:n_G
            Q(index__(i),index__(j)) = 1/n_G;
        end
    end
end
end