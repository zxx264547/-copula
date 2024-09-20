%% 加载数据
clear
close all
clc
load initData.mat
len = length(errorData);

i = 1;
% fig
Data = errorData;
x1 = Data(:,1);%功率
x2 = Data(:,2);%辐照度
x3 = Data(:,3);%温度
x4 = Data(:,4);%湿度

% 利用核密度估计进行概率积分变换 ，把变量转换为[0,1]区间上的均匀分布，即将变量转换为边缘分布形式
u1 = ksdensity(x1,x1,'function','cdf','Bandwidth',0.5);
u2 = ksdensity(x2,x2,'function','cdf','Bandwidth',0.5);
u3 = ksdensity(x3,x3,'function','cdf','Bandwidth',0.5);
u4 = ksdensity(x4,x4,'function','cdf','Bandwidth',0.5);
% 控制u范围在0,1之间
u1(u1>=1) = 0.999;
u2(u2>=1) = 0.999;
u3(u3>=1) = 0.999;
u4(u4>=1) = 0.999;
% 置信水平上下限
for beta1 = 0.9:0.01:0.99
    for beta2 = 0.01:0.01:0.1

        u1_234_up = beta1*ones(len,1);
        u1_234_low = beta2*ones(len,1);
        %% 利用训练样本生成Dvine
        V = Cvine_select(u2,u3,u4,u1);
        
        %% 获取置信区间
        % 把样本集分组，利用循环对每组数据进行求解
        U1_up = Inv_Cvine(u2,u3,u4,u1_234_up,V);
        U1_low = Inv_Cvine(u2,u3,u4,u1_234_low,V);
        up =  U1_up;
        low = U1_low;
        up(up>=1) = 0.999;
        low(low>=1) = 0.999;
        x1_up = ksdensity(x1,up,'Function','icdf','Bandwidth',1);
        x1_low = ksdensity(x1,low,'Function','icdf','Bandwidth',1);
        % x1_up(x1_up>500)=0;
        
        %% 数据清洗
        Dif_low = x1-x1_low;
        Dif_up = x1_up-x1;
        list_low = find(Dif_low<0);
        list_up = find(Dif_up<0);
        normalPower = Data;
        normalPower([list_low;list_up],:) = [];%第一步清洗后的电流数据
        anomalPower = Data([list_low;list_up],:);%离群数据
        recog_out_list  =sort(anomalPower(:,5));%离群数据索引
        recog_norm_list  =sort(setdiff(Data(:,5),recog_out_list ));%正常数据索引
        %% 可视化
        %% 图一:识别出的异常值和正常值
        % figure('NAME','识别结果')
        % scatter3(x2(recog_norm_list),x3(recog_norm_list),x1(recog_norm_list),10,x4(recog_norm_list),"filled");
        % hold on;
        % scatter3(x2(recog_out_list),x3(recog_out_list),x1(recog_out_list),"r.");
        % colorbar;
        % xlabel("辐照度");
        % ylabel("温度");
        % zlabel("功率");
        % ylabel(colorbar,"湿度");
        % % 定义用于绘制曲面图的网格密度
        % density = 100;
        % % 创建用于绘制曲面图的网格点
        % x_grid = linspace(min(x2), max(x2), density);
        % y_grid = linspace(min(x3), max(x3), density);
        % [X, Y] = meshgrid(x_grid, y_grid);
        % % 插值 z 值，以适应网格
        % Z = griddata(x2,x3, x1_up, X, Y, 'linear');
        % s=0.8;
        % surf(X, Y, Z,'FaceAlpha',s, 'FaceColor', 'red');
        % hold on
        % Z = griddata(x2, x3, x1_low, X, Y, 'linear');
        % surf(X, Y, Z,'FaceAlpha',s, 'FaceColor', 'red');
        % shading interp
        % legend('正常值','异常值','上、下边界')
        %% 图二：光伏功率曲线置信区间（时序）
        % figure('Name','光伏功率曲线置信区间（时序）')
        % plot(1:len,x1,'b');
        % hold on
        % plot(1:len,x1_low,'r-');
        % plot(1:len,x1_up,'r-');
        % xlabel('采样点序号')
        % ylabel('功率')
        % legend('采样点功率','上、下边界')
        % hold off
        %% 图三：异常分布真实情况
        % figure('Name','异常分布真实情况')
        % scatter3(initData(:,2),initData(:,3),initData(:,1),10,initData(:,4),"filled");
        % hold on;
        % scatter3(errorData(out,2),errorData(out,3),errorData(out,1),"r.");
        % colorbar;
        % xlabel("辐照度");
        % ylabel("温度");
        % zlabel("功率");
        % ylabel(colorbar,"湿度");
        
        
        %% 计算识别率
        
        
        recog_norm_list = setdiff(Data(:,5),recog_out_list );
        %识别率
        same_list = intersect(real_out_list,recog_out_list);
        accuracy(i)=length(same_list)/length(intersect(real_out_list,Data(:,5)));
        % 误识别率
        same_list = intersect(real_norm_list,recog_out_list );
        error(i)=length(same_list)/length(intersect(real_norm_list,Data(:,5)));
        
        %out1的识别率
        list_out1_recog_correct  = intersect(out1_list,recog_out_list );%算法识别出来的out1的数据索引
        acc_1(i)=length(list_out1_recog_correct )/length(intersect(out1_list,Data(:,5)));
        
        %out2的识别率
        list_out2_recog_correct  = intersect(out2_list,recog_out_list );%算法识别出来的out1的数据索引
        acc_2(i)=length(list_out2_recog_correct )/length(intersect(out2_list,Data(:,5)));
        
        %out3的识别率
        list_out3_recog_correct  = intersect(out3_list,recog_out_list );%算法识别出来的out1的数据索引
        acc_3(i)=length(list_out3_recog_correct )/length(intersect(out3_list,Data(:,5)));
        
        %out4的识别率
        list_out4_recog_correct  = intersect(out4_list,recog_out_list );%算法识别出来的out1的数据索引
        acc_4(i)=length(list_out4_recog_correct )/length(intersect(out4_list,Data(:,5)));
        
        disp(i);%打印log，跟踪程序
        
        output(i,:) = [beta1,beta2,accuracy(i),error(i),acc_1(i),acc_2(i),acc_3(i),acc_4(i)];
        i = i+1;
        
    end
end
figure
for i = 0:9
    
    plot(0.01:0.01:0.1,output(1+i*10:i*10+10,3));
    
    hold on
 
end
xlabel("下阈值")
ylabel("识别率")
legend("0.9","0.91","0.92","0.93","0.94","0.95","0.96" ...
    ,"0.97","0.98","0.99")

figure
for i = 0:9
    
   
    
    plot(0.01:0.01:0.1,output(1+i*10:i*10+10,4));
    
    hold on
end
xlabel("下阈值")
ylabel("误识别率")
legend("0.9","0.91","0.92","0.93","0.94","0.95","0.96" ...
    ,"0.97","0.98","0.99")




% save('F:\MATLAB\两步copula\识别出的异常值索引\list_out_vine_copula.mat', 'list_out_vine_copula');
% save('F:\MATLAB\两步copula\结果\vine_copula.mat');