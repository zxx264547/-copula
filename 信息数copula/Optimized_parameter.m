clear
close all
clc
%% 数据初始化
% 训练样本相关数据
% 数据集分别对应V、I、T、Ir
load data_20001
% 预处理数据
data_norm = preprocess(data);
error_data=error_data_process(data_norm);
Data=[data_norm;error_data];
%给数据添加索引，方便后面计算识别率
list=1:length(Data);
Data=[Data,list'];
% fig
x2 = Data(:,2);%电流
x3 = Data(:,3);%温度
x4 = Data(:,4);%辐照度
% 利用核密度估计进行概率积分变换 ，把变量转换为[0,1]区间上的均匀分布，即将变量转换为边缘分布形式
u2 = ksdensity(x2,x2,'function','cdf');
u3 = ksdensity(x3,x3,'function','cdf');
u4 = ksdensity(x4,x4,'function','cdf');
% 控制u范围在0,1之间
u2(u2>=1) = 0.999;
u3(u3>=1) = 0.999;
u4(u4>=1) = 0.999;
% 置信水平上下限
maxaa=0;
for up=0.96:0.01:0.99
    for low=0.01:0.01:0.04
        u2_34_up = up*ones(length(u4),1);
        u2_34_low = low*ones(length(u4),1);
        %% 选择优copula
        V = Cvine_select2(u2,u3,u4);
        %% 获取置信区间
        u2_up = Inv_Cvine2(u3,u4,u2_34_up,V);
        u2_low = Inv_Cvine2(u3,u4,u2_34_low,V);
        u2_up(u2_up>=1) = 0.999;
        u2_low(u2_low>=1) = 0.999;
        x2_up = ksdensity(x2,u2_up,'Function','icdf');
        x2_low = ksdensity(x2,u2_low,'Function','icdf');
        %% 数据清洗
        list = [1:length(Data)]';
        Dif_low = x2-x2_low;
        Dif_up = x2_up-x2;
        list_low = find(Dif_low<0);
        list_up = find(Dif_up<0);
        %第一步清理后的正常数据
        DataClean_I = Data;
        DataClean_I([list_low;list_up],:) = [];
        DataOut_I = Data([list_low;list_up],:);%离群数据
        list_abnorm = [list_low;list_up];%离群数据索引
        % list_norm = setdiff(list,list_abnorm);%正常数据索引


        list_norm=[1:length(data_norm)]';
        list_error=[length(data_norm)+1:length([data_norm;error_data])]';%真实的错误数据索引
        %识别率
        C = intersect(list_error,DataOut_I(:,5));
        accuracy=length(C)/length(list_error);
        % 误识别率
        C = intersect(list_norm,DataOut_I(:,5));
        error=length(C)/length(list_norm);
        %总识别率
        aa=0.7*accuracy-0.3*error;
        if maxaa<aa
            maxaa=aa;
            maxp=[up,low];
        end
    end
end
x1 = DataClean_I(:,1);%电压
x3 = DataClean_I(:,3);%温度
x4 = DataClean_I(:,4);%辐照度
u1 = ksdensity(x1,x1,'function','cdf');
u3 = ksdensity(x3,x3,'function','cdf');
u4 = ksdensity(x4,x4,'function','cdf');
u1(u1>=1) = 0.999;
u3(u3>=1) = 0.999;
u4(u4>=1) = 0.999;
u1_34_up = 0.99*ones(length(u3),1);
u1_34_low = 0.01*ones(length(u3),1);
%% 利用训练样本生成Dvine
V = Cvine_select2(u1,u3,u4);
%% 获取置信区间
u1_up = Inv_Cvine2(u3,u4,u1_34_up,V);
u1_low = Inv_Cvine2(u3,u4,u1_34_low,V);
u1_up(u1_up>=1) = 0.999;
u1_low(u1_low>=1) = 0.999;
x1_up = ksdensity(x1,u1_up,'Function','icdf');
x1_low = ksdensity(x1,u1_low,'Function','icdf');
%% 数据清理
list = [1:length(DataClean_I)]';
Dif_low = x1-x1_low;
Dif_up = x1_up-x1;
list_low = find(Dif_low<0);
list_up = find(Dif_up<0);
DataClean_V = DataClean_I;
DataClean_V([list_low;list_up],:) = [];
DataOut_V = Data([list_low;list_up],:);
list_abnorm = [list_low;list_up];
list_norm = setdiff(list,list_abnorm);