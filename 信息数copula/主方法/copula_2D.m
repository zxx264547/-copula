clear
close all
clc
load initData.mat
list=errorData(:,5);
Data=errorData;
% 变量顺序
x1 = Data(:,1);%功率
x2 = Data(:,2);%辐照度
x3 = Data(:,3);%温度
x4 = Data(:,4);%湿度

% 利用核密度估计进行概率积分变换 ，把变量转换为[0,1]区间上的均匀分布，即将变量转换为边缘分布形式
u1 = ksdensity(x1,x1,'function','cdf');
u2 = ksdensity(x2,x2,'function','cdf');
u3 = ksdensity(x3,x3,'function','cdf');
u4 = ksdensity(x4,x4,'function','cdf');
% 控制u范围在0,1之间
u1(u2>=1) = 0.999;
u2(u2>=1) = 0.999;
u3(u3>=1) = 0.999;
u4(u4>=1) = 0.999;
U = [u1,u2,u3,u4];
% 置信水平上下限
beta1=0.99;
beta2=0.04;
u1_i_up = beta1*ones(length(u1),1);
u1_i_low = beta2*ones(length(u1),1);
variable = cell(4, 1);
variable{1} = '功率';
variable{2} = '辐照度';
variable{3} = '温度';
variable{4} = '湿度';
figureName = cell(4, 1);
figureName{2} = '功率——辐照度';
figureName{3} = '功率——温度';
figureName{4} = '功率——湿度';
recog_out_list=cell(4,1);
recog_norm_list=cell(4,1);
list_out1_recog_correct = cell(4,1);
list_out2_recog_correct = cell(4,1);
list_out3_recog_correct = cell(4,1);
list_out4_recog_correct = cell(4,1);
for i = 2:4
    %% 选择优copula
    C1i = Copula_selcet(u1,U(:,i));
    %% 获取置信区间
    u1_up=Inv_Copula(C1i , u1_i_up , U(:,i));
    u1_low=Inv_Copula(C1i , u1_i_low , U(:,i));
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
    %%%图一:功率—辐照度
    figure('NAME',figureName{i})
    scatter(Data(recog_norm_list{i},i),x1(recog_norm_list{i}),13,'b.');
    hold on
    scatter(Data(recog_out_list{i},i),x1(recog_out_list{i}),13,'r.');
    % 光伏电流曲线置信边界（辐照度—功率）
    hold on
    [x1_i,P] = sort(Data(:,i));
    plot(x1_i,x1_up(P),'g');
    hold on
    plot(x1_i,x1_low(P),'g');
    hold off
    xlabel(variable{i})
    ylabel('功率')
    % %%图二：光伏功率曲线置信区间（时序）
    figure('Name',sprintf('%s——功率置信区间', variable{i}))
    plot((1:length(x1)),x1,'b');
    hold on
    plot((1:length(x1)),x1_low,'r-');
    plot((1:length(x1)),x1_up,'r-');
    xlabel('采样点序号')
    ylabel('功率')
    legend('采样点功率','上、下边界')
    hold off
    % %%图三：异常分布真实情况
    figure('Name',sprintf('%s——真实', variable{i}))
    scatter(Data(real_norm_list,i),Data(real_norm_list,1),'b.')
    hold on
    scatter(Data(real_out_list,i),Data(real_out_list,1),'r.')
    xlabel(variable{i})
    ylabel('功率')
    
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
    % xlabel(variable{i})
    % ylabel('功率(W)')
    
    %list_out_copula=recog_out_list;
end
% save('F:\MATLAB\两步copula\识别出的异常值索引\list_out_copula.mat', 'list_out_copula');
% save('F:\MATLAB\两步copula\结果\copula.mat');