%% phoyosynthesis

% proportion of this agent of total uptake structure
prop(nr) = ((s_si(nr)*a(nr).Ntot)*a(nr).TtrD)/(Pauto(ceil(s_po(nr)*iparam.dz)));

% proportion of nutrients available to agent considering competition
INN(nr) = IN(t-1,ceil(s_po(nr)*iparam.dz))*prop(nr);
IPP(nr) = IP(t-1,ceil(s_po(nr)*iparam.dz))*prop(nr);
           
% light limitation
s_fI(nr) =  a(nr).IW * a(nr).umax*s_si(nr) * ...
    (I(t,(ceil(s_po(nr)*iparam.dz)))./(a(nr).kI+I(t,(ceil(s_po(nr)*iparam.dz)))));       % Light-dependent phytoplankton growth

%% Aksnes and Cao 2011 (original)
%(Fiksen et al 2013 Eq. 11 / Smith et al. 2014 Eq. 1)

% scaling arguments are extract from Fisksen et al 2013.
% handling time (per radius in days)
s_hN(nr) = (iparam.hNi*((s_si(nr).*10^12/0.216)^(1/0.939)).^-0.33)...
    /((60*60*24)*iparam.dt);
s_hP(nr) = (iparam.hPi*((s_si(nr).*10^12/0.216)^(1/0.939)).^-0.53)...
    /((60*60*24)*iparam.dt);

% fraction covered by uptake sites 
s_pN(nr)  = (iparam.pNi*((s_si(nr).*10^12/0.216)^(1/0.939)).^-0.18); 
s_pP(nr)  = (iparam.pPi*((s_si(nr).*10^12/0.216)^(1/0.939)).^-0.26); 

% nr of uptake sites
s_nN(nr) = 4.*s_pN(nr).*((s_rad(nr)).^2).*(iparam.s^-2);
s_nP(nr) = 4.*s_pP(nr).*((s_rad(nr)).^2).*(iparam.s^-2);

% affinity Fiksen et al 2013 Eq.7
s_affN(nr) = (4*pi*diff*s_rad(nr)*10^6) * (( s_nN(nr)*iparam.s*10^6) / ...
             ((s_nN(nr)*iparam.s*10^6) + (pi*s_rad(nr)*10^6*(1-s_pN(nr))) ));  
s_affP(nr) = (4*pi*diff*s_rad(nr)*10^6) * ((s_nP(nr)*iparam.s*10^6) / ...
             ((s_nP(nr)*iparam.s*10^6) + (pi*s_rad(nr)*10^6*(1-s_pP(nr))) ));  
    
% Aksnes and Cao 2011         
bN = (1/ s_affN(nr)*INN(nr)) + (s_hN(nr)/s_nN(nr));  
bP = (1/ s_affP(nr)*IPP(nr)) + (s_hP(nr)/s_nP(nr));  

cN = (s_hN(nr)/(4*s_nN(nr)*pi*s_rad(nr)*diff*INN(nr))) * ...
     (1-(pi*s_rad(nr)*s_pN(nr)/s_nN(nr)*iparam.s));
cP = (s_hP(nr)/(4*s_nP(nr)*pi*s_rad(nr)*diff*IPP(nr))) * ...
     (1-(pi*s_rad(nr)*s_pP(nr)/s_nP(nr)*iparam.s));

 % need 'real' in here, because low diffusion leads to sqrt(negative) ->
 % imaginary number
s_fN(nr) = a(nr).NW * ( (bN/2*cN) * (1-real(sqrt(1-(4*cN/bN^2)))) );
s_fP(nr) = a(nr).PW * ( (bP/2*cP) * (1-real(sqrt(1-(4*cP/bP^2)))) );

s_fN(IN(t-1,ceil(s_po(nr)*iparam.dz))<=0) = 0; % Fix potentially negative growth rates
s_fP(IP(t-1,ceil(s_po(nr)*iparam.dz))<=0) = 0; % Fix potentially negative growth rates

% get uptake
% this will need to be scaled to the units of uptake
% carbon by light
s_agg(nr) = min([s_fI(nr),s_fN(nr)/a(nr).Ntot,s_fP(nr)/a(nr).Ptot]);  % Effective growth rate

%s_agg = s_phy;

% note: at the second step value turn to Nan and than corrected
% to 0. after that every second value turns negative ->
% correted to zero. in the next step a value apears. most
% liekly from remin and since no growth on zero for timestep,
% the remin value materializes.
      