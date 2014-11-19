%% initalize
    
%-------------------------------------------------------
% disretisaiton for all units still need to be done!!!!
%--------------------------------------------------------

global iparam a 

nTime = floor(iparam.tEnd/iparam.dt)+1;    % nr of iteration

% disretisation
diff = iparam.dt/(iparam.dz^2)*iparam.d;  
diff = iparam.d;

%% eulerian fields

z = 0.5*iparam.dz:iparam.dz:iparam.Depth+0.5*iparam.dz;
nGrid = length(z); % number of cells

IP = zeros(nTime,nGrid); % arrray inorganic phosphate        
IN = zeros(nTime,nGrid); % arrray inorganic nitrogen   
%DOMC = zeros(nTime,nGrid); % arrray organic C   
D = zeros(nTime,nGrid); % arrray organic C   
P = zeros(nTime,nGrid); % arrray organic C   

% matrix
A = zeros(nGrid); 

% change matrices - set to zero
dP  = zeros(1,nGrid);
dIN = zeros(1,nGrid);
dP  = zeros(1,nGrid);
dDN = zeros(1,nGrid);
dDP = zeros(1,nGrid);


% intial concentrations
IN(1,:) = iparam.iniIN + 0*z; 
IP(1,:) = iparam.iniIP + 0*z; 
D(1,:) = iparam.iniD + 0*z;
P(1,:) = iparam.iniP + 0*z;
 
% artifical AS,PS,MS structure of DOM
% here it only serves a 'recognizer' for the TAG of remineralizer
% t_str_DOM = [0.0 1 0.0]; 


%% Agents

for nr = 1:iparam.nAgents

%convention

% tt : true trait, equal to a trait ( trait size, mobitity, composition)
%      does not change over time, stored in the beginning

% a. xy is only used to store & for later
% in the loop axy is used / traits are marked aTxy 
    
% COUNT    
% identity nr for each agent ( unique)
a(nr).nr = nr ;  % create struc. for agents

% nr for each type of agents (offsprings have the same nr)
% in the beginning equals to nr. 
a(nr).typenr = nr;

%% ---------------------------------------------------------------
%% ------------TRAITS---------------------------------------------
%% ---------------------------------------------------------------

% auto- hetero- or mixoTroph
% 1st value - prefered source (0 = auto ;  1 = hetero) binary
% 2nd value - degree of mixotrophy (0 = only your prefered; 1 = auto&hetero are always equally important)

% 1st value - torphic type (1 = auto ; 2 = hetero; 3 = mixotroph) 
troph(nr) = ceil(rand(1)*3);

% 2nd value - degree of mixotrophy (1 = only autotroph; 0 = only heterotroph)
if (troph(nr) == 3)
    t_pref(nr) = rand(1);
elseif (troph(nr) == 1)
    t_pref(nr) = 1;
else
    t_pref(nr) = 0;
end

a(nr).Ttr = [troph(nr), t_pref(nr)];

% left it in because we might want ot return to his later, but for now:
%a(nr).Ttr = [1 0];

t_tro(nr,:) = a(nr).Ttr;

% Mobitity (random around base value)
a(nr).Tmo    = rand(1);   %(*(1-range) + (rand(1) * Tm*(2*range)));  % base mobility

%% Size
% represents the 'adult' size, threshold for reproduction
a(nr).Tsi = 10.^(rand(1) * iparam.svar)/10^12;
t_si(nr) = a(nr).Tsi ;  % for use in loop

%% Relative Composition (sum of 1)  [AS, PS, HS]
% ideal composition 
a(nr).Tstr(1,1) = (rand(1) * (a(nr).Tsi*0.5)) / a(nr).Tsi;   % contribution active structure  
a(nr).Tstr(2,1) = (rand(1) * (a(nr).Tsi*0.5)) / a(nr).Tsi;   % contribution passive structure  
a(nr).Tstr(3,1) = (1 - (a(nr).Tstr(2) + a(nr).Tstr(1)))  ;   % contribution metabolic strcture
% for use in loop
t_str(nr,1)  = a(nr).Tstr(1) ;   % active structure  
t_str(nr,2)  = a(nr).Tstr(2) ;   %  passive structure  
t_str(nr,3)  = a(nr).Tstr(3) ;   % metabolic strcture

%% relative N:P (in %)  [AS, PS, HS]
% phosphate 1-3 % of total
% nitrate 10-30 % of total
% C is the base unit, hence 1 in all cases
a(nr).CNP(1,1:2) = [rand(1)*0.3, rand(1)*0.001] ;  % So: N2C & P2C in active in row 1, in passive in row 2, in storage in row 3
a(nr).CNP(2,1:2) = [rand(1)*0.3, rand(1)*0.001] ;   
a(nr).CNP(3,1:2) = [rand(1)*0.3, rand(1)*0.1] ;

