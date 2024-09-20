clear
close all
clc
%% 数据初始化
% 训练样本相关数据
% 数据集分别对应P,E,T,H
load rawData.mat
% 预处理数据
initData= preprocess(rawData);
list = 1:length(initData);
initData = [initData,list'];
[out1_list,out2_list,out3_list,out4_list,errorData]=error_data_process(initData);
out = [out1_list;out2_list;out3_list;out4_list];
%给数据添加索引，方便后面计算识别率
real_out_list=sort([out1_list;out2_list;out3_list;out4_list]);
real_norm_list= sort(setdiff(list,real_out_list));
%save('./数据/initData.mat');

%% 可视化
subplot(1,3,1);
scatter3(initData(:,2),initData(:,3),initData(:,1),".");
hold on;
scatter3(errorData(out,2),errorData(out,3),errorData(out,1),"r.");
xlabel("辐照度");
ylabel("温度");
zlabel("功率");
subplot(1,3,2);
scatter3(initData(:,2),initData(:,4),initData(:,1),".");
hold on;
scatter3(errorData(out,2),errorData(out,4),errorData(out,1),"r.");
xlabel("辐照度");
ylabel("湿度");
zlabel("功率");
subplot(1,3,3);
scatter3(initData(:,3),initData(:,4),initData(:,1),".");
hold on;
scatter3(errorData(out,3),errorData(out,4),errorData(out,1),"r.");
xlabel("温度");
ylabel("湿度");
zlabel("功率");

figure(Name="四维图")
scatter3(initData(:,2),initData(:,3),initData(:,1),10,initData(:,4),"filled");
hold on;
scatter3(errorData(out,2),errorData(out,3),errorData(out,1),"r.");
colorbar;
xlabel("辐照度");
ylabel("温度");
zlabel("功率");
ylabel(colorbar,"湿度");