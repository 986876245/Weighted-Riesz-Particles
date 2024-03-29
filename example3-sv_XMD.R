##############################################################################
# Parameter estimation using particle Metropolis-Hastings in a SV model
# 

# Published under GNU General Public License
##############################################################################
setwd("/home/daixiongming/Documents/Code/pmh-tutorial-2.1/r")


#### This code takes so much time several days and failed to run nearly 



#setwd("~/Documents/Code/pmh-tutorial-2.1/r")
library("Quandl")
library("mvtnorm")
source("helpers/stateEstimation.R")
source("helpers/parameterEstimation.R")
source("helpers/plotting.R")

# Set the random seed to replicate results in tutorial
set.seed(10)

# Should the results be loaded from file (to quickly generate plots)
loadSavedWorkspace <- FALSE

loadSavedWorkspace <- FALSE


# Save plot to file
#savePlotToFile <- FALSE
savePlotToFile <- TRUE

nPlot <- 2500
#nPlot <- 1200

#Quandl.api_key("RAznaYRym2wbozfQTddG")
#Quandl.api_key("CyzgihyVzJC3pYHR16Jt")  #https://www.quandl.com/tools/r 
Quandl.api_key("kHAzgtSa1bSyAC-norNn")  #https://www.quandl.com/tools/r 

##############################################################################
# Load data
##############################################################################
d <-
  Quandl(
    "NASDAQOMX/OMXS30",
    start_date = "2012-02-04", #2012-2014
    end_date = "2014-02-04",
    type = "zoo"
  )

#d<-Quandl("NASDAQOMX/OMXS30", api_key="RAznaYRym2wbozfQTddG")
y <- as.numeric(100 * diff(log(d$"Index Value")))

##############################################################################
# PMH
##############################################################################
initialTheta <- c(0, 0.9, 0.2)
#initialTheta <- c(0, 0.8, 0.1)

noParticles <- 500
noBurnInIterations <- 2500
#noBurnInIterations <- 1000

#noIterations <- 7500  #original
noIterations <- 7500
#noIterations <- 3200

#stepSize <- diag(c(0.10, 0.01, 0.05) ^ 2)
####################################################################################################################
####################################################################################################################
####################################################################################################################
####################################################################################################################


#p=10
p=3
#rho=.9
rho=.3
Sigma=diag(p)
Sigma=rho^abs(row(Sigma)-col(Sigma))
#Change the stepSize for different parameters
#stepSize <-Sigma/100
Sigma=Sigma/100
#Sigma=diag(c(0.10, 0.01, 0.05) ^ 2)
#Sigma=diag(c(0.10, 0.01, 0.05) )

#setwd("~/Documents/Code/Minimal_Energy_Way/1323273/MED Rcodes")

library(randtoolbox)
library(GenSA)
library(MASS)

f=function(x)
{
  x=-4+8*x
  exp(-.5*t(x)%*%Sigmainv%*%x)
}

lf_original=function(x)
{
  x=-4+8*x
  -.5*t(x)%*%Sigmainv%*%x
}


mu_center<-c(0,0.9,0.1)


lf=function(x)
{
  # x=-4+8*x
  x=x-mu_center
  -.5*t(x)%*%Sigmainv%*%x
}



eucl2=function(u)
  sum(u^2)
energy1=function(x)
{
  d2=apply(D-one%*%t(x),1,eucl2)+10^(-10)
  val=-2*lf(x)+log(sum(exp(-2*lfev-2*p*log(d2))))
  return(val)
}



U=2
W=1.6

ac=2 # 1 is also good!
k=80
m=40
W=1
energy=function(x)
{
  d=apply(D-one%*%t(x),1,eucl2)+10^(-10)
  # d_kernel=kernel_CF(d)
  #d=1/d
  d_kernel=d
  #val=-2*log(f(x))+log(sum(1/(fev^2*d^k)))
  val=-(k/(2*p))*lf(x)+log(sum(exp(-(k/(2*p))*lfev-k*log(d_kernel))))
  A=k*log(d_kernel)
  B=ac*d_kernel
  C=(-1)*lfev*lf(x)*W
  C=exp(C)
  D=C+B
  D=log(D)
  val_w=log(sum(exp(-(m)*D-A)))  #This negative is very important to be loaded in!
  return(val_w)
}











