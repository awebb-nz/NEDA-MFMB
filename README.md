# Noradrenergic and Dopaminergic modulation of meta-cognition and meta-control

This repository contains code and data for Noradrenergic and
Dopaminergic modulation of meta-cognition and meta-control accepted at
the Plos Computational Biology.

Authors: [Sara
Ershadmanesh](https://www.kyb.tuebingen.mpg.de/person/106573/271124),
[Sahar Rajabi](https://www.linkedin.com/in/sahar-rajabi/), [Reza
Rostami](https://profile.ut.ac.ir/en/~rrostami/grants), [Rani
Moran](https://www.qmul.ac.uk/sbbs/staff/rani-moran.html), [Peter
Dayan](https://www.mpg.de/12309370/biological-cybernetics-dayan)

## Abstract

Humans and animals use multiple control systems for decision-making.
This involvement is subject to meta-cognitive regulation -- as a form of
control over control or meta-control. However, the nature of this
meta-control is unclear. For instance, Model-based (MB) control may be
boosted when decision-makers generally lack confidence as it is more
statistically efficient; or it may be suppressed, since the MB
controller can correctly assess its own unreliability. Since control and
metacontrol are themselves subject to the influence of neuromodulators,
we examined the effects of perturbing the noradrenergic and dopaminergic
systems with propranolol and L-DOPA, respectively. We first administered
a simple perceptual task to examine the effects of the manipulations on
meta-cognitive ability. Using Bayesian analyses, we found that $81\%$ of
group M-ratio samples were lower under propranolol relative to Placebo,
suggesting a decrease of meta-cognitive ability; and $60\%$ of group
M-ratio samples were higher under L-DOPA relative to Placebo, considered
as no effect of L-DOPA on meta-cognitive ability . We then asked
subjects to provide choices and confidence ratings in a two-outcome
decision-making task that has been used to dissociate Model-free (MF)
and MB control. MB behavior was enhanced by propranolol, while MF
behavior was not significantly affected by either drug. The interaction
between confidence and MB behavior was highly variable under
propranolol, but under L-DOPA, the interaction was significantly higher
relative to Placebo. Our results suggest a decrease in metacognitive
ability under the influence of propranolol and an enhancement of MB
behavior and meta-control under the influence of propranolol and L-DOPA,
respectively. These findings shed light on the role of NE and DA in
different aspects of control and meta-control and suggest potential
avenues for mitigating dysfunction.

## Installation

1- clone repository for https: git clone
<https://github.com/Ershadmanesh/NEDA-MFMB/tree/main> 2- In RStudio,
load "NEDA-MFMB.Rproj"

## Usage

-   To view the Two-outcome task data in a data frame format, run the ReadData.Rmd script. This script also generates the drug data frame, with column descriptions provided within the file. Additionally, it establishes the association between drug conditions and the days of the experiment for all subjects. The output is saved in the data directory and is utilized in subsequent analyses.

- All the required packages would be installed on your system by running the required "Rmd" files, the code "source("libs/Librarries.R")" plays this role.

-   To produce plots:

    1- Fig 2. A & B & C. At the file
    "Hmeta_drugs.Rmd". These codes call the functions from "HMeta/R"

    2- Fig 3. A & F & C & G. At the file
    "MBMF_contribution.Rmd", there are codes for visualization and
    statistics on the regression results. The regression analysis was
    done with Matlab codes, written by "Rani Moran", in the
    "Matlab-codes/MBMF_contributions_regression.m".

    3- Fig 3. D & H. At the file "Conf_MFMB.Rmd",
    there are codes for visualization and statistics on the regression
    results. The regression analysis was done with Matlab codes, written
    by "Rani Moran", in the "Matlab-codes/Conf_MFMB_regression.m".


- The "Fitting.Rmd"" script fits the data to the hybrid model and compares the parameters across three drug conditions using visualizations and statistical tests. The fitting procedure is based on the "fit/linkfitreal.R" and "simu/simufit.R"" scripts.



## Citation

If you found this code or paper helpful, please cite us as:

Ershadmanesh, S., Rajabi, S., Rostami, R., Moran, R., & Dayan, P.
(2024). Noradrenergic and Dopaminergic modulation of meta-cognition and
meta-control. Plos Computational Biology.

## Contact

For any questions or comments, please contact us at
[sara.ershadmanesh\@tuebingen.mpg.de](mailto:sara.ershadmanesh@tuebingen.mpg.de){.email}
=======
Code Guidence:

Fig 2.  A& B& C
In “Comparison” file,  at the file “Hmeta_drugs.Rmd”. These codes call the functions from “HMeta-d-master-Fleming,S/R”

Fig 3. A&F & C&G
In “Comparison” file,  at the file “MBMF_contribution.Rmd”, there are codes for visualization and statistics on the regression results. The regression analysis was done with Matlab codes, written by “Rani Moran”, in the “Matlab-codes/MBMF_contributions_regression.m”.
Fig 3. D&H
In “Comparison” file,  at the file “Conf_MFMB.Rmd”, there are codes for visualization and statistics on the regression results. The regression analysis was done with Matlab codes, written by “Rani Moran”, in the “Matlab-codes/Conf_MFMB_regression.m”.


In the “Comparison” file, the “ReadData.Rmd” would read the data from Two-outcome task across three days, also would save the order of drugs across participants.


In the “Comparison” file, the” Fitting.Rmd” would fit the data to the hybrid model and compares the parameters across three drug conditions by visualization and statistical tests. The Fitting procedure is based on “fit/linkfitreal.R" and “simu/simufit.R" files.










>>>>>>> 2c9d7dcdcfb0166b195b034fb86a63a95cf5e7e5
