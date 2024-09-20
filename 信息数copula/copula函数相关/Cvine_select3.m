function C = Cvine_select3(u1,u2,u3)
%% 第一层
%选择最优结构(计算变量之间的相关系数)
tau_23= corr(u2, u3, 'type', 'kendall');
tau_12=corr(u1, u2, 'type', 'kendall');
tau_13=corr(u1, u3, 'type', 'kendall');
%保存最大生成树的结构(u1不能作为根节点)
if tau_23+tau_12> tau_23+tau_13
    tau_max=tau_23+tau_12;
    root=2;%1-2-3
else
    tau_max=tau_23+tau_13;
    root=3;%1-3-2
end

if root==2
    % 选择最优copula
    C1 = Copula_selcet(u1,u2);%选取第一条边的copula函数(TE)
    C2 = Copula_selcet(u2,u3);%选取第二条边的copula函数
    % 根据最优copula计算条件cdf值
    u_12 = Get_Ccdf(C1,u1,u2);%第一条边的条件cdf值
    u_23 = Get_Ccdf(C2,u2,u3);%第二条边的条件cdf值
    u_12(u_12>=1)=0.999;
    u_23(u_23>=1)=0.999;
    % 第二层
    % 选择最优copula
    C3 = Copula_selcet(u_12,u_23);
    tau_123= corr(u_12, u_23, 'type', 'kendall');
    
elseif root == 3
    % 选择最优copula
    C1 = Copula_selcet(u2,u3);%选取第一条边的copula函数(TE)
    C2 = Copula_selcet(u1,u3);%选取第二条边的copula函数
    % 根据最优copula计算条件cdf值
    u_13 = Get_Ccdf(C1,u2,u3);%第一条边的条件cdf值
    u_23 = Get_Ccdf(C2,u1,u3);%第二条边的条件cdf值
    u_13(u_13>=1)=0.999;
    u_23(u_23>=1)=0.999;
    % 第二层
    % 选择最优copula
    C3 = Copula_selcet(u_13,u_23);
    tau_123= corr(u_13, u_23, 'type', 'kendall');
end
C = {C1;C2;C3};

end

