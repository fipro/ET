%% initalize
 
global iparam a 

nTime = floor(iparam.tEnd/iparam.dt)+1;    % nr of iteration

% disretisation
diff = (iparam.dz^2)*iparam.d*iparam.dt;  

%% eulerian fields
z = 0.5*iparam.dz:iparam.dz:iparam.Depth+0.5*iparam.dz;
nGrid = length(z); % number of cells

IP = zeros(nTime,nGrid); % arrray inorganic phosphate        
IN = zeros(nTime,nGrid); % arrray inorganic nitrogen   
DN = zeros(nTime,nGrid); % arrray organic phosphate   
DP = zeros(nTime,nGrid); % arrray organic nitrogen   

% field for concentration of phytoplankton in units of nitrogen
% used in self-shading
Pn    = zeros(nTime,nGrid);
Pauto = zeros(nTime,nGrid);

% matrix
A = zeros(nGrid); 

% intial concentrations
IN(1,:) = iparam.iniIN; 
IP(1,:) = iparam.iniIP; 
DN(1,:) = iparam.iniDN;
DP(1,:) = iparam.iniDP;
 
% change matrices - set to zero
dN  = zeros(1,nGrid);
dP  = zeros(1,nGrid);
dDN = zeros(1,nGrid);
dDP = zeros(1,nGrid);


%% matrix
ma(1:nGrid) =   -   diff; 
mb(1:nGrid) = 1 + 2*diff;
mc(1:nGrid) =   -   diff;

% Boundary conditions:
mb(1)   = 1 + diff; % surface Closed
%mb(end) = 1 + diff; % bottom closed

% assemble matrix
A(2:nGrid+1:nGrid*nGrid)       = ma(2:end);
A(1:nGrid+1:nGrid*nGrid)       = mb;
A(nGrid+1:nGrid+1:nGrid*nGrid) = mc(1:end-1);

%% Agents

%% ---------------------------------------------------------------
%% ------------ create arrays ------------------------------------
%% ---------------------------------------------------------------
% intial values set to zero

s_si  = zeros(1,iparam.nAgents);
s_rad = zeros(1,iparam.nAgents);

s_sp  = zeros(1,iparam.nAgents);
s_po  = zeros(1,iparam.nAgents);
s_us  = zeros(1,iparam.nAgents);
s_met  = zeros(1,iparam.nAgents);  
s_pl  = zeros(1,iparam.nAgents);
s_eg  = zeros(1,iparam.nAgents);
s_me  = zeros(iparam.nAgents,3);
Agetm  = zeros(1,iparam.nAgents);
Aup  = zeros(1,iparam.nAgents);
s_aen  = zeros(1,iparam.nAgents);
s_agg  = zeros(1,iparam.nAgents);
s_hgg  = zeros(1,iparam.nAgents);
s_gg  = zeros(1,iparam.nAgents);
s_ng  = zeros(1,iparam.nAgents);
s_up  = zeros(3,iparam.nAgents);

s_pN  = zeros(1,iparam.nAgents);
s_pP  = zeros(1,iparam.nAgents);
s_affN  = zeros(1,iparam.nAgents);
s_affP  = zeros(1,iparam.nAgents);
s_hN  = zeros(1,iparam.nAgents);
s_hP  = zeros(1,iparam.nAgents);
s_nN  = zeros(1,iparam.nAgents);
s_nP  = zeros(1,iparam.nAgents);

s_fI  = zeros(1,iparam.nAgents);
s_fN  = zeros(1,iparam.nAgents);
s_fP  = zeros(1,iparam.nAgents);


for nr = 1:iparam.nAgents
% COUNT   
% identity nr for each agent (unique)
a(nr).nr = nr ;  % create struc. for agents

% nr for each type of agents (offsprings have the same nr)
% in the beginning equals to nr. 
a(nr).typenr = nr;

%% ---------------------------------------------------------------
%% ------------TRAITS---------------------------------------------
%% ---------------------------------------------------------------

% auto- hetero- or mixoTroph
%---------------------------
% 1st value - torphic type (1 = auto ; 2 = hetero; 3 = mixotroph) 
a(nr).TtrT = ceil(rand(1)*3);

% 2nd value - degree of mixotrophy (1 = only autotroph; 0 = only heterotroph)
if (a(nr).TtrT  == 3)
    a(nr).TtrD = rand(1);
