clear
close all
clc
load initData.mat
Data = errorData;
% fig
x1 = Data(:,1);%功率
x2 = Data(:,2);%辐照度
x3 = Data(:,3);%温度
x4 = Data(:,4);%湿度
len = length(Data);
%%
variable = cell(3, 1);
variable{1}.variable1 = '辐照度';
variable{1}.variable2 = '温度';
variable{2}.variable1 = '辐照度';
variable{2}.variable2 = '湿度';
variable{3}.variable1 = '温度';
variable{3}.variable2 = '湿度';
figureName = cell(3, 1);
figureName{1} = '功率——辐照度——温度';
figureName{2} = '功率——辐照度——湿度';
figureName{3} = '功率——温度——湿度';
recog_out_list=cell(3,1);
recog_norm_list=cell(3,1);
list_out1_recog_correct = cell(3,1);
list_out2_recog_correct = cell(3,1);
list_out3_recog_correct = cell(3,1);
list_out4_recog_correct = cell(3,1);
%% 选择条件变量
for i = 1:3
    if i == 1
        % 辐照度和温度
        condVariable1 = x2;
        condVariable2 = x3;

    elseif i == 2
        % 辐照度和湿度
        condVariable1 = x2;
        condVariable2 = x4;
    elseif i == 3
        % 温度和湿度
        condVariable1 = x3;
        condVariable2 = x4;
    end 
    %% 
    % 利用核密度估计进行概率积分变换 ，把变量转换为[0,1]区间上的均匀分布，即将变量转换为边缘分布形式
    u1 = ksdensity(x1,x1,'function','cdf');
    CDF_condVariable1 = ksdensity(condVariable1,condVariable1,'function','cdf');
    CDF_condVariable2 = ksdensity(condVariable2,condVariable2,'function','cdf');
    % 控制u范围在0,1之间
    u1(u1>=1) = 0.999;
    CDF_condVariable1(CDF_condVariable1>=1) = 0.999;
    CDF_condVariable2(CDF_condVariable2>=1) = 0.999;
    % 置信水平上下限
    beta1=0.99;
    beta2=0.04;
    u1_conditon_up = beta1*ones(len,1);
    u1_conditon_low = beta2*ones(len,1);
    
    
    %% 选择优copula
    V = Cvine_select2(u1,CDF_condVariable1,CDF_condVariable2);
    %% 获取置信区间
    %注意，这里输入参数的顺序会影响结果
    u1_up = Inv_Cvine2(CDF_condVariable2,CDF_condVariable1,u1_conditon_up,V);
    u1_low = Inv_Cvine2(CDF_condVariable2,CDF_condVariable1,u1_conditon_low,V);
    u1_up(u1_up>=1) = 0.999;
    u1_low(u1_low>=1) = 0.999;
    
    x1_up = ksdensity(x1,u1_up,'Function','icdf');
    x1_low = ksdensity(x1,u1_low,'Function','icdf');
    %% 数据清洗
    Dif_low = x1-x1_low;
    Dif_up = x1_up-x1;
    list_low = find(Dif_low<0);
    list_up = find(Dif_up<0);
    %第一步清理后的正常数据
    normalPower = Data;
    normalPower([list_low;list_up],:) = [];%第一步清洗后的电流数据
    anomalPower = Data([list_low;list_up],:);%离群数据
    recog_out_list{i} =sort(anomalPower(:,5));%离群数据索引
    recog_norm_list{i} =sort(setdiff(list,recog_out_list{i}));%正常数据索引

 %% 可视化
    %% 图一:识别出的异常值和正常值
    figure('NAME',sprintf('%s——识别结果', figureName{i}))
    scatter3(condVariable1(recog_norm_list{i}),condVariable2(recog_norm_list{i}),x1(recog_norm_list{i}),13,'b.');
    hold on
    scatter3(condVariable1(recog_out_list{i}),condVariable2(recog_out_list{i}),x1(recog_out_list{i}),13,'r.');
    hold on
    % 定义用于绘制曲面图的网格密度
    density = 100;
    % 创建用于绘制曲面图的网格点
    x_grid = linspace(min(condVariable1), max(condVariable1), density);
    y_grid = linspace(min(condVariable2), max(condVariable2), density);
    [X, Y] = meshgrid(x_grid, y_grid);
    % 插值 z 值，以适应网格
    Z = griddata(condVariable1,condVariable2, x1_up, X, Y, 'linear');
    s=0.8;
    surf(X, Y, Z,'FaceAlpha',s);
    hold on
    Z = griddata(condVariable1, condVariable2, x1_low, X, Y, 'linear');
    surf(X, Y, Z,'FaceAlpha',s);
    shading interp
    legend('正常值','异常值','上、下边界')
    xlabel(variable{i}.variable1)
    ylabel(variable{i}.variable2)
    zlabel('功率')
    %% 图二：光伏功率曲线置信区间（时序）
    figure('Name',sprintf('%s——功率置信区间', figureName{i}))
    plot(1:len,x1,'b');
    hold on
    plot(1:len,x1_low,'r-');
    plot(1:len,x1_up,'r-');
    xlabel('采样点序号')
    ylabel('功率')
    legend('采样点功率','上、下边界')
    hold off
    %% 图三：异常分布真实情况
    figure('Name',sprintf('%s——真实', figureName{i}))
    scatter3(condVariable1(real_norm_list),condVariable2(real_norm_list),x1(real_norm_list),'b.')
    hold on
    scatter3(condVariable1(real_out_list),condVariable2(real_out_list),x1(real_out_list),'r.')
    xlabel(variable{i}.variable1)
    ylabel(variable{i}.variable2)
    zlabel('功率')
    

 %% 计算识别率


    recog_norm_list{i}= setdiff(list,recog_out_list{i});
    %识别率
    same_list = intersect(real_out_list,recog_out_list{i});
    accuracy(i)=length(same_list)/length(real_out_list);
    % 误识别率
    same_list = intersect(real_norm_list,recog_out_list{i});
    error(i)=length(same_list)/length(real_norm_list);
    
    %out1的识别率
    list_out1_recog_correct{i} = intersect(out1_list,recog_out_list{i});%算法识别出来的out1的数据索引
    acc_1(i)=length(list_out1_recog_correct{i})/length(out1_list);
    
    %out2的识别率
    list_out2_recog_correct{i} = intersect(out2_list,recog_out_list{i});%算法识别出来的out1的数据索引
    acc_2(i)=length(list_out2_recog_correct{i})/length(out2_list);
    
    %out3的识别率
    list_out3_recog_correct{i} = intersect(out3_list,recog_out_list{i});%算法识别出来的out1的数据索引
    acc_3(i)=length(list_out3_recog_correct{i})/length(out3_list);
    
    %out4的识别率
    list_out4_recog_correct{i} = intersect(out4_list,recog_out_list{i});%算法识别出来的out1的数据索引
    acc_4(i)=length(list_out4_recog_correct{i})/length(out4_list);
    
    % figure('Name',sprintf('%s——最终结果', figureName{i}))
    % scatter(Data(recog_norm_list{i},2),Data(recog_norm_list{i},1),13,'b.')
    % hold on
    % scatter(Data(recog_out_list{i},2),Data(recog_out_list{i},1),13,'r.')
    % xlabel('辐照度')
    % ylabel('功率(W)')
end
%list_out_one_step=recog_out_list;
%save('F:\MATLAB\两步copula\识别出的异常值索引\list_out_one_step.mat', 'list_out_one_step');
%save('F:\MATLAB\两步copula\结果\one_step.mat');