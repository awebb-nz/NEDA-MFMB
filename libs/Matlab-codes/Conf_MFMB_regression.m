%% Code for model-agnostic signatures of MB and MF contributions to chocie...
clear;
close all;
dbstop if error

%load('Result_Files'); % load the results files name in a cell "file"
%nsubs= length(files);
nsubs= 30;
conf_levels= 50:0.1:100;
calib_curve= nan(6, nsubs);

C_MF=[];
U_MF=[];
Y_MF=[];
SS_MF=[];
CONFHL_MF=[];
C_MB=[];
U_MB=[];
Y_MB=[];
SS_MB=[];
P_MB= [];
CONFHL_MB=[];
Drug_MB =[];
drug = load('data/Data_in_matlab/drug_4Rani_30.mat'); % the days which subjects used different drugs
daydrug = drug.drug.pro; 
drugpos = 1;
subjects = [102:112, 114:117, 119:133]; % 30 subjects
%drgname = 'pro, dop, plac';
ndrg= 3;
%for drg = 1: ndrg 
%     if drg == 1 
%         daydrug = drug.drug.pro;
%     elseif drg == 2
%         daydrug = drug.drug.dop;
%     else
%         daydrug = drug.drug.plac;
%     end
     
for ss = 1: nsubs
    day = daydrug(ss); 
    sss = subjects(ss);
    load(['data/main_data/complete/',...
         int2str(sss),'/main/', int2str(sss),'_', int2str(day),'.mat'])
    outcome= Subject.outcome_mat;
    score = score(:);
    RT= RT(:);
    chosen= chosen(:);
    display(ss)
    %probconfall = load(['/Users/sershadmanesh/Nextcloud/Drug_study/data/Data_in_matlab/probconf30.mat']);
    %probconfall= probconfall.probconf;
    %confidence= (0.5+ probconfall(drugpos,ss,:)/2)*100;
    confidence= conf(:);
    n_trials= length(chosen);
    
    % arrange realized reward
    realized_reward= Subject.realized_reward;
    reward_prob= Subject.reward_prob;
    trials= Subject.Trials;
    n_trials_block= 60;
    
    csc= cumsum(histc(confidence, 50:0.1:100));
    [~, med_ind]= min(abs(csc-csc(end)/2));
    confidence_hl= nan(1,length(confidence));
    confidence_hl(confidence> conf_levels(med_ind))= 1;
    confidence_hl(confidence<= conf_levels(med_ind))= 0;
    
    
    % analyze regular trials that are followed by regular trials
    count_MF=0;
    count_MB=0;
    count_MMF=0;
    common_rew_MF= nan(1, n_trials);
    other_rew_MF= nan(1, n_trials);
    common_rew_MB= nan(1, n_trials);
    same_chosen= nan(1, n_trials);
    generalized_chosen= nan(1, n_trials);
    conf_hl_MF= nan(1, n_trials);
    conf_hl_MB= nan(1, n_trials);
    %     RT_MF= nan(1, n_trials);
    %     RT_MB= nan(1, n_trials);
    %
    sameside_MMF= nan(1,n_trials);
    score_MMF= nan(1,n_trials);
    
    % score_vec= nan(1, ceil(n_trials)/3);
    for rr=1: n_trials
        
        if ismember(chosen(rr), 1:4) & mod(rr, n_trials_block) & ismember(chosen(rr+1), 1:4)
        
            if ismember(chosen(rr), trials(rr+1,:)) % this succestion of trals taps on MF
                common_box= intersect(outcome(trials(rr+1,1),:), outcome(trials(rr+1,2),:));
                other_box= setdiff(outcome(chosen(rr),:), common_box);
                %             common_ind= find(outcome(chosen(rr),:)==common_box);
                if isempty(common_box)
                    continue
                end
                count_MF=count_MF+1;
                common_rew_MF(count_MF)= realized_reward(rr, common_box);
                other_rew_MF(count_MF)= realized_reward(rr, other_box);
                same_chosen(count_MF)= chosen(rr)==chosen(rr+1);
                C_MF=[C_MF; common_rew_MF(count_MF)];
                U_MF=[U_MF; other_rew_MF(count_MF)];
                Y_MF=[Y_MF; same_chosen(count_MF)];
                SS_MF=[SS_MF; ss];
                CONFHL_MF= [CONFHL_MF; confidence_hl(rr)];
                
            else % this succestion of trals taps on MB
                sort_trial= sort(trials(rr+1,:));
                ll= [length(intersect(outcome(chosen(rr),:), outcome(sort_trial(1),:)))...
                    length(intersect(outcome(chosen(rr),:), outcome(sort_trial(2),:)))];
                if any(sort(ll)~= [0,1])
                    continue
                end
                option_with_common_outcome= sort_trial(find(ll));
                %                 if ismember(option_with_common_outcome, trials(rr,:))
                %                     continue;
                %                 else
                count_MB=count_MB+1;
                %Drug_MB = [Drug_MB; drg];
                common_box= intersect(outcome(option_with_common_outcome,:), outcome(chosen(rr),:));
                %             common_ind= find(outcome(chosen(rr),:)==common_box);
                common_rew_MB(count_MB)= realized_reward(rr, common_box);
                generalized_chosen(count_MB)= chosen(rr+1)==option_with_common_outcome;
                
                C_MB=[C_MB; common_rew_MB(count_MB)];
                %                 U_MB=[U_MB; other_rew_MB(count_MB)];
                Y_MB=[Y_MB; generalized_chosen(count_MB)];
                P_MB= [P_MB; reward_prob(rr, common_box)];
                SS_MB=[SS_MB; ss];
                CONFHL_MB= [CONFHL_MB; confidence_hl(rr)];
                
                conf_hl_MB(count_MB)= confidence_hl(rr);

            end
        end
    end

