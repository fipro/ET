clear all; close all; clc;
tic;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++  E.T. Model  ++++++++++++++++++++++++++++++++++
%+++++++++++++++++++  (Evolutionary Trait Model)  +++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Version  15/12/2014

global iparam a 

%% parameters
ET_param

%% initial
ET_initial

%ET_intial_plot

%% Initial for realtime plotting
nplotAgents = 4 ;
selectedAgents = round(100*rand(1,nplotAgents)) ;


%% time loop

for t= 2:nTime

    disp(['time: ',num2str(t),'   Agents alive: ' ,num2str(nAgents)]);            % print so see progress
   
    
    %% light field
    
    % self-shading
    % this account in units of nitrogen, since all agents produce a shadow
    for nr= 1:nAgents
        Pn(t,ceil(s_po(nr)*iparam.dz)) = Pn(t-1,ceil(s_po(nr)*iparam.dz))...
                                       + (s_si(nr)*a(nr).Ntot);  
   end
  
    I(t,:) = iparam.I0 * exp( -cumsum(iparam.Kw*Pn(t-1,:))*iparam.dz ...  % Self-shading of all agents
          - iparam.Kp*z);                                                % Extinction by water 

      % collect all uptake structures per box (needed for nutrient uptake
      % competion)
      Pauto = zeros(1,nGrid);
   for nr= 1:nAgents
        Pauto(ceil(s_po(nr)*iparam.dz)) = Pauto(ceil(s_po(nr)*iparam.dz))...
                                       + (s_si(nr)*a(nr).Ntot*a(nr).TtrD); 
   end
      

%% update size
    s_si = max(0, (s_si + s_ng)) ;  
    %x = num2cell(max(0, (s_si(nr) + s_ng))) ;  

    % radius of agent (for autotrophs assuming spheric cell)
    %-----------------------------------------
    % g -> vol (menden-deuer & lassard 2000) / vol -> radius (spheric) / µm -> m
    s_rad = (((3.*((s_si./0.216).^(1/0.939))) ./ (4*3.141)).^(1/3) ) .*0.000001;  
             
%% reproduction/seeding
    % are you willing?

        if (any(s_si>[a.Tsi]) );
            s_rep = (s_si>[a.Tsi]);
            
           ET_seed
        end

%% update states

   % stomach evacuation: 0-1 degree of fullness
    s_us = max(0,s_us - iparam.evac*[a.TstrM]*iparam.dt);
         
    % speed   
    s_sp  =  [a.sp].*s_si*iparam.dt;  % actual speed

%% re-arrange array, removing dead ones  

    % dead or alive
    % you die when less than proportion of maturity (iparam.death)
    a0          = find(s_si < [a.Tsi]*iparam.death);
    [aval apos] = find(s_si >= [a.Tsi]*iparam.death);
    nAgents     = length(aval);

    % dead one into dead array
    deadlen = length(a_dead) - 1;
    for idead = 1:length(a0)
        a_dead(deadlen + idead) = a(a0(idead));
    end

    %only alive ones stay
    anew = a(1);
    for ilive = 1:nAgents
        anew(ilive) = a(apos(ilive));
    end
    a = anew;

    % ...and now update the length of the arrays
    ran  = zeros(nAgents,1);
  
    Asi  = zeros(nAgents);
    learn = zeros(nAgents,3);

    Agetm  = zeros(1,nAgents);
    Agetmm = zeros(1,nAgents);
    Agea   = zeros(1,nAgents);

    % states
    s_si  = s_si(apos);
    s_rad  = s_rad(apos);
    s_sp  = s_sp(apos);
    s_po  = s_po(apos);
    s_us  = s_us(apos);
    s_me  = s_me(apos,:);
    s_ng  = s_ng(apos);
    s_eg  = s_eg(apos);
    s_gg  = s_gg(apos);
    s_hgg = s_hgg(apos);
    s_pl  = s_pl(apos);
    s_met = s_met(apos);
   
    s_fI  = s_fI(apos);
    s_fN  = s_fN(apos);
    s_fP  = s_fP(apos);
    s_agg = s_agg(apos);
    s_aen = s_aen(apos);
 
    s_affN = s_affN(apos);   % nutrient affinity N
    s_affP = s_affP(apos);   % nutrient affinity P 
    s_pN   = s_pN(apos);     % density uptake nutrient sites N
    s_pP   = s_pP(apos);     % density uptake nutrient sites P
    s_hN   = s_hN(apos);  % handling time 
    s_hP   = s_hP(apos);  % handling time 
    s_nN   = s_nN(apos);  % nr. of uptake sites (porters)  N
    s_nP   = s_nP(apos);  % nr. of uptake sites (porters)  P

