function[fitn] = obj_fun(soln)
global dataset
task_count = [50, 100, 150, 200];
num_machines = 10;
execution_times = zeros(length(task_count), 1);
for i = 1:size(soln,1)  %soln,1
    tic;
    n = task_count(i);
    data = dataset{i};
    sol = soln(i);
    data_array = table2array(data);
    % Generate random values for each attribute
    AvailableMemory = data_array(:,1); % in GB
    AvailableCPU =data_array(:,2); % in cores
    ProcessingTime = data_array(:,3); % in ms
    ReactionTime = data_array(:,4); % in ms
    CPUClockSpeed = data_array(:,5); % in GHz
    PriorityTasks = data_array(:,6); % Priority 1-10 scale
    MemoryRequirement = data_array(:,7); % in GB
    CPURequirement = data_array(:,8); % in cores
    CompletionTime = data_array(:,9); % Completion time in ms
    % Combine all attributes into a table
    data = table(AvailableMemory, AvailableCPU, ProcessingTime, ReactionTime, ...
        CPUClockSpeed, PriorityTasks, MemoryRequirement, CPURequirement, CompletionTime);
    % Allocate tasks to machines in round-robin fashion
    machine_task_allocation = sol;
    % Calculate execution time per machine
    total_machine_time = zeros(num_machines, 1);
    for j = 1:num_machines
        tasks_on_machine = (machine_task_allocation == j);
        total_machine_time(j) = sum(CompletionTime(tasks_on_machine)); % Sum of completion times for tasks
    end
    % Store total execution time (maximum of all machine times)
    execution_times(i) = max(total_machine_time);
    % Append the dataset with task allocation information
    Task_Allocated{i} = machine_task_allocation';
    time = toc;
    fitn(i) = time;
end
end

