clc
clear
%% Find the optimal dx value at different conditions of resource competition;
global a Roff dx uI QI NC Ron uA uG1 uG2 uR KI1 KI2 KX J Cmin Cmax n d QG QR QA QX
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
t=[0 1000];
y0=[1,0,0,0,0,0];
[t,y]=ode23(@(t,y) Model0(t,y,Lara(1)),t,y0);
y0=y(end,:);
QR0=[0.5:0.1:1.5]*5;
dx0=0.01:0.001:0.03;
for j=1:length(QR0)
    j
    QR=QR0(j);
    tic
    for m=1:length(dx0)
        dx=dx0(m);
        for i=1:length(Lara)
            [t,y]=ode23(@(t,y) Model0(t,y,Lara(i)),t,y0);
            RFP_NFL(m,i)=y(end,5);
            GFP_NFL(m,i)=y(end,4);
        end

        Coupling_index(j,m)=CI(RFP_NFL(m,:),GFP_NFL(m,:));

    end
    toc

    dx0_for_min_CI(j)=interp1(Coupling_index(j,:),dx0,0)

end

save e_dx3.mat
%%
load e_dx3.mat
imagesc(QR0,dx0, Coupling_index')
xlabel('QR0')
ylabel('dx0 ')
caxis([-0.25 0.25]);
set(gca,'YDir','normal')
% Create a custom colormap: blue → white → red
n = 256; % number of colors
half = round(n/2);
blue = [linspace(0, 1, half)', linspace(0, 1, half)', ones(half, 1)];
red = [ones(half, 1), linspace(1, 0, half)', linspace(1, 0, half)'];
custom_cmap = [blue; red];
colormap(custom_cmap);
hold on
plot(QR0,dx0_for_min_CI,'linewidth',2)