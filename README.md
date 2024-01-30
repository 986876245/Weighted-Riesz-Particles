# R code for Weighted Riesz Particles

This R code implements the Weighted Riesz Particles and particle Metropolis-Hastings (PMH) algorithm for two different dynamical models: a linear Gaussian state-space (LGSS) model with synthetic data and a non-linear stochastic volatility (SV) model with real-world data. 

Requirements 
--------------
The code is written and tested for R 4.2.0 and makes use of the packages Quandl and mvtnorm. These can be installed in R by executing the command:
``` R
install.packages(c("mvtnorm", "Quandl"))
```

Main script files
--------------
These are the main script files that implement the various algorithms discussed in the tutorial.

**example1-lgss_XMD.R** State estimation in a LGSS model using the KF with weighted Riesz particles, the log-bias and the log-MSE of the filtered states under 100 Riesz particles for varying N. The results are presented in Section 4 Table 1.

**qqnorm_total.R** Theoretical Quantiles for 20, 100 and 200 Riesz particles. The results are presented in Section 4 Figure 1.

**example2-lgss-varyingT_XMD.R** The estimated posterior mean and variance when varying T. The results are presented in Section 4 Table 2.

**example2-lgss_XMD.R** Posterior estimate, burning process and ACF for different step size:$h_1=0.05, h_2=0.1, h_3=0.5$.  The results are presented in Section 4 Figure 2. Parameter estimation of three parameters in the SV model using PMH with weighted Riesz particles embedding and the bootstrap PF as the likelihood estimator.

**example3-sv_XMD_phd_recover_new.R** Top: The daily log-returns and estimated log-volatility with $95\%$ confidence intervals of the NASDAQ OMXS30 index for the period between February 4, 2015 and February 4, 2016. Bottom: the posterior estimate(left), the trace of the Markov chain(middle) and the corresponding ACF(right) of $\mu$(purple), $\phi$(magenta) and $\sigma_v$(green) obtained from Riesz particles embedded PMH. The dotted and solid gray lines in the left and middle plots indicate the parameter posterior mean and the parameter priors, respectively.

 
Additional script files for creating plots for tutorial (extra-code-for-tutorial/)
--------------
These are some additional files to recreate some extra results discussed in the tutorial.

**example1-lgss-plotData.R** Some sample code for generate data and recreate the plot of the data presented as Figure 3.

**example2-lgss-varyingT.R** An extended version of *example2-lgss.R* and makes several runs while changing the number of observations. The results are presented in Section 3.2 as Table 1.

**example4-sv-plotProposals.R** Some (ugly) code to plot the estimates of the posterior distribution and the proposal distribution using the output from a run of *example3-sv.R*. This code generates Figure 7 in Section 6.3.2.


Supporting files (helpers/)
--------------
**dataGeneration.R** Generates data from a LGSS model.

**parameterEstimation.R** Implements the PMH algorithm for the LGSS model (particleMetropolisHastings), the SV model (particleMetropolisHastingsSVModel) and the reparameterised SV model (particleMetropolisHastingsSVModelReparameterised).

**stateEstimation.R** Implements the faPF for the LGSS model (particleFilter), the Kalman filter for the LGSS model (kalmanFilter) and the bPF for the SV model (paticleFilterSVmodel).

**plotting.R** Generate the figures presented in the paper using the output of the PMH algorithm for the SV model.

Saved results (savedWorkspaces/ and figures/)
--------------
These directories are placeholders for the output from running the code. The workspaces and plots used in the tutorial are found as a zip-file in the [latest release of the code](https://github.com/compops/pmh-tutorial/releases/latest) as binaries are not usually version controlled by Git and the workspaces are quite large (ca 80 mb).

**savedWorkspaces/** Saved copies of the workspace after running the corresponding code. These outputs are used to generate all the results in the aper. Can be used to directly recreate the plots in the tutorial by setting the flags loadSavedWorkspace and savePlotToFile to TRUE.

**figures/** Saved plots from running the files.

Adapting the code for another model
--------------
The code provided in *helpers/stateInference.R* and *helpers/parameterInferernce.R* is quite general. To adapt this code for your own model, you can start with the code in *example3-sv.R* together with the functions *particleFilterSVmodel* and *particleMetropolisHastings* from the helpers.

### Particle filter
In the particle filter, you need to change the lines connected to: (i) the sampling of the initial state, (ii) the propagation of particles and (iii) the computation of the weights. For (i), you need to rewrite:
``` R
  particles[, 1] <- rnorm(noParticles, mu, sigmav / sqrt(1 - phi^2))
```
to fit your model. Two simple choices are to make use of the stationary distribution of the state (as is done for the SV model) computed by hand or to initialize all particles to some value (as is done in the LGSS model) by:
``` R
  particles[, 1] <- initialState
```
where *initialState* is provided by the user. The particle filter usually quite rapidly converges to the state in this case if the state process quickly forgets its past (mixes well).

For (ii), you need to change:
``` R
    part1 <- mu + phi * (particles[newAncestors, t - 1] - mu)
    part2 <- rnorm(noParticles, 0, sigmav)
    particles[, t] <- part1 + part2
```
to something else. For the bPF, this corresponds to the state process of your state-space model.

For (iii), you need to change:
``` R
    weights[, t] <- dnorm(y[t - 1], 0, exp(particles[, t] / 2), log = TRUE)
```
to something else. For the bPF, this corresponds to the observation process of your state-space model.

Finally, note that the particle filter implementation can only be used for state-space models where the state and observation are scalar. However, it is quite straightforward to make use of particle filtering when the state and/or observations are multivariate. It is basically only bookkeeping. If the dimension of the state is larger than say 5, good proposals are usually required to not run into the curse of dimensionality. This is a hot current research topic in the particle filtering literature.

### Particle Metropolis-Hastings
The implementation of the PMH algorithm is general and does not require any larger changes if the model is changed. The dimensionality of the variables *xHatFiltered*, *xHatFilteredProposed*, *theta* and *thetaProposed* needs to be altered to match the dimensionality of the state and the number of parameters in the new state-space model. Moreover, the initial value of theta and the proposal distribution need to be calibrated for your new model. The simplest way to do this is by so-called pilot runs. Set the initial value to something reasonable and stepSize to a diagonal matrix with quite small elements, so that you get at least some accepted proposed values. After the pilot run, adapt the proposal as is discussed in 6.3.2 and initialise the PMH algorithm in the estimated posterior mean. Repeat this one or two more times or until you are satisfied.

It is known that this simple version of PMH performs bad when the number of parameters is larger than about 5. To circumvent this problem, see the suggestions in Sections 4.3 and 6. It is also discussed there how to choose the number of particles *noParticles* and the number of iterations *noIterations* to use in the PMH algorithm. *noBurnInIterations* can be selected by looking at the trace plot for when the Markov chain has reached its steady-state/stationarity. I usually use *noIterations* as 10,000 or 30,000 (with *noBurnInIterations* as 3,000 or 10,0000) to get good posterior estimates but these runs take time. Also, using *noParticles* as somewhere between *T* and 2*T* is a good place to start.

Copyright information
--------------
``` R
##############################################################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
##############################################################################
```
