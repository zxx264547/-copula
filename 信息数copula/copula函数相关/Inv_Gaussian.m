function u1 = Inv_Gaussian(y,u2,r)
% y=F(u1|u2),u1=F(x1),u2=F(x2)
%% 原h函数
% x1=norminv(u1);
% x2=norminv(u2);
% x=(x1-x2)/(sqrt(1-r^2));
%% 求逆过程
x2=norminv(u2);
x=norminv(y);
x1=x*(sqrt(1-r^2))+r*x2;
u1=normcdf(x1);