% total proprotion of N, P
a(nr).Ptot = a(nr).CNP(1,2) + a(nr).CNP(2,2) + a(nr).CNP(3,2);
a(nr).Ntot = a(nr).CNP(1,1) + a(nr).CNP(2,1) + a(nr).CNP(3,1);

% for use in loop
t_CNPAS(nr,1:2)  = a(nr).CNP(1,:) ;   % active structure  
t_CNPPS(nr,1:2)  = a(nr).CNP(2,:) ;   % passive structure  
t_CNPMS(nr,1:2)  = a(nr).CNP(3,:) ;   % metabolic strcture

t_Ptot(nr) = a(nr).Ptot;  % total proportion of P
t_Ntot(nr) = a(nr).Ntot;  % total proportion of N

% storage (max values for C:N:P)
% allowing up to 100% of total element to be stored
a(nr).stor(1,1)  = (rand(1) * (a(nr).Tsi)) / a(nr).Tsi; % max storage of C
a(nr).stor(1,2) = (rand(1) * (  (a(nr).CNP(1,1)+a(nr).CNP(2,1)...
                     +a(nr).CNP(3,1)) *0.5) ) / (a(nr).CNP(1,1)...
                     +a(nr).CNP(2,1)+a(nr).CNP(3,1));  % max storage of N  
a(nr).stor(1,3) = (rand(1) * (  (a(nr).CNP(1,2)+a(nr).CNP(2,2)...
                     +a(nr).CNP(3,2))  *0.5)) / (a(nr).CNP(1,2)...
                     +a(nr).CNP(2,2)+a(nr).CNP(3,2));  % max storage of P  

t_stor(nr,1)  = a(nr).stor(1,1) ;   % active structure  
t_stor(nr,2)  = a(nr).stor(1,2) ;   %  passive structure  
t_stor(nr,3)  = a(nr).stor(1,3) ;   % metabolic strcture

                 
%% --------------------------------------------------------------               
%% TAGS ---------------------------------------------------------
%% --------------------------------------------------------------

% base prey + range + value
% 1st: optimal prey size; [proportion to your own trait size]
% 2nd: index of flexibility; [times state prey size to both sides]
% 3rd: weight of size 

% size
%a(nr).TagS = [10.^real((log(randn(1)))), 10.^(rand(1)*iparam.sfle), rand(1)];
%a(nr).TagS = [     iparam.svar^(log(rand(1)*2)), rand(1)*iparam.sfle, rand(1)];
%a(nr).TagS = [   10^(log(rand(1)))*2, rand(1)*iparam.sfle, rand(1)];
a(nr).TagS = [   (50.^randn(1)), 25.^randn(1), rand(1)];
% for use in loop
t_tagS(nr,1)  = a(nr).TagS(1) ;   % optimal size  
t_tagS(nr,2)  = a(nr).TagS(2) ;   % flexibilty  
t_tagS(nr,3)  = a(nr).TagS(3) ;   % weight

% active
%a(nr).TagAS = [iparam.svar^(log(rand(1)*2)), rand(1)*iparam.sfle, rand(1)];
%a(nr).TagAS = [real(iparam.svar^(log(randn(1)*2))), 10.^(rand(1)*iparam.sfle), rand(1)];

a(nr).TagAS = [rand(1)*0.5, rand(1), rand(1)];
% for use in loop
t_tagAS(nr,1)  = a(nr).TagAS(1) ;   % optimal proportion of active structure
t_tagAS(nr,2)  = a(nr).TagAS(2) ;   % flexibilty  
t_tagAS(nr,3)  = a(nr).TagAS(3) ;   % weight

% passive
a(nr).TagPS = [rand(1)*0.5, rand(1), rand(1)];
% for use in loop
t_tagPS(nr,1)  = a(nr).TagPS(1) ;   % optimal proportion of active structure
t_tagPS(nr,2)  = a(nr).TagPS(2) ;   % flexibilty  
t_tagPS(nr,3)  = a(nr).TagPS(3) ;   % weight

% metabolic
a(nr).TagMS = [(1-t_tagPS(nr,1)-t_tagAS(nr,1)), rand(1), rand(1)];
% for use in loop
t_tagMS(nr,1)  = a(nr).TagMS(1) ;   % optimal proportion of active structure
t_tagMS(nr,2)  = a(nr).TagMS(2) ;   % flexibilty  
t_tagMS(nr,3)  = a(nr).TagMS(3) ;   % weight

%% ---------------------------------------------------------------
%% ------------PARAMETER------------------------------------------
%% ---------------------------------------------------------------
% p : comination of traits or inital parameter (iparam)
%      does not change over time

