function [Score,NGO_curve,Best_pos,time]=PROPOSED(X,objective,Lowerbound,Upperbound,Max_iterations)
[Search_Agents,dimensions] = size(X);
tic                          % Upper limit for variables
X=[];
X_new=[];
fit=[];
fit_new=[];
NGO_curve=zeros(1,Max_iterations);
%%

for i =1:Search_Agents
    L=X(i,:);
    fit(i)=objective(L);                    % Fitness evaluation (Explained at the top of the page. )
end
for t=1:Max_iterations  % algorithm iteration
    
    %%  update: BEST proposed solution
    [best , blocation]=min(fit);
    
    if t==1
        xbest=X(blocation,:);                                           % Optimal location
        fbest=best;                                           % The optimization objective function
    elseif best<fbest
        fbest=best;
        xbest=X(blocation,:);
    end
    
    
    
    %% UPDATE Northern goshawks based on PHASE1 and PHASE2
    
    for i=1:Search_Agents
        meanfit = mean(fit);
        worstfit = max(fit);
        currentfit = fit(i);
        %% Phase 1: Exploration
        r = currentfit / (worstfit + (meanfit + currentfit) / 100);
        I=round(1+r);
        k=randperm(Search_Agents,1);
        P=X(k,:); % Eq. (3)
        F_P=fit(k);
        
        if fit(i)> F_P
            X_new(i,:)=X(i,:)+rand(1,dimensions) .* (P-I.*X(i,:)); % Eq. (4)
        else
            X_new(i,:)=X(i,:)+rand(1,dimensions) .* (X(i,:)-P); % Eq. (4)
        end
        X_new(i,:) = max(X_new(i,:),Lowerbound);X_new(i,:) = min(X_new(i,:),Upperbound);
        
        % update position based on Eq (5)
        L=X_new(i,:);
        fit_new(i)=objective(L);
        if(fit_new(i)<fit(i))
            X(i,:) = X_new(i,:);
            fit(i) = fit_new(i);
        end
        %% END PHASE 1
        
        %% PHASE 2 Exploitation
        R=0.02*(1-t/Max_iterations);% Eq.(6)
        X_new(i,:)= X(i,:)+ (-R+2*R*rand(1,dimensions)).*X(i,:);% Eq.(7)
        
        X_new(i,:) = max(X_new(i,:),Lowerbound);X_new(i,:) = min(X_new(i,:),Upperbound);
        
        % update position based on Eq (8)
        L=X_new(i,:);
        fit_new(i)=objective(L);
        if(fit_new(i)<fit(i))
            X(i,:) = X_new(i,:);
            fit(i) = fit_new(i);
        end
        %% END PHASE 2
        
    end% end for i=1:N
    
    %%
    %% SAVE BEST SCORE
    best_so_far(t)=fbest; % save best solution so far
    average(t) = mean (fit);
    Score=fbest;
    Best_pos=xbest;
    NGO_curve(t)=Score;
end
%%
time = toc;
end
