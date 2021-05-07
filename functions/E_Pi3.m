%Sorting 
function [pi] = E_Pi3(X,Y,beta)
[n,d] = size(Y);
[A,index] = sort(X*beta);
[B,index1] = sort(Y);
index_inv(index) = 1:n;
pi = index1(index_inv);
end
