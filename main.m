%alphas = input('insert aphas\n'); % wagers
% S = shark = scamer; m = mark = scamee

%gammas = input('intput gammas\n'); % win/loss policy (start w/ 0s and 1s)
gammas = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];

k = size(gammas,2); % we assume s alphas == s gammas == k
alphas = zeros(1,k); %it makes more sense to not input alphas
alphas_ = zeros(1,k);
if(size(alphas) ~= size(gammas)) % see below
    disp('Your vectors need to be the same length');
    return;
end
M_skill = 0.5;
S_budget = 100;
S_pocket = S_budget; % how much he has to spend
M_budget = 100; % M_budget should be <= S_budget
M_loss_prc = 0.5;
M_rho = M_loss_prc * M_budget; % assume he doesn't want to lose more than half his pocket
M_pocket = M_rho; % see above
S_M_rho = M_rho; %we assume shark knows exactly how much he can poach
M_gamma = 1; % we assume the mark will accept the first game

S_M_skill = M_skill; % the shark knows his victim's skill

M_record = zeros(1,k); % mark remembers in -1, 1
S_profit = zeros(1,k);

alpha = randi([1,S_M_rho/2]); % one way of starting off
for t = 1:k
   if(alpha > S_pocket) % bet as much as he has anyway
       alpha = S_pocket;
   end
   if(alpha > M_rho)
       alpha = M_rho;
   end
   if(M_pocket <= 0 || S_pocket <= 0)
       return;
   end

   alphas(t) = alpha; % record
   alphas_(t) = alpha / M_rho; % wagers as a prc of mark pocket
      
   if(alpha > M_rho)
    M_gamma2 = 0;% 2 for temporary
   elseif(think(M_gamma, alpha) > M_rho) % the decision
    M_gamma2 = 0;
    disp('occurs');
   else
    M_gamma2 = 1;
   end
   
   if(M_gamma2 == 1)
    S_gamma = gammas(t);
    if(S_gamma > M_skill) % things are getting weird
      M_pocket = M_pocket - alpha;
      S_pocket = S_pocket + alpha;
      M_budget = M_budget - alpha;
      S_budget = S_budget + alpha;
      S_profit(t) = alpha;
      M_record(t) = -1;
    else
       M_pocket = M_pocket + alpha;
       S_pocket = S_pocket - alpha;
       S_profit(t) = -alpha;
       M_budget = M_budget + alpha;
       S_budget = S_budget - alpha;
       M_record(t) = 1;
    end
   end

      %
   if(t == 1)
       alpha = M_pocket * updateAlpha(M_record(t),alphas_(t), gammas(t+1:end));
   else
       alpha = M_pocket * updateAlpha(M_record(1:t-1),alphas_(1:t-1), gammas(t+1:end));
   end
   %

    %update M_gamma
    %M_gamma = randi([-1,1]);
    %update gammas
    M_rho = M_loss_prc * M_pocket;
end
s = sum(S_profit)