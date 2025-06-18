clc
clear
%% The performances of open loop, Re-NF, and Re-NF-FF at different levels of resource competition;
global a Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX
a=1;
Roff=0.5;
dx=0.0216;
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
QR0=[0.5:0.1:1.5]*5;
% Re-NF-FF
for j=1:length(QR0)
    QR=QR0(j);
    for i=1:length(Lara)
        [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
        RFP_FF(j,i)=y(end,5);
        GFP_FF(j,i)=y(end,4);
    end
end
% Open loop
a=0;
Roff=0;
dx=0.01;
for j=1:length(QR0)
    QR=QR0(j);
    for i=1:length(Lara)
        [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
        RFP_C(j,i)=y(end,5);
        GFP_C(j,i)=y(end,4);
    end
end
% Re-NF
a=0;
Roff=0.5;
dx=0.01;
for j=1:length(QR0)
    QR=QR0(j);
    for i=1:length(Lara)
        [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
        RFP_NF(j,i)=y(end,5);
        GFP_NF(j,i)=y(end,4);
    end
end

%% Calculating CI
for k=1:length(QR0)
    Coupling_index_C(k)=CI(RFP_C(k,:),GFP_C(k,:));
    Coupling_index_NF(k)=CI(RFP_NF(k,:),GFP_NF(k,:));
    Coupling_index_FF(k)=CI(RFP_FF(k,:),GFP_FF(k,:));
end
%%
figure;
hold on;
plot(QR0, Coupling_index_C, '-o', 'LineWidth', 1.8, 'Color', [1 0 0]);  
plot(QR0, Coupling_index_NF, '-o', 'LineWidth', 1.8, 'Color', [0 0.4470 0.7410]);  
plot(QR0, Coupling_index_FF, '-o', 'LineWidth', 1.8, 'Color', [0.9290 0.6940 0.1250]);  
xlabel('Index');
ylabel('Value');
legend('Open loop', 'Re-NF', 'RE-NF-FF');
box on




