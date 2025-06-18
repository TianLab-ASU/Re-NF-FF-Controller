clc
clear

%% Open loop
global a Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX
a=0;
Roff=0;
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
for i=1:length(Lara)
    [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
    RFP_NFL(1,i)=y(end,5);
    GFP_NFL(1,i)=y(end,4);
end
%% The resource competing ability of recombinase controllers is set to be -∞.
QI=Inf;QX=Inf;
y0=[1,0,0,0,0,0];
[t,y]=ode23(@(t,y) Model0(t,y,Lara(1)),t,y0);
y0=y(end,:);
for i=1:length(Lara)
    [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
    RFP_NFL_A(1,i)=y(end,5);
    GFP_NFL_A(1,i)=y(end,4);
end

%% Calculating CI
Coupling_index=CI(RFP_NFL(1,:),GFP_NFL(1,:));
Coupling_index_A=CI(RFP_NFL_A(1,:),GFP_NFL_A(1,:));
bar_plot=bar([Coupling_index,Coupling_index_A]);
labels = {'+CRC','-CRC'}
bar_plot.FaceColor = 'flat';  
bar_plot.CData(1,:) = [43, 45, 66] / 255;  
bar_plot.CData(2,:) = [237, 242, 244] / 255;  
set(gca, 'XTickLabel', labels)
ylabel('Coupling Index')
ylim([-0.3 0]);

