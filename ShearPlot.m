clc
%US is a column vector of the US power used for each bond
%SS is a column vector of the shear strength measured for each bond
% rmout = excludedata(US,SS,'indices',[11])
SFit = fitlm(US, SS);
% ,'Exclude',rmout);

%Change as required
SSTarget = 120;

%Main parts of plot
figure;
hold on;
plot(SFit);
xlabel('US Power (%)');
ylabel('Shear Strength (MPa)');
title('');

%Calculate US and confidence intervals for target shear strength
USEval = linspace(min(US), max(US), 500)';
[SSPred, SSConf] = predict(SFit, USEval);
SSConfWindow = SSConf(:,1) <= SSTarget & SSConf(:,2) >= SSTarget;
SSConfUS = USEval(SSConfWindow);
[~, USTargetIndex] = min(abs(SSTarget - SSPred));
USTarget = USEval(USTargetIndex);

%Mark results on plot
xLim = get(gca, 'xlim');
yLim = get(gca, 'ylim');
plot([min(SSConfUS) min(SSConfUS)], [yLim(1) SSTarget], 'g:', 'HandleVisibility','off');
plot([max(SSConfUS) max(SSConfUS)], [yLim(1) SSTarget], 'g:', 'HandleVisibility','off');
plot([USTarget USTarget], [yLim(1) SSTarget], 'm', 'HandleVisibility','off');
plot([xLim(1) USTarget], [SSTarget SSTarget], 'm', 'HandleVisibility','off');
plot(USTarget, SSTarget, 'mo', 'HandleVisibility','off');
xLim = get(gca, 'xlim');
set(gca, 'xlim', [xLim(1) - 1, xLim(2) + 1]);