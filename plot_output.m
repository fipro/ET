close all

%% prepare --------------------------------------
%% ----------------------------------------------

% sums
bmassum     = sum(bmas);
ng_sum      = sum(ng);
gg_sum      = sum(gg);
agg_sum     = sum(agg);
hgg_sum     = sum(hgg);
metalosssum = sum(metaloss);
predlosssum = sum(predloss);  
eglosssum   = sum(egloss);
aelosssum   = sum(aeloss);

losses = metalosssum+predlosssum;

% group specific biomass
bmasauto=sum(bmas((TtrT(:,1)==1),:));
bmashetr=sum(bmas((TtrT(:,1)==2),:));
bmasmixo=sum(bmas((TtrT(:,1)==3),:));
   
% trophic types
trophic(1) = sum(TtrT(:,1)==1);
trophic(2) = sum(TtrT(:,1)==2);
trophic(3) = sum(TtrT(:,1)==3);

% biomass types bins
y(1)=1e-12;
x(1)=1e-11;
for i=1:15
    %bin(i)=sum(t_si(t_si>y(i) & t_si<x(i)));
    bin(i)=sum(t_si(t_si>y(i) & t_si<x(i)));
    y(i+1)=y(i)*10;
    x(i+1)=x(i)*10;
end

% exsisting parameters over time
 for i=1:t
 
p_up_dead = p_up_d(p_time_d(i)~=0);
 max_p_up(i) = max([p_up_dead,p_up]);    
 min_p_up(i) = min([p_up_dead,p_up]);    
 mean_p_up(i) = mean([p_up_dead,p_up]);    
     
 p_ae_dead = p_ae_d(p_time_d(i)~=0);
 max_p_ae(i) = max([p_ae_dead,p_ae]);    
 min_p_ae(i) = min([p_ae_dead,p_ae]);    
 mean_p_ae(i) = mean([p_ae_dead,p_ae]);    
 
  p_sp_dead = p_sp_d(p_time_d(i)~=0);
 max_p_sp(i) = max([p_sp_dead,p_sp]);    
 min_p_sp(i) = min([p_sp_dead,p_sp]);    
 mean_p_sp(i) = mean([p_sp_dead,p_sp]);    
 
 p_kI_dead = p_kI_d(p_time_d(i)~=0);
 max_p_kI(i) = max([p_kI_dead,p_kI]);    
 min_p_kI(i) = min([p_kI_dead,p_kI]);    
 mean_p_kI(i) = mean([p_kI_dead,p_kI]);    

 p_kP_dead = p_kP_d(p_time_d(i)~=0);
 max_p_kP(i) = max([p_kP_dead,p_kP]);    
 min_p_kP(i) = min([p_kP_dead,p_kP]);    
 mean_p_kP(i) = mean([p_kP_dead,p_kP]);  
 
  p_kN_dead = p_kN_d(p_time_d(i)~=0);
 max_p_kN(i) = max([p_kN_dead,p_kN]);    
 min_p_kN(i) = min([p_kN_dead,p_kN]);    
 mean_p_kN(i) = mean([p_kN_dead,p_kN]);    
 
 p_umax_dead = p_umax_d(p_time_d(i)~=0);
 max_p_umax(i) = max([p_umax_dead,p_umax]);    
 min_p_umax(i) = min([p_umax_dead,p_umax]);    
 mean_p_umax(i) = mean([p_umax_dead,p_umax]);    

 end

  [xx maxpos ]=max(s_sp);
[xx minpos ]=min(s_sp);


%% plot------------------------------------------
%% ----------------------------------------------

%% parameters

figure
subplot(4,2,1)
plot(mean_p_up,'black');
hold on
plot(min_p_up,'red');
plot(max_p_up,'red');
title('uptake');

subplot(4,2,2)
plot(mean_p_umax,'black');
hold on
plot(min_p_umax,'red');
plot(max_p_umax,'red');
title('grazing');

subplot(4,2,3)
plot(mean_p_ae,'black');
hold on
plot(min_p_ae,'red');
plot(max_p_ae,'red');
title('assimilation effiency');

subplot(4,2,4)
plot(mean_p_sp,'black');
hold on
plot(min_p_sp,'red');
plot(max_p_sp,'red');
title('speed');

