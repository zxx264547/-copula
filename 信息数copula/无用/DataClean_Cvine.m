clear
clc
%% Dvine相关说明
% 采用Dvine结构
% x1:辐照度
% x2:温度
% x3:湿度
% x4:功率

%% 数据初始化
% 训练样本相关数据
% 数据集分别对应P、I、T、H
% load Data_norm
load Data-GSGF4
load out_2 %位于二维散点图上方
load out_3 %辐照不为零功率为零
load out_4 %位于二维散点图内部
load out_5 %位于二维散点图下方
load norm_4 %out_4的原始数据

% 预处理数据
Data_norm = preprocess(Data);

out=[out_2;out_4;out_5];
% 修改温度、湿度值
% out(:,3)=-10;
% out(:,4)=-90;

Data=[Data_norm;out];
P=1;I=2;T=3;H=4;
% 变量顺序
% S=[H T I P];
% S=[H I T P];
% S=[T I H P];
S=[I H T P];
x1 = Data(:,S(1));
x2 = Data(:,S(2));
x3 = Data(:,S(3));
x4 = Data(:,S(4));
% 利用核密度估计进行概率积分变换
u1 = ksdensity(x1,x1,'function','cdf','Bandwidth',0.1);% 把变量转换为[0,1]区间上的均匀分布
u2 = ksdensity(x2,x2,'function','cdf','Bandwidth',0.1);
u3 = ksdensity(x3,x3,'function','cdf','Bandwidth',0.1);
u4 = ksdensity(x4,x4,'function','cdf','Bandwidth',0.1);
% 控制u范围在0,1之间
u1(u1==1) = 0.999;
u2(u2==1) = 0.999;
u3(u3==1) = 0.999;
u4(u4==1) = 0.999;
% 置信水平上下限
u4_123_up = 0.98*ones(length(u1),1);
u4_123_low = 0.02*ones(length(u1),1);

%% 利用训练样本生成Dvine
V = Cvine_select(u1,u2,u3,u4);

%% 获取置信区间
% 把样本集分组，利用循环对每组数据进行求解
U4_up = Inv_Cvine(u1,u2,u3,u4_123_up,V);
U4_low = Inv_Cvine(u1,u2,u3,u4_123_low,V);
up =  U4_up;
low = U4_low;
up(up>=1) = 0.999;
low(low>=1) = 0.999;
X4_up = ksdensity(x4,up,'Function','icdf','Bandwidth',0.1);
X4_low = ksdensity(x4,low,'Function','icdf','Bandwidth',0.1);

x_P_up = X4_up;
x_P_low = X4_low; 
x_P = Data(:,P);
x_I = Data(:,I);

%% 计算识别率
list_norm=[1:length(Data_norm)]';
list_out2=[length(Data_norm)+1:length([Data_norm;out_2])]';
list_out4=[length([Data_norm;out_2])+1:length([Data_norm;out_2;out_4])]';
list_out5=[length([Data_norm;out_2;out_4])+1:length([Data_norm;out_2;out_4;out_5])]';

list_id = Identify(x_P,x_P_low,x_P_up);

% out_2识别准确率，类型一
C = intersect(list_out2,list_id);
accuracy_out2=length(C)/length(list_out2);
% out_4识别准确率
C = intersect(list_out4,list_id);
accuracy_out4=length(C)/length(list_out4);
% out_5识别准确率，类型二
C = intersect(list_out5,list_id);
accuracy_out5=length(C)/length(list_out5);
% 总识别率
C = intersect([list_out2;list_out4;list_out5],list_id);
accuracy_total=(200+length(C))/(length([list_out2;list_out4;list_out5])+200);%考虑类型三识别结果
% 误识别率
C = intersect(list_norm,list_id);
error=length(C)/length(list_norm);

%% 清洗及可视化
Clean2

%% 异常分布真实情况
figure('Name','辐照度-功率-真实')
group = ones(length(x_I),1);
gscatter(x_I,x_P,group,[0 0 1],[],6)
hold on
group = ones(length(out),1);
gscatter(out(:,2),out(:,1),group,[1 0 0],[],6)
axis square
xlabel('辐照度')
ylabel('功率')


