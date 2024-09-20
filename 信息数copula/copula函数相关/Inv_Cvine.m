function u4 = Inv_Cvine(u1,u2,u3,u4_123,C)
% C={C12;C23;C34;C13_2;C24_3;C14_23};
%S=[I H T P];
% Dvine中各节点copula类型
C12 = C{1,1};
C13 = C{2,1};
C14 = C{3,1};
C23_1 = C{4,1};
C24_1 = C{5,1};
C34_12 = C{6,1};
% 求u4（即功率的分位点，对照文章中的图4）
u2_1 = Get_Ccdf(C12,u2,u1);
u3_1 = Get_Ccdf(C13,u3,u1);
u3_12 = Get_Ccdf(C23_1,u3_1,u2_1);
u4_12 = Inv_Copula(C34_12,u4_123,u3_12);%u4_123为置信水平上下限
u4_1 = Inv_Copula(C24_1,u4_12,u2_1);
u4 = Inv_Copula(C14,u4_1,u1);
end

