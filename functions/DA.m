function [track, order] = DA(Y_permuted, Y_hat, order, mcmc_steps, m, theta, index)    
   n = numel(Y_permuted);
   track = zeros(mcmc_steps/m,n);
   count = 0;
   for m_step = 1: mcmc_steps
                order_ = order;        % replace the permutation with the old one
                i = randi(n);          % generate random position 1
                j = randi(n);          % generate random position 2
                order_(i) = order(j);  % swap the position 1 with 2
                order_(j) = order(i);  % swap the position 2 with 1
                A = Y_hat(order_,:) - Y_hat(order,:); % compute the acceptance 
                p21 = sum(Y_permuted(:) .* A(:)) + theta*(sum(order ~= 1:n) - sum(order_ ~= 1:n)); % compute the acceptance raito 
                 if 0 < p21              % if acceptance raito is > 0, then accpet
                       order = order_;
                 else
                    if rand < exp(p21)   % if not then don't 
                       order = order_; 
                    end
                 end
                if mod(m_step,m) == 0    % the burning steps
                    count = count + 1;
                    track(count,:) = index(order);
                end
   end
end