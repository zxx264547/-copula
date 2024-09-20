function y = h_Gumbel(u1,u2,p)

%% 计算Gumbel Copula的h函数即F(u1|u2)
% syms C(u,v) h(u,v)
% % 原Gumbel Copula表达式
% C(u,v)=exp(-((-log(u))^(1/p)+(-log(v))^(1/p))^p);
% % 对v求导后的获得h函数表达式
% h(u,v)=diff(C(u,v),v);
% % 将表达式转为句柄函数
% h=matlabFunction(h,'Vars',[u v]);

%% 输出结果
% y=arrayfun(h,u1,u2);

%% 
C1=exp(-((-log(u1)).^(p)+(-log(u2)).^(p)).^(1/p));
C2=(-log(u2)).^(p-1);
C3=((-log(u1)).^(p)+(-log(u2)).^(p)).^(1/p-1);
y=C1.*(1./u2).*C2.*C3;