setwd("/home/daixiongming/Documents/Code/pmh-tutorial-2.1/r")

load("savedWorkspaces/example1-lgss_20.RData")


load("savedWorkspaces/example1-lgss_100.RData")



load("savedWorkspaces/example1-lgss_200.RData")


pdf(file="QQnormtotal.pdf")
par(mfrow=c(3,1))
N_20=20
N_100=100
N_200=200
plot(qnorm(((1:N_20)-.5)/N_20),sort(D20),xlab="Theoretical Quantiles", ylab="Sample Quantiles", main="20 Riesz Particles",col="#9933FF")
abline(0,1,col="#CC0066",lty=2)

plot(qnorm(((1:N_100)-.5)/N_100),sort(D100),xlab="Theoretical Quantiles", ylab="Sample Quantiles", main="100 Riesz Particles",col="#9933FF")
abline(0,1,col="#CC0066",lty=2)

plot(qnorm(((1:N_200)-.5)/N_200),sort(D200),xlab="Theoretical Quantiles", ylab="Sample Quantiles", main="200 Riesz Particles",col="#9933FF")
abline(0,1,col="#CC0066",lty=2)

plot(qnorm(((1:N_20)-.5)/N_20),sort(D20),xlab="Theoretical Quantiles", ylab="Sample Quantiles", main="20 Riesz Particles",col="#9933FF")
abline(0,1,col="#CC0066",lty=2)

plot(qnorm(((1:N_100)-.5)/N_100),sort(D100),xlab="Theoretical Quantiles", ylab="Sample Quantiles", main="100 Riesz Particles",col="#9933FF")
abline(0,1,col="#CC0066",lty=2)

plot(qnorm(((1:N_200)-.5)/N_200),sort(D200),xlab="Theoretical Quantiles", ylab="Sample Quantiles", main="200 Riesz Particles",col="#9933FF")
abline(0,1,col="#CC0066",lty=2)

dev.off()



