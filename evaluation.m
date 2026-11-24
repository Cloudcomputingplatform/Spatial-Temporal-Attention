function[EVAL] = evaluation(sp,act)
for i = 1:length(sp)
    p = sp{i};
    a = act{i};
    tp =0; tn =0; fp =0; fn =0;
    for j = 1:length(p)
        if a(j) == 1 && p(j) == 1
            tp = tp+1;
        elseif a(j) == 0 && p(j) == 0
            tn = tn+1;
        elseif a(j) == 0 && p(j) == 1
            fp = fp+1;
        elseif a(j) == 1 && p(j) == 0
            fn = fn+1;
        end
    end
    Tp(i) = tp;
    Fp(i) = fp;
    Tn(i) = tn;
    Fn(i) = fn;
end
tp = sum(Tp);
fp = sum(Fp);
tn = sum(Tn);
fn = sum(Fn);
accuracy = (tp+tn)/(tp+tn+fp+fn);
sensitivity = tp/(tp+fn);
specificity = tn/(tn+fp);
precision = tp/(tp+fp);
FPR = fp/(fp+tn);
FNR = fn/(tp+fn);
NPV = tn/(tn+fp);
FDR = fp/(tp+fp);
F1_score = (2*tp)/(2*tp+fp+fn);
MCC = ((tp*tn)- (fp*fn))/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
FOR = fn / (fn + tn);
PT = sqrt(FPR) / (sqrt(sensitivity) + sqrt(sensitivity));
CSI = tp / (tp + tn + fp);
BA = (sensitivity + specificity) / 2;
FM = sqrt(sensitivity * precision);
BM = sensitivity + specificity ;
MK = precision + NPV;
lrplus = tp / FPR;
lrminus = FNR / tn;
DOR = lrplus / lrminus;
Prevalence = (tp + fn) / (tp + tn + fp + fn);
EVAL = [tp tn fp fn accuracy sensitivity specificity precision FPR FNR NPV FDR F1_score MCC FOR PT CSI BA FM BM MK lrplus lrminus DOR Prevalence];

end