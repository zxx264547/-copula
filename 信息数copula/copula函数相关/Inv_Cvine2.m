function u1 = Inv_Cvine2(u3,u4,u1_34,C)
% C = {C34;C14;C31_4};
%S=[I H T P];
% Dvine中各节点copula类型
C34 = C{1,1};
C14 = C{2,1};
C31_4 = C{3,1};

% 求u4
u3_4 = Get_Ccdf(C34,u3,u4);
u1_4 = Inv_Copula(C31_4,u1_34,u3_4);
u1=Inv_Copula(C14,u1_4,u4);

end

