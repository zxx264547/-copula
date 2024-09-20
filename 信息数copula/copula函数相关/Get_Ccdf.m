function u1_2 = Get_Ccdf(copula,u1,u2)
% copula=[type,mle,BIC,AIC,P1,P2]
type=copula(1);
p1=copula(5);
p2=copula(6);
if strcmp(type,'Clayton')
    u1_2 = h_Clayton(u1,u2,double(p1));
elseif strcmp(type,'Frank')
    u1_2 = h_Frank(u1,u2,double(p1));
elseif strcmp(type,'Gaussian')
    u1_2 = h_Gaussian(u1,u2,double(p1));
elseif strcmp(type,'Gumbel')
    u1_2 = h_Gumbel(u1,u2,double(p1));
elseif strcmp(type,'t')
    u1_2 = h_t(u1,u2,double(p1),double(p2));
end
u1_2(u1_2==1) = 0.999;
u1_2(u1_2==0) = 0.001;
end