elseif (a(nr).TtrT == 1)
    a(nr).TtrD = 1;
else
    a(nr).TtrD = 0;
end


% Mobitity (random around base value)
%------------------------------------
a(nr).Tmo    = rand(1)*iparam.mobs;   %(*(1-range) + (rand(1) * Tm*(2*range)));  % base mobility


% Size
%------------------------------------
% 'adult' size, threshold for reproduction
a(nr).Tsi = 10.^(rand(1) * iparam.svar)/iparam.lowlim;


% Relative Composition (sum of 1)  [AS, PS, HS]
%----------------------------------------------
% random numbers for optimal value
ranS1 = rand(1);
ranS2 = rand(1);
ranS3 = rand(1);

% composition 
a(nr).TstrA = ranS1/(ranS1+ranS2+ranS3);   % contribution active structure  
a(nr).TstrP = ranS2/(ranS1+ranS2+ranS3);   % contribution passive structure  
a(nr).TstrM = ranS3/(ranS1+ranS2+ranS3);   % contribution metabolic strcture


% relative N:P (in %)  [AS, PS, HS]
%----------------------------------------------
% phosphate 1-3 % of total
% nitrate 10-30 % of total
% C is the base unit, hence 1 in all cases
a(nr).CNA = [rand(1)*0.3] ; % C:N active
a(nr).CPA = [rand(1)*0.001] ; % C:P active
a(nr).CNP = [rand(1)*0.3] ; % C:N passive
a(nr).CPP = [rand(1)*0.001] ; % C:P activeSo: N2C & P2C in active in row 1, in passive in row 2, in storage in row 3
a(nr).CNM = [rand(1)*0.3] ; % C:N metabolism
a(nr).CPM = [rand(1)*0.1] ; % C:P metabolism

% total proprotion of N, P
a(nr).Ptot = (a(nr).CPA + a(nr).CPP + a(nr).CPM)*1/3;
a(nr).Ntot = (a(nr).CNA + a(nr).CNP + a(nr).CNM)*1/3;

%% --------------------------------------------------------------               
%% TAGS ---------------------------------------------------------
%% --------------------------------------------------------------
% random numbers for optimal value
ranV1 = rand(1);
ranV2 = rand(1);
ranV3 = rand(1);

% random numbers for weight
ranW1 = rand(1);
ranW2 = rand(1);
ranW3 = rand(1);

% base prey + range + value
% 1st: optimal prey size; [proportion to your own trait size]
% 2nd: index of flexibility; [times state prey size to both sides]
% 3rd: weight of size [sum of 3; needs to be a fixed sum in order to create
% a trait-off; otherwise max. all would be the solution]

% size
%---------------------------------
a(nr).TagSV = 50.^randn(1); % optimal 
a(nr).TagSF = 25.^randn(1); % flexibilty

% active
%--------------------------------
a(nr).TagASV = ranV1/(ranV1+ranV2+ranV3); % optimal 
a(nr).TagASF = rand(1)*iparam.sfle; % flexibilty
a(nr).TagASW = ranW1/(ranW1+ranW2+ranW3); % weight

% passive
%--------------------------------
a(nr).TagPSV = ranV2/(ranV1+ranV2+ranV3); % optimal 
a(nr).TagPSF = rand(1)*iparam.sfle; % flexibilty
a(nr).TagPSW = ranW2/(ranW1+ranW2+ranW3); % weight

% metabolic
%--------------------------------
a(nr).TagMSV = ranV3/(ranV1+ranV2+ranV3); % optimal 
a(nr).TagMSF = rand(1)*iparam.sfle; % flexibilty
a(nr).TagMSW = ranW3/(ranW1+ranW2+ranW3); % weight

%% ---------------------------------------------------------------
%% ------------PARAMETER------------------------------------------
%% ---------------------------------------------------------------
% combination of traits or inital parameter (iparam) / does not change over time

% assimilation efficency
%----------------------------------------
a(nr).ae = 1/(1 + a(nr).TagSF + a(nr).TagASF + a(nr).TagPSF + a(nr).TagMSF);

% base speed
%----------------------------------------
% move times your size
a(nr).sp =  a(nr).Tmo*(a(nr).TagASV/a(nr).Tsi); 

% max stomach size (prop to actual size)
%----------------------------------------
a(nr).sts = (a(nr).TstrA + a(nr).TstrP)/2;
   
