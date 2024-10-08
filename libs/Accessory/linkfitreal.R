if (!exists("simufit", mode = "function")) source("libs/Accessory/simufit.R")

linkfitreal <- function(par, datasub) {
  rewwalksub <- datasub[, 1:4]
  trialsub <- datasub[, 5:6]
  choicsub <- datasub[, 7]
  # alpha = par[1]
  wmb <- par[1]
  wmf <- par[2]
  # forget = par[4]
  # pr = par[5]
  # pz = par[6]
  # pz = par[5]
  loglik <- simufit(wmb, wmf, rewwalksub, trialsub, choicsub)
  # loglik = simufit(alpha,wmb, wmf, forget,pr, pz, rewwalksub, trialsub, choicsub )
  return(loglik)
}
