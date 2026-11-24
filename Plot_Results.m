function [] = Plot_Results()
clc;
clear all;
close all;
warning off;


ca = {'Best','Worst','Mean','Median','Std_dev'};
%% Convergence
Algms = {'Dsoa','Gro','Cjo','Ngo', 'Prop'};
for var = 1:4 % For all  variations
    for i = 1 : 5 % For all agorithms
        eval(['load ', char(Algms{i})])
        eval(['val(i, :) = ', char(Algms{i}), '(var).fit;'])
    end
       
     ind = find(val(:, end) == min(val(:, end)));
    t = val(5, :);
    val(5, :) = val(ind(1), :);
    val(ind(1), :) = t;
    for i = 1 : 5
%         stat(i, :) = Statistical_Analysis(val(i, :));
        a1{i} = Statistical_Analysis(val(i, :));
    end
    
    fprintf('Statistical Report: %d\n',var)
    ca = {'Best','Worst','Mean','Median','Std_dev'};
    T = table(a1{1}',a1{2}',a1{3}',a1{4}',a1{5}','Rownames',ca);
    T.Properties.VariableNames = {'DSOA','GRO','CJO','NGO', 'RNR-NGOA'};
    disp(T)   
    
    figure,
    plot(val(1, :), 'r', 'LineWidth', 2)
    hold on;
    plot(val(2, :), 'g', 'LineWidth', 2)
    plot(val(3, :), 'b', 'LineWidth', 2)
    plot(val(4, :), 'm', 'LineWidth', 2)
    plot(val(5, :), 'c', 'LineWidth', 2)
    set(gca, 'fontsize', 12);
    grid on;
    xlabel('Iteration', 'fontsize', 12);
    
    ylabel('Cost Function', 'fontsize', 12);
    h = legend('DSOA','GRO','CJO','NGO', 'RNR-NGOA');
    set(h, 'fontsize', 12, 'Location', 'NorthEastOutside')
    print('-dtiff', '-r300', ['./Results/Convergence_', num2str(var)])
end


load Res

Stats = {'BEST', 'WORST', 'MEAN', 'MEDIAN', 'STD'};
Terms = { 'Workflow Execution Time'; 'Total Energy Consumption'; 'Cost'; 'Throughput'; 'Delay'; 
                        'Time'; 'Load'; 'Makespan';'Residual Energy'};


  
 
for i = 1:5
    for j = 1:5
        Outs{i}(j, :) = Res(i).out{j};
    end
    Outs{i}(isinf(Outs{i})|isnan(Outs{i})) = 0;
end

Positive = [4,8,9];

for i = 1:length(Terms)
    for j = 1:length(Outs)
        if length(find(ismember(i, Positive))) >= 1
            Statistics(j, 1) = max(Outs{j}(:, i));
            Statistics(j, 2) = min(Outs{j}(:, i));
            Statistics(j, 3) = mean(Outs{j}(:, i));
            Statistics(j, 4) = median(Outs{j}(:, i));
            Statistics(j, 5) = std(Outs{j}(:, i));
        else
            Statistics(j, 1) = min(Outs{j}(:, i));
            Statistics(j, 2) = max(Outs{j}(:, i));
            Statistics(j, 3) = mean(Outs{j}(:, i));
            Statistics(j, 4) = median(Outs{j}(:, i));
            Statistics(j, 5) = std(Outs{j}(:, i));
        end
    end

    for j = 1:size(Statistics, 2)
        if length(find(ismember(i, Positive))) >= 1
            [a, b] = max(Statistics(:, j));
        else
            [a, b] = min(Statistics(:, j));
        end
        x = Statistics(b, j);
        y = Statistics(end, j);
        Statistics(end, j) = x;
        Statistics(b, j) = y;
    end

    disp(strcat(char(Terms{i}), " Statistical Report --------------------"))
    T = table(char(Stats), Statistics(1, :)', Statistics(2, :)', Statistics(3, :)', Statistics(4, :)', Statistics(5, :)');
    T.Properties.VariableNames = {'Statistics','DSOA','GRO','CJO','NGO', 'RNR-NGOA'};
    disp(T)
end


X = 1:4;

% Define colors and markers for better reuse
colors = {'r', 'g', 'b', 'm', 'k'};
lineStyles = {'-', '-', '-', '-', '-'};
markers = {'s', 's', 's', 's', 's'};
legendLabels = {'DSOA', 'GRO', 'CJO', 'NGO', 'RNR-NGOA'};

% Loop through all Terms
for i = 1:length(Terms)
    % Initialize Plt_Vaues outside of the loop
    sortedValues = NaN(5, 4);

    % Sort Outs for each j and store in sortedValues
    for j = 1:5
        sortedValues(j, :) = sort(Outs{j}(X, i));
    end

    % Swap values based on Positive condition
    for j = 1:size(sortedValues, 2)
        if any(ismember(i, Positive))  % More efficient condition check
            [a, b] = max(sortedValues(:, j));  % If Positive, take max
        else
            [a, b] = min(sortedValues(:, j));  % If not, take min
        end
        % Swap the values for min/max logic
        temp = sortedValues(b, j);
        sortedValues(b, j) = sortedValues(end, j);
        sortedValues(end, j) = temp;
    end

    % Plot the results
    Learn_per = [1,2,3,4];
    figure;
    hold on;
    for j = 1:5
        plot(Learn_per, sortedValues(j, :), 'Color', colors{j}, 'LineWidth', 2, ...
            'Marker', markers{j}, 'MarkerSize', 10, 'LineStyle', lineStyles{j});
    end
    hold off;

    % Set plot aesthetics
    set(gca, 'FontSize', 12);
    grid on;
    xlabel('No Of Tasks', 'FontSize', 12);
    xticks([1, 2, 3, 4]);
    xticklabels({'50', '100', '150', '200'});
    ylabel(char(Terms{i}), 'FontSize', 12);

    % Add a legend
    h = legend(legendLabels);
    set(h, 'FontSize', 12, 'Location', 'NorthEastOutside');

    % Save the figure
    saveas(gcf, fullfile('.\Results\', char(Terms{i})), 'tiff');
end



end
function[a] = Statistical_Analysis(val)
a(1) = min(val);
a(2) = max(val);
a(3) = mean(val);
a(4) = median(val);
a(5) = std(val);
end