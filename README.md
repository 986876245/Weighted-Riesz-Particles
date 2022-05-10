# Weighted-Riesz-Particles
# Variance Reduction of Resampling for SMC

This MATLAB code implements the Variance Reduction of Resampling for Sequential Monte Carlo, which is built in two different dynamical models: a linear Gaussian state-space (LGSS) model and a stochastic volatility (SV) model. The details of our proposal is described in the paper available at https://openreview.net/pdf?id=3XinbUbSzPq

Note that the MATLAB code in this folder covers the basic implementations in the paper. The notation of the variables has been changed sligthly compared with the tutorial paper to improve readability of the code. However, it should be easy to translate between the two. 

Requirements
--------------
The code is written and tested for MATLAB 2021a and makes use of the statistics toolbox and the Quandl package. See https://github.com/quandl/Matlab for more installation and to download the toolbox. Note that urlread2 is required by the Quandl toolbox and should be installed as detailed in the README file of the Quandl toolbox.

Main script files
--------------
These are the main script files that implement the various algorithms discussed in the tutorial.<br>

**example1_lgss.m** State estimation in a LGSS model with different resampling mechanisms. The code is discussed in Section 4.1 and the results are presented in this Section.<br>

**example2_sv.m** Parameter estimation of three parameters in the SV model using PMH with the bootstrap PF as the likelihood estimator with different resmapling method. The code is discussed in Section 4.2 and the results are presented in this section.

Supporting files
--------------
**generateData.m** Implements data generation for the LGSS model.<br>
**kalmanFilter.m** Implements the Kalman filter for the LGSS model.<br>
**particleFilter.m** Implements the faPF for the LGSS model.<br>
**particleFilterSVmodel.m** Implements the bPF for the SV model.<br>
**particleMetropolisHastings.m** Implements the PMH algorithm for the LGSS model.<br>
**particleMetropolisHastingsSVmodel.m** Implements the PMH algorithm for the SV model.<br>
**resampling\*.m**Implements the different resampling method to compare with our proposal.

Adapting the code for another model
--------------
Direct revise the resample schema and then load into the main test script files.

Reference
--------------
"Variance Reduction for Sequential Monte Carlo",https://openreview.net/pdf?id=3XinbUbSzPq



Copyright information
--------------
MIT license 
```