system.time({
  #p=10
  p=3
 #rho=.9
  rho=.3
 # rho=.8
  Sigma=diag(p)
  Sigma=rho^abs(row(Sigma)-col(Sigma))/100
  #Sigma=diag(c(0.10, 0.01, 0.05)^2 )
  Sigmainv=solve(Sigma)
  
  
  initialTheta <- c(0, 0.9, 0.1)
  
  
  nlf=function(x)
    -lf(x)
  #change -lf(x) to lf(x), because GenSA try to find the minimal value! no! 
  #it should be the maximum! the paper in 2017 is wrong!
  #st=GenSA(par=rep(0,p), lower=rep(-4,p),upper=rep(4,p), fn=nlf, control=list(maxit=(1+10*p)))$par
  lower_1 <- c(-4, 0, 0)
  upper_1<-c(4,4,4)
  #st=GenSA(par=initialTheta,lower=rep(-4,p),upper=rep(4,p), fn=nlf, control=list(maxit=(1+10*p)))$par
  st=GenSA(par=initialTheta,lower=lower_1,upper=rep(4,p), fn=nlf, control=list(maxit=(1+10*p)))$par
  
  
  D=matrix(st,ncol=p)
  n=dim(D)[1]
  
  one=rep(1,n)
  lfev=apply(D,1,lf)
  #k=4*p   ##############################################
  #k=20
  k=80
  
 # N=10*p*20*4
  N=10*p*20
  ini=sobol(N,p)
  #lo=rep(.5/N,p)
  lo=rep(0.00001,p)
  
  #up=rep(1-1/N,p)
  up=rep(1-0.000001,p)
  
  
  
  ############################################################################################################
  ############################################################################################################
  ############################################################################################################
  ############################################################################################################
  ############################################################################################################
  U=2
  W=1.6
  
  ac=2 # 1 is also good!
  #k=20
  k=80
  m=40
  #m=10
  W=1

  
  
  
  
  
  
  
  
  for(j in 2:N)
  {#https://cran.r-project.org/web/packages/GenSA/GenSA.pdf 
    #the order can change, although the position of fn is at the second!
    #new=GenSA(par=ini[j,],lower=lo, upper=up, fn=energy, control=list(maxit=j+10*p))$par
    new=GenSA(par=ini[j,],lower=lower_1, upper=upper_1, fn=energy, control=list(maxit=j+10*p))$par
    
    #new=optim(ini[j,],energy,lower=lo, upper=up, method="L-BFGS-B", control=list(maxit=(j+10*p)))$par
    D=rbind(D,new)
    n=dim(D)[1]
    one=rep(1,n)
    lfev=apply(D,1,lf)
  }
})
min(dist(D))



pairs(D,col="#9933FF",labels = c("var1_D", "var2_X", "var_M"),  # Change labels of diagonal
      main = "This is a nice pairs plot in R")


# random normal values with mean [5, 10] and variances [3,6], and covariance 2






Sigmainv2=solve(matrix(c(1,rho,rho,1),2,2))
lf2=function(x)
{
  x=-4+8*x
  -.5*t(x)%*%Sigmainv2%*%x
}
# 
# N.plot=250
# p1=seq(0,1,length=N.plot)
# p2=seq(0,1,length=N.plot)
# fc=matrix(0,N.plot,N.plot)
# for(i in 1:N.plot)
# {
#   for(j in 1:N.plot)
#     fc[i,j]=exp(lf2(c(p1[i],p2[j])))
# }


