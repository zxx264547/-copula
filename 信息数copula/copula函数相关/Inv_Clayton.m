function u1 = Inv_Clayton(y,u2,p)
% y=F(u1|u2),u1=F(x1),u2=F(x2)

%% 计算Clayton Copula的h函数即F(u1|u2)
% L=length(y);
% u1=zeros(L,1);
% syms u v
% % 原Clayton Copula表达式
% C=(u^(-p)+v^(-p)-1)^(-1/p);
% % 对v求导后的获得h函数表达式
% h=diff(C,v);

%% 解方程-根据y、u2求得u1
% for i=1:L
% %     i
%     % 把符号v替换为数值u2(i)
%     h2=subs(h,v,u2(i));
%     % 解方程
%     eqns=h2==y(i);
%     x=solve(eqns,u,'Real',true);
%     % 处理结果
%     x=double(x);
%     u1(i)=x(x>0);
% end

%%
a=(y.*(u2.^(p+1))).^(-p/(p+1));
u1=(a+1-u2.^(-p)).^(-1/p);
