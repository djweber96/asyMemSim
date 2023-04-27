%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function:    y2phiPhaseEq_FH(params)                                    %
% Description: Solve for membrane phase volume fractions of feed side of  %
%                membrane based on Flory-Huggins (FH) sorption model      % 
% Input:       params - struct of system parameters                       %
%                         (see dataBank function for specs)               %
% Output:      phis   - n+1 dimensional vector of membrane phase volume   %
%                         fractions                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phis] = y2phiPhaseEq_DSM(params)

%------------------------------------------------------------------------------------------------------------------------------------% 
%solve for phi based on bulk feed composition
    n = params.n;
    phiGuess(1:n) = params.yf.*0;
    phiGuess(n+1) = 1-sum(phiGuess(1:n));
    options = optimoptions(@fsolve,'Display','off','MaxFunctionEvaluations',5000);
    phis = fsolve(@(phis)y2phiPhaseEq_DSM_RHS(phis,params),phiGuess.',options);
%------------------------------------------------------------------------------------------------------------------------------------% 

end

