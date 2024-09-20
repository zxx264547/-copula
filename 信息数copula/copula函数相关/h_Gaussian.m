function y = h_Gaussian(u1,u2,r)

%% 计算Gaussian Copula的h函数即F(u1|u2)
x1=norminv(u1);
x2=norminv(u2);
x=(x1-r*x2)/(sqrt(1-r^2));

%% 输出结果
y=normcdf(x);
