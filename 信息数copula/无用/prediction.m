function rmse=prediction(data)
X = [data(:,3),data(:,4)];  
Y = data(:,2);  

% 归一化数据
X = zscore(X);
Y = zscore(Y);
% % lstm
% % 划分数据为训练集和测试集
% trainRatio = 0.8;
% validationRatio = 0.1;
% testRatio = 0.1;
% [trainInd, valInd, testInd] = dividerand(size(X, 1), trainRatio, validationRatio, testRatio);
% 
% trainX = X(trainInd, :)';
% trainY = Y(trainInd)';
% valX = X(valInd, :)';
% valY = Y(valInd)';
% testX = X(testInd, :)';
% testY = Y(testInd)';
% 
% % 创建并配置LSTM网络
% numFeatures = 2;  % 输入特征数（温度和辐照度）
% numHiddenUnits = 150;  % LSTM隐藏单元数量
% outputSize = 1;  % 输出大小（电流）
% 
% % 创建LSTM层
% lstm_Layer = lstmLayer(numHiddenUnits, 'OutputMode', 'sequence');
% 
% % 创建ReLU激活层
% relu_Layer = reluLayer();
% 
% % 构建神经网络层序列，将LSTM层和ReLU层连接
% layers = [ ...
%     sequenceInputLayer(numFeatures)
%     lstm_Layer
%     relu_Layer  % 添加ReLU激活函数层
%     fullyConnectedLayer(outputSize)
%     regressionLayer];
% 
% % 配置训练选项
% options = trainingOptions('adam', ...
%     'MaxEpochs', 100, ...
%     'MiniBatchSize', 10, ...
%     'ValidationData', {valX, valY}, ...
%     'ValidationFrequency', 10, ...
%     'Plots', 'training-progress', ...
%     'Verbose', true);
% 
% % 训练LSTM模型
% net = trainNetwork(trainX, trainY, layers, options);
% 
% % 使用模型进行预测
% predictedY = predict(net, testX);
% 
% % 评估模型性能
% rmse = sqrt(mean((testY - predictedY).^2));
% fprintf('Root Mean Squared Error (RMSE): %.4f\n', rmse);
% 
% % 创建时间序列索引
% timeIndex = 1:length(testY);
% 
% % 绘制实际结果和预测结果的曲线
% figure;
% plot(timeIndex, testY, 'b-', 'LineWidth', 2, 'DisplayName', 'Actual');
% hold on;
% plot(timeIndex, predictedY, 'r--', 'LineWidth', 2, 'DisplayName', 'Predicted');
% hold off;
% 
% % 添加图例和标签
% legend('show');
% xlabel('时间步');
% ylabel('电流');
% title('实际电流 vs. 预测电流');
% 
% % 显示均方根误差(RMSE)
% rmse = sqrt(mean((testY - predictedY).^2));
% text(10, max(testY), ['RMSE = ', num2str(rmse)], 'Color', 'red', 'FontSize', 12);
% 
% % 显示图形
% grid on;
%% Bi-lstm
% % 加载和准备数据
% data = load('your_time_series_data.mat'); % 请替换为您自己的数据文件
% X = data.features; % 输入数据
% Y = data.labels;   % 输出数据

% 划分数据集为训练集和测试集
splitRatio = 0.8; % 80% 的数据用于训练
numData = size(X, 1);
splitIdx = round(splitRatio * numData);
XTrain = X(1:splitIdx, :);
YTrain = Y(1:splitIdx, :);
XTest = X(splitIdx+1:end, :);
YTest = Y(splitIdx+1:end, :);

% 创建双向LSTM模型
numHiddenUnits = 64; % LSTM隐藏单元数量

layers = [
    sequenceInputLayer(2) % 输入层，特征维度为2
    bilstmLayer(numHiddenUnits, 'OutputMode', 'sequence')
    fullyConnectedLayer(1)
    regressionLayer
];

% 配置训练选项
options = trainingOptions('adam', ...
    'MaxEpochs', 50, ...
    'MiniBatchSize', 64, ...
    'InitialLearnRate', 0.001, ...
    'ValidationData', {XTest, YTest}, ...
    'ValidationFrequency', 5, ...
    'Plots', 'training-progress', ...
    'Verbose', true);

% 训练双向LSTM模型
net = trainNetwork(XTrain, YTrain, layers, options);

% 进行预测
YPred = predict(net, XTest);

% 反归一化预测结果
YPred = YPred * std(data(:,2)) + mean(data(:,2));

% 可视化结果
figure;
plot(YTest, '-b');
hold on;
plot(YPred, '-r');
legend('实际值', '预测值');
xlabel('时间步');
ylabel('数值');
title('实际值 vs. 预测值');

% 计算性能指标（例如，均方根误差）
rmse = sqrt(mean((YPred - YTest).^2));
disp(['均方根误差 (RMSE): ' num2str(rmse)]);
