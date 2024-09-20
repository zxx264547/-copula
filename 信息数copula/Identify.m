function list_out = Identify(x,x_low,x_up)
%功能：识别出离群值
%输入：原始数据和上下边界
%输出：离群值的索引
%% 异常数据识别
Dif_low = x-x_low;
Dif_up = x_up-x;
list_low = find(Dif_low<0);
list_up = find(Dif_up<0);
list_out = [list_low;list_up];

end

