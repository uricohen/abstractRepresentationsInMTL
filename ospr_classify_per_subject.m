load('ospr_colors.mat');


analyses = {'classify_category_from_meanresponse', ...
            'classify_stim_identity'};


fracholdout = 0.5;
nperms = 10; % numer of repartitionings  
algo = 'svm'; % support vector machiens
              % codingscheme = 'onevsone'; % onevsone onevsall ordinal
codingscheme = 'onevsall'; 

% sdo this to get ospr_doclassperm.m to collapse analyses across all regions
regions_(1).name = 'all';


for ai = 1:numel(analyses)

    
    whichAnalysis = analyses{ai};
    
    disp(sprintf('running %s ', whichAnalysis));
    disp(sprintf('using %s with %s coding-scheme', algo, codingscheme));

    disp(sprintf(['Proportion holdout: %.2f, Number of random reparitionings: ' ...
                  '%d'], fracholdout, nperms));


    % https://de.mathworks.com/help/stats/supervised-learning-machine-learning-workflow-and-algorithms.html
    % https://de.mathworks.com/campaigns/products/offer/machine-learning-with-matlab-conf.html?elqsid=1486651073593&potential_use=Education

    %% load data  generated by aggregate_cherries.m, and
    %% ospr_calculate_zscores.m or ospr_calculate_zcores_trials
    %% the rows in X are observations/instances/examples ... i.e., ospr images
    %% the columns are a set of measurments/predictors/features ...i.e,  cells

    if strcmp(whichAnalysis, 'classify_stim_identity')
        datafilename = 'zvals_trials.mat';

        load(datafilename)
        Y = stim_lookup';
        
        ustims = stim_lookup(1:10:1000);
        ustimlabels = cellfun(@(x) strrep(x, '_', ' '), ustims, 'UniformOutput', false);

        ucats = cat_lookup(1:100:1000);
        ucatlabels = cellfun(@(x) strrep(x, '_', ' '), ucats, 'UniformOutput', false);

        
        ulabels = ustims;
        outfn =  'classification_results_stimuli_per_subject.mat';
        
    elseif strcmp(whichAnalysis, 'classify_category_from_meanresponse')
        datafilename = 'zvals.mat';
        load(datafilename)
        Y = cat_lookup';
        
        ustims = stim_lookup;
        ustimlabels = cellfun(@(x) strrep(x, '_', ' '), ustims, 'UniformOutput', false);
        ucats = cat_lookup(1:10:100);
        ucatlabels = cellfun(@(x) strrep(x, '_', ' '), ucats, 'UniformOutput', false);
        
        ulabels = cat_lookup(1:10:100);
        outfn = 'classification_results_categories_frommeanresponse_per_subject.mat';
    end

    X = zvals'; 

    
    %% do the steps suggested in this video for the unit data:
    %https://de.mathworks.com/videos/machine-learning-with-matlab-getting-started-with-classification-81766.html?elqsid=1491471561059&potential_use=Education

    % for reproducability
    rng('default');
    rng(1);
    
    % get N Subjects
    usubj = unique(cluster_lookup.subjid);
    nsubj = numel(usubj);
    
    %% partition into training and test set
    ooserr = NaN(nperms, nsubj); % out of sample errors per
    kappas = NaN(nperms, nsubj); % cohens kappa
    conf = NaN(nperms, nsubj,numel(ulabels), numel(ulabels)); 
    maxtestperf  = fracholdout * numel(Y) * nperms;

    tic
    disp(sprintf('running %d random repartitionsings into training and test set', ...
                 nperms))
    
    for n = 1:nsubj
        
        idx = cluster_lookup.subjid == usubj(n);
        idx = idx & includeUnits;
        
        for np = 1:nperms
            ci = cvpartition(Y, 'holdout', fracholdout);
            [ooserr(np,n) conf(np, n, :, :) kappas(np, n)]= ospr_doclassperm(X,Y,ci,regions_, ...
                                                              cluster_lookup, ...
                                                              ulabels, ...
                                                              algo, ...
                                                              codingscheme, ...
                                                              idx);

        end
        clear idx
    end
    
    toc

    save(outfn,...
         'ooserr', 'conf', 'nperms', 'algo', ...
         'codingscheme', 'ustims', 'ustimlabels', 'ulabels', 'ucatlabels', ...
         'cat_lookup', 'stim_lookup', 'kappas', ...
         'maxtestperf', 'fracholdout','-v7.3', 'includeUnits')
    disp(sprintf('saved %s ', outfn));
    

end