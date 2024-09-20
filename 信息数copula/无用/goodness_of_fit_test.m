clear
close all
clc
%% 数据初始化
% 训练样本相关数据
% 数据集分别对应V、I、T、Ir
load data_45001_2
% 预处理数据
data_norm = preprocess(data);
[out1,out2,out3,out4]=error_data_process(data_norm);
Data=[data_norm;out1;out2;out3;out4];
%给数据添加索引，方便后面计算识别率
list=1:length(Data);
Data=[Data,list'];
error_data=[out1;out2;out3;out4];

x1 = Data(:,1);
x2 = Data(:,2);%电流
x3 = Data(:,3);%温度
x4 = Data(:,4);%辐照度

u1 = ksdensity(x1,x1,'function','cdf','Bandwidth',0.8);
u2 = ksdensity(x2,x2,'function','cdf','Bandwidth',0.8);
u3 = ksdensity(x3,x3,'function','cdf','Bandwidth',0.8);
u4 = ksdensity(x4,x4,'function','cdf','Bandwidth',0.8);

C3_4 = Copula_selcet(u3,u4);
C1_4=Copula_selcet(u1,u4);

u3_4 = Get_Ccdf(C3_4,u3,u4);
u4_3 = Get_Ccdf(C3_4,u4,u3);
u1_4 = Get_Ccdf(C1_4,u1,u4);

C1_34 = Copula_selcet(u1_4,u3_4);
u1_34 = Get_Ccdf(C1_34,u1_4,u3_4);
Z1=u3;
Z2=u4_3;
Z3=u1_34;
z1 = ksdensity(Z1,Z1,'function','icdf','Bandwidth',0.8);
z2 = ksdensity(Z2,Z2,'function','icdf','Bandwidth',0.8);
z3 = ksdensity(Z3,Z3,'function','icdf','Bandwidth',0.8);

% 计算一维卡方随机变量 Q
Q = z1.^2+z2.^2+z3.^2;

% 自由度为合并随机变量的数量
d = length(Z1);

% 进行KS检验
[h, p, ksstat] = kstest(Q);

% 显示KS检验结果
alpha = 0.05;  % 显著性水平
if h == 0
    disp('KS检验接受原假设，Q符合理论分布。');
else
    disp('KS检验拒绝原假设，Q不符合理论分布。');
end
disp(['KS统计量：', num2str(ksstat)]);
disp(['P-value：', num2str(p)]);
disp(['显著性水平：', num2str(alpha)]);

% sorted_data = sort(Q);

% % 计算每个数据点的相对位置
% n = length(sorted_data); % 数据点数量
% relative_positions = (1:n) / n;
% 
% % 绘制经验分布曲线
% figure;
% plot(sorted_data, relative_positions, 'b', 'LineWidth', 2);
% title('经验分布曲线');
% xlabel('数据值');
% ylabel('累积概率');
% grid on;
% hold on;


% % 设置自由度
% degrees_of_freedom = 2;
% 
% % 生成一系列卡方随机变量的取值
% x = 0:4/8509:4;
% 
% % 计算对应的卡方分布的CDF值
% cdf_values = chi2cdf(x, degrees_of_freedom);
% 
% % 绘制CDF曲线
% plot(x, cdf_values, 'r', 'LineWidth', 2);
% xlabel('卡方随机变量');
% ylabel('CDF值');
% title('卡方分布的累积分布函数');
% grid on;



