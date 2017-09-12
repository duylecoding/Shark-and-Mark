function [ new_wager ] = updateAlpha( M_record, alphas, gammas)
a = sum(M_record == 1)/size(M_record,2); % times mark has won?
b = mean(alphas);
c = sum(gammas == 1) / size(gammas,2);

new_wager = (((b*a/a)*a)/b) * c * c* c; % bayesian updating


end

