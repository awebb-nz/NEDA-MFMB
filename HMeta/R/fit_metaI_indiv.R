#####################################

# Estimate metacognitive sensibility (meta d') for individual subject
#
# Adaptation in R of matlab function 'fit_meta_d_mcmc.m'
# by Steve Fleming 
# for more details see Fleming (2017). HMeta-d: hierarchical Bayesian 
# estimation of metacognitive efficiency from confidence ratings. 
#
# you need to install the following packing before using the function:
# tidyverse
# magrittr
# reshape2
# rjags
# coda
# lattice
# broom
# ggpubr
# ggmcmc
#
# nR_S1 and nR_S2 should be two vectors
# model output is a large mcmc list and two vectors for d1 and c1
#
# AM 2018
##############Peter codes########
# If you have nR_S1, nR_S2 as in the output of trials2counts() from
# Maniscalco and Lau, and function:
#   
#   ent(p) = (-p.*log(p+1e-20) - (1-p) .* log(1-p + 1e-20))/log(2)
# 
# then 
# 
# total=sum(nR_S1+nR_S2);
# tacc=sum(nR_S1(1:nr)+nR_S2(nr+(1:nr)))/total;      % accurate according to generated pos/neg
# mi=ent(tacc);
# pacc=zeros(1,nr);
# rprb=zeros(1,nr);
# for i=1:nr
# rprb(i)=(nR_S1(i)+nR_S2(2*nr+1-i)+nR_S2(i)+nR_S1(2*nr+1-i))/total;
# pacc(i)=(nR_S1(i)+nR_S2(2*nr+1-i))/(rprb(i)*total);
# mi = mi - rprb(i)*ent(pacc(i));
# end
# 
# mi is meta-I
# 
# and mi/end(tac)) is the  meta-I-ratio.
#####################################

## Packages
library(tidyverse)
library(magrittr)
library(reshape2)
library(rjags)
library(coda)
library(lattice)
library(broom)
library(ggpubr)
library(ggmcmc)

fit_metaI_indiv <- function (nR_S1, nR_S2) {
  
  #ent[p] = (-p.*log(p+1e-20) - (1-p) * log(1-p + 1e-20))/log(2)
  # 
  # then 
  # 
  total=sum(nR_S1+nR_S2)
  tacc=sum(nR_S1(1:nr)+nR_S2(nr+(1:nr)))/total     # % accurate according to generated pos/neg
  mi=ent(tacc)
  pacc=zeros(1,nr)
  rprb=zeros(1,nr)
  for (i in 1:nr){
    rprb(i)=(nR_S1(i)+nR_S2(2*nr+1-i)+nR_S2(i)+nR_S1(2*nr+1-i))/total
    pacc(i)=(nR_S1(i)+nR_S2(2*nr+1-i))/(rprb(i)*total)
    mi = mi - rprb(i)*ent(pacc(i))
  }
  
  Tol <- 1e-05
  nratings <- length(nR_S1)/2
  
  # Adjust to ensure non-zero counts for type 1 d' point estimate
  adj_f <- 1/((nratings)*2)
  nR_S1_adj = nR_S1 + adj_f
  nR_S2_adj = nR_S2 + adj_f
  
  ratingHR <- matrix()
  ratingFAR <- matrix()
  
  for (c in 2:(nratings*2)) {
    ratingHR[c-1] <- sum(nR_S2_adj[c:length(nR_S2_adj)]) / sum(nR_S2_adj)
    ratingFAR[c-1] <- sum(nR_S1_adj[c:length(nR_S1_adj)]) / sum(nR_S1_adj)
    
  }
  
  t1_index <- nratings
  d1 <<- qnorm(ratingHR[(t1_index)]) - qnorm(ratingFAR[(t1_index)])
  c1 <<- -0.5 * (qnorm(ratingHR[(t1_index)]) + qnorm(ratingFAR[(t1_index)]))
  
  counts <- t(nR_S1) %>% 
    cbind(t(nR_S2))
  counts <- as.vector(counts)
  
  # Data preparation for model
  data <- list(
    d1 = d1,
    c1 = c1,
    counts = counts,
    nratings = nratings,
    Tol = Tol
  )
  
  ## Model using JAGS
  # Create and update model
  model <- jags.model(file = 'Bayes_metad_indiv_R.txt', data = data,
                      n.chains = 3, quiet=FALSE)
  update(model, n.iter=1000)
  
  # Sampling
  output <- coda.samples( 
    model          = model,
    variable.names = c("meta_d", "cS1", "cS2"),
    n.iter         = 10000,
    thin           = 1 )
  
  return(output)
  
}
