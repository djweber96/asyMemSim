function [G]=mem_gas_sep(z,W)    
    %gas membrane simulation 
    %applied solution_diffusion model with dense polymer membrane
    %bundle of ~2450 hollow fibers
    
%declare differential variables
    C_o2 = W(1); %mol/L
    C_n2 = W(2); %mol/L
    Q = W(3);    %L/hr
    dQ = W(4);
    P = W(5);  %Pa
%various polymer permabillity vector
    pm_o2 = [7600;1000;638;30;16.8;11.2;7.9;1.38;3.1;1.4]*0.000000122198; %convert units from Barrer to mol*M/M^2*hr*bar (STP)
    pm_n2 = [5400;600;320;7.1;3.8;3.3;1.3;0.239;0.46;0.18]*0.000000122138;
    Pm = [pm_o2,pm_n2];
%define constants
    ps = 0; %bar
    r_i = 0.00015; %meter
    R_o = 0.00025; %meter
    T = 298; %Lord Kelvin
    R = 0.083144621; %L bar/mol K
    rho = 1.0184; %kg/m^3 at 1 bar
    mu = 1.81*10^-5; %kg/m*s  at 1 bar and 25 deg C
%define total conc. and partial pressures
    C_T = C_o2+C_n2; %~~.2 mol/L at 5 bar
    P = R*T*C_T; %assuming IG law
    pf_o2 = P*C_o2/C_T;
    pf_n2 = P*C_n2/C_T; 
%flux across membrane
    J_o2 = (Pm(2,1)/(R_o-r_i))*(pf_o2-ps);
    J_n2 = (Pm(2,2)/(R_o-r_i))*(pf_n2-ps); 
%volumetric_flow
    %%[dQ]/[dz] for constant pressure along membrane (d[C_T]/d[z]=0)
    %dQ = -2*pi()*r_i*(J_n2+J_o2)/(C_T);   
    %%[dQ]/[dz] accounting for pressure drop ([dC_T]/[dz]=(1/R*T)*d[P]/d[z])    
     dQ_1 = dQ;
     dQ_2 = (-C_T*R*T*pi()*r_i^2/(mu*Q)+rho*Q/mu)*dQ_1-2*pi()*r_i*(J_n2+J_o2)*R*T*pi()*r_i^2/(mu*Q);
%mass_balence on spiral wound unit
    %[dC_o2]/[dz] =
    dC_o2 = (-C_o2*dQ-2*pi()*r_i*J_o2)/Q; %oxygen concentration change across single fiber
    %[dC_n2]/[dz] =
    dC_n2 = (-C_n2*dQ-2*pi()*r_i*J_n2)/Q; %nitrogen concentration change across single fiber
%NS derived delta P (to test vs. Mass Balance deriverd del P for sanity check
    dP = mu/(pi()*r_i^2)*dQ_2-rho*Q*dQ_1/(pi()*r_i^2);
%differential vector
    G=[dC_o2;dC_n2;dQ_1;dQ_2;dP]; 
    
%%GENERAL NOTES%%
    
    %factors affecting permeabillity(diff*solub):
    %------solubility into membrane matrix : temperature, concentration (pressure dependant if gas) can
    %saturate surface after sometime or at some concentration (if rate-limiting)
    %------diffusion through membrane matrix: temperature, concentration,
    %    pressure (Maxwell_Stephen coupled diffusion mass and energy transport)
                                        %Perm
        %Test cases (dense polymers):  (Barrer)  Selec
                                      % O2   N2  tivety     
    % Poly(1-trimethylsilyl-1-propyne) 7600 5400 1.6
    % Polydimethylsiloxane (PDMS)      1000 600  1.7           /NOTE ABOUT
    % Poly(dimethylsiloxane)           638  320  2.0           /STRUCT:
    % Poly(4-methyl-1-pentene)          30  7.1  4.2           /CREATING_OBJS_
    % Poly(phenylene oxide)           16.8  3.8  4.4           /params.pres
    % Ethyl cellulose                 11.2  3.3  3.4           /params.feed
    % 6FDA-DAF (polyimide)             7.9  1.3  6.2           /like chess
    % Polysulfone                      1.38 0.24 5.8           /organization
    % Polyaramid                        3.1 0.46 6.8           /of pieces
    % Tetrabromo bis polycarbonate      1.4 0.18 7.8
    
    %chaning the volumetric flowrate has no effect on the performace. Which
    %makes sense since the membrane area, permeabillity, and driving force
    %if what affects the separation.
