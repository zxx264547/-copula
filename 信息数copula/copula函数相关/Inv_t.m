function u1 = Inv_t(y,u2,r,nu)
% y=F(u1|u2),u1=F(x1),u2=F(x2)
%% 原h函数
% x1=tinv(u1,nu);
% x2=tinv(u2,nu);
% A=sqrt((nu+x2^2)*(1-r^2)/(nu+1));
% x=(x1-x2)/A;
%% 求逆过程
x2=tinv(u2,nu);
x=tinv(y,nu+1);
A=sqrt((nu+x2.^2)*(1-r^2)/(nu+1));
x1=x.*A+r*x2;
u1=tcdf(x1,nu);

