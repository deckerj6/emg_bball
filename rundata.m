
%% rundata.m
% Jeremy Decker
% 4/5/2021
% Run a recording session for the EMG data. 
clear 
clc
close all

% connect arduino
a = arduino();
% Define other variables
sampleTime = 300;

% call pressureSensor function
[data] = emgSensor(a, sampleTime);

% save pressureSensor output table to a csv in your data folder
% I changed the name of this file for each collection period. 
writetable(data,'C:\Users\kamil\Documents\emgSensorData.csv')

% plot voltage over time
figure
if (data.win >= 0)
    s = sprintf('Your Score: %f', data.win);
    hF = figure; set(hF, 'color', [1 1 1])
    hA = axes; set(hA, 'color', [1 1 1], 'visible', 'off')
    text(0.5,0.5,s)
end
figure
subplot(2,1,1);
plot(data.time,data.voltage)
subplot(2,1,2);
plot(data.time,data.norm_voltage)