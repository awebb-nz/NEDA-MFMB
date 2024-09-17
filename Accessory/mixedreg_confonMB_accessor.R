
mixedreg_confonMB_accessor = function(Y_MB,C_MB,CONFHL_MB,SS_MB){
C_MB= C_MB-.5
CONFHL_MB= CONFHL_MB-.5
C_MB_temp=C_MB 
C_MB=c()
CONFHL_MB_temp=CONFHL_MB
CONFHL_MB=c()
Y_MB_temp=Y_MB
Y_MB=c()
SS_MB_temp=SS_MB
SS_MB=c()
N_MB=c()
for (ss in 1: nsub){
  curr_ind= which(SS_MB_temp==ss)
  c_temp= C_MB_temp[curr_ind]
  chl_temp= CONFHL_MB_temp[curr_ind]
  y_temp= Y_MB_temp[curr_ind]
  for (chl in 0:1){
    for (cc in 0:1){
      C_MB= c(C_MB,cc-0.5)
      CONFHL_MB= c(CONFHL_MB,chl-0.5)
      Y_MB= c(Y_MB,length(which(c_temp==cc-0.5 & chl_temp==chl-0.5 & y_temp==1)))
      SS_MB= c(SS_MB,ss)
      N_MB= c(N_MB, length(which(c_temp==cc-0.5 & chl_temp==chl-0.5)))
    }
  }
}
prop = Y_MB/N_MB
prop[which(N_MB==0)]=0
ret = list(Y_MB, C_MB, CONFHL_MB, SS_MB, N_MB, prop)
return(ret)
}