function [out1_list,out2_list,out3_list,out4_list,Data]=error_data_process(data)
num_out1=fix(0.01*length(data));%功率接近于0的数据占比
num_out2=fix(0.02*length(data));%低于正常功率的数据占比
num_out3=fix(0.01*length(data));%高于正常功率的数据占比
num_out4=fix(0.01*length(data));%正常功率值附近的数据占比
max_data=max(data);
%% 功率接近于0的异常数据out1
% 确定要取出的组数和每组数据的点数
points_per_group = 5;
num_groups = fix(num_out1/points_per_group);
% 计算数据向量中可以取出的连续组数
num_possible_groups = length(data) - points_per_group + 1;
% 初始化存储结果的矩阵
out1_list = [];
out1=[];
out_all = [];%用于判断四类异常数据是否有重复
% 使用循环生成不重叠的随机组索引
for i = 1:num_groups
    % 生成一个不重叠的随机组索引
    while true
        start_idx = randi(num_possible_groups);%每组第一个
        if ~ismember(start_idx:start_idx+points_per_group-1, out_all(:))
            break; % 如果该组数据不与已取出的组数据重叠，则跳出循环
        end
    end
    % 将该组数据存入结果矩阵中
    list=[start_idx:start_idx+points_per_group-1]';
    out1_list = [out1_list;list];
    out_all=[out_all;list];
end
%将正常数据替换成异常数据（一次性替换）
for i=1:length(out1_list)
    data(out1_list(i),1)=abs(randn(1,1));
end
out1=[data(out1_list,1),data(out1_list,2),data(out1_list,3),data(out1_list,4),data(out1_list,5)];
%% 低于概率曲线的异常数据out2
points_per_group = 10;
% num_groups = fix(num_out2/points_per_group );
% 计算数据向量中可以取出的连续组数
num_possible_groups = length(data) - points_per_group + 1;
% 初始化存储结果的矩阵
out2_list = [];
out2=[];
% 使用循环生成不重叠的随机组索引
while length(out2)<=num_out2
    % 生成一个不重叠的随机组索引
    while true
        start_idx = randi(num_possible_groups);
        if ~ismember(start_idx:start_idx+points_per_group-1, out_all(:))
            break; % 如果该组数据不与已取出的组数据重叠，则跳出循环
        end
    end
    % 将该组数据存入结果矩阵中(每取一组存放一次)
    list=[start_idx:start_idx+points_per_group-1]';
    
    out_all=[out_all;list];
    for i=1:length(list)
        if (data(list(i),1)>=0.4*max_data(1,1))
            data(list(i),1)=abs(normrnd(0.2*max_data(1,1), 0.01*max_data(1,1), 1, 1));
           
%             data(list(i),1)=0.2*max_data(1,1);
%             data(list(i),2) =0.2*max_data(1,2);
            out2=[out2;data(list(i),1),data(list(i),2),data(list(i),3),data(list(i),4),data(list(i),5)];
            out_all=[out_all;list(i)];
        end
    end
end
out2_list=out2(:,5);
%% 高于概率曲线的异常数据out3
points_per_group = 10;
% num_groups = fix(num_out3/points_per_group );
% 计算数据向量中可以取出的连续组数
num_possible_groups = length(data) - points_per_group + 1;
% 初始化存储结果的矩阵
out3_list = [];
out3=[];
while length(out3)<=num_out3
    % 生成一个不重叠的随机组索引
    while true
        start_idx = randi(num_possible_groups);
        if ~ismember(start_idx:start_idx+points_per_group-1, out_all(:))
            break; % 如果该组数据不与已取出的组数据重叠，则跳出循环
        end
    end
    % 将该组数据存入结果矩阵中
    list=(start_idx:start_idx+points_per_group-1)';
    
    
    for i=1:length(list)
        if (data(list(i),1)<=0.6*max_data(1,1)&&data(list(i),2)~=0)
            data(list(i),1)=abs(normrnd(0.8*max_data(1,1), 0.01*max_data(1,1), 1, 1));
         
            out3=[out3;data(list(i),1),data(list(i),2),data(list(i),3),data(list(i),4),data(list(i),5)];
            out_all=[out_all;list(i)];
        end
    end
end

out3_list=out3(:,5);
%% 位于概率曲线附近异常数据out4

remain=setdiff((1:length(data))',out_all);
remain = remain(data(remain, 2) ~= 0);
out4_rand=randi(length(remain),num_out4,1);
out4_list=data(remain(out4_rand),5); 
out4=[];

for i=1:num_out4
    data(out4_list(i),1)=abs(normrnd(data(out4_list(i),1), 0.2*max_data(1,1), 1, 1));    
end
out4=[data(out4_list,1),data(out4_list,2),data(out4_list,3),data(out4_list,4),data(out4_list,5)];
%% 
Data=data;
% out_list=[out1_list;out2_list;out3_list;out4_list];
% error_data=[out1;out2;out3;out4];

% error_data(error_data(:,1)==0|error_data(:,2)==0,:)=[];
% out1=error_data(:,1);
% out2=error_data(:,2);
% out3=error_data(:,3);
% out4=error_data(:,4);
end

