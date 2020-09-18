function [Coeff,Mu,Sigma] = normalKDE(data,bandwidth)
% compute the normal kernel density estimator when viewed as a Gaussian
% mixture

N = length(data);
if size(data,1) > size(data,2)
    data = data'; % convert to row vector
end

if nargin < 2 % bandwidth not provided, use Silverman (1986)'s rule of thumb
    mu = mean(data); % mean
    sigma = norm(data-mu)/sqrt(N); % standard deviation
    bandwidth = (4/(3*N))^(1/5)*sigma;
end

Coeff = ones(1,N)/N;
Mu = data;
Sigma = ones(1,N)*bandwidth;

end

