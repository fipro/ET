     % reduce size for 'adult'
        % up to now no cost for splitting itself
        s_si = s_si - (s_rep .* t_si.*0.5) ;
        %nroffsp = sum(s_rep);
        [s_xx s_reppos]= find(s_rep == 1);
        %      REle= length(REVPOS);
               
        % add newly seeded agents
        for count = 1:length(s_reppos)          
            a(nAgents + count)    = a(s_reppos(count));    
            a(nAgents + count).nr = nAgents + count;
            
            % add strucutres
            s_si(nAgents + count)    = s_si(s_reppos(count));  
            s_str(nAgents + count,:) = s_str(s_reppos(count));  
            s_sp(nAgents + count)    = s_sp(s_reppos(count));  
            s_po(nAgents + count,:)  = s_po(s_reppos(count));  
            s_me(nAgents + count,:)  = s_me(s_reppos(count)); 
            s_pl(nAgents + count)    = s_pl(s_reppos(count));
            s_nl(nAgents + count)    = s_nl(s_reppos(count)); 
            s_met(nAgents + count)  = s_met(s_reppos(count));
            s_aen(nAgents + count) =s_aen (s_reppos(count));
            
            s_eg(nAgents + count) = 0; 
            s_gg(nAgents + count) = 0;
            s_us(nAgents + count) = 0;  
            s_ng(nAgents + count) = 0; 
    
            
            p_ae(nAgents + count)   = p_ae(s_reppos(count));  
            p_sp(nAgents + count)   = p_sp(s_reppos(count));  
            p_up(nAgents + count)   = p_up(s_reppos(count));
            
            t_tagS(nAgents + count,:)  = t_tagS(s_reppos(count));  
            t_tagAS(nAgents + count,:) = t_tagAS(s_reppos(count));
            t_tagPS(nAgents + count,:) = t_tagPS(s_reppos(count));
            t_tagMS(nAgents + count,:) = t_tagMS(s_reppos(count));
            t_CNPAS(nAgents + count,:) = t_CNPAS(s_reppos(count)) ;
            t_CNPPS(nAgents + count,:) = t_CNPPS(s_reppos(count)) ;
            t_CNPMS(nAgents + count,:) = t_CNPMS(s_reppos(count)) ;
            t_stor(nAgents + count,:)  = t_stor(s_reppos(count)); 
            t_si(nAgents + count)      = t_si(s_reppos(count));  
            t_str(nAgents + count,:)   = t_str(s_reppos(count));  
        end
        
        % update counts
        nAgents = length(a);