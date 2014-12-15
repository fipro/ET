close all;

mkdir('initial_plots');

% size
figure(1)
semilogy(sort(s_si),'black');
hold on
semilogy(sort([a.Tsi]));
title('inital size ');
semilogy(sort(s_rad),'red')
legend ('size [g]','trait-size [g]', 'radius [m]'); 
print(1,'-dpng','-r300',[ 'initial_plots/size']);

% auto- hetero- mixotroph
figure(2)
subplot(2,1,1)
 hist(([a.TtrT]))
 title('auto(1)- hetero(2)- mixotroph(3)');
 subplot(2,1,2)
 plot(sort([a.TtrD]))
 title('degree of autotrophy');
 print(2,'-dpng','-r300',['initial_plots/trophy']);
 
 % active passive metabolic sturcutre
figure(3)
 plot(sort([a.TstrA]),'black')
 hold on
 plot(sort([a.TstrP]),'red')
 plot(sort([a.TstrM]))
  title('structures')
  legend('active','passive','metabolic');
  print(3,'-dpng','-r300',[ 'initial_plots/structures']);
  
  % mobility
  figure(4)
  subplot(2,1,1)
  plot(sort([a.Tmo]));
  title(' base Mobility');
  subplot(2,1,2)
    semilogy(sort([a.sp]));
    title('speed');
    print(4,'-dpng','-r300',[ 'initial_plots/mobility']);
  
  % C:N:P composition per struc
  figure(5)
  subplot(3,2,1)
  bar(sort([a.CNA]));
  title('active N'); 
    subplot(3,2,2)
  bar(sort([a.CPA]));
  title('active P'); 
    subplot(3,2,3)
  bar(sort([a.CNP]));
  title('passive N'); 
    subplot(3,2,4)
  bar(sort([a.CPP]));
  title('passive P'); 
    subplot(3,2,5)
  bar(sort([a.CNM]));
  title('metabolic N'); 
    subplot(3,2,6)
  bar(sort([a.CPM]));
  title('metabolic P'); 
  print(5,'-dpng','-r300',[ 'initial_plots/CNP_struc']);
 
 % overall C:N:P composition  
 figure(6)
 subplot(2,1,1)
  bar(sort([a.Ntot]));
  title('total proportional N'); 
    subplot(2,1,2)
  bar(sort([a.Ptot]));
  title('total proportional P');
  print(6,'-dpng','-r300',['initial_plots/CNP_comp']);
  
  % TAGs
  figure(7)
  subplot(2,2,1)
  plot(sort([a.TagSV]));
  errorbar(sort([a.TagSV]),sort([a.TagSF]))
  set(gca, 'YScale', 'log');
  title('size')
  subplot(2,2,2)
  plot(sort([a.TagASV]));
  errorbar(sort([a.TagASV]),sort([a.TagASF]))
  set(gca, 'YScale', 'log');
   title('active')  
  subplot(2,2,3)
  plot(sort([a.TagPSV]));
  errorbar(sort([a.TagPSV]),sort([a.TagPSF]))
  set(gca, 'YScale', 'log');
   title('passive')
    subplot(2,2,4)
  plot(sort([a.TagMSV]));
  errorbar(sort([a.TagMSV]),sort([a.TagMSF]))
  set(gca, 'YScale', 'log');
   title('metabolic')
   print(7,'-dpng','-r300',[ 'initial_plots/TAGs_value']);
   
   % TAG weights
   figure(8)
   subplot(1,3,1)
   hist([a.TagASW])
   title('active weights') 
   subplot(1,3,2)
   hist([a.TagPSW])
   title('passive weights') 
    subplot(1,3,3)
   hist([a.TagMSW])
   title('metabolic weights') 
   print(8,'-dpng','-r300',['initial_plots/TAGs_weights']);
   
   % assimilation efficeny
   figure(9)
   plot(sort([a.ae]))
   title('assim');
   print(9,'-dpng','-r300',[ 'initial_plots/assim_eff']);
  
   % stomach
   figure(10)
   subplot(2,1,1)
   plot(sort(iparam.evac*[a.TstrM]))
   title('stomach evaculation');
   legend([num2str(iparam.evac)]);
   subplot(2,1,2)
   plot(sort([a.sts]))
   title('stomach size');
   print(10,'-dpng','-r300',[ 'initial_plots/stomach']);
   
   % position in water column
   figure(11)
   [counts,bins] = hist(s_po); 
    barh(bins,counts);
    set(gca,'Ydir','reverse');
    ylabel('Depth [m]');
    title('vertical distribution');
    print(11,'-dpng','-r300',[ 'initial_plots/position']);
    
      % uptake sites (nutrients)
    figure(12)
    subplot(2,2,1)
    loglog(s_rad,s_nN)
    hold on
    loglog(s_rad,s_nP,'red')
    legend('N','P');
    ylabel('[nr]');
    xlabel('radius [m]');
    title('nr. of uptake sites');
  
     % surface faction covered
     subplot(2,2,2)
     loglog(s_rad,s_pN)
     hold on
     loglog(s_rad,s_pP,'red')
     legend('N','P');
     xlabel('radius [m]');
     title('surface faction covered with uptake sites');
    
     % handling time
     subplot(2,2,3)
     loglog(s_rad,s_hN)
     hold on
     loglog(s_rad,s_hP,'red');
     ylabel('[h]');
     legend('N','P');
         xlabel('radius [m]');
     title('handling time');
     
     % affinity Fiksen et al 2013 Eq.7
     subplot(2,2,4)
     loglog(s_rad,s_affN)
     hold on
      loglog(s_rad,s_affP,'red')
     legend('N','P');
         xlabel('radius [m]');
     title('nutirent affinity');
        print(11,'-dpng','-r300',['initial_plots/autotroph']);
     
     close all;