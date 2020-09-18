function Theta = getTheta(gamma,R,Rf,p)
% solve optimal portfolio problem with CRRA agent
% gamma: vector of relative risk aversion coefficients
% R: vector of gross stock returns
% Rf: gross risk-free rate
% p: vector of probabilities

N = length(gamma);
Theta = 0*gamma;

if Rf <= min(R) % risk-free asset dominated by risky one
    Theta = Inf*ones(size(gamma));
    return
end

options = optimset('TolX',1e-10,'TolFun',1e-10);

for n=1:N
    gamn = gamma(n);
    func = @(theta)(dot(p,((theta*R+(1-theta)*Rf).^(-gamn)).*(R-Rf)));
    thetaMax = Rf/(Rf-min(R))-1e-6;
    theta = fzero(func,[0 thetaMax],options);
    Theta(n) = theta;
end

end

