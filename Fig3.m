clc
clear

%% Negative feedback loop (NFL), a=0, Roff=0.5
global a Roff dx uI
a=0;
Roff=.5;
dx=0.01;
uI=0.8;
Lara = linspace(0, 5*10^-3, 100);
y0=[1,0,0,0,0,0];
t=[0 1000];

Roff0=(0:30)*0.025;

for j=1:31
    Roff=Roff0(j);
    for i=1:length(Lara)
        [t,y]=ode23(@(t,y) Model(t,y,Lara(i)),t,y0);
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
%%
GFP_nor=GFP_NFL./GFP_NFL(:,1);
subplot(2,2,1)
imagesc(Lara, Roff0,  GFP_nor)
set(gca, 'ydir','normal')
subplot(2,2,2)
Score=mean(GFP_nor'-0.5);
barh(Roff0, Score) 