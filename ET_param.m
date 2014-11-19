%% parameters

%% domain

iparam.tEnd = 1000;   % total time 
iparam.dt   = 1;     % time discretisation  

iparam.Depth  = 200 ; % depth (gridpoints) size of spatial dimension
iparam.dz   = 1 ; % spatial resolution in meters for grid

iparam.nAgents= 1000 ;  % number of agents

%% physics

% iparam.I0 = 100 ; % surface light [watt m^-2]
iparam.I0=10^5*12; % mikromols/m^2/s
iparam.Kp=0.2; % backround turbidity (per meters)
iparam.Kw=0.015; % attenuation coefficient of Phytoplankton (K)  (square meters per mmol of nitrogen)
iparam.d = 100  ; % diffusion for now

% inital resources (starting with Redfield)
iparam.iniP0=0.016; % mmol N/m^3 
iparam.iniN0=0.106; % mmol N/m^3   0.1
iparam.iniDOM=0; % mmol DOM/m^3

%% nutrients

% nutrient size

%NH4+ = 18.03851 g mol−1  / NO3- = 62.0049 g mol-1 /  NO2- = 46.01 g mol−1
iparam.Is = 10e-10;
%PO4 = 94.9714 g mol−1
%iparam.IPs = 10e-10;
% same size since bound in organic molecules
% would be nice to have organic particles as well / so DOM and POM 
% random size when being egested could be a way forward
iparam.Os = 10e-5;

% remineralisatoin rate Detritus -> nutrients
iparam.rmin = 0.1;

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
% gives (15) a range of ~1 pg - 1 kg! units are later set to g in ET_intial
iparam.sfle  = 5; %iparam.svar*0.5; %/10 ; % max. felxibility of intial prey size felxibility / 1 - assimilation efficency
iparam.scon  = 0.7 ; %conversion efficency for structures  /  assimilation efficency
iparam.ins   = 0.5  ; % intial size as in trait size

% scaled (on size, speed, flex or anything else that seems to make sense)
iparam.sm    = 0.02;     % base standard metabolism   
iparam.am    = 0.1 ;      % base active metabolism 
iparam.mm    = 0.05;     % base movment cost  

%iparam.sm    = 0.01  ;     % base standard metabolism   
%iparam.am    = 0.05 ;      % base active metabolism 
%iparam.mm    = 0.01;     % base movment cost 

iparam.mut = 0.01 ;     % mutation properbility

% Some parameters for movement:
iparam.r = 0.33 ; % standard deviation

% die at proportion of size of maturity
iparam.death = 0.25;