%% parameters

%% domain

iparam.tEnd = 500;   % total time 
iparam.dt   = 1;     % time discretisation  

iparam.Depth  = 150 ; % depth (gridpoints) size of spatial dimension
iparam.dz   = 1 ; % spatial resolution in meters for grid

iparam.nAgents= 1000 ;  % number of agents

%% physics

% iparam.I0 = 100 ; % surface light [watt m^-2]
iparam.I0=10^5*12; % mikromols/m^2/s
iparam.Kp=0.015; % backround turbidity 
iparam.Kw=0.2; % attenuation coefficient of Phytoplankton (K)
iparam.d = 0.1  ; % diffusion for now

% inital resources (starting with Redfield)
iparam.IP0=10; % mmol N/m^3 
iparam.IN0=160; % mmol N/m^3   0.1
iparam.DOM=0; % mmol DOM/m^3

%% nutrients

% nutrient size

%NH4+ = 18.03851 g mol−1  / NO3- = 62.0049 g mol-1 /  NO2- = 46.01 g mol−1
iparam.INs = 10e-10;
%PO4 = 94.9714 g mol−1
iparam.IPs = 10e-10;
% same size since bound in organic molecules
% would be nice to have organic particles as well / so DOM and POM 
% random size when being egested could be a way forward
iparam.ONs = 10e-5;
iparam.OPs = 10e-5;

% order of structures (active,passive,metabolic, storage)
iparam.INStr(1,:)=[0, 1, 0, 0];
iparam.IPStr(1,:)=[0, 1, 0, 0];
iparam.ONStr(1,:)=[0, 1, 0, 0];
iparam.OPStr(1,:)=[0, 1, 0, 0];

%% biology

% time step should be set at scale with max base speed so speed at adult
% size, ti hsoudl be the fastest guy in town

% intial values
iparam.svar  = 15   ; % variability in agents intial size + prey optimal size 
% gives (15) a range of ~1 pg - 1 kg! units ar elater set to g in ET_intial
iparam.sfle  = 5; %iparam.svar*0.5; %/10 ; % max. felxibility of intial prey size felxibility / 1 - assimilation efficency
iparam.scon  = 0.7 ; %conversion efficency for structures  /  assimilation efficency
iparam.ins   = 0.5  ; % intial size as in trait size

% scaled (on size, speed, flex or anything else that seems to make sense)
iparam.sm    = 0.02;     % base standard metabolism   
iparam.am    = 0.1 ;      % base active metabolism 
iparam.mm    = 0.01;     % base movment cost  

%iparam.sm    = 0.01  ;     % base standard metabolism   
%iparam.am    = 0.05 ;      % base active metabolism 
%iparam.mm    = 0.01;     % base movment cost 

iparam.mut    =0.01 ;     % mutation properbility

% Some parameters for movement:
iparam.r = 0.33 ; % standard deviation
