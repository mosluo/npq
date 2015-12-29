clear all;

rng(12345);

disp(sprintf ( 'Starting run \n') )

RunObj=initialise();                       % Initialise parameters for run
RunObj.params.modelsToRun=[2];

alphasArray=RunObj.params.ALPHAS_ARRAY;

for i=1:size(RunObj.params.NBITS_ARRAY,2)
    
    RunObj.params.NBITS=RunObj.params.NBITS_ARRAY(:,i);

    for j=1:size(RunObj.params.NAFFINITY_ARRAY,2)
        
        RunObj.params.NAFFINITY=RunObj.params.NAFFINITY_ARRAY(:,j);

        for k=1:size(RunObj.params.ALPHAS_ARRAY,2)
                   
            RunObj=clear_results(RunObj);
            RunObj=make_res_dir(RunObj);
            RunObj.params.NPQ_ALPHA=alphasArray(1,k);

            for l=1:RunObj.params.NRUNS
                
                RunObj=load_data(RunObj);  % Load the object representing the run configuration
                RunObj=preprocess(RunObj,l);
                
                [RunObj, bitsSBQ] = get_baseline(RunObj);
                
                %%%%%% SBQ baseline
                if ~isempty(find(RunObj.params.modelsToRun==1))
                    
                    RunObj=compute_sbq(RunObj,bitsSBQ, l);
                    
                end

                %%%%%% NPQ baseline
                if ~isempty(find(RunObj.params.modelsToRun==2))
                    
                    RunObj = compute_npq(RunObj, l);
                    
                end
            end
            
            save_results(RunObj)
        end
    end
end