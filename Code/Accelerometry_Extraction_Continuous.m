%%%% Script to extract Accelerometry data and jerk using 3-axis accelerometer
%%%% voltages from a .continuous data file
%%%% code does not trim data
%%%% produces 2 plots: smoothed accelerometry and smoothed jerk over time


%%% Adjust the following values as needed:

Aux_file = 100; % Auxillary channel where voltage data is recorded
original_sample_rate = 30000;
desired_sample_rate = 10;
smoothing_kernel_width = 60;  

%%
rawdata2 = cell(1,3);
for i=1:3

    [rawdata2{:,i}, timestamps] = load_open_ephys_data([num2str(Aux_file),'_AUX', num2str(i),'.continuous']);
  
end
rawdata = cell2mat(rawdata2);
data_len = size(rawdata, 1); 

Acc = sqrt(rawdata(:,1).^2+rawdata(:,2).^2+rawdata(:,3).^2);

[p,q] = rat(desired_sample_rate/original_sample_rate);
t_start = min(timestamps);
Acc_rs = resample(Acc,p,q);
time_new = (0:numel(Acc_rs)-1)/desired_sample_rate+t_start;
time_rs = time_new';
rs_min = min(Acc_rs);
Acc_new = Acc_rs - rs_min;

diffAcc = abs(Acc_new(2:end)-Acc_new(1:end-1));
diffAcc(length(diffAcc)+1,1) = diffAcc(end);

acc_smoothed = smoothdata(Acc_new,'gaussian',smoothing_kernel_width);
accjerk_smoothed = smoothdata(diffAcc,'gaussian',smoothing_kernel_width);

figure(1)
plot(time_rs,acc_smoothed)
title('Smoothed Acceleration Score')
xlabel('Time')
ylabel('Acceleration Score')

figure(2)
plot(time_rs,accjerk_smoothed)
title('Smoothed Acceleration Jerk')
xlabel('Time')
ylabel('Acceleration Score Jerk')





