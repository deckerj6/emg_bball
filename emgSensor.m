%% emgSensor.m

function [data] = emgSensor(a, gameTime)
    %INPUTS:
    % a: arduino
    % gameTime: time(seconds) to run the function
    % calibration: True/False
    %% Initialize Variables
    timeVec = [];
    voltageVec = [];
    lowcal = [];
    midcal = [];
    hical = [];
    
    %% Calibration Block
    disp("Starting Calibration")
    disp("Calibration Part 1: Fully Extended Arm")
    disp("Press Enter to Start Calibration Part 1...")
    while getkey ~= 13
    end
    i=1;
    tic
    while toc < 3
        voltage = readVoltage(a, 'A0');
        lowcal(i) = voltage;
        i=i+1;
    end
    disp("Calibration Part 2: Half Flexed Arm")
    disp("Press Enter to Start Calibration Part 2")
    while getkey ~=13
    end
    i = 1;
    tic 
    while toc < 3
        voltage = abs(readVoltage(a, 'A0')); % Track the rectified signal only
        midcal(i) = voltage;
        i = i+1;
    end 
    disp("Calibration Part 3: Fully Flexed Arm")
    disp("Press Enter to Start Calibration Part 3")
    while getkey ~=13
    end
    i = 1;
    tic 
    while toc < 3
        voltage = readVoltage(a, 'A0');
        hical(i) = voltage;
        i = i+1;
    end 
    disp("Calculating Calibration Curves")
    lowmean = mean(lowcal);
    midmean = mean(midcal);  
    himean = mean(hical);
    p = polyfit([lowmean, midmean, himean], [0,0.5,1],1);
    % This is used in the normalized output. 
    disp("Approximate Middle Value:")
    disp((midmean-p(2))/p(1))
    
    
    %% Recording Block
    % Set the time to a particular set of times or whatever, adjust the
    % data as you go for the liveplot. 
    disp("Calibration Complete, please press enter to start the game")
    win = 0;
    while getkey ~=13
    end
    h = animatedline;
    time = 0;
    window = 10;
    axis([time-window,time+window,4.0,5.3]);
    xlabel('Elapsed Time (seconds)')
    ylabel('Voltage (V)')
    i = 1;
    tic
    while toc < 10
      voltage = readVoltage(a, 'A0');
      time = toc;
      timeVec(i) = time;
      voltageVec(i) = voltage;
      norm_voltage(i) = (voltage-p(2))/p(1);
      addpoints(h, time,norm_voltage);
      drawnow
      plot(time, voltageVec(i), '.r', 'MarkerSize', 100);
      hold on;
      plot(timeVec(i), 5.15, '-s', 'MarkerSize', 100, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'w', 'LineWidth', 2);
      hold on;
      plot(timeVec(i), 5.08, '-s', 'MarkerSize', 40, 'MarkerEdgeColor', 'k', 'LineWidth', 2);
      hold on;
      plot(timeVec(i), 5.0, 'o', 'MarkerSize', 30, 'MarkerEdgeColor', 'red', 'LineWidth', 2);
      hold off;
      axis([time-window,time+window,4.0,5.3]);
      set(gca, 'Visible', 'off')

      if (voltageVec(i) > 4.9)
           win = win + 1;
      end
      i = i+1;
    end
    % Write Recorded Data to a file. 
    data = table(timeVec, voltageVec, norm_voltage, win, 'VariableNames', {'time', 'voltage', 'norm_voltage', 'win'});
end
      
      
      
    
    