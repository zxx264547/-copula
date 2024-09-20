clear 
close all
clc

% 1. 读取表格数据

%% 广泗光伏二站数据
% tableData = readtable('.\数据\广泗光伏二站数据.xlsx'); 
% 
% rawData(:,1) = tableData(:,3);%功率
% rawData(:,2) = tableData(:,4);%辐照度
% rawData(:,3) = tableData(:,7);%温度
% rawData(:,4) = tableData(:,9);%湿度

%% 广泗光伏四站数据

% 设置 Excel 文件路径
filename = '.\数据\广泗光伏四站数据.xlsx';



% 使用readtable函数读取数据
tableData = readtable(filename);

rawData(:,1) = tableData(:,3);%功率
rawData(:,2) = tableData(:,4);%辐照度
rawData(:,3) = tableData(:,8);%温度
rawData(:,4) = tableData(:,9);%湿度
%% 华电大仪光伏数据
% tableData = readtable('.\数据\华电大仪光伏数据.xlsx'); 
% 
% rawData(:,1) = tableData(:,3);%功率
% rawData(:,2) = tableData(:,4);%辐照度
% rawData(:,3) = tableData(:,8);%温度
% rawData(:,4) = tableData(:,9);%湿度


%%
%%
rawData = table2array(rawData);
% 2. 保存为MAT文件
save('.\数据\rawData.mat', 'rawData'); 
% 3. plot数据
%scatter3(rawData(:,2),rawData(:,3),rawData(:,1),".");