%% ---------------------------------------------------------------
%% ------------STATES---------------------------------------------
%% ---------------------------------------------------------------
% compination of trait traits & condition

% size
%-----------------------------------------
% starting at param.ins size of adult
% Size - start at 0.1 0f an adult
s_si(nr) = a(nr).Tsi*iparam.ins ;  

% radius of agent (for autotrophs assuming spheric cell)
%-----------------------------------------
% g -> vol (menden-deuer & lassard 2000) / vol -> radius (spheric) / µm -> m
%s_rad(nr) = (((3*((s_si(nr)/0.216)^(1/0.939))) / (4*pi))^(1/3) ) ; %*0.000001; 
s_rad(nr) = (((3.*((s_si(nr).*10^12/0.216)^(1/0.939))) ./ (4*pi))^(1/3) )*0.000001; 

% speed  
%-----------------------------------------
s_sp(nr)  =  a(nr).sp*s_si(nr)*iparam.dt;  

% agent position
%-----------------------------------------
s_po(nr) = rand(1)*iparam.Depth;

% autotrophic rates
%-----------------------------------------

a(nr).kI=a(nr).TstrM*10^6; 

% concept by Aksnes and Cao 2011
if ( a(nr).TtrT~=2)
    
    % base (specific) maximum uptake for light
    %(scales with active structure and the metabolic structure)
    a(nr).umax = (a(nr).TstrA + a(nr).TstrM)*2;
    
    % scaling arguments are extract from Fisksen et al 2013. They are
    % assumed to be the "average" value. Weights therefore 
    
    % handling time (per radius in hours)
    s_hN(nr) = (iparam.hNi*((s_si(nr).*10^12/0.216)^(1/0.939)).^-0.33)/(60*60);
    s_hP(nr) = (iparam.hPi*((s_si(nr).*10^12/0.216)^(1/0.939)).^-0.53)/(60*60);

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

% autotrophic weights 
%-----------------------------------------
    % random numbers for weight
    ranW1 = rand(1);
    ranW2 = rand(1);
    ranW3 = rand(1);

    a(nr).IW = ranW1/(ranW1+ranW2+ranW3); 
    a(nr).NW = ranW2/(ranW1+ranW2+ranW3); 
    a(nr).PW = ranW3/(ranW1+ranW2+ranW3); 
    
else
    a(nr).IW = 0; 
    a(nr).NW = 0; 
    a(nr).PW = 0;
    a(nr).up = 0;
end

%% set for loop to stores

nAgents = iparam.nAgents;

a(nr).time(1)      = 1;  % time

a(nr).s(1)         = s_si(nr);  % size

a(nr).Sagg(1)      = s_agg(nr);  % gross growth
a(nr).Shgg(1)      = s_hgg(nr);  % netgrowth

a(nr).Sgg(1)      = s_gg(nr);  % gross growth
a(nr).Sng(1)      = s_ng(nr);  % netgrowth

a(nr).Sml(1)      = s_met(nr);   % metabolism losses
a(nr).Spl(1)      = s_pl(nr) ;  % predation losses
a(nr).Sel(1)      = s_eg(nr) ;  % egestion losses
a(nr).Sal(1)      = s_aen(nr) ;% assimilation + nut mismatch losses

a(nr).Sp(1)     = s_po(nr); % agent position
a(nr).Ssp(1)      = s_sp(nr) ;  % actual speed
a(nr).Sus(1)      = s_us(nr);   % uptake saturation (stomach)
a(nr).Sup(1)      = Aup(nr);   % uptake

a(nr).rad(1)      = s_rad(nr);  % cell radius 

a(nr).affN(1)      = s_affN(nr);   % nutrient affinity
a(nr).affP(1)      = s_affP(nr);   % nutrient affinity
a(nr).pN(1)        = s_pN(nr);     % density uptake nutrient sites
a(nr).pP(1)        = s_pP(nr);     % density uptake nutrient sites
a(nr).hN(1)        = s_hN(nr);  % handling time N
a(nr).hP(1)        = s_hP(nr);  % handling time P
a(nr).nN(1)        = s_nN(nr);  % nr. of uptake sites (porters) 
a(nr).nP(1)        = s_nP(nr);  % nr. of uptake sites (porters) 

a_dead=a(1);
a_deadnew=a(1);

end