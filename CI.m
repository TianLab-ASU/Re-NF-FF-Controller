function [CI,GFP_Sim]=CI(a,b)
        [xData, yData] = prepareCurveData( a/max(a), b/b(1) );
        ft = 'pchipinterp';
        [fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );
        RFP_Sim=0:0.01:1;
        GFP_Sim=feval(fitresult,RFP_Sim);
        CI=mean(((GFP_Sim-1)));
end