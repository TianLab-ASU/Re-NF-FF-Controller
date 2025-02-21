function dydt = Model(t,y,Lara)
global a Roff dx uI
NC=50; Ron=0.1; uA=0.5; uG1=0.8; uG2=2; uR=0.5; KI1=.1; KI2=5; 
KX=5; J=0.001; Cmin=0.000001; Cmax=0.015; n=3; d=0.01; QG=50; QR=5;
QA=150; QI=150; 
Sa = Cmin+(Cmax-Cmin)*(Lara^n/(Lara^n+J^n));
Ratio=y(1);INT=y(2);AraC=y(3);GFP=y(4);RFP=y(5);XIS=y(6);
RR=Sa*AraC^2/(Sa*AraC^2+1);
PFQ=1+NC*(1/QG+1/QA+1/QI+2*Ratio*RR/QR+a*(1-Ratio)*RR/QR); 
dydt=[Ron*INT^4/(KI1^4+INT^4)*(1-Ratio)-Roff*(XIS^4/(KX^4+XIS^4))*(INT^4/(KI2^4+INT^4))*Ratio; % Ratio
    (uI*NC/QI)/PFQ-INT*d; % Integrase
    (uA*NC/QA)/PFQ-AraC*d; % AraC
    (uG1*NC/QG+a*uG2*(1-Ratio)*NC*(RR/QR))/PFQ-GFP*d; % GFP
    uR*Ratio*NC*(RR/QR)/PFQ-RFP*d; % RFP
    uR*Ratio*NC*(RR/QR)/PFQ-XIS*dx; % Excisionase
    ];