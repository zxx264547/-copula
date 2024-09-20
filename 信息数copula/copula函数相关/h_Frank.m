function y = h_Frank(u1,u2,p)

%% 计算Frank Copula的h函数即F(u1|u2)
% syms C(u,v) h(u,v)
% % 原Frank Copula表达式
% C(u,v)=(-1/p)*log(1+(exp(-p*u)-1)*(exp(-p*v)-1)/(exp(-p)-1));
% % 对v求导后的获得h函数表达式
% h(u,v)=diff(C(u,v),v);
% % 将表达式转为句柄函数
% h=matlabFunction(h,'Vars',[u v]);

%% 输出结果
% y=arrayfun(h,u1,u2);

%% 利用解析表达式1进行计算
% x1=exp(-p*u1)-1;
% x2=exp(-p*u2);
% C=exp(-p)-1;
% up=x1.*x2;
% low=C+x1.*(x2-1);
% y2=up./low;

%% 利用解析表达式2进行计算
a=exp(p*(1-u1-u2));
b=exp(p*(1-u2));
c=exp(p*(1-u1));
y=(a-b)./(1+a-b-c);