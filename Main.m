function[] = Main_24_09_24()
clc;
clear all;
close all;
warning off;

global dataset

% Read Dataset1
an = 0;
if an == 1
    fname = './Dataset/Dataset1/cloud_data/rsscn7/train_dataset/';
    dir_list = dir(fullfile(fname, '*'));
    dir_list = dir_list([dir_list.isdir]); % Get only directories
    Images_1 = {};
    Target = {};
    
    for i = 1:length(dir_list)
        file = fullfile(fname, dir_list(i).name);
        dir_list1 = dir(fullfile(file, '*'));
        dir_list1 = dir_list1(~[dir_list1.isdir]); % Get only files
        
        for j = 1:length(dir_list1)
            i,j
            file1 = fullfile(file, dir_list1(j).name);
            read = imread(file1);
            read = imresize(read, [128, 128]);
            Images_1{end+1} = read;
            Target{end+1} = dir_list(i).name;
        end
    end
    
    Target = string(Target);
    Uni = unique(Target);
    Target_1 = zeros(length(Target), length(Uni));
    
    for i = 1:length(Uni)
        ind = strcmp(Target, Uni(i));
        Target_1(ind, i) = 1;
    end
    
    save('Images_1.mat', 'Images_1');
    save('Target_1.mat', 'Target_1');
end

% Read Dataset2
an = 1;
if an == 1
    fname = './Dataset/Dataset2/AID/';
    dir_list = dir(fullfile(fname, '*'));
    dir_list = dir_list([dir_list.isdir]); % Get only directories
    Images_2 = {};
    Target = {};
    
    for i = 1:length(dir_list)
        file = fullfile(fname, dir_list(i).name);
        dir_list1 = dir(fullfile(file, '*'));
        dir_list1 = dir_list1(~[dir_list1.isdir]); % Get only files
        
        for j = 1:length(dir_list1)
            i,j
            file1 = fullfile(file, dir_list1(j).name);
            read = imread(file1);
            read = imresize(read, [128, 128]);
            Images_2{end+1} = read;
            Target{end+1} = dir_list(i).name;
        end
    end
    
    Target = string(Target);
    Uni = unique(Target);
    Target_2 = zeros(length(Target), length(Uni));
    
    for i = 1:length(Uni)
        ind = strcmp(Target, Uni(i));
        Target_2(ind, i) = 1;
    end
    
    save('Images_2.mat', 'Images_2');
    save('Target_2.mat', 'Target_2');
end


% Initialization  Attributes
an = 0;
if an == 1
    task_count = [50, 100, 150, 200]; % Number of tasks
    dataset = {};

    % Loop over different task counts
    for i = 1:length(task_count)
        n = task_count(i);
        % Generate random values for each attribute
        AvailableMemory = randi([8, 64], n, 1); % in GB
        AvailableCPU = randi([2, 16], n, 1); % in cores
        ProcessingTime = randi([1, 100], n, 1); % in ms
        ReactionTime = randi([1, 50], n, 1); % in ms
        CPUClockSpeed = randi([1, 5], n, 1); % in GHz
        PriorityTasks = randi([1, 10], n, 1); % Priority 1-10 scale
        MemoryRequirement = randi([1, 8], n, 1); % in GB
        CPURequirement = randi([1, 8], n, 1); % in cores
        CompletionTime = ProcessingTime + randi([5, 50], n, 1); % Completion time in ms

        % Combine all attributes into a table
        data = table(AvailableMemory, AvailableCPU, ProcessingTime, ReactionTime, ...
            CPUClockSpeed, PriorityTasks, MemoryRequirement, CPURequirement, CompletionTime);

        % Append to the final dataset
        dataset{i} =  data;
    end
    save dataset dataset
end

