%% mutation

% mutaitons a renot being tacked up to now
% this is still odd
    % there is a chance of mutation (iparam.mut) and a magnitute of change
        
    % given there are n = 18 (size,  4xTAG value, 4xTAG flex, 
    % value 3x compartment, 3xCNP of comaprtment changing in N,
    % 3xCNP of comaprtment changing in P)
    % 18 x Agents gives the total mutation space
    % this way one Agent is exposed to possibly of multiply mutation per
    % round (even tough unlikely)
    % storage doesn't change for now can be added.
    
    n = 18;
    
    % identify random position of mutation in total agent space
    rel_mut_loci=(rand(round(length(t_si)*n*iparam.mut),1));
    mut_loci= round (rel_mut_loci*length(t_si)*n);
    
    % indentify agent and position in agent that mutates
    mut_agent_loci=ceil(mut_loci/length(t_si));
    mut_agent=ceil(mut_loci/n);
    
    %% mutate randomly by 10% in value (0-10% no idea why)
    
    % 1 = size 
    % so at this positions of mut_agent the loci says 1
    t_si(mut_agent(mut_agent_loci==1)) = ...
    t_si(mut_agent(mut_agent_loci==1))*(1+(randn(1)*0.1));
    
    % 2 = t_tagS value
    t_tagS(mut_agent(mut_agent_loci==2),1) = ...
        t_tagS(mut_agent(mut_agent_loci==2),1)*(1+(randn(1)*0.1));
    
    % 3 = t_tagS flex
    t_tagS(mut_agent(mut_agent_loci==3),2) = ...
        t_tagS(mut_agent(mut_agent_loci==3),2)*(1+(randn(1)*0.1));
    
    % 4 = t_tagAS value
    t_tagAS(mut_agent(mut_agent_loci==4),1) = ...
        t_tagAS(mut_agent(mut_agent_loci==4),1)*(1+(randn(1)*0.1));
    
     % 5 = t_tagAS flex
    t_tagAS(mut_agent(mut_agent_loci==5),2) = ...
        t_tagAS(mut_agent(mut_agent_loci==5),2)*(1+(randn(1)*0.1));
    
    % 6 = t_tagPS value
    t_tagPS(mut_agent(mut_agent_loci==6),1) = ...
        t_tagPS(mut_agent(mut_agent_loci==6),1)*(1+(randn(1)*0.1));
    
       % 7 = t_tagPS flex
    t_tagPS(mut_agent(mut_agent_loci==7),2) = ...
        t_tagPS(mut_agent(mut_agent_loci==7),2)*(1+(randn(1)*0.1));
    
    % 8 = t_tagMS value
    t_tagMS(mut_agent(mut_agent_loci==8),1) = ...
        t_tagMS(mut_agent(mut_agent_loci==8),1)*(1+(randn(1)*0.1));
    
        % 9 = t_tagMS flex
    t_tagMS(mut_agent(mut_agent_loci==9),2) = ...
        t_tagMS(mut_agent(mut_agent_loci==9),2)*(1+(randn(1)*0.1));
    
    % 10 = t_CNPAS change N
    t_CNPAS(mut_agent(mut_agent_loci==10),1) = ...
        t_CNPAS(mut_agent(mut_agent_loci==10),1)*(1+(randn(1)*0.1));
    
     % 11 = t_CNPAS change P
    t_CNPAS(mut_agent(mut_agent_loci==11),2) = ...
        t_CNPAS(mut_agent(mut_agent_loci==11),2)*(1+(randn(1)*0.1));
    
        % 12 = t_CNPPS change N
    t_CNPPS(mut_agent(mut_agent_loci==12),1) = ...
        t_CNPPS(mut_agent(mut_agent_loci==12),1)*(1+(randn(1)*0.1));
    
     % 13 = t_CNPPS change P
     t_CNPPS(mut_agent(mut_agent_loci==13),2) = ...
         t_CNPPS(mut_agent(mut_agent_loci==13),2)*(1+(randn(1)*0.1));

        % 14 = t_CNPMS change N
    t_CNPMS(mut_agent(mut_agent_loci==14),1) = ...
        t_CNPMS(mut_agent(mut_agent_loci==14),1)*(1+(randn(1)*0.1));
    
      % 15 = t_CNPMS change P
    t_CNPMS(mut_agent(mut_agent_loci==15),1) = ...
        t_CNPMS(mut_agent(mut_agent_loci==15),1)*(1+(randn(1)*0.1));
    
          % 16 = t_str AS
          rate = randn(1)*0.1;
          % change AS by rate
    t_str(mut_agent(mut_agent_loci==16),1) = ...
        t_str(mut_agent(mut_agent_loci==16),1)*(1+rate);
    % change PS by half the rate to keep proportions
    t_str(mut_agent(mut_agent_loci==16),2) = ...
        t_str(mut_agent(mut_agent_loci==16),2)*(1-(rate*0.5));
    % change MS by half the rate to keep proportions
        t_str(mut_agent(mut_agent_loci==16),3) = ...
        t_str(mut_agent(mut_agent_loci==16),3)*(1-(rate*0.5));
    
              % 17 = t_str PS
          rate = randn(1)*0.1;
          % change APS by rate
    t_str(mut_agent(mut_agent_loci==17),2) = ...
        t_str(mut_agent(mut_agent_loci==17),2)*(1+rate);
    % change AS by half the rate to keep proportions
    t_str(mut_agent(mut_agent_loci==17),1) = ...
        t_str(mut_agent(mut_agent_loci==17),1)*(1-(rate*0.5));
    % change MS by half the rate to keep proportions
        t_str(mut_agent(mut_agent_loci==17),3) = ...
        t_str(mut_agent(mut_agent_loci==17),3)*(1-(rate*0.5));
    
                  % 18 = t_str MS
          rate = randn(1)*0.1;
          % change MS by rate
    t_str(mut_agent(mut_agent_loci==18),3) = ...
        t_str(mut_agent(mut_agent_loci==18),3)*(1+rate);
    % change AS by half the rate to keep proportions
    t_str(mut_agent(mut_agent_loci==18),1) = ...
        t_str(mut_agent(mut_agent_loci==18),1)*(1-(rate*0.5));
    % change PS by half the rate to keep proportions
        t_str(mut_agent(mut_agent_loci==18),2) = ...
        t_str(mut_agent(mut_agent_loci==18),2)*(1-(rate*0.5));
    
    
    
    % doesn't mutaute for mow, its not implementend anyways...
          % 19 = t_stor
  %  t_stor(mut_agent(mut_agent_loci==19),1) = ...
   %     t_stor(mut_agent(mut_agent_loci==19),1)*(1+(randn(1)*0.1));
   
