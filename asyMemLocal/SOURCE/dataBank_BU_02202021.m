%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function:    dataBank(sysInfo)                                          %
% Description: Build parameter matricies based on system specifications.  %
% Input:       sysInfoExt - external struct defining simulation specs     %
%                             (memID, mixID, yf, n, lmem, Pu, Pd, T, R    %
%                              memPhaseModel, diffModel, swlDiffModel)    %
% Output:      params     - struct of system parameters                   %
%                             (compID, n, Vs, HanSolParam, psat, chis [FH %
%                             or FH-LM], diffs, Ch & bs [FH-LM or DSM],   %
%                             ks [DSM], unitActPhis, Bffv, and all        %
%                             fields listed in sysInfo struct)            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
function [params] = dataBank_BU_02202021(sysInfo)

%------------------------------------------------------------------------------------------------------------------------------------% 
%full parameter/data sets
    if contains(sysInfo.memID,'SBAD1')
      % Lively/Ronita's 9-comp data TOL/MCH/1MN/DCN/NOC/IOC/TBB/TPB/ICE/SBAD-1
        params.lmem = 0.3; % thickness of active membrane layer um
        params.compID = struct('TOL', 1, 'MCH', 2, 'MNP', 3, 'DEC', 4, 'NOC', 5, 'IOC', 6, 'TBB', 7, 'TPB', 8, 'ICT', 9);
        params.n = 9; 
        params.Vs = [106.521;128.123;139.823;156.962;163.42;165.552;155.529;240.069;293.267;62326]; %cm3/mol
        params.HanSolParam = [18,1.4,2;16,0,1;20.6,0.8,4.7;18,0,0;15.5,0,0;14.1,0,0;17.4,0.1,1.1;18,0,0.6;16.3,0,0]; %[delD,delP,delH;...]
        params.psat = [28.998;46.596;0.059;0.975;14.805;49.087;2.115;0.0352;0.0458];%torr
        
        if contains(sysInfo.memPhaseModel,'F-H')    
            params.chis = [1,1,1,1,1,1,1,1,1,0.839;...
                    1,1,1,1,1,1,1,1,1,1.658;...
                    1,1,1,1,1,1,1,1,1,0.705;...
                    1,1,1,1,1,1,1,1,1,2.785;...
                    1,1,1,1,1,1,1,1,1,1.139;...
                    1,1,1,1,1,1,1,1,1,3.046;...
                    1,1,1,1,1,1,1,1,1,2.347;...
                    1,1,1,1,1,1,1,1,1,2.696;...
                    1,1,1,1,1,1,1,1,1,3.128];
                    params.chis(params.n+1,1:params.n+1) =  [params.chis(:,end).',1]; %note chi_ji = chi_ij exp FH
    %          params.diffs = [1,1,1,1,1,1,1,1,1,37.4;...
    %                  1,1,1,1,1,1,1,1,1,13.8;...
    %                  1,1,1,1,1,1,1,1,1,0.197;...
    %                  1,1,1,1,1,1,1,1,1,3.73;...
    %                  1,1,1,1,1,1,1,1,1,9.05;...
    %                  1,1,1,1,1,1,1,1,1,3.54;...
    %                  1,1,1,1,1,1,1,1,1,6.66;...
    %                  1,1,1,1,1,1,1,1,1,0.0114;...
    %                  1,1,1,1,1,1,1,1,1,0.454];
    %                 params.diffs(params.n+1,1:params.n+1) =  [params.diffs(:,end).',1]; %um2/s FH Exp Based MS diffs 
             params.diffs = [1,100000,0.001*params.Vs(3)/params.Vs(1),1100000,1100000,1100000,1100000,1100000,1100000,16.2327;...
                     1000000,1,1000000,1100000,1100000,1100000,1100000,1100000,1100000,5.7752;...
                     0.001,100000,1,1100000,1100000,1100000,1100000,1100000,1100000,0.0561;...
                     100000,100000,100000,1,1100000,1100000,1100000,1100000,1100000,1.7710;...
                     100000,100000,100000,1100000,1,1100000,1100000,1100000,1100000,5.7602;...
                     100000,100000,100000,1100000,1100000,1,1100000,1100000,1100000,7.2548;...
                     100000,100000,100000,1100000,1100000,1100000,1,1100000,1100000,3.849;...
                     100000,100000,100000,1100000,1100000,1100000,1100000,1,1100000,0.0926;...
                     100000,100000,100000,1100000,1100000,1100000,1100000,1100000,1,0.6245]; %um2/s FH Exp Based tweaked for single comp MS diffs 
%              params.diffs = [1,1,1,1,1,1,1,1,1,14.8614;...
%                      1,1,1,1,1,1,1,1,1,2.9657;...
%                      1,1,1,1,1,1,1,1,1,0.0446;...
%                      1,1,1,1,1,1,1,1,1,1.3774;...
%                      1,1,1,1,1,1,1,1,1,4.4687;...
%                      1,1,1,1,1,1,1,1,1,4.3721;...
%                      1,1,1,1,1,1,1,1,1,2.6776;...
%                      1,1,1,1,1,1,1,1,1,0.0926;...
%                      1,1,1,1,1,1,1,1,1,0.5681]; %Mixed Exp (LOW ERROR) Based FH Tweaked to match single comp FH um2/s   
            if sysInfo.memPhaseModel_FicksOG == 1
                params.diffs = [1,1,1,1,1,1,1,1,1,3.7657;...
                    1,1,1,1,1,1,1,1,1,3.4166;...
                    1,1,1,1,1,1,1,1,1,0.0099;...
                    1,1,1,1,1,1,1,1,1,1.4823;...
                    1,1,1,1,1,1,1,1,1,2.3031;...
                    1,1,1,1,1,1,1,1,1,6.3334;...
                    1,1,1,1,1,1,1,1,1,2.9556;...
                    1,1,1,1,1,1,1,1,1,0.0768;...
                    1,1,1,1,1,1,1,1,1,0.5510]; %um2/s FICKS FH-BC tweaked for single comp 20bar
%               params.diffs = [1,1,1,1,1,1,1,1,1,3.4476;...
%                   1,1,1,1,1,1,1,1,1,1.7544;...
%                   1,1,1,1,1,1,1,1,1,0.0079;...
%                   1,1,1,1,1,1,1,1,1,1.1529;...
%                   1,1,1,1,1,1,1,1,1,1.7867;...
%                   1,1,1,1,1,1,1,1,1,3.8168;...
%                   1,1,1,1,1,1,1,1,1,2.0560;...
%                   1,1,1,1,1,1,1,1,1,0.0768;...
%                   1,1,1,1,1,1,1,1,1,0.5013]; %um2/s FICKS (LOW ERROR) FH-BC tweaked for single comp 20 bar
            end
        elseif contains(sysInfo.memPhaseModel,'DSM')
            params.Ch = [0.110;0.0910;0;0.0620;0.287;0.07;0.0033;0.0146;0.00998];
            params.bs = [0.810;0.120;212;0;0.120;0.68;56853;271;46.5]; %torr^-1 mixed exp and genome
            params.ks = [0.0208;0.000955;19.3;0.0272;0.00987;0.00026;0.02080;0.504;0.251]; 
            params.diffs = [1,1,1,1,1,1,1,1,1,6.281;...
                     1,1,1,1,1,1,1,1,1,2.5734;...
                     1,1,1,1,1,1,1,1,1,0.0183;...
                     1,1,1,1,1,1,1,1,1,0.8516;...
                     1,1,1,1,1,1,1,1,1,2.2382;...
                     1,1,1,1,1,1,1,1,1,0.8031;...
                     1,1,1,1,1,1,1,1,1,1.6864;...
                     1,1,1,1,1,1,1,1,1,0.0391;...
                     1,1,1,1,1,1,1,1,1,0.2659];
                    params.diffs(params.n+1,1:params.n+1) =  [params.diffs(:,end).',1]; %Mixed Exp Based DSM Tweaked to match single comp backup1.22 i-OCT for 20 bar fit but 2.852 for fit of 30bar-60bar %um2/s            
%                params.diffs = [1,1,1,1,1,1,1,1,1,5.7505;...
%                      1,1,1,1,1,1,1,1,1,1.3215;...
%                      1,1,1,1,1,1,1,1,1,0.0146;...
%                      1,1,1,1,1,1,1,1,1,0.6344;...
%                      1,1,1,1,1,1,1,1,1,1.7364;...
%                      1,1,1,1,1,1,1,1,1,0.484;...
%                      1,1,1,1,1,1,1,1,1,1.1732;...
%                      1,1,1,1,1,1,1,1,1,0.0391;...
%                      1,1,1,1,1,1,1,1,1,0.242];
%                     params.diffs(params.n+1,1:params.n+1) =  [params.diffs(:,end).',1]; %Mixed Exp (LOW ERROR) Based DSM Tweaked to match single comp DSM um2/s    
            if sysInfo.memPhaseModel_FicksOG == 1
                params.diffs = [1,1,1,1,1,1,1,1,1,12.5410;...
                  1,1,1,1,1,1,1,1,1,6.2405;...
                  1,1,1,1,1,1,1,1,1,0.0393;...
                  1,1,1,1,1,1,1,1,1,0.8375;...
                  1,1,1,1,1,1,1,1,1,4.6304;...
                  1,1,1,1,1,1,1,1,1,4.7135;...
                  1,1,1,1,1,1,1,1,1,1.8986;...
                  1,1,1,1,1,1,1,1,1,0.0654;...
                  1,1,1,1,1,1,1,1,1,0.3617]; %um2/s FICKS DSM-BC tweaked for single comp
%               params.diffs = [1,1,1,1,1,1,1,1,1,11.4816;...
%                   1,1,1,1,1,1,1,1,1,3.2046;...
%                   1,1,1,1,1,1,1,1,1,0.0313;...
%                   1,1,1,1,1,1,1,1,1,0.6514;...
%                   1,1,1,1,1,1,1,1,1,3.5922;...
%                   1,1,1,1,1,1,1,1,1,2.8406;...
%                   1,1,1,1,1,1,1,1,1,1.3207;...
%                   1,1,1,1,1,1,1,1,1,0.0654;...
%                   1,1,1,1,1,1,1,1,1,0.3291]; %um2/s FICKS (LOW ERROR) DSM-BC tweaked for single comp
            end
        elseif contains(sysInfo.memPhaseModel,'FH-LM')
            params.chis = [1,1,1,1,1,1,1,1,1,1.01;...
                    1,1,1,1,1,1,1,1,1,2.28;...
                    1,1,1,1,1,1,1,1,1,0.79;...
                    1,1,1,1,1,1,1,1,1,3.06;...
                    1,1,1,1,1,1,1,1,1,1.67;...
                    1,1,1,1,1,1,1,1,1,3.76;...
                    1,1,1,1,1,1,1,1,1,2.68;...
                    1,1,1,1,1,1,1,1,1,3.33;...
                    1,1,1,1,1,1,1,1,1,3.63];
            params.chis(params.n+1,1:params.n+1) =  [params.chis(:,end).',1]; %note chi_ji = chi_ij exp FH-LM mixed FH
            params.Ch = [0.31;0.07302;0.481;0.00761;0.206;0.0112;0.01585;0.01597;0.00801];
            params.bs = [0.431;0.263;86.057;2.145;0.410;0.157;2.404;328.692;110.020]; %torr^-1 
    %         params.diffs = [1,1,1,1,1,1,1,1,1,13;...
    %                  1,1,1,1,1,1,1,1,1,2.71;...
    %                  1,1,1,1,1,1,1,1,1,0.073;...
    %                  1,1,1,1,1,1,1,1,1,2.54;...
    %                  1,1,1,1,1,1,1,1,1,4.32;...
    %                  1,1,1,1,1,1,1,1,1,.812;...
    %                  1,1,1,1,1,1,1,1,1,.0309;...
    %                  1,1,1,1,1,1,1,1,1,0.00527;...
    %                  1,1,1,1,1,1,1,1,1,0.36515];
    %                   params.diffs(params.n+1,1:params.n+1) = [params.diffs(:,end).',1]; %um2/s Mixed Exp Based FH-LM
             params.diffs = [1,1,1,1,1,1,1,1,1,7.3448;...
                    1,1,1,1,1,1,1,1,1,2.7868;...
                    1,1,1,1,1,1,1,1,1,0.0245;...
                    1,1,1,1,1,1,1,1,1,0.957;...
                    1,1,1,1,1,1,1,1,1,2.7194;...
                    1,1,1,1,1,1,1,1,1,3.6993;...
                    1,1,1,1,1,1,1,1,1,1.9841;...
                    1,1,1,1,1,1,1,1,1,0.0453;...
                    1,1,1,1,1,1,1,1,1,0.342];
                    params.diffs(params.n+1,1:params.n+1) =  [params.diffs(:,end).',1];%Mixed Exp Based FHLM Tweaked to match single comp FH-DSM um2/s    
%              params.diffs = [1,1,1,1,1,1,1,1,1,6.7243;...
%                      1,1,1,1,1,1,1,1,1,1.4311;...
%                      1,1,1,1,1,1,1,1,1,0.0195;...
%                      1,1,1,1,1,1,1,1,1,0.7443;...
%                      1,1,1,1,1,1,1,1,1,2.1097;...
%                      1,1,1,1,1,1,1,1,1,2.2294;...
%                      1,1,1,1,1,1,1,1,1,1.3803;...
%                      1,1,1,1,1,1,1,1,1,0.0453;...
%                      1,1,1,1,1,1,1,1,1,0.2948];
%                     params.diffs(params.n+1,1:params.n+1) =  [params.diffs(:,end).',1];%Mixed Exp (LOW ERROR) Based FHLM Tweaked to match single comp FH-DSM um2/s      
%             params.diffs = [1,0.3,0.3,100000,0.1,100000,100000,0.05,100000,5.36;...
%                      0.3*params.Vs(1)/params.Vs(2),100000,100000,100000,100000,100000,100000,100000,100000,2.06;...
%                      0.05*params.Vs(1)/params.Vs(3),100000,100000,100000,100000,100000,100000,100000,100000,0.0178;...
%                      100000,100000,100000,100000,100000,100000,100000,100000,100000,0.755;...
%                      0.1*params.Vs(1)/params.Vs(5),100000,100000,100000,100000,100000,100000,100000,0.1,1.88;...
%                      100000,100000,100000,100000,100000,100000,100000,100000,100000,2.852;...
%                      100000,100000,100000,100000,100000,100000,100000,100000,100000,1.5;...
%                      0.05*params.Vs(1)/params.Vs(8),100000,100000,100000,100000,100000,100000,100000,100000,0.038;...
%                      100000,100000,100000,100000,0.1*params.Vs(5)/params.Vs(9),100000,100000,100000,100000,0.238];%fudge diff matrix (FH-LM) plus FFV diffs 
    %         params.diffs = [1,1,1,1,1,1,1,1,1,6.25;...
    %                  1,1,1,1,1,1,1,1,1,3.5;...
    %                  1,1,1,1,1,1,1,1,1,0.022;...
    %                  1,1,1,1,1,1,1,1,1,0.718;...
    %                  1,1,1,1,1,1,1,1,1,2.03;...
    %                  1,1,1,1,1,1,1,1,1,2.852;...
    %                  1,1,1,1,1,1,1,1,1,0.522;...
    %                  1,1,1,1,1,1,1,1,1,0.0048;...
    %                  1,1,1,1,1,1,1,1,1,0.238];
    %                 params.diffs(params.n+1,1:params.n+1) =  [params.diffs(:,end).',1];%Mixed Exp Based FHLM (phi_FH)*(1-Ch)Tweaked to match single comp FH-DSM  backup1.22 i-OCT for 20 bar fit but 2.852 for fit of 30bar-60bar %um2/s             
%             params.diffs = [1,0.3,100000,100000,0.1,100000,100000,0.05,100000,2.3;...
%                      0.3*params.Vs(1)/params.Vs(2),100000,100000,100000,100000,100000,100000,100000,100000,2.3;...
%                      100000,100000,100000,100000,100000,100000,100000,100000,100000,2.3;...
%                      100000,100000,100000,100000,100000,100000,100000,100000,100000,2.3;...
%                      0.1*params.Vs(1)/params.Vs(5),100000,100000,100000,100000,100000,100000,100000,100000,2.3;...
%                      100000,100000,100000,100000,100000,100000,100000,100000,100000,2.3;...
%                      100000,100000,100000,100000,100000,100000,100000,100000,100000,2.3;...
%                      0.05*params.Vs(1)/params.Vs(8),100000,100000,100000,100000,100000,100000,100000,100000,2.3;...
%                      100000,100000,100000,100000,100000,100000,100000,100000,100000,2.3];%fudge diff matrix (FH-LM)
            if sysInfo.memPhaseModel_FicksOG == 1
                params.diffs = [1,1,1,1,1,1,1,1,1,5.8877;...
                    1,1,1,1,1,1,1,1,1,5.2182;...
                    1,1,1,1,1,1,1,1,1,0.0147;...
                    1,1,1,1,1,1,1,1,1,1.0072;...
                    1,1,1,1,1,1,1,1,1,4.8609;...
                    1,1,1,1,1,1,1,1,1,7.0424;...
                    1,1,1,1,1,1,1,1,1,2.3340;...
                    1,1,1,1,1,1,1,1,1,0.0844;...
                    1,1,1,1,1,1,1,1,1,0.4830]; %um2/s FICKS FHLM-BC tweaked for single comp
%               params.diffs = [1,1,1,1,1,1,1,1,1,5.3903;...
%                   1,1,1,1,1,1,1,1,1,2.6796;...
%                   1,1,1,1,1,1,1,1,1,0.0117;...
%                   1,1,1,1,1,1,1,1,1,0.7833;...
%                   1,1,1,1,1,1,1,1,1,3.7710;...
%                   1,1,1,1,1,1,1,1,1,4.2440;...
%                   1,1,1,1,1,1,1,1,1,1.6236;...
%                   1,1,1,1,1,1,1,1,1,0.0844;...
%                   1,1,1,1,1,1,1,1,1,0.4394]; %um2/s FICKS (LOW ERROR) FHLM-BC tweaked for single comp
            end
        end
        
    %  FFV Diff Model
        params.unitActPhis = [0.420;0.1;0.55;0.0248;0.1569;0.02;0.0429;0.0288;0.0153];
        %params.Bffv = 0.5*[0;1;0;1;0;1;1;1;1]; %0 if phi_i_unit_act >~= FFV_dry and 0.3 if "" << "" 
        params.Bffv = 0.03*[1;1;1;1;1;1;1;1;1]; 
        %params.Bffv = [3.9;0.75;12;0.14;2.1;0.1005;0.245;0.225;0.116]; %fit to UAV and self Ds 
        %params.Bffv = [0;0;0;0.14;0;0;0.2;0.2;0.116]; %fit to UAV and self Ds 
        
    elseif contains(sysInfo.memID,'PIM1')

         %Lively/Ronita's Exp Data for 5-comp TOL/HEP/PXY/OXY/ICE/PIM-1
        params.lmem = 1.5; %thickness of active membrane layer um
        params.compID = struct('TOL', 1, 'HEP', 2, 'PXY', 3, 'OXY', 4, 'ICT', 5);
        params.n = 5;
        params.Vs = [106.521;146.927;123.738;121.196;293.267;71429]; %cm3/mol
        params.HanSolParam = [18,1.4,2;15.3,0,0;17.6,1,3.1;17.8,1,3.1;16.3,0,0]; %[delD,delP,delH;...]
        params.psat = [28.998;44.854;8.803;6.637;0.0458]; %torr
        
        if contains(sysInfo.memPhaseModel,'F-H')
            params.chis = [1,0.0003,0.0005,1.04,0.0001,0.648;...
                0.0003,1,0.0008,0.0002,0.002,0.803;...
                0.0005,0.0008,1,0.0006,1,0.642;...
                0.0003,0.0002,0.0004,0.0004,0.0002,0.56;...
                0.0002,0.001,0.0002,0.0001,0.002,0.699];
                params.chis(params.n+1,1:params.n+1) =  [params.chis(:,end).',1]; %note chi_ji = chi_ij exp FH
            params.diffs = [1,100000,100000,100000,100000,52.5264;...
                100000,1,100000,100000,100000,181.8748;...
                100000,100000,1,100000,100000,36.5886;...
                100000,100000,100000,1,100000,16.8727;...
                100000,100000,100000,100000,1,2.9311]; %um2/s FH EXP (tweaked @20 bar)
%             params.diffs = [1,100000,100000,100000,100000,39.0283;...
%                 100000,1,100000,100000,100000,147.7324;...
%                 100000,100000,1,100000,100000,27.395;...
%                 100000,100000,100000,1,100000,13.7676;...
%                 100000,100000,100000,100000,1,1.5948]; %um2/s FH EXP (LOW ERROR)(tweaked @20 bar)
            if sysInfo.memPhaseModel_FicksOG == 1
                params.diffs = [1,100000,100000,100000,100000,7.0013;...
                    100000,1,100000,100000,100000,42.057;...
                    100000,100000,1,100000,100000,4.9931;...
                    100000,100000,100000,1,100000,1.3589;...
                    100000,100000,100000,100000,1,0.6324]; %um2/s FH-BC FICKS  (tweaked @20 bar)
%                 params.diffs = [1,100000,100000,100000,1000000,5.2021;...
%                     100000,1,100000,100000,100000,34.1618;...
%                     100000,100000,1,100000,100000,3.7385;...
%                     100000,100000,100000,1,100000,1.1095;...
%                     100000,100000,100000,100000,1,0.3441]; %um2/s FH-BC FICKS (LOW ERROR)(tweaked @20 bar)
            end
        elseif contains(sysInfo.memPhaseModel,'DSM')
            params.Ch = [0.221;0.579;0.321;0;0.533];
            params.bs = [6880;0.973;15800;31.5;10917]; %torr^-1 mixed exp and genome
            params.ks = [0.0525;0.00744;0.171;0.538;17.41]; 
            params.diffs = [1,100000,100000,100000,100000,14.6296;...
                100000,1,100000,100000,100000,56.7947;...
                100000,100000,1,100000,100000,9.429;...
                100000,100000,100000,1,100000,2.9588;...
                100000,100000,100000,100000,1,0.6406]; %um2/s DSM EXP  (tweaked @20 bar)
%            params.diffs = [1,100000,100000,100000,100000,10.8702;...
%                 100000,1,100000,100000,100000,46.1329;...
%                 100000,100000,1,100000,100000,7.0598;...
%                 100000,100000,100000,1,100000,2.4157;...
%                 100000,100000,100000,100000,1,0.3485]; %um2/s DSM EXP (LOW ERROR)(tweaked @20 bar)      
            if sysInfo.memPhaseModel_FicksOG == 1
                params.diffs = [1,100000,100000,100000,100000,46.0608;...
                    100000,1,100000,100000,100000,279.5765;...
                    100000,100000,1,100000,100000,32.4309;...
                    100000,100000,100000,1,100000,13.5977;...
                    100000,100000,100000,100000,1,2.4911]; %um2/s DSM-BC FICKS  (tweaked @20 bar)
%                 params.diffs = [1,100000,100000,100000,100000,34.2468;...
%                     100000,1,100000,100000,100000,227.0934;...
%                     100000,100000,1,100000,100000,24.2821;...
%                     100000,100000,100000,1,100000,11.1019;...
%                     100000,100000,100000,100000,1,1.3554]; %um2/s DSM-BC FICKS (LOW ERROR)(tweaked @20 bar)
            end
        elseif contains(sysInfo.memPhaseModel,'FH-LM')
            params.Ch = [0.77;0.68;0.73;0.71;1.09];
            params.bs = [0.589;0.681;5.316;6.547;169.7];
            params.chis = [1,0.0003,0.0005,1.04,0.0001,0.73;...
                0.0003,1,0.0008,0.0002,0.002,1.38;...
                0.0005,0.0008,1,0.0006,1,0.71;...
                0.0003,0.0002,0.0004,0.0004,0.0002,0.57;...
                0.0002,0.001,0.0002,0.0001,0.002,1.09];
                params.chis(params.n+1,1:params.n+1) =  [params.chis(:,end).',1]; %note chi_ji = chi_ij exp FH_LM
            params.diffs = [1,100000,100000,100000,100000,19.2733;...
                100000,1,100000,100000,100000,63.1223;...
                100000,100000,1,100000,100000,13.0002;...
                100000,100000,100000,1,100000,6.6166;...
                100000,100000,100000,100000,1,0.755]; %um2/s FH_DSM EXP (tweaked @20 bar)
%             params.diffs = [1,100000,100000,100000,100000,14.3206;...
%                 100000,1,100000,100000,100000,51.2706;...
%                 100000,100000,1,100000,100000,9.7336;...
%                 100000,100000,100000,1,100000,5.4022;...
%                 100000,100000,100000,100000,1,0.410]; %um2/s FH_DSM EXP (LOW ERROR) (tweaked @20 bar)
            if sysInfo.memPhaseModel_FicksOG == 1
                params.diffs = [1,100000,100000,100000,100000,12.8445;...
                    100000,1,100000,100000,100000,259.1834;...
                    100000,100000,1,100000,100000,8.4555;...
                    100000,100000,100000,1,100000,1.7153;...
                    100000,100000,100000,100000,1,4.0725]; %um2/s FHLM-BC FICKS  (tweaked @20 bar)
%                 params.diffs = [1,100000,100000,100000,100000,9.5438;...
%                     100000,1,100000,100000,100000,210.528;...
%                     100000,100000,1,100000,100000,6.3309;...
%                     100000,100000,100000,1,100000,1.4005;...
%                     100000,100000,100000,100000,1,2.2158]; %um2/s FHLM-BC FICKS (LOW ERROR)(tweaked @20 bar)
            end
        end
  %FFV Diff Model
    params.unitActPhis = [0.65;0.46;0.67;0.85;0.6];
    params.Bffv = 0.03*[1;1;1;1;1]; %0 if phi_i_unit_act > FFV_dry and 0.3 if "" << "" 
    %params.Bffv = 0.1*ones(5,1); %0 if phi_i_unit_act > FFV_dry and 0.3 if less than
    end
%------------------------------------------------------------------------------------------------------------------------------------% 

%------------------------------------------------------------------------------------------------------------------------------------% 
%custom parameter sets based on inputs
%custom parameter sets based on inputs
    compID = [];
    for i = 1:sysInfo.n
        compID_i = getfield(params.compID,sysInfo.mixID(i));
        compID = [compID;compID_i];
    end
    if contains(sysInfo.memPhaseModel,'F-H')||contains(sysInfo.memPhaseModel,'FH-LM')
        params.chis = [0.1*ones(sysInfo.n),params.chis(compID,end);params.chis([compID;1],end).']; %note chi_ji = chi_ij
    end
    params.diffs = [100000*ones(sysInfo.n),params.diffs(compID,end)]; %um2/s  
    params.Vs = [params.Vs(compID);params.Vs(end)]; %cm3/mol
    if sysInfo.crossDiffFudge == 1
        for k = 1:length(sysInfo.crossDiffSpecs)/2
            j = sysInfo.crossDiffSpecs(2*k);
            i = sysInfo.crossDiffSpecs(2*k-1);
            params.diffs(i,j) = sysInfo.crossDiffVals(k);
            params.diffs(j,i) = params.diffs(i,j)*params.Vs(j)/params.Vs(i);
        end
    end
    if contains(sysInfo.memPhaseModel,'DSM')||contains(sysInfo.memPhaseModel,'FH-LM')
        params.bs = params.bs(compID);
        params.Ch = params.Ch(compID);
    end
    if contains(sysInfo.memPhaseModel,'DSM')
        params.ks = params.ks(compID);
    end
    params.HanSolParam = params.HanSolParam(compID,:);
    params.psat = params.psat(compID);
    params.Bffv = params.Bffv(compID);
    params.unitActPhis = params.unitActPhis(compID);
%------------------------------------------------------------------------------------------------------------------------------------% 

%------------------------------------------------------------------------------------------------------------------------------------% 
%carry over needed sysInfo to params
    params.T = sysInfo.T;
    params.R = sysInfo.R;
    params.mixID = sysInfo.mixID;
    if contains(sysInfo.memID,'SBAD1')
        params.memID = 1;
    elseif contains(sysInfo.memID,'PIM1')
        params.memID = 2;
    end
    params.compID = cell2struct(mat2cell(1:sysInfo.n,1,ones(sysInfo.n,1)),params.mixID,2);
    params.Pu = sysInfo.Pu;
    params.Pd = sysInfo.Pd;
    params.yf = sysInfo.yf;
    params.n = sysInfo.n;
    if contains(sysInfo.memPhaseModel,'F-H')
        params.memPhaseModel = 1;
    elseif contains(sysInfo.memPhaseModel,'DSM')
        params.memPhaseModel = 2;
    elseif contains(sysInfo.memPhaseModel,'FH-LM')
        params.memPhaseModel = 3;
    end
    if contains(sysInfo.diffModel,'NoCoupling')
        params.diffModel = 1;
    elseif contains(sysInfo.diffModel,'Vignes')
        params.diffModel = 2;
    elseif contains(sysInfo.diffModel,'Darken')
        params.diffModel = 3;
    elseif contains(sysInfo.diffModel,'Fudge')
        params.diffModel = 4;
    end
    if contains(sysInfo.swlDiffModel,'none')
        params.swlDiffModel = 1;
    elseif contains(sysInfo.swlDiffModel,'FFV-OG')
        params.swlDiffModel = 2;
    elseif contains(sysInfo.swlDiffModel,'FFV-UAV')
        params.swlDiffModel = 3;
    elseif contains(sysInfo.swlDiffModel,'Avg-Diff')
        params.swlDiffModel = 4;
    end
    if contains(sysInfo.numMethod,'FullDis')
        params.numNodes = sysInfo.numNodes; 
    elseif contains(sysInfo.numMethod,'MultShootAlg')
        params.numShootPoints = sysInfo.numShootPoints; 
        params.casADi = sysInfo.casADi;
    end
    params.solverSpec = sysInfo.solverSpec;
    params.iterDetail = sysInfo.iterDetail;
    params.crossDiffFudge = sysInfo.crossDiffFudge;
    params.memPhaseModel_FicksOG = sysInfo.memPhaseModel_FicksOG;
    params.noThermoCoupling = sysInfo.noThermoCoupling;
    if sysInfo.crossDiffFudge == 1
        params.crossDiffSpecs = sysInfo.crossDiffSpecs;
        params.crossDiffVals = sysInfo.crossDiffVals;
    end
%------------------------------------------------------------------------------------------------------------------------------------% 

end
