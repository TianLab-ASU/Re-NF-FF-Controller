clc
clear

global a Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX
a=0; Roff=0.5; dx=0.0216; uI=0.8; QI=150; NC=50; Ron=0.1; uA=0.5; uG1=0.8; uG2=2; uR=0.5; KI1=.1; KI2=5; 
KX=5; J=0.001; Cmin=0.000001; Cmax=0.015; n=3; d=0.01; QG=50; QR=5; QA=150; QX=5; 
PP0=[uA uG1 uG2 uI uR QA QG QI QR QX Roff Ron KI1 KI2 KX dx d NC Cmin Cmax n J];
Parameter_Rand_FF=PP0.*ones(length(PP0)*2,length(PP0));
for i=1:length(PP0)
    Parameter_Rand_FF(2*i-1,i)=Parameter_Rand_FF(2*i-1,i)*1.2; % 20% variance
    Parameter_Rand_FF(2*i,i)=Parameter_Rand_FF(2*i,i)*0.8; % 20% variance
end 

dx=0.01;
PP0_NF=[uA uG1 uG2 uI uR QA QG QI QR QX Roff Ron KI1 KI2 KX dx d NC Cmin Cmax n J];
Parameter_Rand_NF=PP0_NF.*ones(length(PP0_NF)*2,length(PP0_NF));
for i=1:length(PP0_NF)
    Parameter_Rand_NF(2*i-1,i)=Parameter_Rand_NF(2*i-1,i)*1.2; % 20% variance
    Parameter_Rand_NF(2*i,i)=Parameter_Rand_NF(2*i,i)*0.8; % 20% variance
end 
%%
for run = 1:length(Parameter_Rand_NF)
    Parameter_temp=num2cell(Parameter_Rand_NF(run,:)); % define the column that will be chosen randomly
    [uA uG1 uG2 uI uR QA QG QI QR QX Roff Ron KI1 KI2 KX dx d NC Cmin Cmax n J]=deal(Parameter_temp{1:22});% define the column that will be chosen randomly
    a=0; % Re-NF controller
    Lara = linspace(0, 5*10^-3, 100);
    t=[0 1000];
    y0=[1,0,0,0,0,0];
    [t,y]=ode23(@(t,y) Model0(t,y,Lara(1)),t,y0);
    y0=y(end,:);
    for i=1:length(Lara)
        [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
        RFP_NFL_NF(1,i)=y(end,5);
        GFP_NFL_NF(1,i)=y(end,4);
    end
    Coupling_index_NF(run)=CI(RFP_NFL_NF(1,:),GFP_NFL_NF(1,:));
end    
%%
for run = 1:length(Parameter_Rand_FF)
    Parameter_temp=num2cell(Parameter_Rand_FF(run,:)); % define the column that will be chosen randomly
    [uA uG1 uG2 uI uR QA QG QI QR QX Roff Ron KI1 KI2 KX dx d NC Cmin Cmax n J]=deal(Parameter_temp{1:22});% define the column that will be chosen randomly
    a=1; % Re-NF-FF controller
    Lara = linspace(0, 5*10^-3, 100);
    t=[0 1000];
    y0=[1,0,0,0,0,0];
    [t,y]=ode23(@(t,y) Model0(t,y,Lara(1)),t,y0);
    y0=y(end,:);
    for i=1:length(Lara)
        [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
        RFP_NFL_FF(1,i)=y(end,5);
        GFP_NFL_FF(1,i)=y(end,4);
    end
    Coupling_index_FF(run)=CI(RFP_NFL_FF(1,:),GFP_NFL_FF(1,:));
end        
%%
for j=1:length(Coupling_index_NF)/2
    NF(1,j)=Coupling_index_NF(1,2*j-1);
    NF(2,j)=Coupling_index_NF(1,2*j);
    FF(1,j)=Coupling_index_FF(1,2*j-1);
    FF(2,j)=Coupling_index_FF(1,2*j);
end
%%
subplot(2,1,2)

bar((FF(1,:)),'FaceColor',[0.85,0.33,0.10],'EdgeColor',[1.00,0.41,0.16],'LineWidth',1.5);
hold on
b=bar((FF(2,:)),'FaceColor',[0.00,0.45,0.74],'EdgeColor',[0.07,0.62,1.00],'LineWidth',1.5);
b(1).BaseValue = 0;
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22])
set(gca,'XTickLabel',{'uA','uG1','uG2','uI','uR','QA','QG','QI','QR','QX','Roff','Ron','KI1','KI2','KX','dx','d','NC','Cmin','Cmax','n','J'});
ylabel('Coupling index');
set(gca,'fontweight','bold','FontSize',14);
xtickangle(90);
ylim([-0.08 0.08])
set(gca,'LineWidth',2);
box on;
title(['Re-NF-FF controller'])

subplot(2,1,1)

bar((NF(1,:)),'FaceColor',[0.85,0.33,0.10],'EdgeColor',[1.00,0.41,0.16],'LineWidth',1.5);
hold on
b=bar((NF(2,:)),'FaceColor',[0.00,0.45,0.74],'EdgeColor',[0.07,0.62,1.00],'LineWidth',1.5);
b(1).BaseValue = -0.1431;
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22])
%set(gca,'XTickLabel',{'uA','uG1','uG2','uI','uR','QA','QG','QI','QR','QX','Roff','Ron','KI1','KI2','KX','dx','d','NC','Cmin','Cmax','n','J'});
ylabel('Coupling index');
set(gca,'fontweight','bold','FontSize',14);
xtickangle(90);
%ylim([-0.21 -0.16])
set(gca,'LineWidth',2);
box on;
title(['Re-NF controller'])