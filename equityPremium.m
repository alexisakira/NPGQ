clear
clc;

set(0,'DefaultTextFontSize', 14)
set(0,'DefaultAxesFontSize', 14)
set(0,'DefaultLineLineWidth',2)

colors = get(gca,'ColorOrder');

c1 = colors(1,:);
c2 = colors(2,:);

close all

%% get real per capita consumption expenditures

shillerC = xlsread('chapt26.xlsx','I27:I147'); % consumption
shillerY = xlsread('chapt26.xlsx','A27:A147'); % year
T1 = shillerY(end)-2000;
shillerC = shillerC/shillerC(end-T1); % normalize 2000 to 1

temp1 = xlsread('PCECCA.csv','B2:B91'); % aggregate consumption
temp2 = xlsread('Population.csv','B2:B91'); % population
fredC = temp1./temp2;
fredY = [1929:2018]';
T2 = fredY(end)-2000;
fredC = fredC/fredC(end-T2);

figure
plot(shillerY,shillerC,fredY,fredC)
xlabel('Year')

% combine data to create longer series
year = [shillerY(1:end-T1); fredY(end-T2+1:end)];
C = [shillerC(1:end-T1); fredC(end-T2+1:end)];

cgrowth = diff(log(C)); % log consumption growth

gamma = linspace(1,10,1001); % relative risk aversion
%gamma(1) = []; % avoid zero risk aversion
N = 5; % number of grid points to discretize

T = length(cgrowth); % sample size
mu = mean(cgrowth); % sample mean
sigma = sqrt(sum((cgrowth-mu).^2)/T); % sample standard deviation

% kernel density
[Coeff,Mu,Sigma] = normalKDE(cgrowth);

%% plot histogram
x = linspace(-0.15,0.15,1001)';
edges = linspace(-0.15,0.15,11);

fx1 = normpdf(x,mu,sigma); % Gaussian density
fx2 = gmPDF(x,Coeff,Mu,Sigma); % kernel density

figure(1)
histogram(cgrowth,edges,'Normalization','pdf'); hold on
plot(x,fx2,'-k');
plot(x,fx1,'--k');
xlabel('Log consumption growth')
ylabel('Probability density')
legend('Histogram','Nonparametric','Gaussian','Location','NW')
hold off

%% construct Gaussian mixture quadratures
[x1,p1] = GaussianMixtureQuadrature(1,mu,sigma,N);
[x2,p2] = NPGQ(cgrowth,N);

%% compute equity premium
% Gaussian
M1G = p1*exp(x1');
M2G = p1*exp((x1')*(-gamma));
M3G = p1*exp((x1')*(1-gamma));
epG = log(M1G) + log(M2G) - log(M3G);

% NP-GQ
M1NP = p2*exp(x2');
M2NP = p2*exp((x2')*(-gamma));
M3NP = p2*exp((x2')*(1-gamma));
epNP = log(M1NP) + log(M2NP) - log(M3NP);

figure(2)
plot(gamma,100*epNP,'-','Color',c1); hold on
plot(gamma,100*epG,'--','Color',c1);
xlabel('Relative risk aversion')
ylabel('Log equity premium (%)')
legend('Nonparametric','Gaussian','Location','NW')
xlim([min(gamma) max(gamma)])

figure(3)
plot(gamma,100*(epNP./epG-1));
xlabel('Relative risk aversion')
ylabel('Equity premium error (%)')
xlim([min(gamma) max(gamma)])