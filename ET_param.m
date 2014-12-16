%% parameters
%% ---UNITS-------------------------------
% meters
% days
% gram carbon
% 
%% ---------------------------------------

%% Domain

iparam.tEnd = 24*365;   % total time 
iparam.dt   = 1/24;     % time discretisation (days) -> 1/24 = hours

iparam.Depth  = 50 ; % depth (gridpoints) size of spatial dimension
iparam.dz   = 1 ; % spatial resolution (m)

iparam.nAgents= 500 ;  % number of agents

%% physics

iparam.d = 1000  ; % Turbulent diffusivity (m^2/day)

% remineralization rate (1/day) (Beckmann & Hense, 2007)
iparam.rmin = 100;  % wasn't that 0.1?

% light
% 300 W m–2 (about 1380 µmol photons m–2 s–1)
iparam.I0 = 1380*(60*60*24)/1000; % surface light (mmol photons/m^2/day)
iparam.I0=10^5*12; % mikromols/m^2/s
iparam.Kp=0.2; %  Light attenuation coefficient by sea water (1/m)
iparam.Kw=0.015; % attenuation coefficient of Phytoplankton   (square meters per mmol of nitrogen)

%% biology

% time step should be set at scale with max base speed so speed at adult
% size, this should be the fastest guy in town

% intial values
iparam.svar  = 8   ; % variability in agents intial size + prey optimal size 
% gives (11) a range of ~1 pg - 1 g! units are later set to g in ET_intial
%        15 -> 1 kg
%        8  -> 1 mg  (~adult hyperborus)
% defines lower limit for size range 
iparam.lowlim = 10^12; 
%10^12=10e-12 -> 1 pg
%10^11=10e-11 -> 10 pg

iparam.sfle  = 5; % prey size felxibility (scaling factor) / 1 - assimilation efficency
iparam.ins   = 0.5  ; % intial size as in trait size

% scaled (on size, speed, flex or anything else that seems to make sense)
iparam.sm    = 0.01;     % base standard metabolism   
iparam.am    = 0.00 ;    % base active metabolism 
iparam.mm    = 0.005;    % base movement cost  

iparam.mut = 0.01 ;     % mutation properbility (day)

% Some parameters for movement:
iparam.mobs = 100; % scaling factor for general mobility
iparam.r = 0.33 ; % standard deviation (randomisation of movement)

% die at proportion of size of maturity
iparam.death = 0.1;

% size of uptake site [m] (Fiksen et al 2013 -> Berg & Purcell 1977)
iparam.s =  1*10^-9;

% uptake sites cover intercept (extracted from Fiksen et al 2013)
iparam.pNi = 2.41e-4 ;
iparam.pPi = 3.32e-4 ;

% handling time intercept (extracted from Fiksen et al 2013)
iparam.hNi = 1.07e-4; % [s]
iparam.hPi = 6.5e-4; % [s]

% scaling factor for evaculation rate of stomach
% 0-1 / if 1 than s_si.*[a.TstrM]
iparam.evac = 0.3;

% scaling factor for learning
% (higher value = slower learning / 1 = instantanius adaptation to optimal)  
iparam.lscale = 3;

%% intial values

% inital resources (starting with Redfield)
iparam.iniIP=0.016; % mmol N/m^3 
iparam.iniIN=0.106; % mmol N/m^3  
iparam.iniDN=0.1; % mmol DOM/m^3
iparam.iniDP=0.1; % mmol DOM/m^3