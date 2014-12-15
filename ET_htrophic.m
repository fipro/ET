
          % detection range                 distance
Adet=((1+s_si(nr))*(1+s_si(:)))>(pdist2(s_po(nr),s_po','euclidean'))';

% size
Adet = Adet.*( (max(0,  (a(nr).TagSF - (abs(1-(s_si(:)./a(nr).TagSV))))./a(nr).TagSF )) > 0);

% uptake saturation / handling time -> only eat when the stomach is empty
% proportion of total structural uptake
Adet = Adet.*(s_us(nr) ~= 1);

% no self-feeding -> set own to zero
Adet(nr) = 0;

s_up(:,1) =  Adet .* (a(nr).TagASW .* max(0, (a(nr).TagASF - (abs(1-([a.TstrA]./a(nr).TagASV))))./a(nr).TagASF ))';
s_up(:,2) =  Adet .* (a(nr).TagPSW .* max(0, (a(nr).TagPSF - (abs(1-([a.TstrP]./a(nr).TagPSV))))./a(nr).TagPSF ))';
s_up(:,3) =  Adet .* (a(nr).TagMSW .* max(0, (a(nr).TagMSF - (abs(1-([a.TstrM]./a(nr).TagMSV))))./a(nr).TagMSF ))';

Aup=s_up(:,3)+s_up(:,2)+s_up(:,1);
% sort feeding encounters
[Aval Apos] = (sort(Aup));
Apos        = fliplr(Apos(Aval~=0));

getm=[];  
giv=[];

NA = a(nr).TstrA .*a(nr).CNA;
NP = a(nr).TstrP .*a(nr).CNP;
NM = a(nr).TstrM .*a(nr).CNM;
PA = a(nr).TstrA .*a(nr).CPA;
PP = a(nr).TstrP .*a(nr).CPP;
PM = a(nr).TstrM .*a(nr).CPM;

for i=Apos'

    if (s_us(nr)<1)

        s_lim=[];
        dNA =[];
        dNP =[];
        dNM =[];
        dPA =[];
        dPP =[];
        dPM =[];

        % winner gets - uptake
        %            size of prey     max uptake        max space in stomach         
        getm = min([ s_si(i) , Aup(i)* s_si(nr), (1-s_us(nr))*a(nr).sts*s_si(nr)]); 

         %   getm = min([ s_si(i) , Aup.* s_si(nr), (1-s_us(nr))*a(nr).sts*s_si(nr)]); 


        %% assimilation 
        dNA = a(i).TstrA .*a(i).CNA - NA;
        dNP = a(i).TstrP .*a(i).CNP - NP;
        dNM = a(i).TstrM .*a(i).CNM - NM;  

        dPA = a(i).TstrA .*a(i).CPA - PA;
        dPP = a(i).TstrP .*a(i).CPP - PP;
        dPM = a(i).TstrM .*a(i).CPM - PM; 

        % find limiting resource 
        s_lim=min(dNA+dNP+dNM,dPA+dPP+dPM);
        s_lim=min(0,s_lim);

        % gross growth
        s_hgg(nr) = getm.*(1+s_lim)'.* a(nr).ae;

        % predation losses
        s_pl(i) = getm;    

        % losses due to assimilation effiency and nutrient mismatch
        s_aen(nr) = getm-s_hgg(nr);

        % update stomach
        s_us(nr) = s_us(nr) + getm./(a(nr).sts*s_si(nr)); 

        % update prey biomass
        s_si(i) = s_si(i)-s_pl(i);

     end
             % update position 
    % attacker goes to last defenders position and defender stays
    s_po(nr) =  s_po(i);
end