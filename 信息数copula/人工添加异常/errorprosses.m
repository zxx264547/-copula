function errorData = errorprosses(voltage,current,irradiance,temperature)
% 添加位于二维散点图上方的错误数据
num_errors = 100; % 错误数据点的数量
high_voltage =max(voltage) +  100 * rand(num_errors,1); % 异常高电压
high_temperature=min(temperature) +  (max(temperature)-min(temperature)) * rand(num_errors,1);%异常高电压对应温度
high_current = max(current) +  100 * rand(num_errors,1); % 异常高电流
high_irradiance=min(irradiance) +  (max(irradiance)-min(irradiance)) * rand(num_errors,1);%异常高电流对应辐照度
voltage=[voltage;high_voltage];
irradiance = [irradiance;high_irradiance];
temperature = [temperature;high_temperature];
current = [current;high_current];
% 添加为零的错误数据
zero_voltage = 0.5*rand(num_errors,1); 
zero_current = 0.5*rand(num_errors,1); 
zero_temperature=min(temperature) +  (max(temperature)-min(temperature)) * rand(num_errors,1);
zero_irradiance=min(irradiance) +  (max(irradiance)-min(irradiance)) * rand(num_errors,1);%异常高电流对应辐照度
voltage=[voltage;zero_voltage];
irradiance = [irradiance;zero_irradiance];
temperature = [temperature; zero_temperature];
current = [current;zero_current];

% 添加位于二维散点图内部的错误数据
inter_voltage = min(voltage) +  (max(voltage)-min(voltage)) * rand(num_errors,1);
inter_temperature=min(temperature) +  (max(temperature)-min(temperature)) * rand(num_errors,1);
inter_current = min(current) +  (max(current)-min(current)) * rand(num_errors,1);
inter_irradiance=min(irradiance) +  (max(irradiance)-min(irradiance)) * rand(num_errors,1);%异常高电流对应辐照度
voltage=[voltage;inter_voltage];
irradiance = [irradiance;inter_irradiance];
temperature = [temperature; inter_temperature];
current = [current; inter_current];

% 添加位于二维散点图下方的错误数据
low_voltage = min(voltage) -  100 * rand(num_errors,1);
low_temperature=min(temperature) +  (max(temperature)-min(temperature)) * rand(num_errors,1);
low_current =min(current) -  100 * rand(num_errors,1); 
low_irradiance=min(irradiance) +  (max(irradiance)-min(irradiance)) * rand(num_errors,1);
voltage=[voltage;low_voltage];
irradiance = [irradiance; low_irradiance];
temperature = [temperature; low_temperature];
current = [current; low_current];

errorData=[voltage,current,irradiance,temperature];