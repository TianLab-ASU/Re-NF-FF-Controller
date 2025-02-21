%% Feedforward loop (FFL), a=1, Roff=0.5
clc
clear
global a Roff dx uI
a=1; 
Roff=.5;
dx=0.01;
uI=0.8;
Lara = linspace(0, 5*10^-3, 100);
y0=[1,0,0,0,0,0];
t=[0 1000];
    uI0=0.8*(1-(0:20)*.05);
for j=1:21
    uI=uI0(j);
    j
    for i=1:length(Lara)
        [t,y]=ode23(@(t,y) Model(t,y,Lara(i)),t,y0);
        RFP_FFLM(j,i)=y(end,5);
        GFP_FFLM(j,i)=y(end,4);
    end 

    if j==1||j==11
    subplot(2,2,3)
    plot(RFP_FFLM(j,:)/RFP_FFLM(j,end), GFP_FFLM(j,:)/GFP_FFLM(j,1));
    hold on
    end
end
%%
a=0;
Roff=0;
uI=0.8;
for i=1:length(Lara)
[t,y]=ode23(@(t,y) Model(t,y,Lara(i)),t,y0);
RFP_OL(i)=y(end,5);
GFP_OL(i)=y(end,4);
end
subplot(2,2,3)
plot(RFP_OL/RFP_OL(end), GFP_OL/GFP_OL(1),'b');
%%
GFP_nor=GFP_FFLM./GFP_FFLM(:,1);
subplot(2,2,1)
imagesc(Lara, uI0, GFP_nor)
set(gca, 'ydir','normal')
subplot(2,2,2)
Score=mean(GFP_nor'-1);
barh(uI0,Score,'BaseValue',0) 