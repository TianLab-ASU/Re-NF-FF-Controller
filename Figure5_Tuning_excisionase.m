clc
clear
%% Tuning dx for optimizing the performance of Re-NF-FF, a=1, Roff=0.5;
global a Roff dx uI QI e NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX
a=1;
Roff=0.5;
dx=0.01;
uI=0.8;
QI=150;
NC=50;
Ron=0.1; uA=0.5; uG1=0.8; uG2=2; uR=0.5; KI1=.1; KI2=5; 
KX=5; J=0.001; Cmin=0.000001; Cmax=0.015; n=3; d=0.01; QG=50; QR=5;
QA=150; QX=5; 
Lara = linspace(0, 5*10^-3, 100);
y0=[1,0,0,0,0,0];
t=[0 1000];
[t,y]=ode23(@(t,y) Model0(t,y,Lara(1)),t,y0);
y0=y(end,:);                                                  
dx0=0.01*(1+(0:20)*.15)
for j=1:length(dx0)
    dx=dx0(j)
    
    for i=1:length(Lara)
        [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
        RFP_FFLM(j,i)=y(end,5);
        GFP_FFLM(j,i)=y(end,4);
    end 
end
%% Calculating CI
for k=1:length(dx0)
    [Coupling_index(k),GFP_Sim(k,:)]=CI(RFP_FFLM(k,:),GFP_FFLM(k,:));
end
subplot(2,2,2)
barh(dx0, Coupling_index) 
subplot(2,2,1)
RFP_Sim=0:0.01:1;
imagesc( RFP_Sim, dx0, GFP_Sim)
set(gca, 'ydir','normal')

%% Open loop, a=0, Roff=0;
a=0; 
Roff=0;
dx=0.01;
for i=1:length(Lara)
[t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
RFP_OL(i)=y(end,5);
GFP_OL(i)=y(end,4);
end
subplot(2,2,3)
plot(RFP_OL/RFP_OL(end), GFP_OL/GFP_OL(1),'b');
hold on
%% Find the optimal dx value
dx0_for_min_CI=interp1(Coupling_index,dx0,0) 
j=101;
a=1; 
Roff=0.5;
dx=dx0_for_min_CI
for i=1:length(Lara)
    [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
    RFP_FFLM(j,i)=y(end,5);
    GFP_FFLM(j,i)=y(end,4);
end
subplot(2,2,3)
plot(RFP_FFLM(j,:)/RFP_FFLM(j,end), GFP_FFLM(j,:)/GFP_FFLM(j,1));
hold on
plot(RFP_FFLM(1,:)/RFP_FFLM(1,end), GFP_FFLM(1,:)/GFP_FFLM(1,1));