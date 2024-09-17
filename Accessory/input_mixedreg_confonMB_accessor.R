
input_mixedreg_confonMB_accessor = function(chosen,score, confidence,sub,realized_reward,reward_prob,trials){
  
  C_MB=c()
  U_MB=c()
  Y_MB=c()
  SS_MB=c()
  CONFHL_MB=c()
  P_MB = c()

  conf_levels= seq(50,100.1, by= 0.1)
  #conf_scr = matrix(0,nrow=3,ncol=3)  
  n_trials = 300
  n_trials_block= 60
  outcome= rbind(c(1,3), c(1,4), c(2,3), c(2,4))
h = hist(confidence, breaks =seq(50,100.1, by= 0.1),  right = FALSE)
csc = cumsum(h$counts)
med_ind = min(abs(csc-csc[length(csc)]/2))
med_plac = which(abs(csc-csc[length(csc)]/2)== med_ind)
confidence_hl= rep(NA,length(confidence))
confidence_hl[confidence> mean(conf_levels[med_plac])]= 1
confidence_hl[confidence<= mean(conf_levels[med_plac])]= 0


count_MB=0;
common_rew_MB= rep(0, n_trials)
same_chosen= rep(0, n_trials)
generalized_chosen= rep(0, n_trials)
conf_hl_MB= rep(0, n_trials)
score_chosen = rep(0, n_trials) #Sara added

for (rr in 1:n_trials){
  if ((chosen[rr] %in% 1:4) & (rr%% n_trials_block)!=0 & (chosen[rr+1] %in% 1:4)){
    
    if (chosen[rr] %in% trials[rr+1,]){
      common_plac= outcome[trials[rr+1,1],] %in% outcome[trials[rr+1,2],]
      common_box = outcome[trials[rr+1,1],common_plac]
      other_plac = which((outcome[chosen[rr],] %in% common_box)== 0)
      other_box= outcome[chosen[rr],other_plac] 
      
    } else { # this succestion of trals taps on MB
      sort_trial= sort(trials[rr+1,])
      ll= c(length(which((outcome[chosen[rr],] %in% outcome[sort_trial[1],])==1)),
            length(which((outcome[chosen[rr],] %in% outcome[sort_trial[2],])==1)))
      if (sum(as.integer(sort(ll)== c(0,1)))== 2){
        option_with_common_outcome= sort_trial[which(ll==1)]
        
        count_MB=count_MB+1
        common_plac= outcome[option_with_common_outcome,]%in% outcome[chosen[rr],]
        common_box= outcome[option_with_common_outcome,common_plac]
        
        common_rew_MB[count_MB]= realized_reward[rr, common_box]
        generalized_chosen[count_MB]= as.integer(chosen[rr+1]==option_with_common_outcome)
        score_chosen[count_MB] = score[rr]
        C_MB=c(C_MB, common_rew_MB[count_MB])
        Y_MB=c(Y_MB, generalized_chosen[count_MB])
        P_MB= c(P_MB, reward_prob[rr, common_box])
        SS_MB=c(SS_MB, sub)
        CONFHL_MB= c(CONFHL_MB, confidence_hl[rr])

      } #sum(as.integer
    } # MB subsection
  } # chosen[rr] %in% 1:4
  #print(rr)
} # rr in 1:n_trials
ret = list(Y_MB,C_MB,CONFHL_MB,SS_MB, P_MB)
return(ret)
}

