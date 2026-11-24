function [best_fitness,Convergence_curve ,best_position,time] = DSOA(positions,objFunc,lb,ub,maxEpochs)
[numDoves,dim] = size(positions);
% Algorithm parameters
lambda = 0.9;         % Satiety weight factor
eta = 0.18;           % Learning rate
satiety = zeros(1, numDoves);   % Initialize satiety levels for each dove
% Evaluate initial fitness for each dove
fitness = arrayfun(@(i) feval(objFunc,positions(:,i)), 1:numDoves);
[best_fitness, best_idx] = min(fitness);  % Find best initial solution
best_position = positions(:, best_idx);
Convergence_curve=zeros(1, Max_iter);% Position of best solution
tic;
% Main DSO loop
for epoch = 1:maxEpochs
    % Update each dove's satiety level
    for i = 1:numDoves
        satiety(i) = lambda * satiety(i) + fitness(i) - best_fitness;
    end
    
    % Select the dove with the highest satiety to be the "best" dove
    [~, best_satisfied_idx] = max(satiety);
    best_satisfied_position = positions(:, best_satisfied_idx);
    
    % Update positions of doves based on the best satisfied dove
    for i = 1:numDoves
        dist = norm(positions(:,i) - best_satisfied_position);
        max_dist = max(vecnorm(positions - best_satisfied_position));
        
        % Update equation based on satiety and distance
        beta = (satiety(best_satisfied_idx) - satiety(i)) / satiety(best_satisfied_idx);
        beta = beta * (1 - dist / max_dist);
        
        % Position update
        positions(:,i) = positions(:,i) + eta * beta * (best_satisfied_position - positions(:,i));
        
        % Ensure positions are within bounds
        positions(:,i) = max(lb, min(positions(:,i), ub));
        
        % Evaluate new fitness
        fitness(i) = feval(objFunc,positions(:,i));
    end
    
    % Update global best
    [current_best_fitness, best_idx] = min(fitness);
    if current_best_fitness < best_fitness
        best_fitness = current_best_fitness;
        best_position = positions(:, best_idx);
    end
    
    % Termination condition (for minimal fitness change)
    if abs(best_fitness - current_best_fitness) < 1e-6
        break;
    end
    Convergence_curve(epoch) = best_fitness;
end
time = toc;
end
