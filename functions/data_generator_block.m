function [P] = data_generator_block(n,g_ID)
blockindex_ = unique(g_ID);
G = length(blockindex_);
P = 1:n;
index2 = 1:n;
index1 = [];
for g = 1:G   
    index = g_ID == blockindex_(g);
    n_G = sum(index);
    if n_G == 1
       index1 = [index1 index2(index)];
    end
    P_ = randperm(n_G);
    P__ = P(index);
    P(index) = P__(P_);
end
end