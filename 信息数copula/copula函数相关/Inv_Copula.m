function u1 = Inv_Copula(copula,u1_2,u2)
% copula=[type,mle,BIC,AIC,P1,P2]
type=copula(1);
p1=copula(5);
p2=copula(6);
if strcmp(type,'Clayton')
    u1 = Inv_Clayton(u1_2,u2,double(p1));
elseif strcmp(type,'Frank')
    u1 = Inv_Frank(u1_2,u2,double(p1));
elseif strcmp(type,'Gaussian')
    u1 = Inv_Gaussian(u1_2,u2,double(p1));
elseif strcmp(type,'Gumbel')
    u1 = Inv_Gumbel(u1_2,u2,double(p1));
elseif strcmp(type,'t')
    u1 = Inv_t(u1_2,u2,double(p1),double(p2));
end
end

