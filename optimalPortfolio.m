clear
clc;

set(0,'DefaultTextFontSize', 14)
set(0,'DefaultAxesFontSize', 14)
set(0,'DefaultLineLineWidth',2)

colors = get(gca,'ColorOrder');

c1 = colors(1,:);
c2 = colors(2,:);

close all

gamma = linspace(1,7,101); % relative risk aversion
N = 5; % number of grid points to discretize

%% import data of stock returns and risk-free rate
freq = 3; % data frequency; 1 = monthly, 2 = quarterly, 3 = annual
if freq == 1
    Rfree = xlsread('PredictorData2016.xlsx','Monthly','K674:K1753');
    infl = xlsread('PredictorData2016.xlsx','Monthly','L674:L1753');
    CRSP = xlsread('PredictorData2016.xlsx','Monthly','Q674:Q1753');
elseif freq == 2
    Rfree = xlsread('PredictorData2016.xlsx','Quarterly','L226:L585');
    infl = xlsread('PredictorData2016.xlsx','Quarterly','M226:M585');
    CRSP = xlsread('PredictorData2016.xlsx','Quarterly','S226:S585');
elseif freq == 3
    Rfree = xlsread('PredictorData2016.xlsx','Annual','L58:L147');
    infl = xlsread('PredictorData2016.xlsx','Annual','M58:M147');
    CRSP = xlsread('PredictorData2016.xlsx','Annual','T58:T147');
end

RfData = (1+Rfree)./(1+infl);
RData = (1+CRSP)./(1+infl);

Rf = exp(mean(log(RfData)));
logRex = log(RData) - log(RfData);
T = length(logRex); % sample size

%% estimate densities
% Gaussian
mu = mean(logRex);
sigma = norm(logRex-mu)/sqrt(T);

% kernel density
[Coeff,Mu,Sigma] = normalKDE(logRex);

%% plot histogram
if freq == 1
    x = linspace(-0.3,0.2,1001)';
    edges = linspace(-0.3,0.2,20);
elseif freq == 2
    x = linspace(-0.6,0.6,1001)';
    edges = linspace(-0.6,0.6,20);
elseif freq == 3
    x = linspace(-0.8,0.6,1001)';
    edges = linspace(-0.8,0.6,10);
end

fx1 = normpdf(x,mu,sigma); % Gaussian density
fx2 = gmPDF(x,Coeff,Mu,Sigma); % kernel density

figure(1)
histogram(logRex,edges,'Normalization','pdf'); hold on
plot(x,fx2,'-k');
plot(x,fx1,'--k');
xlabel('Log excess returns')
ylabel('Probability density')
legend('Histogram','Nonparametric','Gaussian','Location','NW')
hold off

%% construct Gaussian mixture quadratures
[x1,p1] = GaussianMixtureQuadrature(1,mu,sigma,N);
[x2,p2] = NPGQ(logRex,N);

%% solve optimal portfolio problem
R1 = Rf*exp(x1);
R2 = Rf*exp(x2);

Theta1 = getTheta(gamma,R1,Rf,p1);
Theta2 = getTheta(gamma,R2,Rf,p2);

portError = 100*(Theta1./Theta2-1);

figure(2)
plot(gamma,Theta2,'-','Color',c1); hold on
plot(gamma,Theta1,'--','Color',c1); hold off
xlabel('Relative risk aversion')
ylabel('Optimal portfolio')
legend('Nonparametric','Gaussian')

figure(3)
plot(gamma,portError)
xlabel('Relative risk aversion')
ylabel('Portfolio error (%)')
ylim([0 ceil(max(portError))])
