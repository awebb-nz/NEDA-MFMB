#####################################

# Estimate metacognitive efficiency (Mratio) at the group level
#
# Adaptation in R of matlab function 'fit_meta_d_mcmc_group.m'
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
# Audrey Mazancieux 2018

#####################################

## Packages
library(tidyverse)
library(magrittr)
library(reshape2)
library(coda)
library(lattice)
library(broom)
library(ggpubr)


fit_metaI_indiv <- function (nR_S1, nR_S2) {
  
  nratings <- length(nR_S1)/2
  total = sum(nR_S1+nR_S2)
  tacc = sum(nR_S1[1:nratings]+nR_S2[nratings+(1:nratings)])/total      #% accurate according to generated pos/neg
  mi = ent(tacc)
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
  
  return(output)
}
