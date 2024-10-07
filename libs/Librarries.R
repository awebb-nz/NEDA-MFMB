##%######################################################%##
#                                                          #
####                    Load Library                    ####
#                                                          #
##%######################################################%##

if(!("stringi" %in% installed.packages())) install.packages("stringi")
if(!("tidyverse" %in% installed.packages())) install.packages("tidyverse")
if(!("gghalves" %in% installed.packages())) install.packages("gghalves")
if(!("lme4" %in% installed.packages())) install.packages("lme4")
if(!("R.matlab" %in% installed.packages())) install.packages("R.matlab")
if(!("DEoptim" %in% installed.packages())) install.packages("DEoptim")
if(!("cowplot" %in% installed.packages())) install.packages("cowplot")
if(!("reshape2" %in% installed.packages())) install.packages("reshape2")
if(!("rjags" %in% installed.packages())) install.packages("rjags")
if(!("coda" %in% installed.packages())) install.packages("coda")
if(!("ggpubr" %in% installed.packages())) install.packages("ggpubr")
if(!("ggmcmc" %in% installed.packages())) install.packages("ggmcmc")


library(tidyverse)
library(gghalves)
library(lme4)
library(R.matlab)
library(DEoptim)
library(cowplot)
library(reshape2)
library(rjags)
library(coda)
library(ggpubr)
library(ggmcmc)

# library(magrittr)
# 
# 
# library(lattice)
# library(broom)
# library(ggpubr)
# 

#library("readxl")





##%######################################################%##
#                                                          #
####                        chunking                        ####
#                                                          #
##%######################################################%##

knitr::opts_chunk$set(echo = FALSE,warning = FALSE, message = FALSE, 
                      error = FALSE, comment="", fig.align = "center" ) 