end
%end  % drug

% for MF analysis arrange in table
C_MF= C_MF-.5;
CONFHL_MF= CONFHL_MF-.5;

C_MF_temp=C_MF; C_MF=[];
CONFHL_MF_temp=CONFHL_MF; CONFHL_MF=[];
Y_MF_temp=Y_MF; Y_MF=[];
SS_MF_temp=SS_MF; SS_MF=[];
N_MF=[];
for ss=1: nsubs
    curr_ind= find(SS_MF_temp==ss);
    c_temp= C_MF_temp(curr_ind);
    chl_temp= CONFHL_MF_temp(curr_ind);
    y_temp= Y_MF_temp(curr_ind);
    for chl=0:1
        for cc=0:1
            C_MF= [C_MF;cc-.5];
            CONFHL_MF= [CONFHL_MF;chl-.5];
            Y_MF= [Y_MF;length(find(c_temp==cc & chl_temp==chl-.5 & y_temp==1))];
            SS_MF= [SS_MF;ss];
            N_MF= [N_MF; length(find(c_temp==cc & chl_temp==chl-.5))];
        end
    end
end
MF_tbl_with_conf= table(C_MF, CONFHL_MF, Y_MF, SS_MF, N_MF, 'VariableNames', {'C_MF', 'CONFHL_MF', 'Y_MF', 'SS_MF', 'N_MF'});
MF_tbl_with_conf = MF_tbl_with_conf(find(N_MF~=0),:);
MF_formula_with_conf= 'Y_MF~ C_MF*CONFHL_MF + (C_MF*CONFHL_MF|SS_MF)';
glme_MF_with_conf = fitglme(MF_tbl_with_conf,MF_formula_with_conf,'Distribution', 'binomial', 'FitMethod','Laplace',...
    'BinomialSize',MF_tbl_with_conf.N_MF, 'CheckHessian', true);

coeff_MB_with_conf= glme_MB_with_conf.Coefficients.Estimate(2:end);
coeff_MB_SE_with_conf= glme_MB_with_conf.Coefficients.SE(2:end);
[pVal,F,DF1,DF2] = coefTest(glme_MB_with_conf, [0 1 0 -.5]); % for low confidence
[pVal,F,DF1,DF2] = coefTest(glme_MB_with_conf, [0 1 0 .5]); % for high confidence

