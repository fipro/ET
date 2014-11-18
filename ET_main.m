clear all; close all; clc;
tic;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++  E.T. Model  ++++++++++++++++++++++++++++++++++
%+++++++++++++++++++  (Evolutionary Trait Model)  +++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Version  11/11/2014

% trade offs 
%  size range of attackability (flex): lower assimilation efficency
%  mismatch in optimal composition: reduces uptake by the mismatch proportion

global iparam a 

%% parameters
ET_param

%% initial
ET_initial

%% nutrient fields

    ma(1:nGrid) =   -   diff;
    mb(1:nGrid) = 1 + 2*diff;
    mc(1:nGrid) =   -   diff;
  
    %Boundary conditions:
    mb(1) = 1 + diff; % surface Closed
    mb(end) = 1 + diff; % bottom closed
    
     % this would be for sediment at the bottom, not needed
     % param.Rb = 30;   % Nutrient concentration in the sediment
     % param.h = 0.01;   % Sediment-water column permeability
     % mb(end) = 1 + d + param.dt*param.p/param.dz; % Diffusion from bottom
     % Sn(end) = param.dt*param.h*param.Rb/param.dz;  
  
    % assemble matrix
    A(2:nGrid+1:nGrid*nGrid)       = ma(2:end);
    A(1:nGrid+1:nGrid*nGrid)       = mb;
    A(nGrid+1:nGrid+1:nGrid*nGrid) = mc(1:end-1);

for t= 2:nTime
    
    disp(['time: ',num2str(t),'   Agents alive: ' ,num2str(nAgents)]);            % print so see progress

%% light field
% thing about how to estiamte chlorohpyll; to get extinction due to
% phytoplankton, so for now just water turbidity
% I=iparam.I0*exp(-cumsum(iparam.Kp*phi+iparam.Kw)*iparam.dz);
I = iparam.I0 * exp( -cumsum(iparam.Kp*z));                         % Extinction by water
 
%% nutrient fields
% calc reaction
   %dIN = -uP     .*P(i-1,:) +  param.remin*D(i-1,:);
   dIN = -0.5;
   dIP = -0.5;
   dDOM = -0.5;
   
   % solve
   s(1,:)=(IN(t-1,:)+dIN*iparam.dt); 
   IN(t,:)=A\(s)';
   
   s(1,:)=(DOM(t-1,:)+dDOM*iparam.dt); 
   DOM(t,:)=A\(s)';
   
   s(1,:)=(IP(t-1,:)+dIP*iparam.dt); 
   IP(t,:)=A\(s)';
   
   % kill negatives
   IN(t,:) = max(0, IN(t,:)); 
   IP(t,:) = max(0, IP(t,:)); 
   DOM(t,:) = max(0, DOM(t,:)); 

    
