           
            % find limiting resource
            s_fI(nr) = Iint(nr)./(p_kI(nr)+Iint(nr));       % Light-dependent phytoplankton growth
            s_fN(nr) = INint(nr)./(p_kN(nr)+INint(nr));     % Nutrient-dependenth growth
            s_fP(nr) = IPint(nr)./(p_kP(nr)+IPint(nr));     % Nutrient-dependenth growth
            
            s_fN(IN(t-1,ceil(s_po(nr)*iparam.dz))<=0) = 0; % Fix potentially negative growth rates
            s_fP(IP(t-1,ceil(s_po(nr)*iparam.dz))<=0) = 0; % Fix potentially negative growth rates

            % get uptake
            s_phy(nr) = p_umax(nr)*min([s_fI(nr),s_fN(nr),s_fP(nr)])*t_tro(nr,2)*s_si(nr); % Effective growth rate
       
            s_agg(nr) = s_phy(nr)*p_ae(nr);