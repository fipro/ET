     % reduce size for 'adult'
        % up to now no cost for splitting itself
        s_si = s_si - (s_rep .* [a.Tsi].*0.5) ;
      
        [s_xx s_reppos]= find(s_rep == 1);
     
               
        % add newly seeded agents
        for count = 1:length(s_reppos)          
            a(nAgents + count)    = a(s_reppos(count));    
            a(nAgents + count).nr = nAgents + count;
            
            % add strucutres
            s_si(nAgents + count)    = s_si(s_reppos(count));  
            s_sp(nAgents + count)    = s_sp(s_reppos(count));  
            s_po(nAgents + count)  = s_po(s_reppos(count));  
            s_me(nAgents + count,:)  = s_me(s_reppos(count),:); 
            s_pl(nAgents + count)    = s_pl(s_reppos(count));
            s_met(nAgents + count)   = s_met(s_reppos(count));
            s_aen(nAgents + count)   = s_aen (s_reppos(count));
            
            s_eg(nAgents + count) = 0; 
            s_gg(nAgents + count) = 0;
            s_us(nAgents + count) = 0;  
            s_ng(nAgents + count) = 0; 
            
            s_fI(nAgents + count)  = s_fI(s_reppos(count));
            s_fN(nAgents + count)  = s_fN(s_reppos(count));
            s_fP(nAgents + count)  = s_fP(s_reppos(count));
            s_agg(nAgents + count)  = s_agg(s_reppos(count));
            s_hgg(nAgents + count)  = s_hgg(s_reppos(count));
    
            
            
            s_rad(nAgents + count)  = s_rad(s_reppos(count));
            s_us(nAgents + count)  = s_us(s_reppos(count));
            s_ng(nAgents + count)  = s_ng(s_reppos(count));
            s_aen(nAgents + count) = s_aen(s_reppos(count));

            s_affN(nAgents + count) = s_affN(s_reppos(count));   % nutrient affinity N
            s_affP(nAgents + count) = s_affP(s_reppos(count));   % nutrient affinity P 
            s_pN(nAgents + count)   = s_pN(s_reppos(count));     % density uptake nutrient sites N
            s_pP(nAgents + count)   = s_pP(s_reppos(count));     % density uptake nutrient sites P
            s_hN(nAgents + count)   = s_hN(s_reppos(count));  % handling time 
            s_hP(nAgents + count)   = s_hP(s_reppos(count));  % handling time 
            s_nN(nAgents + count)   = s_nN(s_reppos(count));  % nr. of uptake sites (porters)  N
            s_nP(nAgents + count)   = s_nP(s_reppos(count));  % nr. of uptake sites (porters)  P
            
 end
        
        % update counts
        nAgents = length(a);