%% update size
 
    %Size
    s_si = max(0, s_si + s_ng) ;  
    
               
     %% reproduction/seeding
    
    % are you willing?
    s_rep = (s_si>t_si);
    
    if (sum(s_rep(:)) ) ~= 0;
         
       ET_seed
    end
    
    
    %% update states
    
    % handling time
    % maximum evacualtion rate of stomach is related to metabolic structure
    % note, only empty stomach can eat
    % e.g. if MS=0.33 than 0.33 of the max uptake can be reduced
    % the formulation below will still work if partital feeding on full
    % stomach should will be implemented
    % currently the max 'stomach size' is the the max uptake p_up
    s_us = max(0,(s_us + s_gg) - (p_up.*s_si*t_str(:,3))') ;  

    % speed   
    s_sp  =  p_sp.*s_si;  % actual speed
   
   
 %% re-arrange array, removing dead ones  
    
 % dead or alive
 % you die when less than X of your mature size
  a0 = find (s_si  == 0);
  [aval apos] = find(s_si ~= 0);
 % a0 = find (s_si  < t_si*0.2);
 %[aval apos] = find(s_si  >= t_si*0.2);
 nAgents=length(aval);
 
% dead one into dead array
 deadlen=length(a_dead) - 1;
 for idead = 1:length(a0)
     a_dead(deadlen + idead) = a(a0(idead));
 end

%only alive ones stay
 anew= a(1);
 for ilive = 1:nAgents
     anew(ilive) = a(apos(ilive));
 end
 a=anew;

 % ...and now update the length of the arrays for
 % the matrix
 ran=sparse(nAgents,1);
 
 Adet = sparse(nAgents,nAgents);
 Aenc = sparse(nAgents,nAgents);
 Asi = sparse(nAgents,nAgents);
 Afit = sparse(nAgents,nAgents);
% Amov = sparse(alen);
 Aus = sparse(nAgents,nAgents);
 Adis = sparse(nAgents,nAgents);
 Afea=sparse(nAgents,nAgents);
 Afe=sparse(nAgents,nAgents);
 
 AcomAS = sparse(nAgents,nAgents);
 AcomPS = sparse(nAgents,nAgents);
 AcomMS = sparse(nAgents,nAgents);
 
 Agetm=sparse(1,nAgents,nAgents);
 Agetmm=sparse(1,nAgents,nAgents);
 Agea=sparse(1,nAgents,nAgents);
   
 % traits
 t_str   = t_str(apos,:);
 t_si    = t_si(apos);
 t_tagS  = t_tagS(apos,:);
 t_tagAS = t_tagAS(apos,:);
 t_tagPS = t_tagPS(apos,:);
 t_tagMS = t_tagMS(apos,:);
 t_CNPAS = t_CNPAS(apos,:);
 t_CNPPS = t_CNPPS(apos,:);
 t_CNPMS = t_CNPMS(apos,:);
 t_stor  = t_stor(apos,:);

 % parameters
 p_ae = p_ae(apos);
 p_up = p_up(apos);
 p_sp = p_sp(apos);
 
 % states
 s_si   = s_si(apos);
 s_str  = s_str(apos,:);
 s_sp   = s_sp(apos);
 s_po   = s_po(apos);
 s_us   = s_us(apos);
 s_me   = s_me(apos,:);
 s_ng   = s_ng(apos);
 s_eg   = s_eg(apos);
 s_gg   = s_gg(apos);
 s_pl   = s_pl(apos);
 s_nl   = s_nl(apos); 
 s_met = s_met(apos);
 s_aen = s_aen(apos);

   %% agent loop
    for nr = 1:nAgents

    %% move

        % move / with d being diffusion (needs to be defined)
     %   ran(nr,:) = -1 + ( rand ( 1, 2 ) * 2 ) ;
         ran(nr) = -1 + ( rand(1) * 2 ) ;

        % new position
        s_po(nr)=  s_po(nr) + (2*ran(nr)'*sqrt(2*iparam.r^-1*s_sp(nr)))';
     
        % Sticky boundary conditions
      %  s_po(nr,:)= max ( s_po(nr,:), 1) ;            % set bottom boundary
       % s_po(nr,:) = min ( iparam.nGrid, s_po(nr,:)) ;   % set surface boundary
        s_po(nr)= max ( s_po(nr), 1) ;            % set bottom boundary
        s_po(nr) = min ( iparam.Depth, s_po(nr)) ;   % set surface boundary
 
        
           %% encounter ?

        for nr2 = 1:nAgents
               
            % matrix of all specific detection radius relations
            Adet(nr, nr2)= (1 + s_si(nr)) * (1+ s_si(nr2));

            % does the size fit?
            Asi(nr,nr2) = t_tagS(nr,3) * max(0.0 , 1 - (abs ( t_tagS(nr,1)*s_si(nr) - t_si(nr2))/ (t_tagS(nr,2)*s_si(nr2))));
   
            % does the composition fit
            AcomAS(nr,nr2) = t_tagAS(nr,3) * max(0.0 , 1 - (abs ( t_tagAS(nr,1) - t_str(nr2,1))/ (t_tagAS(nr,2)*s_str(nr2,1))));
            AcomPS(nr,nr2) = t_tagPS(nr,3) * max(0.0 , 1 - (abs ( t_tagPS(nr,1) - t_str(nr2,2))/ (t_tagPS(nr,2)*s_str(nr2,2))));
            AcomMS(nr,nr2) = t_tagMS(nr,3) * max(0.0 , 1 - (abs ( t_tagMS(nr,1) - t_str(nr2,3))/ (t_tagMS(nr,2)*s_str(nr2,3))));
                   
            % can I catch you?
            %Amov(nr,nr2)= s_sp(nr)>s_sp(nr2);
         
        end

        % uptake saturation / handling time
        % only eat when the stomach is empty
        Aus(nr,:) = (s_us(nr) == 0);  

     end
        
    % find distance between agents & see if they can detect each other
    Adis=(squareform(pdist(s_po,'euclidean'))); 
    Aenc=(Adet>Adis); 

    % who will have a real feeding encounter (encounter, hunger, size, composition)
    Afit = Asi .* Aenc .*Aus .* AcomAS .* AcomPS .* AcomMS; %.* Amov  
    
    % find best fitting prey
    [Afex Afey] =max(Afit');
    for i=1:nAgents        % write value (afex) to corresponding position
        Afea(i,Afey(i))= Afex(i);
    end
    
    % remove muiltiple predators
     [Afeax Afeay] =max(Afea);
     for i=1:nAgents        % write value (afex) to corresponding position
        Afe(Afeay(i),i)= Afeax(i);
    end

    % set diagonal to zero (don't eat yourself)
    Afe(logical(eye(size(Afe)))) = 0;

 %% feeding ?   

    if (sum(Afe(:))) ~= 0 ;  
        
      ET_grow;
      
    else
        s_pl(:) = 0;
        s_gg(:) = 0;
        Agetm = 0;
        Ca=1;
    end
    
    %% loss terms

    % metabolic losses
    % standard metabolism / proportion of your own total size
    s_me(:,1) = iparam.sm.*s_si(:) ;           
    % active metabolism / part of everything that has been ingeested (not
    % nessarily digested)
    %s_me(Ca(1,:),2) = iparam.am*Agetm'; 
    s_me(:,2) = iparam.am.*s_gg; 
    % movement costs / relative speed * actual size ^2 * cost parameter
    s_me(:,3) = iparam.mm.*s_si(:).*s_sp(:);        

    % total metabolic losses
    s_met  = sum(s_me');  % total metabolic costs
 
    %% egestion
    %  meatbolic losses + sloppy feeding + nutrient mismatch
    s_eg = s_met + s_aen;
    
        % overall losses
    s_nl = s_pl + s_met + s_aen;
    
%     %% total losses
%     s_loss = s_eg + s_pl;
%     
%     Agetmm(Ca(1,:)) = Agetm;
%     % from assimilation (efficency + nutrient inbalance)
%     Aega= (Agetmm - s_gg);
%     
%     % assimilation + metabolism
%     s_eg = s_met + Aega  ;
%  
   
    % net growth
    % not s_aen because it represents the losses that are not even
    % assililated
    s_ng  = s_gg -  s_pl - s_met ; 
     
    
%% store updated structures and variables back to agent array

    for nr = 1:nAgents
       
        a(nr).time(t)  = t;  % time
        
        a(nr).s(t)     = s_si(nr);  % size
        a(nr).Str(t,1) = s_str(nr,1);    
        a(nr).Str(t,2) = s_str(nr,2);     
        a(nr).Str(t,3) = s_str(nr,3);    

        a(nr).Sgg(t)      = s_gg(nr);   % gross growth
        a(nr).Sng(t)      = s_ng(nr);   % netgrowth
        
        a(nr).Snl(t)      = s_nl(nr);   % net loss
        a(nr).Sml(t)      = s_met(nr); % metabolism losses
        a(nr).Spl(t)      = s_pl(nr) ;  % predation losses
        a(nr).Sel(t)      = s_eg(nr) ;  % egestion losses
        a(nr).Sal(t)      = s_aen(nr) ;  % assimilation + nut mismatch losses
         
        a(nr).Sp(t)     = s_po(nr); % agent position
        a(nr).Ssp(t)      = s_sp(nr) ;  % actual speed
        a(nr).Sus(t)      = s_us(nr);   % uptake saturation (stomach)
    
    end

    %% mutate
    
    ET_mutate

     
end



toc;
disp('job done');