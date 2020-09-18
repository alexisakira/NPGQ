Replication files for "Data-based Automatic Discretization of Nonparametric Distributions" by Alexis Akira Toda

Please visit https://alexisakira.github.io/discretization/ for more information on discretization.

1. Instructions
- If you want to discretize a nonparametric distribution, just use NPGQ.m
- To replicate results in Section 3.1, just run equityPremium.m
- To replicate results in Section 3.2, just run optimalPortfolio.m

2. File descriptions

[Main files]
- NPGQ.m: 		Implements nonparametric Gaussian mixture quadrature
- equityPremium.m: 	Generates outputs of Section 3.1
- optimalPortfolio.m:	Generates outputs of Section 3.2

[Data files]
- chapt26.xlsx: 		Robert Shiller's spreadsheet
- PCECCA.csv: 			US aggregate consumption
- Population.csv: 		US population
- PredictorData2016.xlsx: 	Amit Goyal's spreadsheet

[Subroutines]
- assetPricing.m:		Solves asset pricing model in Section 3.1
- GaussianMixtureQuadrature.m: 	Implements Gaussian quadrature for Gaussian mixture
- getTheta.m:			Compute optimal portfolio
- gmPDF.m:			Probability density function of Gaussian mixture
- normalKDE.m:			Compute kernel density estimator viewed as Gaussian mixture