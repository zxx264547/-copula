function u1_34 = Cvine2(u2,u3,u4,C)
% C = {C34;C14;C31_4};
%S=[I H T P];
% Cvine中各节点copula类型
C34 = C{1,1};
C14 = C{2,1};
C1_34 = C{3,1};

% 求u4
u1_4 = Get_Ccdf(C14,u2,u4);
u3_4 = Get_Ccdf(C34,u3,u4);
u1_34 = Get_Ccdf(C1_34,u1_4,u3_4);

end