% base maximum uptake (scales with active structure and the metabolic structure)
p_up(nr) = (t_str(nr,1)+t_str(nr,3))/2;

% maximum uptake (scales with active structure and 66% of metabolism)
% 66% still need an explanation or mentioend as a scaling parameter
%p_up(nr) = t_str(nr,1)+t_str(nr,3)*0.66;
% defense 
%p_def(nr) = t_str(nr,2)+t_str(nr,3)*0.33;

% assimilation efficency
% use overall flexibilty
% invert of flex, trait-off for greater variability
% needs to be tunes much better

% p_ae(nr) = (exp(1/  ...
%     (a(nr).TagS(2)+a(nr).TagAS(2)+a(nr).TagPS(2)+a(nr).TagMS(2))/4 ...
%     ))  /  (exp(1/  ...
%     (a(nr).TagS(2)+a(nr).TagAS(2)+a(nr).TagPS(2)+a(nr).TagMS(2))/4 ...
%     )+1);
p_ae(nr) = 1/(1+a(nr).TagS(2)+a(nr).TagAS(2)+a(nr).TagPS(2)+a(nr).TagMS(2));

% base speed
p_sp(nr)  =  a(nr).Tmo*(t_str(nr,1)/t_si(nr)); 

% autotrophic rates
if (t_tro(nr,1)~=2)
    p_kI(nr) =  t_str(nr,3)*10^5; % light half saturation 
    p_kN(nr) =  t_str(nr,3);      % nitrogen half saturation 
    p_kP(nr) =  t_str(nr,3)*(1/16);      % phosphate half saturation 
    
    p_umax(nr) = 10*t_str(nr,1);  % max growth rate
else
    p_kI(nr)   = 0;
    p_kN(nr)   = 0;
    p_kP(nr)   = 0;
    p_umax(nr) = 0;
end
    
%% ---------------------------------------------------------------
%% ------------STATES---------------------------------------------
%% ---------------------------------------------------------------
% st : compination of trait traits & condition
% starting at param.ins size of adult
% Size - start at 0.1 0f an adult
s_si(nr) = a(nr).Tsi*iparam.ins ;  

% inital composition (optimal)
%s_str(nr,1)  = s_si(nr)*a(nr).Tstr(1) ;    % active structure  
%s_str(nr,2)  = s_si(nr)*a(nr).Tstr(2) ;    %  passive structure  
%s_str(nr,3)  = s_si(nr)*a(nr).Tstr(3) ;    % resource strcture

% speed   
s_sp(nr)  =  p_sp(nr)*s_si(nr);  

% agent position
s_po(nr,:)=[rand(1)*iparam.Depth];

s_us(nr)     = 0;  % uptake saturation
s_nl(nr)     = 0;  
s_ng(nr)     = 0;  
s_met(nr)    = 0;  
s_pl(nr)     = 0;  
s_eg(nr)     = 0;  
s_gg(nr)     = 0;
s_me(nr,3)   = 0;  
Agetm(nr,nr) = 0;
s_aen(nr)    = 0;
s_fI(nr)     = 0;
s_fN(nr)     = 0;
s_fP(nr)     = 0;
s_agg(nr)    = 0;
s_hgg(nr)    = 0;
     
      
%% set for loop to stores

nAgents = iparam.nAgents;

%s_sgg=zeros(nAgents,3);
%s_sng=zeros(nAgents,3);

s_gg=zeros(1,nAgents);
s_ng=zeros(1,nAgents);

%Agetmm=zeros(1,nAgents);

Aus=zeros(nAgents);

a(nr).time(1)      = s_gg(nr);  % gross growth

a(nr).s(1)       = s_si(nr);  % size
%a(nr).Str(1,1)   = s_str(nr,1);    
%a(nr).Str(1,2)   = s_str(nr,2);     
%a(nr).Str(1,3)   = s_str(nr,3);    

a(nr).Sgg(1)      = s_gg(nr);  % gross growth
a(nr).Sng(1)      = s_ng(nr);  % netgrowth

a(nr).Snl(1)      = s_nl(nr);  % net loss
a(nr).Sml(1)      = s_met(nr);   % metabolism losses
a(nr).Spl(1)      = s_pl(nr) ;  % predation losses
a(nr).Sel(1)      = s_eg(nr) ;  % egestion losses
a(nr).Sal(1)      = s_aen(nr) ;% assimilation + nut mismatch losses

a(nr).Sp(1,:)     = s_po(nr,:); % agent position
a(nr).Ssp(1)      = s_sp(nr) ;  % actual speed
a(nr).Sus(1)      = s_us(nr);   % uptake saturation (stomach)

a_dead=a(1);
a_deadnew=a(1);

end