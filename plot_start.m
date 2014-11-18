%% plot------------------------------------------
%% ----------------------------------------------
close all


%bmas=zeros(length(anew),t-1);
%bmas=zeros(length(anew),t-1);

for i=1:length(a)
   
   bmas(i,:)    =a(i).s(:);
   netloss(i,:) =a(i).Snl(:);    
   metaloss(i,:)=a(i).Sml(:);
   predloss(i,:)=a(i).Spl(:);  
   egloss(i,:)  =a(i).Sel(:);
   aeloss(i,:)  =a(i).Sal(:);
   
   
   gg(i,:)  =a(i).Sgg(:);
   ng(i,:)  =a(i).Sng(:);
   
     
end

%% sums
 bmassum     = sum(bmas);
   
  ng_sum=sum(ng);
  gg_sum=sum(gg);
  
      
  netlosssum  = sum(netloss);    
  metalosssum = sum(metaloss);
  predlosssum = sum(predloss);  
  eglosssum   = sum(egloss);
  aelosssum   = sum(aeloss);
 
 %% Bmass
 figure
 
 semilogy(bmas)
 
  %% over all biomass
    
  figure
  plot(bmassum)
  
  %% growth & losses
  
  figure
  plot(ng_sum,'black')
  hold on;
  plot(gg_sum,'green')
  plot(netlosssum,'red');
  legend('net growth','gross growth','net losses');
  
  %% losses

 % totlosssum=(netlosssum+predlosssum);
  
  figure
   plot(netlosssum./bmassum,'black');
   hold on;
  plot(predlosssum./bmassum,'red');
  plot(aelosssum./bmassum,'blue');  
 % hold on;
 plot(metalosssum./bmassum,'green');
  %plot(metalosssum./bmassum,'green--');
  title('losses');
  legend('total','predation','egestion','metabolic');
  