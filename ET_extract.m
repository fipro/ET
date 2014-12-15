
for i=1:length(a)
   
   nr(i,:)      = a(i).nr(:);  % create struc. for agents
   nr_type(i,:) = a(i).typenr(:);
      
   bmas(i,:)    =a(i).s(:);
  
   metaloss(i,:)=a(i).Sml(:);
   predloss(i,:)=a(i).Spl(:);  
   egloss(i,:)  =a(i).Sel(:);
   aeloss(i,:)  =a(i).Sal(:);
   
   position(i,:)  =a(i).Sp(:);
   speed(i,:)  =a(i).Ssp(:);
   
   uptake_sat(i,:)  =a(i).Sus(:);
   
   gg(i,:)  =a(i).Sgg(:);
   ng(i,:)  =a(i).Sng(:);
   
   mobi(i)=a(i).Tmo ;
   speed(i,:) = a(i).Ssp(:);
   
   agg(i,:)  =a(i).Sagg(:);
   hgg(i,:)  =a(i).Shgg(:);
   
   Tsi(i)=a(i).Tsi;
   t_si(i)=a(i).Tsi;
   TtrT(i,:)=a(i).TtrT(:);
   TtrD(i,:)=a(i).TtrD(:);

   
   TASA(:,i)=a(i).TstrA(:);
   TASP(:,i)=a(i).TstrP(:);
   TASM(:,i)=a(i).TstrM(:);

   TCNP_AS(i,:)=a(i).CNA(:);
   TCNP_PS(i,:)=a(i).CNP(:);
   TCNP_MS(i,:)=a(i).CNM(:);
  
   TCNP_AS(i,:)=a(i).CPA(:);
   TCNP_PS(i,:)=a(i).CPP(:);
   TCNP_MS(i,:)=a(i).CPM(:);
   
   TAG_S(i,1)=a(i).TagSV(:);
   TAG_S(i,2)=a(i).TagSF(:);
     
   TAG_AS(i,1)=a(i).TagASV(1);
   TAG_AS(i,2)=a(i).TagASF(1);
   TAG_AS(i,3)=a(i).TagASW(1);
   
   TAG_PS(i,1)=a(i).TagPSV(1);
   TAG_PS(i,2)=a(i).TagPSF(1);
   TAG_PS(i,3)=a(i).TagPSW(1);
   
   TAG_MS(i,1)=a(i).TagMSV(1);
   TAG_MS(i,2)=a(i).TagMSF(1);
   TAG_MS(i,3)=a(i).TagMSW(1);
   
aff(i,1) = a(i).affN(1);
aff(i,2) = a(i).affP(1);   % nutrient affinity
p(i,1) = a(i).pN(1);     % density uptake nutrient sites
p(i,2) = a(i).pP(1);     % density uptake nutrient sites
hand(i,1) = a(i).hN(1);  % handling time N
hand(i,2) = a(i).hP(1);  % handling time P
num(i,1) = a(i).nN(1);  % nr. of uptake sites (porters) 
num(i,2) = a(i).nP(1);  % nr. of uptake sites (porters) 
   
   % parameters
    p_up(i) = a(i).Sup(1);
    p_ae(i) = a(i).ae(1);
    p_sp(i) = a(i).sp(1); 
    p_sts(i) = a(i).sts(1);
   
end

%% dead ones
p_time_d=zeros(length(a_dead),t);

 for i=1:length(a_dead)
     
 p_up_d(i) = a_dead(i).Sup(1);
 p_sts_d(i) = a_dead(i).sts(1);
 p_ae_d(i) = a_dead(i).ae(1);
 p_sp_d(i) = a_dead(i).sp(1); 
 aff_d(i,1) = a(i).affN(1);
aff_d(i,2) = a_dead(i).affP(1);   % nutrient affinity
p_d(i,1) = a_dead(i).pN(1);     % density uptake nutrient sites
p_d(i,2) = a_dead(i).pP(1);     % density uptake nutrient sites
hand_d(i,1) = a_dead(i).hN(1);  % handling time N
hand_d(i,2) = a_dead(i).hP(1);  % handling time P
num_d(i,1) = a_dead(i).nN(1);  % nr. of uptake sites (porters) 
num_d(i,2) = a_dead(i).nP(1);  % nr. of uptake sites (porters) 
   
 p_umax_d(i) = a_dead(i).umax(1);
 
 p_time_d(i,1: length(a_dead(i).time(:))) = a_dead(i).time(:);
% 
 end