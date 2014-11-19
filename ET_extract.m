
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
   
   agg(i,:)  =a(i).Sagg(:);
   hgg(i,:)  =a(i).Shgg(:);
   
   Tsi(i)=a(i).Tsi;
   Ttr(i,:)=a(i).Ttr(:);

   TAS(:,i)=a(i).Tstr(:);

   TCNP_S(i,:)=a(i).CNP(1,1:2);
   TCNP_PS(i,:)=a(i).CNP(2,1:2);
   TCNP_MS(i,:)=a(i).CNP(3,1:2);
   
   TAG_S(i,1)=a(i).TagS(1);
   TAG_S(i,2)=a(i).TagS(2);
   TAG_S(i,3)=a(i).TagS(3);
   
   TAG_AS(i,1)=a(i).TagAS(1);
   TAG_AS(i,2)=a(i).TagAS(2);
   TAG_AS(i,3)=a(i).TagAS(3);
   
   TAG_PS(i,1)=a(i).TagPS(1);
   TAG_PS(i,2)=a(i).TagPS(2);
   TAG_PS(i,3)=a(i).TagPS(3);
   
   TAG_MS(i,1)=a(i).TagMS(1);
   TAG_MS(i,2)=a(i).TagMS(2);
   TAG_MS(i,3)=a(i).TagMS(3);
   
   end