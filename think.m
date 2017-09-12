function [ play ] = think(M_gamma, alpha)

play = alpha * M_gamma - alpha * (1 - M_gamma);


end

