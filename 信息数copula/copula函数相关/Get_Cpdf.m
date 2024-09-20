function c12 = Get_Cpdf(copula,u1,u2)
% copula=[type,mle,BIC,AIC,P1,P2]
type=copula(1);
p1=copula(5);
p2=copula(6);
if strcmp(type,'Clayton')
    c12 = c_Clayton(u1,u2,double(p1));
elseif strcmp(type,'Frank')
    c12 = c_Frank(u1,u2,double(p1));
elseif strcmp(type,'Gaussian')
    c12 = c_Gaussian(u1,u2,double(p1));
elseif strcmp(type,'Gumbel')
    c12 = c_Gumbel(u1,u2,double(p1));
elseif strcmp(type,'t')
    c12 = c_t(u1,u2,double(p1),double(p2));
end
end

