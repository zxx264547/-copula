function u1 = Inv_Frank(y,u2,p)
% y=F(u1|u2),u1=F(x1),u2=F(x2)

%% 计算Frank Copula的h函数即F(u1|u2)
% L=length(y);
% u1=zeros(L,1);
% syms C(u,v) h(u,v)
% % 原Frank Copula表达式
% C(u,v)=(-1/p)*log(1+(exp(-p*u)-1)*(exp(-p*v)-1)/(exp(-p)-1));
% % 对v求导后的获得h函数表达式
% h(u,v)=diff(C(u,v),v);

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
% 变形前
% a=(exp(-p)-1)*y;
% b=exp(-p*u2);
% x=a./(y+b-y.*b);
% u1=log(x+1)/(-p);
% 变形后
% a=(1-exp(p))*y;
% b=exp(p*(1-u2));
% x=a./(y*exp(p)+b-y.*b);
% u1=log(x+1)/(-p);
% 变形
a=(1-exp(p))*y;
b=exp(p*(1-u2));
% x=a./(y*exp(p)+b-y.*b);
fenzi = a+y*exp(p)+b-y.*b;
fenmu = y*exp(p)+b-y.*b;
u1 = (log(fenzi)-log(fenmu))/(-p);
% u1 = u1;
