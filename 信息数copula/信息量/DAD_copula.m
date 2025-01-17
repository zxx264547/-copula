clear
close all
clc
load initData.mat
% 定义网格大小和变量范围
len = 1000;
initData = initData(1:len,:);
n = length(initData); % 网格点数量
p = initData(:,1);
e = initData(:,2);
t = initData(:,3);
h = initData(:,4);


p = ksdensity(p,p,'function','cdf');
e = ksdensity(e,e,'function','cdf');
t = ksdensity(t,t,'function','cdf');
h = ksdensity(h,h,'function','cdf');

% 初始化矩阵D1和D2
D1 = diag(ones(n, 1));
D2 = diag(ones(n, 1));

%% pe
% 初始化核函数A
A1 = exp(-abs(p' - e)); % 使用外积来生成核矩阵

% 迭代计算D1和D2
maxIter = 1000; % 最大迭代次数
tolerance = 1e-6; % 收敛容忍度
for iter = 1:maxIter
    oldD1 = D1;
    oldD2 = D2;
    
    % 更新D1和D2
    for i = 1:n
        D1(i,i) = 1 / sum(D2 * A1(i,:)');  % 使用sum确保得到标量
        D2(i,i) = 1 / sum(D1 * A1(:,i));  % 使用sum确保得到标量
    end
    
    % 检查收敛性
    if max(abs(diag(D1) - diag(oldD1))) < tolerance && ...
       max(abs(diag(D2) - diag(oldD2))) < tolerance
        disp('Converged.');
        break;
    end
end


% 计算最终的Copula密度函数
C = D1 * A1 * D2;
figure("Name","i-p")
% 可视化结果

[A,B] = meshgrid(p,e);
transparency = 1;
s = surf(A, B, C,'FaceAlpha',transparency);
s.EdgeColor = 'none';
xlabel('功率(p.u.)');
ylabel('辐照度(p.u.)');
zlabel('联合概率密度');
% title('Bivariate Copula Density Function');

%% pt
% 初始化核函数A
A2 = exp(-abs(p' - t)); % 使用外积来生成核矩阵

% 迭代计算D1和D2
for iter = 1:maxIter
    oldD1 = D1;
    oldD2 = D2;
    
    % 更新D1和D2
    for i = 1:n
        D1(i,i) = 1 / sum(D2 * A2(i,:)');  % 使用sum确保得到标量
        D2(i,i) = 1 / sum(D1 * A2(:,i));  % 使用sum确保得到标量
    end
    
    % 检查收敛性
    if max(abs(diag(D1) - diag(oldD1))) < tolerance && ...
       max(abs(diag(D2) - diag(oldD2))) < tolerance
        disp('Converged.');
        break;
    end
end


% 计算最终的Copula密度函数
C = D1 * A2 * D2;
% subplot(2,3,2)
figure("Name","p-t")
% 可视化结果
[A,B] = meshgrid(p,t);

s = surf(A, B, C,'FaceAlpha',transparency);
s.EdgeColor = 'none';
xlabel('功率(p.u.)');
ylabel('温度(p.u.)');
zlabel('联合概率密度');
% title('Bivariate Copula Density Function');
%% ph
% 初始化核函数A
A3 = exp(-abs(p' - h)); % 使用外积来生成核矩阵

% 迭代计算D1和D2
for iter = 1:maxIter
    oldD1 = D1;
    oldD2 = D2;
    
    % 更新D1和D2
    for i = 1:n
        D1(i,i) = 1 / sum(D2 * A3(i,:)');  % 使用sum确保得到标量
        D2(i,i) = 1 / sum(D1 * A3(:,i));  % 使用sum确保得到标量
    end
    
    % 检查收敛性
    if max(abs(diag(D1) - diag(oldD1))) < tolerance && ...
       max(abs(diag(D2) - diag(oldD2))) < tolerance
        disp('Converged.');
        break;
    end
end


% 计算最终的Copula密度函数
C = D1 * A3 * D2;
figure
% 可视化结果
[A,B] = meshgrid(p,h);

s = surf(A, B, C,'FaceAlpha',transparency);
s.EdgeColor = 'none';
xlabel('功率');
ylabel('湿度');
zlabel('联合概率密度');
title('Bivariate Copula Density Function');
%% et
% 初始化核函数A
A4 = exp(-abs(e' - t)); % 使用外积来生成核矩阵

% 迭代计算D1和D2
for iter = 1:maxIter
    oldD1 = D1;
    oldD2 = D2;
    
    % 更新D1和D2
    for i = 1:n
        D1(i,i) = 1 / sum(D2 * A4(i,:)');  % 使用sum确保得到标量
        D2(i,i) = 1 / sum(D1 * A4(:,i));  % 使用sum确保得到标量
    end
    
    % 检查收敛性
    if max(abs(diag(D1) - diag(oldD1))) < tolerance && ...
       max(abs(diag(D2) - diag(oldD2))) < tolerance
        disp('Converged.');
        break;
    end
end


% 计算最终的Copula密度函数
C = D1 * A4 * D2;
figure("Name","i-t")
% 可视化结果
[A,B] = meshgrid(e,t);

s = surf(A, B, C,'FaceAlpha',transparency);
s.EdgeColor = 'none';
xlabel('辐照度(p.u.)');
ylabel('温度(p.u.)');
zlabel('联合概率密度');
%% eh
% 初始化核函数A
A5 = exp(-abs(e' - h)); % 使用外积来生成核矩阵

% 迭代计算D1和D2
for iter = 1:maxIter
    oldD1 = D1;
    oldD2 = D2;
    
    % 更新D1和D2
    for i = 1:n
        D1(i,i) = 1 / sum(D2 * A5(i,:)');  % 使用sum确保得到标量
        D2(i,i) = 1 / sum(D1 * A5(:,i));  % 使用sum确保得到标量
    end
    
    % 检查收敛性
    if max(abs(diag(D1) - diag(oldD1))) < tolerance && ...
       max(abs(diag(D2) - diag(oldD2))) < tolerance
        disp('Converged.');
        break;
    end
end


% 计算最终的Copula密度函数
C = D1 * A5 * D2;
figure("Name","i-h")
% 可视化结果
[A,B] = meshgrid(e,h);
s = surf(A, B, C,'FaceAlpha',transparency);
s.EdgeColor = 'none';
xlabel('辐照度(p.u.)');
ylabel('湿度(p.u.)');
zlabel('联合概率密度');

%% th
% 初始化核函数A
A6 = exp(-abs(t' - h)); % 使用外积来生成核矩阵

% 迭代计算D1和D2
for iter = 1:maxIter
    oldD1 = D1;
    oldD2 = D2;
    
    % 更新D1和D2
    for i = 1:n
        D1(i,i) = 1 / sum(D2 * A6(i,:)');  % 使用sum确保得到标量
        D2(i,i) = 1 / sum(D1 * A6(:,i));  % 使用sum确保得到标量
    end
    
    % 检查收敛性
    if max(abs(diag(D1) - diag(oldD1))) < tolerance && ...
       max(abs(diag(D2) - diag(oldD2))) < tolerance
        disp('Converged.');
        break;
    end
end


% 计算最终的Copula密度函数
C = D1 * A6 * D2;
figure
% 可视化结果
[A,B] = meshgrid(t,h);
s = surf(A, B, C,'FaceAlpha',transparency);
s.EdgeColor = 'none';

xlabel('温度');
ylabel('湿度');
zlabel('联合概率密度');
