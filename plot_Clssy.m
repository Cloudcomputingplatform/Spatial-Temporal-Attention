function[] = plot_Clssy()

load Eval_actual
load Eval_Pred
X = Eval_actual;
Y = Eval_Pred;
X1 = Eval_actual;
Y1 = Eval_Pred;

load Eval_all
Perf_Terms = ["Accuracy"; "Sensitivity"; "Specificity"; "Precision"; "FPR"; "FNR"; "NPV"; "FDR"; "F1-Score"; "MCC";"FOR"; "PT"; "CSI"; "BA"; "FM" ;"BM"; "MK"; "LR+"; "LR-"; "DOR"; "PREVALENCE";];
Learn_per = [1,2,3,4,5];

%% Display Channel Estimation Table
for i = 1:size(Eval_all, 1)
    for j = 1:size(Eval_all{i, 5}, 1)
        Value_R(j, :) = Eval_all{i, 5}(j, 5:end);
    end

    
    Table = table(Perf_Terms, Value_R(1, :)', Value_R(2, :)', Value_R(3, :)', Value_R(4, :)', Value_R(5, :)');
    Table.Properties.VariableNames = {'TERMS', 'DNN','CNN','MBLANet','DU-NET','DCNN-STANet'};
    disp(strcat('------------------------- Dataset - ', num2str(i), ' - Classifier Comparison -------------------------'))
    disp(Table)
end


%% Plot Feature Variation Results
for n = 1:20
    for i = 1:size(Eval_all, 1)
        for j = 1:size(Eval_all, 2)
            for k = 1:size(Eval_all{i, j}, 1)
                if n == 10
                    val_f(j, k) = Eval_all{i, j}(k, n + 4);
                else
                    val_f(j, k) = Eval_all{i, j}(k, n + 4) * 100;
                end
            end
        end
%         val_for_line = val_f(:, 1:5)';
        val_for_bar = val_f(:, 1:5)';
         
        figure,
        bar(Learn_per, val_for_bar, 'Linewidth', 1.5)
        set(gca, 'fontsize', 12);
        grid on;
        xlabel('KFOLD', 'fontsize', 12);
        xticklabels({'1','2','3','4','5'})
        ylabel(char(Perf_Terms{n}), 'fontsize', 12);
        h = legend('DNN','CNN','MBLANet','DU-NET','DCNN-STANet');
        set(h,'fontsize', 12, 'Location', 'bestoutside')
        print('-dtiff', '-r300', ['./Results/', 'bar-', char(Perf_Terms(n)), '-Dataset-', num2str(i)])
    end
end

end

