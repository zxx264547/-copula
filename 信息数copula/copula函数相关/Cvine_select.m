function C = Cvine_select(u1,u2,u3,u4)

% ��һ��
% ѡ������copula
C12 = Copula_selcet(u1,u2);
C13 = Copula_selcet(u1,u3);
C14 = Copula_selcet(u1,u4);
% ��������copula��������cdfֵ
u2_1 = Get_Ccdf(C12,u2,u1);
u3_1 = Get_Ccdf(C13,u3,u1);
u4_1 = Get_Ccdf(C14,u4,u1);

% �ڶ���
% ѡ������copula
C23_1 = Copula_selcet(u2_1,u3_1);
C24_1 = Copula_selcet(u2_1,u4_1);
% ��������copula��������cdfֵ
u3_12 = Get_Ccdf(C23_1,u3_1,u2_1);
u4_12 = Get_Ccdf(C24_1,u4_1,u2_1);

% ������
% ѡ������copula
C34_12 = Copula_selcet(u3_12,u4_12);

C = {C12;C13;C14;C23_1;C24_1;C34_12};
end