%% autotroph growth

% no autotrophic uptake -> will be overwritten if autotrophic
      s_agg          = zeros(1,nAgents);
    
    for nr = find([a.TtrT] ~= 2)   % agent loop only for autotrophics   

        %interpolate nutrient conc. for actual agent position
        INint(nr)=interp1(z,IN(t-1,1:end),(s_po(nr)*iparam.dz));
        IPint(nr)=interp1(z,IP(t-1,1:end),(s_po(nr)*iparam.dz));

        %interpolate light for actual agent position
        Iint(nr)=interp1(z,I(t,1:end),(s_po(nr)*iparam.dz));

        % autotrophic uptake
        ET_atrophic
        
    end
    
%% heterotrophic uptake

        s_hgg          = zeros(1,nAgents);
        s_pl           = zeros(1,nAgents);
        s_aen          = zeros(1,nAgents);

       Ca=1;

    % Food of the right size in range? Hungry? Only for heterotrophics
     AA=find([a.TtrT] ~= 1);
     
    %% %growth
   %function [s_si, s_us, s_hgg, s_pl, s_aen, s_po] = ET_grow(AA, nAgents, s_si, s_us, s_po)

     s_up=zeros(nAgents,3);
     Aup=zeros(1,length(AA));
     Aval =zeros(1,length(AA));
     Apos =zeros(1,length(AA));
     Adet = zeros(1,nAgents);


for nr = AA(randperm(length(AA))); % randomized feeding order
    
    % heterotrophic uptake
    ET_htrophic
       
end
  
            %% learn 
         ET_learn
  
    %% total uptake (hetero & auto)
   
    s_gg = s_hgg + s_agg;
  
