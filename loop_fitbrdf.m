%% Loop through two fits 
% Step 1: Start from alphau = 0.2, fit ro_s and ro_d
% Step 2: Get the XBest from above fit and fix them, fit only alphau
function loop_fitbrdf(iter)

% iter = 5;
setGlobalalpha(0.2);

% init 2 param fitting
LB_2 = [0.001; 0.001];
UB_2 = [1.0; 1.0];
NumDiv_2 = [5 5];
MinDeltaX_2 = [1e-5 1e-5];

% init 1 param fitting
LB_1 = 0.001;
UB_1 = 1.0;
NumDiv_1 = 5;
MinDeltaX_1 = 1e-5;

bestRhos = [];
bestAlphas = [];
bestfit_2pr = [];
bestfit_1pr = [];

fitname = '30percent_try1.mat'
for i = 1:iter
    
    [XBest2,BestF2,Iters2] = Grid_Search(2, LB_2', UB_2', NumDiv_2, MinDeltaX_2, 1e-7, 1000, 'renderIm_2params');
    sprintf('This is XBest2:');
    XBest2;
    setGlobalros(XBest2(1))
    setGlobalrod(XBest2(2))
    bestRhos = [bestRhos;XBest2];
    bestfit_2pr = [bestfit_2pr;BestF2];
    sprintf('Fix rho_s: %f and rho_d: %f and fit alpha',XBest2(1),XBest2(2));
    [XBest1,BestF1,Iters1] = Grid_Search(1, LB_1, UB_1, NumDiv_1, MinDeltaX_1, 1e-7, 1000, 'renderIm_1params');
    sprintf('This is best alpha: %f',XBest1);
    setGlobalalpha(XBest1(1))
    bestAlphas = [bestAlphas;XBest1];
    bestfit_1pr = [bestfit_1pr;BestF1];
    sprintf('Fix alphau: %f and fit rho_s and rho_d', XBest1);
    imname = strcat('/scratch/gk925/hpc_brdf_fitting30/fit_results/multispectral/', fitname);
    save(imname, 'bestRhos','bestAlphas','bestfit_2pr','bestfit_1pr');

    
end

return;
