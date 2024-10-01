%% Code for model-agnostic signatures of MB and MF contributions to chocie...
clear;
close all;
dbstop if error


%load('Result_Files'); % load the results files name in a cell "file"
subjects = [102:112, 114:117, 119:133];
nsubs = 30;% length(files);
nday = 3;
ndrug =3;
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
Drug = [];
confdetect = zeros(1,nsubs);
drug = load('/Users/sershadmanesh/Nextcloud/Drug_study/Public/data/Data_in_matlab/drug_day_30.mat'); % the days which subjects used different drugs
%daydrug = drug.drug.pro;  % change the drug
drug_cell = struct2cell(drug.drug);
for dru = 1:ndrug
    
    daydrug = drug_cell{dru,1};
for ss = 1: nsubs 
    

    day = daydrug(ss); 
    %day = dop(ss); 
    sss = subjects(ss);
        
    load(['/Users/sershadmanesh/Nextcloud/Drug_study/data/complete/',...
         int2str(sss),'/main/', int2str(sss),'_', int2str(day),'.mat'])
 
    outcome= Subject.outcome_mat;
    RT= RT(:);
    chosen= chosen(:);
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
               
                if count_MB==5 
                    %disp(rr)
                end
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
                Drug= [Drug; dru]; 
                
                conf_hl_MB(count_MB)= confidence_hl(rr);

            end
        end
    end
    common_rew_MF= common_rew_MF(1: count_MF);
    other_rew_MF= other_rew_MF(1: count_MF);
    common_rew_MB= common_rew_MB(1: count_MB);
    conf_hl_MB= conf_hl_MB(1: count_MB);
    conf_hl_MF= conf_hl_MF(1: count_MF);
  
    
    % score_vec= score_vec(1: count_MB);
    same_chosen= same_chosen(1: count_MF);
    generalized_chosen= generalized_chosen(1: count_MB);
    
    ind_00= find(common_rew_MF==0 & other_rew_MF==0);
    ind_01= find(common_rew_MF==0 & other_rew_MF==1);
    ind_10= find(common_rew_MF==1 & other_rew_MF==0);
    ind_11= find(common_rew_MF==1 & other_rew_MF==1);
    prob_same_fact(:,:,ss)= [mean(same_chosen(ind_00)) mean(same_chosen(ind_01)); mean(same_chosen(ind_10)) mean(same_chosen(ind_11))];
    
    
    ind_below= find(common_rew_MB==0);
    ind_above= find(common_rew_MB==1);
    prob_generalized_median_split(:,ss)= [sum(generalized_chosen(ind_below))/length(ind_below)...
        sum(generalized_chosen(ind_above))/length(ind_above)];
end
end

%% for MF analysis arrange in table
C_MF_temp=C_MF; C_MF=[];
U_MF_temp=U_MF; U_MF=[];
Y_MF_temp=Y_MF; Y_MF=[];
SS_MF_temp=SS_MF; SS_MF=[];
N_MF=[];
confDETECT = [];

for ss=1: nsubs
    curr_ind= find(SS_MF_temp==ss);
    c_temp= C_MF_temp(curr_ind);
    u_temp= U_MF_temp(curr_ind);
    y_temp= Y_MF_temp(curr_ind);
    for uu=0:1
        for cc=0:1
            confDETECT = [confDETECT; confdetect(ss)];
            C_MF= [C_MF;cc-.5];
            U_MF= [U_MF;uu-.5];
            Y_MF= [Y_MF;length(find(c_temp==cc & u_temp==uu & y_temp==1))];
            SS_MF= [SS_MF;ss];
            N_MF= [N_MF; length(find(c_temp==cc & u_temp==uu))];
        end
    end
end


MF_tbl= table(C_MF, U_MF, Y_MF, SS_MF, N_MF, 'VariableNames', {'C_MF', 'U_MF', 'Y_MF', 'SS_MF', 'N_MF'});
MF_formula= 'Y_MF~ C_MF*U_MF + (C_MF*U_MF|SS_MF)'; % why not devided by N_MF???
glme_MF = fitglme(MF_tbl,MF_formula,'Distribution', 'binomial', 'FitMethod','Laplace','BinomialSize',MF_tbl.N_MF, 'CheckHessian', true);
coeff_MF= glme_MF.Coefficients.Estimate(2:end);
coeff_MF_SE= glme_MF.Coefficients.SE(2:end);
[random_effects,random_effect_names,random_effect_stats] = randomEffects(glme_MF);
random_effects_with_intercept= random_effects;
random_effects(1:(length(coeff_MF)+1):length(random_effects))=[]; % drop intercepts
random_effects= reshape(random_effects, [length(coeff_MF), nsubs]);
random_effects_with_intercept= reshape(random_effects_with_intercept, [length(coeff_MF)+1, nsubs]);
tot_effects= repmat(coeff_MF, [1 nsubs])+ random_effects;
tot_effects_with_intercept= repmat(glme_MF.Coefficients.Estimate, [1 nsubs])+ random_effects_with_intercept;
 
% %% for MB analysis arrange in table
% % Here we cannot pool data together because P differs from trial to trial!
N_MB= 1+zeros(length(C_MB),1);
MB_tbl= table(C_MB, P_MB, Y_MB, SS_MB, 'VariableNames', {'C_MB', 'P_MB', 'Y_MB', 'SS_MB'});
MB_formula= 'Y_MB~ C_MB*P_MB + (C_MB*P_MB|SS_MB)';
glme_MB = fitglme(MB_tbl,MB_formula,'Distribution', 'binomial', 'FitMethod','Laplace', 'CheckHessian', true);

coeff_MB= glme_MB.Coefficients.Estimate(2:end);
coeff_MB_SE= glme_MB.Coefficients.SE(2:end);
[random_effects,random_effect_names,random_effect_stats] = randomEffects(glme_MB);
random_effects_with_intercept= random_effects;
random_effects(1:(length(coeff_MB)+1):length(random_effects))=[]; % drop intercepts
random_effects= reshape(random_effects, [length(coeff_MB), nsubs]);
random_effects_with_intercept= reshape(random_effects_with_intercept, [length(coeff_MB)+1, nsubs]);
tot_effects= repmat(coeff_MB, [1 nsubs])+ random_effects;
tot_effects_with_intercept= repmat(glme_MB.Coefficients.Estimate, [1 nsubs])+ random_effects_with_intercept;
 

