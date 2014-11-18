
Ca=[];    
Agetm=[];    
Agiv=[];  
s_lim=[];
N1=[];
N2=[];
P1=[];
P2=[];
dN=[];
dP=[];

% select possible positive encounters / this way reduce to nessesary iters
%first predator / sec. prey
[Ca(1,:) Ca(2,:)] = find(Afe ~= 0);
[nrpair nrag] = size(Ca);


    %    disp([num2str(nrag)]);
     %   disp(['ca1 ',num2str(Ca(1,:))]);
      %  disp(['ca2 ',num2str(Ca(2,:))]);


% update position 
% attacker goes to defenders position and defender stays
s_po(Ca(1,:)) =  s_po(Ca(2,:));

% uptake compair offence & defence -> if ratio positive, than I can eat
% some part of you (max all).

% winner gets - uptake
Agetm(1: nrag) = min( s_si(Ca(2,:)) , p_up(Ca(1,:)).* s_si(Ca(1,:)) );  

% loser gives - loss
Agiv(1: nrag) = min( s_si(Ca(2,:)) , p_up(Ca(1,:)).* s_si(Ca(1,:)) );  

%% assimilation 

% find porportion of total uptake
N1= (t_str(Ca(1,:),1).*t_CNPAS(Ca(1,:),1) + t_str(Ca(1,:),2).*t_CNPPS(Ca(1,:),1)...
    +t_str(Ca(1,:),3).*t_CNPMS(Ca(1,:),1));
P1= (t_str(Ca(1,:),1).*t_CNPAS(Ca(1,:),2) + t_str(Ca(1,:),2).*t_CNPPS(Ca(1,:),2)...
    +t_str(Ca(1,:),3).*t_CNPMS(Ca(1,:),2));
N2= (t_str(Ca(2,:),1).*t_CNPAS(Ca(2,:),1) + t_str(Ca(2,:),2).*t_CNPPS(Ca(2,:),1)...
    +t_str(Ca(2,:),3).*t_CNPMS(Ca(2,:),1));
P2= (t_str(Ca(2,:),1).*t_CNPAS(Ca(2,:),2) + t_str(Ca(2,:),2).*t_CNPPS(Ca(2,:),2)...
    +t_str(Ca(2,:),3).*t_CNPMS(Ca(2,:),2));

% find limiting resource 
dN=  N2-N1;  % negatives indicate limitation
dP=  P2-P1;  % negatives indicate limitation
s_lim=min(dN,dP);
s_lim=min(0,s_lim);

% gross growth
s_gg          = zeros(1,nAgents);
s_gg(Ca(1,:)) = Agetm.*(1+s_lim)'.* p_ae(Ca(1,:));

% predation losses
s_pl          = zeros(1,nAgents);
s_pl(Ca(2,:)) = Agiv;    

% losses due to assimilation effiency and nutrient mismatch
s_aen          = zeros(1,nAgents);
s_aen(Ca(1,:)) = Agetm-s_gg(Ca(1,:));


