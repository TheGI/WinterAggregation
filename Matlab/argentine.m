PathName = uigetdir;
PathName = [PathName '/'];
FileList=dir([PathName '*.csv']);
%%
fileinfo = struct(...
    'type', {}, ...
    'date', {});

for ii = 1:numel(FileList)
    NameParts = strsplit(FileList(ii).name,{'_','.'});
    fileinfo(end+1).type = NameParts{1};
    fileinfo(end).date = NameParts{2};
    fileinfo(end).fullname = FileList(ii).name;
end

%%
datainfo = struct('date',{},...
    'aggrnum',{},...
    't_start',{},...
    't_stop',{},...
    'winter',{},...
    'numup',{},...
    'numdown',{},...
    'speedup',{},...
    'speeddown',{},...
    'numup_sd',{},...
    'numdown_sd',{},...
    'speedup_sd',{},...
    'speeddown_sd',{},...
    'temperature',{},...
    'humidity',{},...
    'light',{});

ind_fcc = find(strcmp({fileinfo(:).type},'antData'));
[uq_date, uq_date_ind] = unique({fileinfo(ind_fcc).date});
for ii = 1:length(uq_date)
    dd = uq_date(ii);
    envind = find(strcmp({fileinfo(:).type},'envData') & strcmp({fileinfo(:).date}, dd));
    Tenv = readtable([PathName fileinfo(envind).fullname],...
        'Delimiter',',','ReadVariableNames',true);
    antind = find(strcmp({fileinfo(:).type},'antData') & strcmp({fileinfo(:).date}, dd));
    Tant = readtable([PathName fileinfo(antind).fullname],...
        'Delimiter',',','ReadVariableNames',true);
    Tant.numup = str2double({Tant.numup{:}})';
    Tant.numdown = str2double({Tant.numdown{:}})';
    Tant.speedup = str2double({Tant.speedup{:}})';
    Tant.speeddown = str2double({Tant.speeddown{:}})';
    
    for jj = 1:16:length(Tant.numup)
        datainfo(end+1).date = dd;
        datainfo(end).aggrnum = Tant.aggrnum(jj);
        datainfo(end).t_start = Tant.t_start(jj);
        datainfo(end).t_stop = Tant.t_stop(jj);
        if Tant.winter(jj) > 0
            datainfo(end).winter = 1;
        else
            datainfo(end).winter = 0;
        end
        datainfo(end).temperature = nanmean(Tenv.temperature(Tenv.time >= ...
            Tant.t_start(jj) & Tenv.time <= Tant.t_stop(jj)));
        datainfo(end).humidity = nanmean(Tenv.humidity(Tenv.time >= ...
            Tant.t_start(jj) & Tenv.time <= Tant.t_stop(jj)));
        datainfo(end).light = nanmean(Tenv.light(Tenv.time >= ...
            Tant.t_start(jj) & Tenv.time <= Tant.t_stop(jj)));
        
        datainfo(end).numup = nanmean(Tant.numup(jj:jj+15));
        datainfo(end).numdown = nanmean(Tant.numdown(jj:jj+15));
        datainfo(end).speedup = nanmean(Tant.speedup(jj:jj+15));
        datainfo(end).speeddown = nanmean(Tant.speeddown(jj:jj+15));
        datainfo(end).numup_sd = nanstd(Tant.numup(jj:jj+15));
        datainfo(end).numdown_sd = nanstd(Tant.numdown(jj:jj+15));
        datainfo(end).speedup_sd = nanstd(Tant.speedup(jj:jj+15));
        datainfo(end).speeddown_sd = nanstd(Tant.speeddown(jj:jj+15));
    end
end

datatable = struct2table(datainfo);
%%
uq_date = unique([datainfo.date]);
uq_aggr = unique([datainfo.aggrnum]);


h1 = figure;
h2 = figure;
h3 = figure;
h4 = figure;
h5 = figure;
h6 = figure;
h7 = figure;
h8 = figure;
h9 = figure;
h10 = figure;
h11 = figure;
h12 = figure;
h13 = figure;
h14 = figure;
h15 = figure;
h16 = figure;
h17 = figure;

f1 = fopen([PathName 'Temperature_vs_ForagingRateUp.csv'],'w');
f2 = fopen([PathName 'Temperature_vs_ForagingRateDown.csv'],'w');
f3 = fopen([PathName 'Temperature_vs_IndividualSpeedUp.csv'],'w');
f4 = fopen([PathName 'Temperature_vs_IndividualSpeedDown.csv'],'w');
f5 = fopen([PathName 'Humidity_vs_ForagingRateUp.csv'],'w');
f6 = fopen([PathName 'Humidity_vs_ForagingRateDown.csv'],'w');
f7 = fopen([PathName 'Humidity_vs_IndividualSpeedUp.csv'],'w');
f8 = fopen([PathName 'Humidity_vs_IndividualSpeedDown.csv'],'w');
f9 = fopen([PathName 'Light_vs_ForagingRateUp.csv'],'w');
f10 = fopen([PathName 'Light_vs_ForagingRateDown.csv'],'w');
f11 = fopen([PathName 'Light_vs_IndividualSpeedUp.csv'],'w');
f12 = fopen([PathName 'Light_vs_IndividualSpeedDown.csv'],'w');
f13 = fopen([PathName 'Winter_vs_ForagingRateUp.csv'],'w');
f14 = fopen([PathName 'Winter_vs_ForagingRateDown.csv'],'w');
f15 = fopen([PathName 'Winter_vs_Temperature.csv'],'w');
f16 = fopen([PathName 'Winter_vs_Humidity.csv'],'w');
f17 = fopen([PathName 'Winter_vs_Light.csv'],'w');

