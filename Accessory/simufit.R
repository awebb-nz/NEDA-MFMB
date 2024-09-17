# alpha = 0.4
# wmb = 0.6
# wmf = 0.4
# forget = 0.2
# pr = 0.1
# pz = 1
# rewwalk = rewwalk
# trials = trials
# choice = choicsub

#simufit = function(alpha, wmb, wmf, forget, pr, pz, rewwalk, trials, choice){ #
simufit = function( wmb, wmf, rewwalk, trials, choice){ #

  reward = rewwalk
  nTrials = length(choice)
  association = rbind(c(1,3), c(1,4), c(2,3), c(2,4)) #rbind(c(1,2), c(1,3), c(2,4), c(3,4)) # same as Rani
  v_mb = matrix(NaN,nTrials,4) #0.5 Rani   #// model-based stimulus values for level 1 (2 stimuli)
  v_mf = matrix(NaN,nTrials,4) # 1 Rani   #// model-free stimulus values for level 1&2 (1,2--> level 1, 3-6--> level 2)
 # pers = matrix(NaN,nTrials,4)    # increase for chosen and decrease for unchosens!!!!
  loglik_choice= rep(NaN,nTrials)
  counter= 0
  alpha = 1
  forget = 0
  
  
  for (t in 1:nTrials){
     if (t%%60 ==1){  # new block would start from next trial
         Q_MF= rep(1,4)
         Q_MB= .5*rep(1,4)
         indic4= rep(1,4)
     }
    
    v_mf[t,]= Q_MF
    v_mb[t,]= Q_MB
    #pers[t,]= indic4
    
     if (choice[t] %in% 1:4){
       counter = counter+1
       chosen_ind= 2- (trials[t,1]==choice[t])
       # simulate chosen
       curr_Q_MF= Q_MF[trials[t,]]
       curr_Q_MB= c(sum(Q_MB[association[trials[t,1],]]), sum(Q_MB[association[trials[t,2],]]))
       
       curr_Q= (wmf)*curr_Q_MF+ wmb*curr_Q_MB;
       
       # Perseverance
       #indicator= indic4[trials[t,]]
       in_exp= curr_Q#+ pz*indicator
       in_exp= in_exp-max(in_exp)
       loglik_choice[counter]= in_exp[chosen_ind]- log(sum(exp(in_exp)))
       
       curr_outcome= association[choice[t],];
       score= sum(reward[t,curr_outcome]);
       
       # learn MF
       pred_err_MF= score-Q_MF[choice[t]]
       Q_MF[choice[t]]= Q_MF[choice[t]]+alpha*pred_err_MF
       forget_ind= setdiff(1:4, choice[t])
       Q_MF[forget_ind]= Q_MF[forget_ind]+forget*(- Q_MF[forget_ind])
       
       # learn MB
       pred_err_MB= reward[t,curr_outcome]-Q_MB[curr_outcome]
       Q_MB[curr_outcome]= Q_MB[curr_outcome]+ alpha*pred_err_MB
       forget_ind= setdiff(1:4, curr_outcome)
       Q_MB[forget_ind]= Q_MB[forget_ind]+forget*(- Q_MB[forget_ind])
       
      # indic4= (1-pr)*indic4;
      # indic4[choice[t]]= indic4[choice[t]]+pr;
       
    }
  }
  loglikchoice= loglik_choice[1:counter]
 # saveRDS(logprob, file="data/logprob_dru1sub1.rds")
  loglik = -sum(loglikchoice)
  return(loglik)
}
