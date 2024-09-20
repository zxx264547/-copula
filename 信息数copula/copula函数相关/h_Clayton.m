function y = h_Clayton(u1,u2,p)

%% 计算Clayton Copula的h函数即F(u1|u2)
% syms C(u,v) h(u,v)
% % 原Clayton Copula表达式
% C(u,v)=(u^(-p)+v^(-p)-1)^(-1/p);
% % 对v求导后的获得h函数表达式
% h(u,v)=diff(C(u,v),v);
% % 将表达式转为句柄函数
% h=matlabFunction(h,'Vars',[u v]);

%% 带入h函数计算结果
% y=double(h(x1,x2,pp));
% y=arrayfun(h,u1,u2);

%%
a=(u1.^(-p)+u2.^(-p)-1).^(-1-1/p);
y=(u2.^(-p-1)).*a;