fprintf(f1,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f2,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f3,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f4,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f5,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f6,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f7,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f8,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f9,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f10,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f11,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f12,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f13,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f14,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f15,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f16,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f17,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');

for ii = 1:length(uq_date)
    dd = uq_date{ii};
    for jj = 1:length(uq_aggr)
        aa = uq_aggr(jj);
        index = strcmp([datainfo.date],dd) & [datainfo.aggrnum] == aa;
        
        % Temperature vs. Num Up
        X = [datainfo(index).temperature]';
        Y = [datainfo(index).numup]'/30;
        test = fitlm(X,Y);
        figure(h1);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Temperature vs. Foraging Rate Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Temperature vs. Foraging Rate Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Foraging Rate Up (ants/sec)','FontSize',8);
        xlabel('Avg. Temperature (C)','FontSize',8);
        fprintf(f1,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        % Temperature vs. Num Down
        X = [datainfo(index).temperature]';
        Y = [datainfo(index).numdown]'/30;
        test = fitlm(X,Y);
        figure(h2);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Temperature vs. Foraging Rate Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Temperature vs. Foraging Rate Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Foraging Rate Down (ants/sec)','FontSize',8);
        xlabel('Avg. Temperature (C)','FontSize',8);
        fprintf(f2,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % Temperature vs. Speed Up
        X = [datainfo(index).temperature]';
        Y = [datainfo(index).speedup]';
        test = fitlm(X,Y);
        figure(h3);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Temperature vs. Indiviudal Speed Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Temperature vs. Individual Speed Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Individual Speed Up (cm/sec)','FontSize',8);
        xlabel('Avg. Temperature (C)','FontSize',8);
        fprintf(f3,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % Temperature vs. Speed Down
        X = [datainfo(index).temperature]';
        Y = [datainfo(index).speeddown]';
        test = fitlm(X,Y);
        figure(h4);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Temperature vs. Individual Speed Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Temperature vs. Individual Speed Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Individual Speed Down (cm/sec)','FontSize',8);
        xlabel('Avg. Temperature (C)','FontSize',8);
        fprintf(f4,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % humidity vs. Num Up
        X = [datainfo(index).humidity]';
        Y = [datainfo(index).numup]'/30;
        test = fitlm(X,Y);
        figure(h5);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Humidity vs. Foraging Rate Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Humidity vs. Foraging Rate Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Foraging Rate Up (ants/sec)','FontSize',8);
        xlabel('Avg. Humidity (%RH)','FontSize',8);
        fprintf(f5,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % humidity vs. Num Down
        X = [datainfo(index).humidity]';
        Y = [datainfo(index).numdown]'/30;
        test = fitlm(X,Y);
        figure(h6);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Humidity vs. Foraging Rate Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Humidity vs. Foraging Rate Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Foraging Rate Down (ants/sec)','FontSize',8);
        xlabel('Avg. Humidity (%RH)','FontSize',8);
        fprintf(f6,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % humidity vs. Speed Up
        X = [datainfo(index).humidity]';
        Y = [datainfo(index).speedup]';
        test = fitlm(X,Y);
        figure(h7);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Humidity vs. Individual Speed Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Humidity vs. Individual Speed Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Individual Speed Up (cm/sec)','FontSize',8);
        xlabel('Avg. Humidity (%RH)','FontSize',8);
        fprintf(f7,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % humidity vs. Speed Down
        X = [datainfo(index).humidity]';
        Y = [datainfo(index).speeddown]';
        test = fitlm(X,Y);
        figure(h8);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Humidity vs. Individual Speed Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Humidity vs. Individual Speed Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Individual Speed Down (cm/sec)','FontSize',8);
        xlabel('Avg. Humidity (%RH)','FontSize',8);
        fprintf(f8,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % light vs. Num Up
        X = [datainfo(index).light]';
        Y = [datainfo(index).numup]'/30;
        test = fitlm(X,Y);
        figure(h9);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Light vs. Foraging Rate Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Light vs. Foraging Rate Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Foraging Rate Up (ants/sec)','FontSize',8);
        xlabel('Avg. Light (max 1024)','FontSize',8);
        fprintf(f9,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % light vs. Num Down
        X = [datainfo(index).light]';
        Y = [datainfo(index).numdown]'/30;
        test = fitlm(X,Y);
        figure(h10);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Light vs. Foraging Rate Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Light vs. Foraging Rate Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Foraging Rate Down (ants/sec)','FontSize',8);
        xlabel('Avg. Light (max 1024)','FontSize',8);
        fprintf(f10,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % light vs. Speed Up
        X = [datainfo(index).light]';
        Y = [datainfo(index).speedup]';
        test = fitlm(X,Y);
        figure(h11);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Light vs. Individual Speed Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Light vs. Individual Speed Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Individual Speed Up (cm/sec)','FontSize',8);
        xlabel('Avg. Light (max 1024)','FontSize',8);
        fprintf(f11,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        % light vs. Speed Down
        X = [datainfo(index).light]';
        Y = [datainfo(index).speeddown]';
        test = fitlm(X,Y);
        figure(h12);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Light vs. Individual Speed Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Light vs. Individual Speed Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Individual Speed Down (cm/sec)','FontSize',8);
        xlabel('Avg. Light (max 1024)','FontSize',8);
        fprintf(f12,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        % Winter vs. Num Up
        X = [datainfo(index).numup]';
        Y = [datainfo(index).winter]';
        test = fitglm(X,Y,'Distribution','binomial');
        b = glmfit(X,Y,'binomial');
        Yfit = glmval(b,X,'logit');
        figure(h13);
        subplot(3,3,(ii-1)*3 + jj);
        plot(X, Y,'o',X,Yfit,'.');
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Foraging Rate Up vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Foraging Rate Up vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Winter Ant Presence','FontSize',8);
        xlabel('Avg. Foraging Rate Up (ants/sec)','FontSize',8);
        ylim([-0.25 1.25]);
        fprintf(f13,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        % Winter vs. Num Down
        X = [datainfo(index).numdown]';
        Y = [datainfo(index).winter]';
        test = fitglm(X,Y,'Distribution','binomial');
        b = glmfit(X,Y,'binomial');
        Yfit = glmval(b,X,'logit');
        figure(h14);
        subplot(3,3,(ii-1)*3 + jj);
        plot(X, Y,'o',X,Yfit,'.');
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Foraging Rate Down vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Foraging Rate Down vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Winter Ant Presence','FontSize',8);
        xlabel('Avg. Foraging Rate Down (ants/sec)','FontSize',8);
        ylim([-0.25 1.25]);
        fprintf(f14,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        % Winter vs. Temperature
        X = [datainfo(index).temperature]';
        Y = [datainfo(index).winter]';
        test = fitglm(X,Y,'Distribution','binomial');
        b = glmfit(X,Y,'binomial');
        Yfit = glmval(b,X,'logit');
        figure(h15);
        subplot(3,3,(ii-1)*3 + jj);
        plot(X, Y,'o',X,Yfit,'.');
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Temperature vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Temperature vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Winter Ant Presence','FontSize',8);
        xlabel('Avg. Temperature (C)','FontSize',8);
        ylim([-0.25 1.25]);
        fprintf(f15,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        % Winter vs. Humidity
        X = [datainfo(index).humidity]';
        Y = [datainfo(index).winter]';
        test = fitglm(X,Y,'Distribution','binomial');
        b = glmfit(X,Y,'binomial');
        Yfit = glmval(b,X,'logit');
        figure(h16);
        subplot(3,3,(ii-1)*3 + jj);
        plot(X, Y,'o',X,Yfit,'.');
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Humidity vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Humidity vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Winter Ant Presence','FontSize',8);
        xlabel('Avg. Humidity (%RH)','FontSize',8);
        ylim([-0.25 1.25]);
        fprintf(f16,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        % Winter vs. Light
        X = [datainfo(index).light]';
        Y = [datainfo(index).winter]';
        test = fitglm(X,Y,'Distribution','binomial');
        b = glmfit(X,Y,'binomial');
        Yfit = glmval(b,X,'logit');
        figure(h17);
        subplot(3,3,(ii-1)*3 + jj);
        plot(X, Y,'o',X,Yfit,'.');
        if test.Coefficients.pValue(2) < 0.01
            title(sprintf('***Light vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Light vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Winter Ant Presence','FontSize',8);
        xlabel('Avg. Light (max 1024)','FontSize',8);
        ylim([-0.25 1.25]);
        fprintf(f17,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
    end
end

set(h1,'PaperOrientation','landscape');
set(h1,'PaperUnits','normalized');
set(h1,'PaperPosition', [0 0 1 1]);
print(h1, '-dpdf', [PathName 'Temperature_vs_ForagingRateUp_Plot.pdf']);
set(h2,'PaperOrientation','landscape');
set(h2,'PaperUnits','normalized');
set(h2,'PaperPosition', [0 0 1 1]);
print(h2, '-dpdf', [PathName 'Temperature_vs_ForagingRateDown_Plot.pdf']);
set(h3,'PaperOrientation','landscape');
set(h3,'PaperUnits','normalized');
set(h3,'PaperPosition', [0 0 1 1]);
print(h3, '-dpdf', [PathName 'Temperature_vs_IndividualSpeedUp_Plot.pdf']);
set(h4,'PaperOrientation','landscape');
set(h4,'PaperUnits','normalized');
set(h4,'PaperPosition', [0 0 1 1]);
print(h4, '-dpdf', [PathName 'Temperature_vs_IndividualSpeedDown_Plot.pdf']);
set(h5,'PaperOrientation','landscape');
set(h5,'PaperUnits','normalized');
set(h5,'PaperPosition', [0 0 1 1]);
print(h5, '-dpdf', [PathName 'Humidity_vs_ForagingRateUp_Plot.pdf']);
set(h6,'PaperOrientation','landscape');
set(h6,'PaperUnits','normalized');
set(h6,'PaperPosition', [0 0 1 1]);
print(h6, '-dpdf', [PathName 'Humidity_vs_ForagingRateDown_Plot.pdf']);
set(h7,'PaperOrientation','landscape');
set(h7,'PaperUnits','normalized');
set(h7,'PaperPosition', [0 0 1 1]);
print(h7, '-dpdf', [PathName 'Humidity_vs_IndividualSpeedUp_Plot.pdf']);
set(h8,'PaperOrientation','landscape');
set(h8,'PaperUnits','normalized');
set(h8,'PaperPosition', [0 0 1 1]);
print(h8, '-dpdf', [PathName 'Humidity_vs_IndividualSpeedDown_Plot.pdf']);
set(h9,'PaperOrientation','landscape');
set(h9,'PaperUnits','normalized');
set(h9,'PaperPosition', [0 0 1 1]);
print(h9, '-dpdf', [PathName 'Light_vs_ForagingRateUp_Plot.pdf']);
set(h10,'PaperOrientation','landscape');
set(h10,'PaperUnits','normalized');
set(h10,'PaperPosition', [0 0 1 1]);
print(h10, '-dpdf', [PathName 'Light_vs_ForagingRateDown_Plot.pdf']);
set(h11,'PaperOrientation','landscape');
set(h11,'PaperUnits','normalized');
set(h11,'PaperPosition', [0 0 1 1]);
print(h11, '-dpdf', [PathName 'Light_vs_IndividualSpeedUp_Plot.pdf']);
set(h12,'PaperOrientation','landscape');
set(h12,'PaperUnits','normalized');
set(h12,'PaperPosition', [0 0 1 1]);
print(h12, '-dpdf', [PathName 'Light_vs_IndividualSpeedDown_Plot.pdf']);
set(h13,'PaperOrientation','landscape');
set(h13,'PaperUnits','normalized');
set(h13,'PaperPosition', [0 0 1 1]);
print(h13, '-dpdf', [PathName 'Winter_vs_ForagingRateUp_Plot.pdf']);
set(h14,'PaperOrientation','landscape');
set(h14,'PaperUnits','normalized');
set(h14,'PaperPosition', [0 0 1 1]);
print(h14, '-dpdf', [PathName 'Winter_vs_ForagingRateDown_Plot.pdf']);
set(h15,'PaperOrientation','landscape');
set(h15,'PaperUnits','normalized');
set(h15,'PaperPosition', [0 0 1 1]);
print(h15, '-dpdf', [PathName 'Winter_vs_Temperature_Plot.pdf']);
set(h16,'PaperOrientation','landscape');
set(h16,'PaperUnits','normalized');
set(h16,'PaperPosition', [0 0 1 1]);
print(h16, '-dpdf', [PathName 'Winter_vs_Humidity_Plot.pdf']);
set(h17,'PaperOrientation','landscape');
set(h17,'PaperUnits','normalized');
set(h17,'PaperPosition', [0 0 1 1]);
print(h17, '-dpdf', [PathName 'Winter_vs_Light_Plot.pdf']);

fclose(f1);
fclose(f2);
fclose(f3);
fclose(f4);
fclose(f5);
fclose(f6);
fclose(f7);
fclose(f8);
fclose(f9);
fclose(f10);
fclose(f11);
fclose(f12);
fclose(f13);
fclose(f14);
fclose(f15);
fclose(f16);
fclose(f17);

%%
save([PathName 'argentine.mat'], 'fileinfo', 'datainfo','datatable');

%%

uq_date = unique([datainfo.date]);
uq_aggr = unique([datainfo.aggrnum]);

h1 = figure;
h2 = figure;
h3 = figure;
h4 = figure;
h5 = figure;

f1 = fopen([PathName 'Temp,Humid,Light,Winter_vs_NumUp.csv'],'w');
f2 = fopen([PathName 'Temp,Humid,Light,Winter_vs_NumDown.csv'],'w');
f3 = fopen([PathName 'Temp,Humid,Light,Winter_vs_SpeedUp.csv'],'w');
f4 = fopen([PathName 'Temp,Humid,Light,Winter_vs_SpeedDown.csv'],'w');
f5 = fopen([PathName 'Num Up,Num Down,Temp,Humid,Light_vs_Winter.csv'],'w');

fprintf(f1,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f2,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f3,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f4,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f5,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');

for ii = 1:length(uq_date)
    dd = uq_date{ii};
    for jj = 1:length(uq_aggr)
        aa = uq_aggr(jj);
        index = strcmp([datainfo.date],dd) & [datainfo.aggrnum] == aa;
        
        % lm(mean arg rate up ~ temp + humid + light + winter)
        X = [datainfo(index).temperature;...
            datainfo(index).humidity;...
            datainfo(index).light;...
            datainfo(index).winter]';
        Y = [datainfo(index).numup]';
        test = fitlm(X,Y);
        figure(h1);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.05
            title(sprintf('***Temp,Humid,Light,Winter vs. Num Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Temp,Humid,Light,Winter vs. Num Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Num Up (ants/min)','FontSize',8);
        xlabel('Avg. Temp,Humid,Light,Winter','FontSize',8);
        fprintf(f1,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        %lm(mean arg speed up ~ temp + humid + light + winter)
        X = [datainfo(index).temperature;...
            datainfo(index).humidity;...
            datainfo(index).light;...
            datainfo(index).winter]';
        Y = [datainfo(index).numdown]';
        test = fitlm(X,Y);
        figure(h2);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.05
            title(sprintf('***Temp,Humid,Light,Winter vs. Num Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Temp,Humid,Light,Winter vs. Num Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Num Down (ants/min)','FontSize',8);
        xlabel('Avg. Temp,Humid,Light,Winter','FontSize',8);
        fprintf(f2,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        %lm(mean arg speed up ~ temp + humid + light + winter)
        X = [datainfo(index).temperature;...
            datainfo(index).humidity;...
            datainfo(index).light;...
            datainfo(index).winter]';
        Y = [datainfo(index).speedup]';
        test = fitlm(X,Y);
        figure(h3);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.05
            title(sprintf('***Temp,Humid,Light,Winter vs. Speed Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Temp,Humid,Light,Winter vs. Speed Up\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Speed Up (cm/s)','FontSize',8);
        xlabel('Avg. Temp,Humid,Light,Winter','FontSize',8);
        fprintf(f3,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        
        %lm(mean arg speed down ~ temp + humid + light + winter)
        X = [datainfo(index).temperature;...
            datainfo(index).humidity;...
            datainfo(index).light;...
            datainfo(index).winter]';
        Y = [datainfo(index).speeddown]';
        test = fitlm(X,Y);
        figure(h4);
        subplot(3,3,(ii-1)*3 + jj);
        test.plot;
        if test.Coefficients.pValue(2) < 0.05
            title(sprintf('***Temp,Humid,Light,Winter vs. Speed Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Temp,Humid,Light,Winter vs. Speed Down\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Avg. Speed Down (cm/s)','FontSize',8);
        xlabel('Avg. Temp,Humid,Light,Winter','FontSize',8);
        fprintf(f4,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
        
        %glm(winter presence/absence ~ temp + humid + light + arg rate up + arg rate down)
        X = [datainfo(index).numup;...
            datainfo(index).numdown;...
            datainfo(index).temperature;...
            datainfo(index).humidity;...
            datainfo(index).light]';
        Y = [datainfo(index).winter]';
        test = fitglm(X,Y,'Distribution','binomial');
        b = glmfit(X,Y,'binomial');
        Yfit = glmval(b,X,'logit');
        figure(h5);
        subplot(3,3,(ii-1)*3 + jj);
        plot(X, Y,'o',X,Yfit,'.');
        if test.Coefficients.pValue(2) < 0.05
            title(sprintf('***Num Up, Num Down, Temp, Humid, Light vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        else
            title(sprintf('Num Up, Num Down, Temp, Humid, Light vs. Winter Ant Presence\n Day: %s Aggregation: %d',...
                dd,jj),'FontSize',8);
        end
        
        ylabel('Winter Ant Presence','FontSize',8);
        xlabel('Avg. Num Up, Num Down, Temp, Humid, Light','FontSize',8);
        ylim([-0.25 1.25]);
        fprintf(f5,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
    end
end

set(h1,'PaperOrientation','landscape');
set(h1,'PaperUnits','normalized');
set(h1,'PaperPosition', [0 0 1 1]);
print(h1, '-dpdf', [PathName 'Temp,Humid,Light,Winter_vs_NumUp_Plot.pdf']);
set(h2,'PaperOrientation','landscape');
set(h2,'PaperUnits','normalized');
set(h2,'PaperPosition', [0 0 1 1]);
print(h2, '-dpdf', [PathName 'Temp,Humid,Light,Winter_vs_NumDown_Plot.pdf']);
set(h3,'PaperOrientation','landscape');
set(h3,'PaperUnits','normalized');
set(h3,'PaperPosition', [0 0 1 1]);
print(h3, '-dpdf', [PathName 'Temp,Humid,Light,Winter_vs_SpeedUp_Plot.pdf']);
set(h4,'PaperOrientation','landscape');
set(h4,'PaperUnits','normalized');
set(h4,'PaperPosition', [0 0 1 1]);
print(h4, '-dpdf', [PathName 'Temp,Humid,Light,Winter_vs_SpeedDown_Plot.pdf']);
set(h5,'PaperOrientation','landscape');
set(h5,'PaperUnits','normalized');
set(h5,'PaperPosition', [0 0 1 1]);
print(h5, '-dpdf', [PathName 'Num Up,Num Down,Temp,Humid,Light_vs_Winter_Plot.pdf']);

fclose(f1);
fclose(f2);
fclose(f3);
fclose(f4);
fclose(f5);

%%

h1 = figure;
h2 = figure;

f1 = fopen([PathName 'Environmental_Factors_vs_Foraging_Rate_Up.csv'],'w');
f2 = fopen([PathName 'Environmental_Factors_vs_Foraging_Rate_Down.csv'],'w');
f3 = fopen([PathName 'Environmental_Factors_vs_Individual_Speed_Up.csv'],'w');
f4 = fopen([PathName 'Environmental_Factors_vs_Individual_Speed_Down.csv'],'w');

fprintf(f1,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f2,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f3,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');
fprintf(f4,'%s,%s,%s,%s,%s\n','ExpDay','Aggregation','R-Squared','Slope','P-Value');

for jj = 1:length(uq_aggr)
    aa = uq_aggr(jj);
    index = [datainfo.aggrnum] == aa;
    X = [datainfo(index).temperature;...
        datainfo(index).humidity;...
        datainfo(index).light]';
    Y = [datainfo(index).numup]';
    test = fitlm(X,Y);
    figure(h1);
    subplot(2,3,jj);
    test.plot;
    if test.Coefficients.pValue(2) < 0.01
        title(sprintf('***Environmental Factors vs. Foraging Rate Up\n Aggregation: %d',...
            jj),'FontSize',8);
    else
        title(sprintf('Environmental Factors vs. Foraging Rate Up\n Aggregation: %d',...
            jj),'FontSize',8);
    end
    
    ylabel('Avg. Foraging Rate Up (ants/sec)','FontSize',8);
    xlabel('Avg. Environmental Factors','FontSize',8);
    fprintf(f1,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
    
    %lm(mean arg speed up ~ temp + humid + light + winter)
    X = [datainfo(index).temperature;...
        datainfo(index).humidity;...
        datainfo(index).light]';
    Y = [datainfo(index).numdown]';
    test = fitlm(X,Y);
    figure(h1);
    subplot(2,3,jj+3);
    test.plot;
    if test.Coefficients.pValue(2) < 0.01
        title(sprintf('***Environmental Factors vs. Foraging Rate Down\n Aggregation: %d',...
            jj),'FontSize',8);
    else
        title(sprintf('Environmental Factors vs. Foraging Rate Down\n Aggregation: %d',...
            jj),'FontSize',8);
    end
    
    ylabel('Avg. Foraging Rate Up (ants/sec)','FontSize',8);
    xlabel('Avg. Environmental Factors','FontSize',8);
    fprintf(f2,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
    
    X = [datainfo(index).temperature;...
        datainfo(index).humidity;...
        datainfo(index).light]';
    Y = [datainfo(index).speedup]';
    test = fitlm(X,Y);
    figure(h2);
    subplot(2,3,jj);
    test.plot;
    if test.Coefficients.pValue(2) < 0.05
        title(sprintf('***Environmental Factors vs. Individual Speed Up\n Aggregation: %d',...
            jj),'FontSize',8);
    else
        title(sprintf('Environmental Factors vs. Individual Speed Up\n Aggregation: %d',...
            jj),'FontSize',8);
    end
    
    ylabel('Avg. Individual Speed Up (cm/sec)','FontSize',8);
    xlabel('Avg. Environmental Factors','FontSize',8);
    fprintf(f3,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
    
    
    %lm(mean arg speed down ~ temp + humid + light + winter)
    X = [datainfo(index).temperature;...
        datainfo(index).humidity;...
        datainfo(index).light]';
    Y = [datainfo(index).speeddown]';
    test = fitlm(X,Y);
    figure(h2);
    subplot(2,3,jj+3);
    test.plot;
    if test.Coefficients.pValue(2) < 0.05
        title(sprintf('***Environmental Factors vs. Individual Speed Down\n Aggregation: %d',...
            jj),'FontSize',8);
    else
        title(sprintf('Environmental Factors vs. Individual Speed Down\n Aggregation: %d',...
            jj),'FontSize',8);
    end
    
    ylabel('Avg. Individual Speed Down (cm/sec)','FontSize',8);
    xlabel('Avg. Environmental Factors','FontSize',8);
    fprintf(f4,'%d,%d,%.2f,%.2f,%.2f\n',ii,jj,test.Rsquared.Ordinary,test.Coefficients.Estimate(2),test.Coefficients.pValue(2));
    
end
set(h1,'PaperOrientation','landscape');
set(h1,'PaperUnits','normalized');
set(h1,'PaperPosition', [0 0 1 1]);
print(h1, '-dpdf', [PathName 'Environmental_Factors_vs_Foraging_Rate_Plot.pdf']);
set(h2,'PaperOrientation','landscape');
set(h2,'PaperUnits','normalized');
set(h2,'PaperPosition', [0 0 1 1]);
print(h2, '-dpdf', [PathName 'Environmental_Factors_vs_Individual_Speed_Plot.pdf']);

fclose(f1);
fclose(f2);
fclose(f3);
fclose(f4);

%%
temprate = zeros(3,2);
tempspeed = zeros(3,2);
for ii = 1:length(uq_date)
    dd = uq_date{ii};
    for jj = 1:length(uq_aggr)
        aa = uq_aggr(jj);
        index = strcmp([datainfo.date],dd) & [datainfo.aggrnum] == aa;
        disp('Rate');
        disp(['Day: ' num2str(ii) ' Aggr: ' num2str(jj)...
            ' Value: ' num2str(nanmean([datainfo(index).numup]))]);
        disp(['Day: ' num2str(ii) ' Aggr: ' num2str(jj)...
            ' Value: ' num2str(nanmean([datainfo(index).numdown]))]);
        disp('Speed');
        disp(['Day: ' num2str(ii) ' Aggr: ' num2str(jj)...
            ' Value: ' num2str(nanmean([datainfo(index).speedup]))]);
        disp(['Day: ' num2str(ii) ' Aggr: ' num2str(jj)...
            ' Value: ' num2str(nanmean([datainfo(index).speeddown]))]);
        if nanmean([datainfo(index).numup]) > temprate(jj,1)
            temprate(jj,1) = nanmean([datainfo(index).numup]);
            temprate(jj,2) = ii;
        end
        if nanmean([datainfo(index).numdown]) > temprate(jj,1)
            temprate(jj,1) = nanmean([datainfo(index).numdown]);
            temprate(jj,2) = ii;
        end
        if nanmean([datainfo(index).speedup]) > tempspeed(jj,1)
            tempspeed(jj,1) = nanmean([datainfo(index).speedup]);
            tempspeed(jj,2) = ii;
        end
        if nanmean([datainfo(index).speeddown]) > tempspeed(jj,1)
            tempspeed(jj,1) = nanmean([datainfo(index).speeddown]);
            tempspeed(jj,2) = ii;
        end
    end
end

for ii = 1:3
    disp(['Max Rate: ' num2str(temprate(ii,1)/30) ...
        ' Max Day: ' num2str(temprate(ii,2)) ...
        ' Max Speed: ' num2str(tempspeed(ii,1)) ...
        ' Max Day: ' num2str(tempspeed(ii,2))]);
end

%%

h1 = figure;
for ii = 1:length(uq_date)
    dd = uq_date{ii};
    index = strcmp([datainfo.date],dd);
    meantime = ([datainfo(index).t_start] + [datainfo(index).t_stop])/2+ 4*3600;
    H = floor(meantime/3600);
    M = floor((meantime - H*3600)/60);
    S = floor((meantime - H*3600 - M*60));
    X = datenum(0,0,0,H,M,S);
    figure(h1);
    subplot(1,3,1);
    hold on;
    plot(X,smooth([datainfo(index).temperature]),'o-');
    title('Temperature Across All Survey Dates','FontSize',8);
    legend(uq_date{1},uq_date{2},uq_date{3});
    datetick('x','HH');
    xlabel('Time');
    ylabel('Temperature (C)');
    hold off;
    subplot(1,3,2);
    hold on;
    plot(X,[datainfo(index).humidity],'o-');
    title('Humidity Across All Survey Dates','FontSize',8);
    legend(uq_date{1},uq_date{2},uq_date{3});
    datetick('x','HH');
    xlabel('Time');
    ylabel('Humidity (%RH)');
    hold off;
    subplot(1,3,3);
    hold on;
    plot(X,[datainfo(index).light],'o-');
    title('Light Across All Survey Dates','FontSize',8);
    legend(uq_date{1},uq_date{2},uq_date{3});
    datetick('x','HH');
    xlabel('Time');
    ylabel('Light (max 1024)');
    hold off;
end

 set(h1,'PaperOrientation','landscape');
 set(h1,'PaperUnits','normalized');
 set(h1,'PaperPosition', [0 0 1 0.5]);
 print(h1, '-dpdf', [PathName 'EnvironmentalFactors_Plot.pdf']);


%%

h1 = figure;
for ii = 1:length(uq_date)
    dd = uq_date{ii};
    for jj = 1:length(uq_aggr)
        aa = uq_aggr(jj);
        index = strcmp([datainfo.date],dd) & [datainfo.aggrnum] == aa;
        
        meantime = ([datainfo(index).t_start] + [datainfo(index).t_stop])/2+ 4*3600;
        H = floor(meantime/3600);
        M = floor((meantime - H*3600)/60);
        S = floor((meantime - H*3600 - M*60));
        X = datenum(0,0,0,H,M,S);
        
        figure(h1);
        subplot(3,4,1+(ii-1)*4);
        hold on;
        plot(X,[datainfo(index).numup]/30,'o-');
        title(['Foraging Rate Up | ' dd],'FontSize',8);
        if ii == 1
        h = legend('Colony 1','Colony 2','Colony 3','FontSize',8);
        end
        datetick('x','HH');
        xlabel('Time');
        ylabel('Foraging Rate Up (ants/sec)');
        hold off;
        subplot(3,4,2+(ii-1)*4);
        hold on;
        plot(X,[datainfo(index).numdown]/30,'o-');
        title(['Foraging Rate Down | ' dd],'FontSize',8);
        if ii == 1
        legend('Colony 1','Colony 2','Colony 3','FontSize',8);
        end
        datetick('x','HH');
        xlabel('Time');
        ylabel('Foraging Rate Up (ants/sec)');
        hold off;
        subplot(3,4,3+(ii-1)*4);
        hold on;
        plot(X,[datainfo(index).speedup],'o-');
        title(['Individual Speed Up | ' dd],'FontSize',8);
        if ii == 1
        legend('Colony 1','Colony 2','Colony 3','FontSize',8);
        end
        datetick('x','HH');
        xlabel('Time');
        ylabel('Individual Speed Up (cm/sec)');
        hold off;
        subplot(3,4,4+(ii-1)*4);
        hold on;
        plot(X,[datainfo(index).speeddown],'o-');
        title(['Indiviudal Speed Down | ' dd],'FontSize',8);
        if ii == 1
        legend('Colony 1','Colony 2','Colony 3','FontSize',8);
        end
        datetick('x','HH');
        xlabel('Time');
        ylabel('Individual Speed Down (cm/sec)');
        hold off;
    end
end
 
 set(h1,'PaperOrientation','landscape');
 set(h1,'PaperUnits','normalized');
 set(h1,'PaperPosition', [0 0 1 1]);
 print(h1, '-dpdf', [PathName 'AllColony_Plot.pdf']);

%%

h1 = figure;
for ii = 1:length(uq_aggr)
    aa = uq_aggr(ii);    
    for jj = 1:length(uq_date)
        dd = uq_date{jj};
        index = strcmp([datainfo.date],dd) & [datainfo.aggrnum] == aa;
        
        meantime = ([datainfo(index).t_start] + [datainfo(index).t_stop])/2+ 4*3600;
        H = floor(meantime/3600);
        M = floor((meantime - H*3600)/60);
        S = floor((meantime - H*3600 - M*60));
        X = datenum(0,0,0,H,M,S);
        
        figure(h1);
        h2 = subplot(3,4,1+(ii-1)*4);
        hold on;
        plot(X,[datainfo(index).numup]/30,'o-');
        title(['Foraging Rate Up | Colony ' num2str(aa)],'FontSize',8);
        if ii == 3
        legend(uq_date{1},uq_date{2},uq_date{3});
        end
        datetick('x','HH');
        xlabel('Time');
        ylabel('Foraging Rate Up (ants/sec)');
        hold off;
        h3 = subplot(3,4,2+(ii-1)*4);
        hold on;
        plot(X,[datainfo(index).numdown]/30,'o-');
        title(['Foraging Rate Down | Colony ' num2str(aa)],'FontSize',8);
        if ii == 3
        legend(uq_date{1},uq_date{2},uq_date{3});
        end
        datetick('x','HH');
        xlabel('Time');
        ylabel('Foraging Rate Up (ants/sec)');
        hold off;
        h4 = subplot(3,4,3+(ii-1)*4);
        hold on;
        plot(X,[datainfo(index).speedup],'o-');
        title(['Individual Speed Up | Colony ' num2str(aa)],'FontSize',8);
        if ii == 3
        legend(uq_date{1},uq_date{2},uq_date{3});
        end
        datetick('x','HH');
        xlabel('Time');
        ylabel('Individual Speed Up (cm/sec)');
        hold off;
        h5 = subplot(3,4,4+(ii-1)*4);
        hold on;
        plot(X,[datainfo(index).speeddown],'o-');
        title(['Indiviudal Speed Down | Colony ' num2str(aa)],'FontSize',8);
        if ii == 3
        legend(uq_date{1},uq_date{2},uq_date{3});
        end
        datetick('x','HH');
        xlabel('Time');
        ylabel('Individual Speed Down (cm/sec)');
        hold off;
        
    end
end
 set(h1,'PaperOrientation','landscape');
 set(h1,'PaperUnits','normalized');
 set(h1,'PaperPosition', [0 0 1 1]);
 print(h1, '-dpdf', [PathName 'AllSurveyDays_Plot.pdf']);