[random_effects,random_effect_names,random_effect_stats] = randomEffects(glme_MB_with_conf);
random_effects_with_intercept= random_effects;
random_effects(1:(length(coeff_MB_with_conf)+1):length(random_effects))=[]; % drop intercepts
random_effects= reshape(random_effects, [length(coeff_MB_with_conf), nsubs]);
random_effects_with_intercept= reshape(random_effects_with_intercept, [length(coeff_MB_with_conf)+1, nsubs]);
tot_effects= repmat(coeff_MB_with_conf, [1 nsubs])+ random_effects;
tot_effects_low= repmat(coeff_MB_with_conf, [1 nsubs])+ random_effects;
tot_effects_with_intercept= repmat(glme_MB_with_conf.Coefficients.Estimate, [1 nsubs])+ random_effects_with_intercept;



% %% for MB analysis arrange in table
% % Here we cannot pool data together because P differs from trial to trial!
C_MB= C_MB-.5;
P_MB= P_MB-.5;
CONFHL_MB= CONFHL_MB-.5;

C_MB_temp=C_MB; C_MB=[];
CONFHL_MB_temp=CONFHL_MB; CONFHL_MB=[];
Y_MB_temp=Y_MB; Y_MB=[];
SS_MB_temp=SS_MB; SS_MB=[];
N_MB=[];
for ss=1: nsubs
    curr_ind= find(SS_MB_temp==ss);
    c_temp= C_MB_temp(curr_ind);
    chl_temp= CONFHL_MB_temp(curr_ind);
    y_temp= Y_MB_temp(curr_ind);
    for chl=0:1
        for cc=0:1
            C_MB= [C_MB;cc-.5];
            CONFHL_MB= [CONFHL_MB;chl-.5];
            Y_MB= [Y_MB;length(find(c_temp==cc-.5 & chl_temp==chl-.5 & y_temp==1))];
            SS_MB= [SS_MB;ss];
             N_MB= [N_MB; length(find(c_temp==cc-.5 & chl_temp==chl-.5 ))];
        end
    end
end


MB_formula_with_conf= 'Y_MB~ C_MB*CONFHL_MB+ (C_MB*CONFHL_MB|SS_MB)'; % WORKS

MB_tbl_with_conf= table(C_MB, CONFHL_MB, Y_MB, SS_MB, N_MB, 'VariableNames', {'C_MB', 'CONFHL_MB', 'Y_MB', 'SS_MB', 'N_MB'});


glme_MB_with_conf = fitglme(MB_tbl_with_conf,MB_formula_with_conf,'Distribution', 'binomial', 'FitMethod','Laplace',...
    'BinomialSize',MB_tbl_with_conf.N_MB, 'CheckHessian', true);
glme_MB_with_conf = fitglme(MB_tbl_with_conf,MB_formula_with_conf,'Distribution', 'Normal', 'FitMethod','Laplace',...
    'CheckHessian', true);



coeff_MB_with_conf= glme_MB_with_conf.Coefficients.Estimate(2:end);
coeff_MB_SE_with_conf= glme_MB_with_conf.Coefficients.SE(2:end);
[pVal,F,DF1,DF2] = coefTest(glme_MB_with_conf, [0 1 0 -.5]); % for low confidence
[pVal,F,DF1,DF2] = coefTest(glme_MB_with_conf, [0 1 0 .5]); % for high confidence

[random_effects,random_effect_names,random_effect_stats] = randomEffects(glme_MB_with_conf);
random_effects_with_intercept= random_effects;
random_effects(1:(length(coeff_MB_with_conf)+1):length(random_effects))=[]; % drop intercepts
random_effects= reshape(random_effects, [length(coeff_MB_with_conf), nsubs]);
random_effects_with_intercept= reshape(random_effects_with_intercept, [length(coeff_MB_with_conf)+1, nsubs]);
tot_effects= repmat(coeff_MB_with_conf, [1 nsubs])+ random_effects;
tot_effects_low= repmat(coeff_MB_with_conf, [1 nsubs])+ random_effects;
tot_effects_with_intercept= repmat(glme_MB_with_conf.Coefficients.Estimate, [1 nsubs])+ random_effects_with_intercept;

'end';
