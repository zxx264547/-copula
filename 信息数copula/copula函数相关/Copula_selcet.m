function [BestCopula,GOF_AIC] = Copula_selcet(u1,u2)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明

%% 计算各种类型copula的评价参数GOF
Name={'type','mle','BIC','AIC','P1','P2'};%copula函数类别，最大似然值，BIC指标，AIC指标，估计参数值
GOF(1,:)=string(Name);
Ns=length(u1);

% Clayton copula
clt = copulafit('Clayton',[u1 u2]);%copula函数估计值
y = copulapdf('Clayton',[u1 u2],clt);%概率密度
mle_clt=sum(log(y));
BIC_clt=1*log(Ns)-2*mle_clt;
AIC_clt=2*1-2*mle_clt;
GOF(2,:)=string({'Clayton',mle_clt,BIC_clt,AIC_clt,clt,'-'});

% Frank copula
fr = copulafit('Frank',[u1 u2]);
y = copulapdf('Frank',[u1 u2],fr);
mle_fr=sum(log(y));
BIC_fr=1*log(Ns)-2*mle_fr;
AIC_fr=2*1-2*mle_fr;
GOF(3,:)=string({'Frank',mle_fr,BIC_fr,AIC_fr,fr,'-'});

% Gaussian copula
gauss = copulafit('Gaussian',[u1 u2]);
y = copulapdf('Gaussian',[u1 u2],gauss);
mle_gauss=sum(log(y));
BIC_gauss=1*log(Ns)-2*mle_gauss;
AIC_gauss=2*1-2*mle_gauss;
GOF(4,:)=string({'Gaussian',mle_gauss,BIC_gauss,AIC_gauss,gauss(1,2),'-'});

% t copula
[tr,tn] = copulafit('t',[u1 u2]);
y = copulapdf('t',[u1 u2],tr,tn);
mle_t=sum(log(y));
BIC_t=2*log(Ns)-2*mle_t;
AIC_t=2*2-2*mle_t;
GOF(5,:)=string({'t',mle_t,BIC_t,AIC_t,tr(1,2),tn});

% Gumbel copula
gb = copulafit('Gumbel',[u1 u2]);
y = copulapdf('Gumbel',[u1 u2],gb);
mle_gb=sum(log(y));
BIC_gb=1*log(Ns)-2*mle_gb;
AIC_gb=2*1-2*mle_gb;
GOF(6,:)=string({'Gumbel',mle_gb,BIC_gb,AIC_gb,gb,'-'});

%% 对评价结果进行排序筛选
% 最大似然值mle越大越好
% mle=double(GOF(2:6,2));
% [~,Ind]=sort(mle,'descend' );
% GOF_mle=GOF(Ind+1,:);
% GOF_mle=[Name;GOF_mle];

% 贝叶斯信息准则BIC越小越好
% BIC=double(GOF(2:6,3));
% [~,Ind]=sort(BIC,'ascend');
% GOF_BIC=GOF(Ind+1,:);
% GOF_BIC=[Name;GOF_BIC];

% 赤池信息准则AIC(最合适)，越小越好
AIC=double(GOF(2:end,4));
[~,Ind]=sort(AIC,'ascend');
GOF_AIC=GOF(Ind+1,:);
GOF_AIC=[Name;GOF_AIC];

% 最优Copula
BestCopula=GOF_AIC(2,:);

end