% Classification
an = 0;
if an == 1
    load Images_1;
    load Images_2;
    load Target_1;
    load Target_2;
    k_fold = 5;
    for a = 1:2 % for 2 Datasets
        if a == 1
            Images = Images_1;
            Target = Target_1;
        else
            Images =Images_2;
            Target =Target_2;
        end
        for i = 1:k_fold
            Eval = zeros(5, 23);
            Total_Index = 1:size(Images, 2);
            Test_index = ((i - 1) * (size(Images, 2) / k_fold) + 1) : (i * (size(Images, 2) / k_fold));
            Train_Index = setdiff(Total_Index, Test_index);
            Train_Data = Images(Train_Index);
            Test_Data = Images(round(Test_index));
            Train_Target = Target(Train_Index);
            Test_Target = Target(round(Test_index));
            
            % Assuming you have the respective models defined
            Eval_all{a,i,1} = Model_DNN(Train_Data, Train_Target, Test_Data, Test_Target);
            Eval_all(a,i,2) = Model_CNN(Train_Data, Train_Target, Test_Data, Test_Target);
            Eval_all(a,i,3) = Model_CNN_AM(Train_Data, Train_Target, Test_Data, Test_Target);
            Eval_all(a,i,4) = Model_DU_NET(Train_Data, Train_Target, Test_Data, Test_Target);
            Eval_all(a,i,5) = Model_DilCNN-STANet(Train_Data, Train_Target, Test_Data, Test_Target);         
        end
    end
    
    save Eval_all Eval_all
end

%% Optimization for Task Allocation %%
an = 0;
if an == 1
    load dataset
    task_count = [50, 100, 150, 200];     
    for i = 1 :length(task_count)           
        Npop = 10;
        Chlen = task_count(i);
        xmin = zeros(Npop,Chlen);  % Minimum bound
        xmax = ones(Npop,Chlen);   % Maximum bound
        initsol = xmin + (xmax-xmin).*rand(Npop,Chlen); 
        itermax = 250;
        funct_name = 'obj_fun';

        %% Transfering data by various algorithm
        disp('DSOA')
        [bestfit,fitness,bestsol,time] = DSOA(initsol,funct_name,xmin,xmax,itermax);
        Dsoa(i).bf = bestfit; Dsoa(i).fit= fitness; Dsoa(i).bs = bestsol; Dsoa(i).ct = time;
        save Dsoa Dsoa

        disp('GRO')
        [bestfit,fitness,bestsol,time] = GRO(initsol,funct_name,xmin,xmax,itermax);
        Gro(i).bf = bestfit; Gro(i).fit= fitness; Gro(i).bs = bestsol; Gro(i).ct = time;
        save Gro Gro

        disp('GJO')
        [bestfit,fitness,bestsol,time] = GJO(initsol,funct_name,xmin,xmax,itermax);
        Cjo(i).bf = bestfit; Cjo(i).fit= fitness'; Cjo(i).bs = bestsol; Cjo(i).ct = time;
        save Cjo Cjo

        disp('NGO')
        [bestfit,fitness,bestsol,time] = NGO(initsol,funct_name,xmin,xmax,itermax);
        Ngo(i).bf = bestfit; Ngo(i).fit= fitness; Ngo(i).bs = bestsol; Ngo(i).ct = time;
        save Ngo Ngo

        disp('PROPOSED')
        [bestfit,fitness,bestsol,time] = PROPOSED(initsol,funct_name,xmin,xmax,itermax);
        Prop(i).bf = bestfit; Prop(i).fit= fitness'; Prop(i).bs = bestsol; Prop(i).ct = time;
        save Prop Prop
    end
end

% Task allocation
an = 0;
if an == 1
    load dataset
    load Prop
    task_count = [50, 100, 150, 200];
    num_machines = 10;
    execution_times = zeros(length(task_count), 1); % Store total execution times
    % Loop over different task counts
    for i = 1:length(task_count)
        n = task_count(i);
        data = dataset{i};
        sol = Prop(i);
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
    end
    save Task_Allocated Task_Allocated
end

Plot_Results()
plot_Clssy()
end


