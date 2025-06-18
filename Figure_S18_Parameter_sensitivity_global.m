clc
clear
global a Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX
a=0; Roff=0.5; dx=0.0216; uI=0.8; QI=150; NC=50; Ron=0.1; uA=0.5; uG1=0.8; uG2=2; uR=0.5; KI1=.1; KI2=5; 
KX=5; J=0.001; Cmin=0.000001; Cmax=0.015; n=3; d=0.01; QG=50; QR=5; QA=150; QX=5; 

PP0=[Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX];
num_Samples = 1000; 
Parameter_change=PP0.*ones(num_Samples,length(PP0));
variable_Range = [Parameter_change(1,:)*0.8; Parameter_change(1,:)*1.2]; % 20% varience
rng default % For reproducibility
[lhs] = lhsdesign(num_Samples, length(PP0)); % Generate Latin Hypercube Sample
[Parameter_Rand_FF] = [lhs] .* (variable_Range(2,:) - variable_Range(1,:)) + variable_Range(1,:);

dx=0.01;
PP0_NF=[Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX];
Parameter_change_NF=PP0_NF.*ones(num_Samples,length(PP0_NF));
variable_Range_NF = [Parameter_change_NF(1,:)*0.8; Parameter_change_NF(1,:)*1.2]; % 20% varience
rng default % For reproducibility
[lhs] = lhsdesign(num_Samples, length(PP0_NF)); % Generate Latin Hypercube Sample
[Parameter_Rand_NF] = [lhs] .* (variable_Range_NF(2,:) - variable_Range_NF(1,:)) + variable_Range_NF(1,:);


%%
for run = 1:length(Parameter_Rand_NF)
    Parameter_temp=num2cell(Parameter_Rand_NF(run,:)); % define the column that will be chosen randomly
    [Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX]=deal(Parameter_temp{1:22});% define the column that will be chosen randomly
    a=0; Roff=0; % Open loop
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
    Coupling_index(run)=CI(RFP_NFL(1,:),GFP_NFL(1,:));
end
%%
for run = 1:length(Parameter_Rand_NF)
    Parameter_temp=num2cell(Parameter_Rand_NF(run,:)); % define the column that will be chosen randomly
    [Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX]=deal(Parameter_temp{1:22});% define the column that will be chosen randomly
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
    [Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX]=deal(Parameter_temp{1:22});% define the column that will be chosen randomly
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
figure()
histogram(Coupling_index,'LineWidth',1.5,'FaceColor',[1 0 0],'FaceAlpha',0.5,'EdgeColor',[1 0 0],'DisplayName','Open loop')
hold on;
histogram(Coupling_index_NF,'LineWidth',1.5,'FaceColor',[0 0.4470 0.7410],'FaceAlpha',0.5,'EdgeColor',[0 0.4470 0.7410],'DisplayName','Re-NF')   
hold on;
histogram(Coupling_index_FF,'LineWidth',1.5,'FaceColor',[0.9290 0.6940 0.1250],'FaceAlpha',0.5,'EdgeColor',[0.9290 0.6940 0.1250],'DisplayName','Re-NF-FF')
xlabel('Coulping index');
ylabel('Counts');
set(gca,'LineWidth',2);
box on;
set(gca,'fontweight','bold','FontSize',14);