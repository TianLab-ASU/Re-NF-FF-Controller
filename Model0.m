function dydt = Model0(t,y,Lara)
global a Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX
Sa = Cmin+(Cmax-Cmin)*(Lara^n/(Lara^n+J^n));
Ratio=y(1);INT=y(2);AraC=y(3);GFP=y(4);RFP=y(5);XIS=y(6);
RR=Sa*AraC^2/(Sa*AraC^2+1);
PFQ=1+NC*(1/(QG)+1/(QA)+1/(QI)+Ratio*RR/(QR)+Ratio*RR/(QX)+a*(1-Ratio)*RR/(QR)); 
dydt=[Ron*INT^4/(KI1^4+INT^4)*(1-Ratio)-Roff*(XIS^4/(KX^4+XIS^4))*(INT^4/(KI2^4+INT^4))*Ratio; % Ratio
    (uI*NC/(QI))/PFQ-INT*d; % Integrase
    (uA*NC/(QA))/PFQ-AraC*d; % AraC
    (uG1*NC/(QG)+a*uG2*(1-Ratio)*NC*(RR/(QR)))/PFQ-GFP*d; % GFP
    uR*Ratio*NC*(RR/(QR))/PFQ-RFP*d; % RFP
    uR*Ratio*NC*(RR/(QX))/PFQ-XIS*dx; % Excisionase
    ];