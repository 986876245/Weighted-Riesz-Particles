##############################################################################
# Parameter estimation using particle Metropolis-Hastings in a SV
# with a proposal adapted from a pilot run.
# 

# Published under GNU General Public License
##############################################################################

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
savePlotToFile <- TRUE
nPlot <- 2500

Quandl.api_key("CyzgihyVzJC3pYHR16Jt")
#Quandl.api_key("RAznaYRym2wbozfQTddG")  #https://www.quandl.com/tools/r 

##############################################################################
# Load data
##############################################################################
d <-
  Quandl(
    "NASDAQOMX/OMXS30",
    start_date = "2015-02-04",
    end_date = "2016-02-04",
    type = "zoo"
  )
y <- as.numeric(100 * diff(log(d$"Index Value")))


##############################################################################
# PMH
##############################################################################

initialTheta <- c(0, 0.9, 0.2)
noParticles <- 500
noBurnInIterations <- 2500
noIterations <- 7500
stepSize <- matrix(
  c(
    0.137255431,-0.0016258103,
    0.0015047492,-0.0016258103,
    0.0004802053,-0.0009973058,
    0.0015047492,-0.0009973058,
    0.0031307062
  ),
  ncol = 3,
  nrow = 3
)
stepSize <- 2.562^2 / 3 * stepSize

if (loadSavedWorkspace) {
  load("savedWorkspaces/example4-sv.RData")
} else {
  res <- particleMetropolisHastingsSVmodel(y, initialTheta, noParticles, noIterations, stepSize)
}

##############################################################################
# Plot the results
##############################################################################
if (savePlotToFile) {
  cairo_pdf("figures/example4-sv.pdf",
            height = 10,
            width = 8)
}

iact <- makePlotsParticleMetropolisHastingsSVModel(y, res, noBurnInIterations, noIterations, nPlot)

# Close the plotting device
if (savePlotToFile) {
  dev.off()
}

##############################################################################
# Compute and save the results
##############################################################################

# Print the estimate of the posterior mean and standard deviation
resTh <- res$theta[noBurnInIterations:noIterations, ]
thhat   <- colMeans(resTh)
thhatSD <- apply(resTh, 2, sd)

print(thhat)
print(thhatSD)

#[1] -0.0997589  0.9723418  0.1492119
#[1] 0.27266581 0.01792217 0.04535608

# Compute an estimate of the IACT using the first 100 ACF coefficients
print(iact)
# [1] 31.94972 32.07775 28.36988

# Save the workspace to file
if (!loadSavedWorkspace) {
  save.image("savedWorkspaces/example4-sv.RData")
}