subplot(4,2,5)
plot(mean_p_kI,'black');
hold on
plot(min_p_kI,'red');
plot(max_p_kI,'red');
title('half sat. light');

subplot(4,2,6)
plot(mean_p_kN,'black');
hold on
plot(min_p_kN,'red');
plot(max_p_kN,'red');
title('half sat. nitrogen');

subplot(4,2,7)
plot(mean_p_kP,'black');
hold on
plot(min_p_kP,'red');
plot(max_p_kP,'red');
title('half sat. phosphate');

%% fields
figure
subplot(2,2,1)
contourf(DP(1:t-1,:)')
title ('org phosphate');
set(gca,'Ydir','reverse');
shading flat;
h=colorbar;

subplot(2,2,2)
contourf(DN(1:t-1,:)')
title ('org nitrate');
set(gca,'Ydir','reverse');
shading flat;
h=colorbar;

subplot(2,2,3)
contourf(IP(1:t-1,:)')
title ('inorg phosphate');
set(gca,'Ydir','reverse');
shading flat;
h=colorbar;

subplot(2,2,4)
contourf(IN(1:t-1,:)')
title ('inorg nitrate');
set(gca,'Ydir','reverse');
shading flat;
h=colorbar;

%% phyto conc (chl)
 figure
 contourf(Pn(1:t-1,:)');
 title ('chl concentration');
 set(gca,'Ydir','reverse');
 shading flat;
 h=colorbar;
 
 %% light field
 
 figure
 contourf(I');
 title ('light');
 set(gca,'Ydir','reverse');
 shading flat;
 h=colorbar;
 

%% types % trophic types

figure
subplot(1,2,1)
plot(sort(nr_type),'*');
title('offspring types');
subplot(1,2,2)
plot(trophic,'*');
title('trophic types 1=auto 2=hetero 3=mixo');

%% size structure

figure
subplot(2,1,1)
plot(sort(t_si));
title('size distribution per tracer');
subplot(2,1,2)
hist(t_si);
title('histogram size');

figure
subplot(2,1,1)
semilogx(y(1:15)*5,bin,'*');
title('biomass per size bin [semilog]');
subplot(2,1,2)
loglog(y(1:15)*5,bin,'*');
title('biomass per size bin [loglog]');

%% hetero vs. auto

figure
plot(hgg_sum,'red')
 hold on;
 plot(agg_sum,'green')
  legend('hetero','auto');
  title('total sum production'); 

    %% over all biomass & biomass per types
    
  figure
  plot(bmassum,'black');
  hold on
    plot(bmasauto,'green');
     plot(bmashetr,'red');
      plot(bmasmixo,'blue');
  title('total biomass');
  legend('total','auto','hetero','mixo');
 
  %% mobility
  % mobility distribution
  figure
  plot(sort(mobi));
  title('mobitliy scaling');  
  
  % speed of fastest and slowest over time
figure
plot(1:length(position(1,:)),position(maxpos,:),'red');
hold on;
plot(1:length(position(1,:)),position(minpos,:),'black');
set(gca,'Ydir','reverse');
title('vertical position over time');
legend('fastest','slowest');
  
%% growth & losses
  
  figure
  plot(ng_sum,'black')
  hold on;
  plot(gg_sum,'green')
  plot(losses,'red');
  plot(-aelosssum,'blue');
  legend('net growth','gross growth','losses(meta+pred)','assimilation losses');
  title('total sum values');
  
  %% losses
% 
% figure
% plot(losses./bmassum,'black');
% hold on;
% plot(predlosssum./bmassum,'red');
% plot(aelosssum./bmassum,'blue');  
% % hold on;
% plot(metalosssum./bmassum,'green');
% %plot(metalosssum./bmassum,'green--');
% title('losses per biomass');
% legend('total','predation','egestion','metabolic');
% 
% figure
% %plot(losses,'black');
% %hold on;
% plot(predlosssum,'red');
% hold on;
% plot(aelosssum,'blue');  
% % hold on;
% plot(metalosssum,'green');
% %plot(metalosssum./bmassum,'green--');
% title('losses absolute');
% legend('total','predation','egestion','metabolic');