clc
clear
%% Tuning Roff for optimizing the performance of Re-NF, a=0, Roff=0.5;
global a Roff dx uI QI e NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX
a=0;
Roff=0.5;
dx=0.01;
uI=0.8;
QI=150;
NC=50;
Ron=0.1; uA=0.5; uG1=0.8; uG2=2; uR=0.5; KI1=.1; KI2=5; 
KX=5; J=0.001; Cmin=0.000001; Cmax=0.015; n=3; d=0.01; QG=50; QR=5;
QA=150; QX=5; 
Lara = linspace(0, 5*10^-3, 100);
t=[0 1000];
y0=[1,0,0,0,0,0];
[t,y]=ode23(@(t,y) Model0(t,y,Lara(1)),t,y0);
y0=y(end,:);

Roff0=(0:30)*0.025;

for j=1:31
    Roff=Roff0(j);
    for i=1:length(Lara)
        [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
        RFP_NFL(j,i)=y(end,5);
        GFP_NFL(j,i)=y(end,4);
        ratio(j,i)=y(end,1);
    end


    if j==1 || j==31 
    subplot(2,2,3)
    plot(RFP_NFL(j,:)/RFP_NFL(j,end), GFP_NFL(j,:)/GFP_NFL(j,1));
    hold on
    end
end
%% Calculating CI
for k=1:length(Roff0)
    [Coupling_index(k),GFP_Sim(k,:)]=CI(RFP_NFL(k,:),GFP_NFL(k,:));
end
subplot(2,2,2)
barh(Roff0, Coupling_index) 
subplot(2,2,1)
RFP_Sim=0:0.01:1;
imagesc( RFP_Sim, Roff0, GFP_Sim)
set(gca, 'ydir','normal')
