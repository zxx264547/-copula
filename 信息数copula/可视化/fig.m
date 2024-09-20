close all
x1 = Data(:,1);%电压
x2 = Data(:,2);%电流
x3 = Data(:,3);%温度
x4 = Data(:,4);%辐照度

figure('Name','电流-真实')
scatter3(Data(out1_list,4),Data(out1_list,3),Data(out1_list,2),12,'g.');
hold on
scatter3(Data(out2_list,4),Data(out2_list,3),Data(out2_list,2),12,'.');
hold on
scatter3(Data(out3_list,4),Data(out3_list,3),Data(out3_list,2),12,'.');
hold on
scatter3(Data(out4_list,4),Data(out4_list,3),Data(out4_list,2),12,'r.');
hold on
scatter3(Data(real_norm_list,4),Data(real_norm_list,3),Data(real_norm_list,2),12,'b.');
ylabel('温度(℃)')
xlabel('辐照度(W/m^2)')
zlabel('电流(A)')
legend('异常类型1','异常类型2','异常类型3','异常类型4','正常值','Location','northwest','FontSize',12)

figure('Name','电压-真实')
scatter3(Data(out1_list,4),Data(out1_list,3),Data(out1_list,1),12,'g.');
hold on
scatter3(Data(out2_list,4),Data(out2_list,3),Data(out2_list,1),12,'.');
hold on
scatter3(Data(out3_list,4),Data(out3_list,3),Data(out3_list,1),12,'.');
hold on
scatter3(Data(out4_list,4),Data(out4_list,3),Data(out4_list,1),12,'r.');
hold on
scatter3(Data(real_norm_list,4),Data(real_norm_list,3),Data(real_norm_list,1),12,'b.');
ylabel('温度(℃)')
xlabel('辐照度(W/m^2)')
zlabel('电压(V)')
legend('异常类型1','异常类型2','异常类型3','异常类型4','正常值','Location','northwest','FontSize',12)

% figure('Name','电压-真实-二维')
% scatter(Data(out1_list,4),Data(out1_list,1),13,'.');
% hold on
% scatter(Data(out2_list,4),Data(out2_list,1),13,'.');
% hold on
% scatter3(Data(out3_list,4),Data(out3_list,3),Data(out3_list,1),13,'.');
% hold on
% scatter3(Data(out4_list,4),Data(out4_list,3),Data(out4_list,1),13,'r.');
% hold on
% scatter3(Data(real_norm_list,4),Data(real_norm_list,3),Data(real_norm_list,1),13,'b.');
% ylabel('温度(℃)')
% xlabel('辐照度(W/m^2)')
% zlabel('电压(V)')
% legend('异常类型1','异常类型2','异常类型3','异常类型4','正常值')

%% 人工合成异常前后曲线对比
figure('NAME','人工合成异常前后电压对比')
len=3000;
% Data(:,2)=Data(:,2)./10;
% data(:,2)=data(:,2)./10;
plot(1:len,Data(1:len,1),'r')
hold on
plot(1:len,data(1:len,1),'b')
xlabel('采样序列号')
ylabel('电压')
legend('添加异常后','原始电压')

figure('NAME','人工合成异常前后电流对比')
plot(1:len,Data(1:len,2),'r')
hold on
plot(1:len,data(1:len,2),'b')
xlabel('采样序列号')
ylabel('电流')
legend('添加异常后','原始电流')


