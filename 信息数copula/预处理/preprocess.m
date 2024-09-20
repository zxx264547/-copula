function Data = preprocess(Data)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
x_P = abs(Data(:,1));
x_E = abs(Data(:,2));
x_T = Data(:,3);
x_H = abs(Data(:,4));


%填充缺失值
x_P = fillmissing(x_P,'previous');
x_T = fillmissing(x_T,'previous');
x_E = fillmissing(x_E,'previous');
x_H = fillmissing(x_H,'previous');

Data = [x_P,x_E,x_T,x_H];
Data(x_E == 0,:) = [];
Data(Data(:,3) > 80,:) = [];
Data(Data(:,4) <= 0,:) = [];
Data(Data(:,4) >= 100,:) = [];
% Data(x_E == 0 & x_P ~= 0,:) = [];

% Data(Data(:,4)>=1000,:) =0;
% Data(Data(:,4)==0,:) =[];

%给数据添加噪声
%噪声比例
% 
% a=0.98;
% num=fix(a*length(Data));
% list=randperm(length(Data),num);
% % % b=0.04;
% % % Data_norm(list,1)=abs((1+b*randn(num,1)).*Data_norm(list,1));
% % % Data_norm(list,2)=abs((1+b*randn(num,1)).*Data_norm(list,2));
% % 
% for i=1:length(list)
% %     if Data(list(i),4)>100
% %     Data(list(i),1)=abs(normrnd(Data(list(i),1), (25-(0.01*Data(list(i),4)-5)^2)*5, 1, 1));
% %     Data(list(i),2)=abs(normrnd(Data(list(i),2), (25-(0.01*Data(list(i),4)-5)^2)*0.5, 1, 1));
% %     else 
%     Data(list(i),1)=abs(normrnd(Data(list(i),1), (25-(0.01*Data(list(i),4)-5)^2)*2, 1, 1));
%     Data(list(i),2)=abs(normrnd(Data(list(i),2), (25-(0.01*Data(list(i),4)-5)^2)*0.2, 1, 1));
% %     end
%     Data(list(i),3)=normrnd(Data(list(i),3), 1, 1, 1);
%     Data(list(i),4)=abs(normrnd(Data(list(i),4), 5, 1, 1));
% 
% end
% 
% 
% % Data_norm(list,3)=(1+0.03*randn(num,1)).*Data_norm(list,3);
% % Data_norm(list,4)=abs((1+0.03*randn(num,1)).*Data_norm(list,4));
% % Data_norm(Data_norm(:,1)==0|Data_norm(:,2)==0|Data_norm(:,4)==0,:)=[];
% Data(Data(:,1)==0|Data(:,2)==0,:)=[];
% % Data_norm(Data_norm(:,4)==0,:)=[];
% 
% 
% 
% % 计算要删除的行数
% rows_to_delete = round(0.3 * sum(Data(:, 4) >= 0 & Data(:, 4) <= 200));
% 
% % 生成符合范围条件的行的索引列表
% valid_indices = find(Data(:, 4) >= 0 & Data(:, 4) <= 200);
% 
% % 随机选择要删除的行的索引
% random_indices = randsample(valid_indices, rows_to_delete);
% 
% % 根据随机索引删除相应的行
% Data(random_indices, :) = [];
% 
% % 现在，data 中包含了删除20%后的数据



end

