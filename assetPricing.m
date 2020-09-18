function [PD,Rs,ERs,Rf,pi,SDF] = assetPricing(beta,gamma,psi,P,Q,logcg)
% solve asset pricing model
%% inputs
% beta: discount factor
% gamma: relative risk aversion
% psi: elasticity of intertemporal substitution
% P: transition probability matrix (S x S)
% Q: matrix of conditional log consumption growth distribution (S^2 x J)
% logcg: matrix of log consumption growth (S^2 x J)
%% outputs
% PD: price-dividend ratio (S x 1)
% Rs: matrix of stock returns (S^2 x J)
% Rf: conditional gross risk-free rate (S x 1)
% pi: stationary distribution (S x 1)
% SDF: stochastic discount factor (S x S)

if gamma == 1
    error('gamma must be different from 1')
end
if psi == 1
    error('psi must be different from 1')
end

S = size(P,1); % number of states
MGF1 = reshape(sum(Q.*exp((1-gamma)*logcg),2),S,S)'; % matrix of MGF
K = P.*MGF1;
theta = (1-gamma)/(1-1/psi);

g = getFixedPoint(beta,theta,K);
temp = (K*g).^(1/theta-1)*(g').^(1-1/theta); % matrix used to define SDF
L = K.*temp;
r = eigs(L,1); % spectral radius of L
if beta*r >= 1
    error('nonexistence of asset prices')
end

PD = (eye(S)-beta*L)\(beta*L*ones(S,1)); % price-dividend ratio
[v,~] = eigs(P',1);
pi = v/sum(v); % stationary distribution

MGF2 = reshape(sum(Q.*exp((-gamma)*logcg),2),S,S)'; % matrix of MGF
SDF = beta*MGF2.*temp; % stochastic discount factor
Rf = 1./(sum(P.*SDF,2)); % gross risk-free rate

Rs = bsxfun(@times,kron(1./PD,PD+1),exp(logcg));
ERss = reshape(sum(Q.*Rs,2),S,S)';
ERs = sum(P.*ERss,2); % expected gross stock returns

end