%% loss terms

    % metabolic losses
    % standard metabolism / proportion of your own total size
    s_me(:,1) = iparam.sm.*s_si*iparam.dt ;           

    % mixotrohps need to maintain the two machineries  
    if (a(nr).TtrT == 3)
        s_me(:,1) = s_me(:,1)*2;
    end
    % active metabolism / part of everything that has been ingeested (not
    % nessarily digested)
    %s_me(Ca(1,:),2) = iparam.am*Agetm'; 
    s_me(:,2) = iparam.am.*s_gg; 
    % movement costs / relative speed * actual size ^2 * cost parameter
    s_me(:,3) = iparam.mm.*s_si.*s_sp;        

    % total metabolic losses
    s_met  = sum(s_me');  % total metabolic costs

%% egestion
    %  meatbolic losses + sloppy feeding + nutrient mismatch
    s_eg = s_met + s_aen;

    % net growth
    % not s_aen because it represents the losses that are not even assililated
    s_ng  = s_gg -  s_pl - s_met ; 

        
%% store updated structures and variables back to agent array

% this can possibly done outside a loop!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1!

    for nr = 1:nAgents

        a(nr).time(t) = t;  % time

        a(nr).s(t)   = s_si(nr);  % size

        a(nr).Shgg(t) = s_hgg(nr);   % gross growth
        a(nr).Sagg(t) = s_agg(nr);   % gross growth
        
        a(nr).Sgg(t) = s_gg(nr);   % gross growth
        a(nr).Sng(t) = s_ng(nr);   % netgrowth

        a(nr).Sml(t) = s_met(nr); % metabolism losses
        a(nr).Spl(t) = s_pl(nr) ;  % predation losses
        a(nr).Sel(t) = s_eg(nr) ;  % egestion 
        a(nr).Sal(t) = s_aen(nr) ;  % assimilation + nut mismatch losses
        a(nr).Sup(t)   = Aup(nr);   

        a(nr).Sp(t)  = s_po(nr); % agent position
        a(nr).Ssp(t) = s_sp(nr) ;  % actual speed
        a(nr).Sus(t) = s_us(nr);   % uptake saturation (stomach)
        
        a(nr).rad(t) = s_rad(nr);  % cell radius 

        a(nr).affN(t) = s_affN(nr);   % nutrient affinity
        a(nr).affP(t) = s_affP(nr);   % nutrient affinity
        a(nr).pN(t)   = s_pN(nr);     % density uptake nutrient sites
        a(nr).pP(t)   = s_pP(nr);     % density uptake nutrient sites
        a(nr).hN(t)   = s_hN(nr);  % handling time 
        a(nr).hP(t)   = s_hP(nr);  % handling time 
        a(nr).nN(t)   = s_nN(nr);  % nr. of uptake sites (porters) 
        a(nr).nP(t)   = s_nP(nr);  % nr. of uptake sites (porters) 
        
    end
   

    
%% mutate
  
    ET_mutate

%% nutrient fields - reaction
    
    % changes related to field 
    dN  =  + iparam.rmin*DN(t-1,:);      % Remineralization from the detritus
    dP  =  + iparam.rmin*DP(t-1,:);      % Remineralization from the detritus
    dDN =  - iparam.rmin*DN(t-1,:);
    dDP =  - iparam.rmin*DP(t-1,:);

    % changes related to agents    
    for nr = 1:nAgents

       dN(ceil(s_po(nr)*iparam.dz)) = dN(ceil(s_po(nr)*iparam.dz))...
              -s_agg(nr); % *t_Ntot(nr)*s_si(nr);

       dP(ceil(s_po(nr)*iparam.dz)) = dP(ceil(s_po(nr)*iparam.dz))...
             -s_agg(nr) ;%;*t_Ptot(nr)*s_si(nr); 

       dDP(ceil(s_po(nr)*iparam.dz)) = dDP(ceil(s_po(nr)*iparam.dz))...
             +s_eg(nr)*a(nr).Ptot*s_si(nr);

       dDN(ceil(s_po(nr)*iparam.dz)) = dDN(ceil(s_po(nr)*iparam.dz))...
             +s_eg(nr)*a(nr).Ntot*s_si(nr);
    end 
   
    % solve (implicit difussion)
    s(1,:)=(IN(t-1,:)+dN*iparam.dt); 
    IN(t,:)=A\(s)';

    s(1,:)=(IP(t-1,:)+dP*iparam.dt); 
    IP(t,:)=A\(s)';

    s(1,:)=(DN(t-1,:)+dDN*iparam.dt); 
    DN(t,:)=A\(s)';

    s(1,:)=(DP(t-1,:)+dDP*iparam.dt); 
    DP(t,:)=A\(s)';
   
    % kill negatives
    IN(t,:) = max(0, IN(t,:)); 
    IP(t,:) = max(0, IP(t,:)); 
    DN(t,:) = max(0, DN(t,:)); 
    DP(t,:) = max(0, DP(t,:)); 

    
       for nr=1:nAgents     
  %%   move agents

        % move / with d being diffusion (needs to be defined)
        ran(nr) = -1 + ( rand(1) * 2 ) ;

        % displacement due to diffusion
          s_po(nr) = s_po(nr) + 2*ran(nr)*sqrt(2*iparam.r^-1*diff);
 
        % movement due to mobility
        s_po(nr) =  s_po(nr) + (2*ran(nr)'*sqrt(2*iparam.r^-1*s_sp(nr)))';

        % Sticky boundary conditions
        %  s_po(nr,:)= max ( s_po(nr,:), 1) ;            % set bottom boundary
        %  s_po(nr,:) = min ( iparam.nGrid, s_po(nr,:)) ;   % set surface boundary
        s_po(nr) = max ( s_po(nr), 1) ;            % set bottom boundary
        s_po(nr) = min ( iparam.Depth, s_po(nr)) ;   % set surface boundary
       end
    
%% Update real life plots
    
  %  RealTimePlots ( a, 'Sng', selectedAgents, t ) ;
     
end

toc;
disp('job done');
