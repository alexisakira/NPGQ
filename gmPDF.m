function fval = gmPDF(x,Coeff,Mu,Sigma)
% Gaussian mixture density

N = length(Coeff);
fval = 0*x;
for n=1:N
    fval = fval + Coeff(n)*normpdf(x,Mu(n),Sigma(n));
end

end

