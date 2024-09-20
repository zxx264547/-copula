function C = Cvine_select2(u1,u2,u3)
%% 第一层
%选择最优结构(计算变量之间的相关系数)
tau_23= corr(u2, u3, 'type', 'kendall');
tau_12=corr(u1, u2, 'type', 'kendall');
tau_13=corr(u1, u3, 'type', 'kendall');
%保存最大生成树的结构
if tau_23+tau_12> tau_23+tau_13
    tau_max=tau_23+tau_12;
    U=[u2,u3,u1,u2];
    jiedian=2;
else
    tau_max=tau_23+tau_13;
    U=[u2,u3,u1,u3];
    jiedian=3;
end
% 选择最优copula
C1 = Copula_selcet(U(:,1),U(:,2));%选取第一条边的copula函数(TE)
C2 = Copula_selcet(U(:,3),U(:,4));%选取第二条边的copula函数

% 根据最优copula计算条件cdf值
u_1 = Get_Ccdf(C1,U(:,1),U(:,2));%第一条边的条件cdf值
u_2 = Get_Ccdf(C2,U(:,3),U(:,4));%第二条边的条件cdf值
u_1(u_1>=1)=0.999;
u_2(u_2>=1)=0.999;

% 第二层
% 选择最优copula
C3 = Copula_selcet(u_1,u_2);
tau_123= corr(u_1, u_2, 'type', 'kendall');

C = {C1;C2;C3};
end