#image(p1,p2,fc,col=cm.colors(5), xlab=expression(x[9]), ylab=expression(x[10]))
#pdf(file="multinorm_XMD.pdf")
#contour(p1,p2,fc,nlevels=10, lty=3,lwd=.5, xlab=expression(x[9]), ylab=expression(x[10]),drawlabels = FALSE)
#points(D[,9],D[,10],cex=.75)
#points(D[,2],D[,3],cex=.75,col="#9933FF") #the same color with the first experiment1.lgss.r
#abline(a=0,b=1,lty=2)
#points(ini[,9],ini[,10],pch=3,col=2,cex=.75)
#points(ini[,2],ini[,3],pch=3,col=2,cex=.75)

#M=mvrnorm(N,rep(0,p),Sigma)
#M=mvrnorm(N,mu_center/8,Sigma)
#M=(M+mu_center)/8
#M=(M+4)/8
#points(M[,9],M[,10],pch=4,col=3,cex=.75)
#points(M[,2],M[,3],pch=4,col=3,cex=.75)

#dev.off()
####################################################################################################################
#########################################################################################################################################################################################################################
####################################################################################################################
####################################################################################################################


stepSize<-Sigmainv/100


if (loadSavedWorkspace) {
  load("savedWorkspaces/example3-sv_XMD.RData")
} else {
  res <- particleMetropolisHastingsSVmodel(y, initialTheta, noParticles, noIterations, stepSize,D)
}
savePlotToFile <- TRUE # why I need to put it here so that it can save?
##############################################################################
# Plot the results
##############################################################################
if (savePlotToFile) {
  cairo_pdf("figures/example3-sv_XMD.pdf",
            height = 10,
            width = 8)
}

iact <- makePlotsParticleMetropolisHastingsSVModel(y, res, noBurnInIterations, noIterations, nPlot)

# Close the plotting device
if (savePlotToFile) {
  dev.off()
}

# Print the estimate of the posterior mean and standard deviation
resTh <- res$theta[noBurnInIterations:noIterations, ]
thhat   <- colMeans(resTh)
thhatSD <- apply(resTh, 2, sd)

print(thhat)
print(thhatSD)

#[1] -0.2337134  0.9708399  0.1498914
#[1] 0.37048000 0.02191359 0.05595271

# Compute an estimate of the IACT using the first 100 ACF coefficients
print(iact)
# [1] 135.19084  85.98935  65.80120

# Estimate the covariance of the posterior to tune the proposal
estCov <- var(resTh)
#               [,1]          [,2]          [,3]
# [1,]  0.137255431 -0.0016258103  0.0015047492
# [2,] -0.001625810  0.0004802053 -0.0009973058
# [3,]  0.001504749 -0.0009973058  0.0031307062

# Save the workspace to file
if (!loadSavedWorkspace) {
  save.image("savedWorkspaces/example3-sv_XMD.RData")
}

################ test program ##########################

sigma <- matrix(c(3,2,2,6), 2, 2)
mu <- c(5,10)
x <- rmvnorm(1000, mean = mu, sigma = sigma)
head(x)
summary(x)
plot(x[,1], x[,2])


sigma <- matrix(c(3,2,1,2,6,2,1,2,1), 3, 3)
mu <- c(5,10,1)
x <- rmvnorm(1000, mean = mu, sigma = sigma)
head(x)
summary(x)
plot(x[,1], x[,2])
pairs(x)

###########This function should be simulated#########################
stepSize <- diag(c(0.10, 0.01, 0.05) ^ 2)
mu2=c(0,0.9,0.1)
x <- rmvnorm(1000, mean = mu2, sigma = stepSize) # square already have!
head(x)
summary(x)
plot(x[,1], x[,2])
pairs(x)


########### True Test ########################
#Sigma
#p=10
p=3
#rho=.9
rho=.3
Sigma=diag(p)
Sigma=rho^abs(row(Sigma)-col(Sigma))
#Change the stepSize for different parameters
#stepSize <-Sigma/100
Sigma=Sigma/100

library("mvtnorm")

x <- rmvnorm(1000, mean = mu2, sigma = Sigma)
head(x)
summary(x)
plot(x[,1], x[,2])
pairs(x)

