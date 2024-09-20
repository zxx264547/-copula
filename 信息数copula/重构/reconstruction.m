% clc
% clear
% close all
% load initialize_无噪声
% load list_out_vine_copula
% load list_out_copula
% load list_out_one_step
% load list_out_quantile
% 初始化修复后的数据
DATA_vine_copula=Data;
DATA_copula=Data;
DATA_one_step=Data;
DATA_quantile=Data;
%% 计算权重系数
V=data(:,1);
I=data(:,2);
T=data(:,3);
E=data(:,4);
% 计算变量之间的相关性系数
cov_TI=cov(T,I);
cov_EI=cov(E,I);
cov_TV=cov(T,V);
cov_EV=cov(E,V);
rou_TI=cov_TI(1,2)/(std(T)*std(I));
rou_EI=cov_EI(1,2)/(std(E)*std(I));
rou_TV=cov_TV(1,2)/(std(T)*std(V));
rou_EV=cov_EV(1,2)/(std(E)*std(V));
w_TI=rou_TI/(rou_TI+rou_EI);
w_EI=rou_EI/(rou_TI+rou_EI);
w_TV=rou_TV/(rou_TV+rou_EV);
w_EV=rou_EV/(rou_TV+rou_EV);
%% 对每个异常点进行修复(vine_copula)
for i = 1:length(list_out_vine_copula)
    out_index = list_out_vine_copula(i);
    
    % 初始化相似度和修复值
    min_distance_I =100000;
    min_distance_V =100000;
    % 计算异常点与其他采样点的相似度
    for j = 1:length(V)
        if j == out_index
            continue;  % 跳过自身
        end
        % 计算加权欧式距离
        distance_I = sqrt(w_TI*(T(j)-T(out_index))^2+w_EI*(E(j)-E(out_index))^2);
        distance_V = sqrt(w_TV*(T(j)-T(out_index))^2+w_EV*(E(j)-E(out_index))^2);
        % 更新最大相似度和修复值
        if distance_I < min_distance_I
            min_distance_I = distance_I;
            DATA_vine_copula(out_index,2) = I(j);  % 使用与异常点最相似的功率值进行修复
        end
        if distance_V < min_distance_V
            min_distance_V = distance_V;
            DATA_vine_copula(out_index,1) = V(j);  % 使用与异常点最相似的功率值进行修复
        end
    end
end
%% 对每个异常点进行修复(copula)
for i = 1:length(list_out_copula)
    out_index = list_out_copula(i);
    
    % 初始化相似度和修复值
    min_distance_I =100000;
    min_distance_V =100000;
    % 计算异常点与其他采样点的相似度
    for j = 1:length(V)
        if j == out_index
            continue;  % 跳过自身
        end
        % 计算加权欧式距离
        distance_I = sqrt(w_TI*(T(j)-T(out_index))^2+w_EI*(E(j)-E(out_index))^2);
        distance_V = sqrt(w_TV*(T(j)-T(out_index))^2+w_EV*(E(j)-E(out_index))^2);
        % 更新最大相似度和修复值
        if distance_I < min_distance_I
            min_distance_I = distance_I;
            DATA_copula(out_index,2) = I(j);  % 使用与异常点最相似的功率值进行修复
        end
        if distance_V < min_distance_V
            min_distance_V = distance_V;
            DATA_copula(out_index,1) = V(j);  % 使用与异常点最相似的功率值进行修复
        end
    end
end
%% 对每个异常点进行修复(one_step)
for i = 1:length(list_out_one_step)
    out_index = list_out_one_step(i);
    
    % 初始化相似度和修复值
    min_distance_I =100000;
    min_distance_V =100000;
    % 计算异常点与其他采样点的相似度
    for j = 1:length(V)
        if j == out_index
            continue;  % 跳过自身
        end
        % 计算加权欧式距离
        distance_I = sqrt(w_TI*(T(j)-T(out_index))^2+w_EI*(E(j)-E(out_index))^2);
        distance_V = sqrt(w_TV*(T(j)-T(out_index))^2+w_EV*(E(j)-E(out_index))^2);
        % 更新最大相似度和修复值
        if distance_I < min_distance_I
            min_distance_I = distance_I;
            DATA_one_step(out_index,2) = I(j);  % 使用与异常点最相似的功率值进行修复
        end
        if distance_V < min_distance_V
            min_distance_V = distance_V;
            DATA_one_step(out_index,1) = V(j);  % 使用与异常点最相似的功率值进行修复
        end
    end
end
%% 对每个异常点进行修复(quantile)
for i = 1:length(list_out_quantile)
    out_index = list_out_quantile(i);
    
    % 初始化相似度和修复值
    min_distance_I =100000;
    min_distance_V =100000;

    % 计算异常点与其他采样点的相似度
    for j = 1:length(V)
        if j == out_index
            continue;  % 跳过自身
        end
        % 计算加权欧式距离
        distance_I = sqrt(w_TI*(T(j)-T(out_index))^2+w_EI*(E(j)-E(out_index))^2);
        distance_V = sqrt(w_TV*(T(j)-T(out_index))^2+w_EV*(E(j)-E(out_index))^2);
        % 更新最大相似度和修复值
        if distance_I < min_distance_I
            min_distance_I = distance_I;
            DATA_quantile(out_index,2) = I(j);  % 使用与异常点最相似的功率值进行修复
        end
        if distance_V < min_distance_V
            min_distance_V = distance_V;
            DATA_quantile(out_index,1) = V(j);  % 使用与异常点最相似的功率值进行修复
        end
    end
end
%% 可视化
figure('NAME','重构前后数据对比（电压）')

plot(1:length(DATA_copula),DATA_copula(:,1), 'LineWidth', 2);
hold on
plot(1:length(DATA_one_step),DATA_one_step(:,1), 'LineWidth', 2);
hold on
plot(1:length(DATA_quantile),DATA_quantile(:,1), 'LineWidth', 2);
hold on


plot(1:length(DATA_vine_copula),DATA_vine_copula(:,1), 'LineWidth', 2);
hold on
plot(1:length(Data),Data(:,1), 'LineWidth', 2);
hold off
% plot(1:length(data),data(:,1));
% hold on
xlabel('采样点序号')
ylabel('电压(V)')
legend('二元copula','藤copula-PTE','分位数法','本文方法','重构前')
figure ('NAME','重构前后数据对比（电流）')

plot(1:length(DATA_copula),DATA_copula(:,2), 'LineWidth', 0.5);
hold on
plot(1:length(DATA_one_step),DATA_one_step(:,2), 'LineWidth', 0.5);
hold on
plot(1:length(DATA_quantile),DATA_quantile(:,2), 'LineWidth', 0.5);
hold on

plot(1:length(DATA_vine_copula),DATA_vine_copula(:,2),'r', 'LineWidth', 0.5);
hold on
plot(1:length(Data),Data(:,2),'b', 'LineWidth', 0.5);

hold off
% plot(1:length(data),data(:,1));
% hold on
xlabel('采样点序号')
ylabel('电流(I)')
legend('二元copula','藤copula-PTE','分位数法','本文方法','重构前')
% save('F:\MATLAB\两步copula\预测数据\DATA_vine_copula.mat', 'DATA_vine_copula');
% save('F:\MATLAB\两步copula\预测数据\DATA_copula.mat', 'DATA_copula');
% save('F:\MATLAB\两步copula\预测数据\DATA_one_step.mat', 'DATA_one_step');
% save('F:\MATLAB\两步copula\预测数据\DATA_quantile.mat', 'DATA_quantile');