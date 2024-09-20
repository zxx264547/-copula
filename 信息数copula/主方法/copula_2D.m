clear
close all
clc
load initData.mat
list=errorData(:,5);
Data=errorData;
% ����˳��
x1 = Data(:,1);%����
x2 = Data(:,2);%���ն�
x3 = Data(:,3);%�¶�
x4 = Data(:,4);%ʪ��

% ���ú��ܶȹ��ƽ��и��ʻ��ֱ任 ���ѱ���ת��Ϊ[0,1]�����ϵľ��ȷֲ�����������ת��Ϊ��Ե�ֲ���ʽ
u1 = ksdensity(x1,x1,'function','cdf');
u2 = ksdensity(x2,x2,'function','cdf');
u3 = ksdensity(x3,x3,'function','cdf');
u4 = ksdensity(x4,x4,'function','cdf');
% ����u��Χ��0,1֮��
u1(u2>=1) = 0.999;
u2(u2>=1) = 0.999;
u3(u3>=1) = 0.999;
u4(u4>=1) = 0.999;
U = [u1,u2,u3,u4];
% ����ˮƽ������
beta1=0.99;
beta2=0.04;
u1_i_up = beta1*ones(length(u1),1);
u1_i_low = beta2*ones(length(u1),1);
variable = cell(4, 1);
variable{1} = '����';
variable{2} = '���ն�';
variable{3} = '�¶�';
variable{4} = 'ʪ��';
figureName = cell(4, 1);
figureName{2} = '���ʡ������ն�';
figureName{3} = '���ʡ����¶�';
figureName{4} = '���ʡ���ʪ��';
recog_out_list=cell(4,1);
recog_norm_list=cell(4,1);
list_out1_recog_correct = cell(4,1);
list_out2_recog_correct = cell(4,1);
list_out3_recog_correct = cell(4,1);
list_out4_recog_correct = cell(4,1);
for i = 2:4
    %% ѡ����copula
    C1i = Copula_selcet(u1,U(:,i));
    %% ��ȡ��������
    u1_up=Inv_Copula(C1i , u1_i_up , U(:,i));
    u1_low=Inv_Copula(C1i , u1_i_low , U(:,i));
    u1_up(u1_up>=1) = 0.999;
    u1_low(u1_low>=1) = 0.999;
    x1_up = ksdensity(x1,u1_up,'Function','icdf');
    x1_low = ksdensity(x1,u1_low,'Function','icdf');
   
    %% ������ϴ
    Dif_low = x1-x1_low;
    Dif_up = x1_up-x1;
    list_low = find(Dif_low<0);
    list_up = find(Dif_up<0);
    %��һ����������������
    normalPower = Data;
    normalPower([list_low;list_up],:) = [];%��һ����ϴ��ĵ�������
    anomalPower = Data([list_low;list_up],:);%��Ⱥ����

    recog_out_list{i} =sort(anomalPower(:,5));%��Ⱥ��������
    recog_norm_list{i} =sort(setdiff(list,recog_out_list{i}));%������������
    %% ���ӻ�
    %%%ͼһ:���ʡ����ն�
    figure('NAME',figureName{i})
    scatter(Data(recog_norm_list{i},i),x1(recog_norm_list{i}),13,'b.');
    hold on
    scatter(Data(recog_out_list{i},i),x1(recog_out_list{i}),13,'r.');
    % ��������������ű߽磨���նȡ����ʣ�
    hold on
    [x1_i,P] = sort(Data(:,i));
    plot(x1_i,x1_up(P),'g');
    hold on
    plot(x1_i,x1_low(P),'g');
    hold off
    xlabel(variable{i})
    ylabel('����')
    % %%ͼ����������������������䣨ʱ��
    figure('Name',sprintf('%s����������������', variable{i}))
    plot((1:length(x1)),x1,'b');
    hold on
    plot((1:length(x1)),x1_low,'r-');
    plot((1:length(x1)),x1_up,'r-');
    xlabel('���������')
    ylabel('����')
    legend('�����㹦��','�ϡ��±߽�')
    hold off
    % %%ͼ�����쳣�ֲ���ʵ���
    figure('Name',sprintf('%s������ʵ', variable{i}))
    scatter(Data(real_norm_list,i),Data(real_norm_list,1),'b.')
    hold on
    scatter(Data(real_out_list,i),Data(real_out_list,1),'r.')
    xlabel(variable{i})
    ylabel('����')
    
    %% ����ʶ����


    recog_norm_list{i}= setdiff(list,recog_out_list{i});
    %ʶ����
    same_list = intersect(real_out_list,recog_out_list{i});
    accuracy(i)=length(same_list)/length(real_out_list);
    % ��ʶ����
    same_list = intersect(real_norm_list,recog_out_list{i});
    error(i)=length(same_list)/length(real_norm_list);
    
    %out1��ʶ����
    list_out1_recog_correct{i} = intersect(out1_list,recog_out_list{i});%�㷨ʶ�������out1����������
    acc_1(i)=length(list_out1_recog_correct{i})/length(out1_list);
    
    %out2��ʶ����
    list_out2_recog_correct{i} = intersect(out2_list,recog_out_list{i});%�㷨ʶ�������out1����������
    acc_2(i)=length(list_out2_recog_correct{i})/length(out2_list);
    
    %out3��ʶ����
    list_out3_recog_correct{i} = intersect(out3_list,recog_out_list{i});%�㷨ʶ�������out1����������
    acc_3(i)=length(list_out3_recog_correct{i})/length(out3_list);
    
    %out4��ʶ����
    list_out4_recog_correct{i} = intersect(out4_list,recog_out_list{i});%�㷨ʶ�������out1����������
    acc_4(i)=length(list_out4_recog_correct{i})/length(out4_list);
    
    % figure('Name',sprintf('%s�������ս��', figureName{i}))
    % scatter(Data(recog_norm_list{i},2),Data(recog_norm_list{i},1),13,'b.')
    % hold on
    % scatter(Data(recog_out_list{i},2),Data(recog_out_list{i},1),13,'r.')
    % xlabel(variable{i})
    % ylabel('����(W)')
    
    %list_out_copula=recog_out_list;
end
% save('F:\MATLAB\����copula\ʶ������쳣ֵ����\list_out_copula.mat', 'list_out_copula');
% save('F:\MATLAB\����copula\���\copula.mat');