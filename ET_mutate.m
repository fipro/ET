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
rel_mut_loci=(rand(round(length([a.Tsi])*n*iparam.mut),1));
mut_loci= round (rel_mut_loci*length([a.Tsi])*n);

% indentify agent and position in agent that mutates
mut_agent_loci=ceil(mut_loci/length([a.Tsi]));
mut_agent=ceil(mut_loci/n);

%% mutate randomly by 10% in value (0-10% no idea why)

% 1 = size 
% so at this positions of mut_agent the loci says 1
for x1=find(mut_agent_loci==1)'
    [a(x1).Tsi] = [a(x1).Tsi]*(1+(randn(1)*0.1));
end

% 2 = t_tagS value
for x2=find(mut_agent_loci==2)'
    [a(x2).TagSV] = [a(x2).TagSV]*(1+(randn(1)*0.1));
end

% 3 = t_tagS flex
for x3=find(mut_agent_loci==3)'
    [a(x3).TagSF] = [a(x3).TagSF]*(1+(randn(1)*0.1));
end

% 4 = t_tagAS value
for x4=find(mut_agent_loci==4)'
    [a(x4).TagASV] = [a(x4).TagASV]*(1+(randn(1)*0.1));
end

% 5 = t_tagAS flex
for x5=find(mut_agent_loci==5)'
    [a(x5).TagASF] = [a(x5).TagASF]*(1+(randn(1)*0.1));
end  

% 6 = t_tagPS value
for x6=find(mut_agent_loci==6)'
    [a(x6).TagPSV] = [a(x6).TagPSV]*(1+(randn(1)*0.1));
end 

% 7 = t_tagPS flex
for x7=find(mut_agent_loci==7)'
    [a(x7).TagPSF] = [a(x7).TagPSF]*(1+(randn(1)*0.1));
end 

% 8 = t_tagMS value
for x8=find(mut_agent_loci==8)'
    [a(x8).TagMSV] = [a(x8).TagMSV]*(1+(randn(1)*0.1));
end

% 9 = t_tagMS flex
for x9=find(mut_agent_loci==9)'
    [a(x9).TagMSF] = [a(x9).TagMSF]*(1+(randn(1)*0.1));
end

% 10 = t_CNPAS change N
for x10=find(mut_agent_loci==10)'
    [a(x10).CNA]= [a(x10).CNA]*(1+(randn(1)*0.1));
end

% 11 = t_CNPAS change P
for x11=find(mut_agent_loci==11)'
    [a(x11).CPA] = [a(x11).CPA]*(1+(randn(1)*0.1));
end

% 12 = t_CNPPS change N
for x12=find(mut_agent_loci==12)'
    [a(x12).CNP] = [a(x12).CNP]*(1+(randn(1)*0.1));
end 

% 13 = t_CNPPS change P
for x13=find(mut_agent_loci==13)'
    [a(x13).CPP] = [a(x13).CPP]*(1+(randn(1)*0.1));
end

% 14 = t_CNPMS change N
for x14=find(mut_agent_loci==14)'
    [a(x14).CNM] = [a(x14).CNM]*(1+(randn(1)*0.1));
end

% 15 = t_CNPMS change P
for x15=find(mut_agent_loci==15)'
    [a(x15).CPM] = [a(x15).CPM]*(1+(randn(1)*0.1));
end

% 16 = t_str AS
rate = randn(1)*0.1;
% change AS by rate
for x16=find(mut_agent_loci==16)'
    [a(x16).TstrA] = [a(x16).TstrA]*(1+rate);
    % change PS by half the rate to keep proportions
    [a(x16).TstrP] = [a(x16).TstrP]*(1-(rate*0.5));
    % change MS by half the rate to keep proportions
    [a(x16).TstrM] = [a(x16).TstrM]*(1-(rate*0.5));
end

% 17 = t_str PS
rate = randn(1)*0.1;
% change APS by rate
for x17=find(mut_agent_loci==17)'
    [a(x17).TstrP] = [a(x17).TstrP]*(1+rate);
    % change AS by half the rate to keep proportions
    [a(x17).TstrA] = [a(x17).TstrA]*(1-(rate*0.5));
    % change MS by half the rate to keep proportions
    [a(x17).TstrM] = [a(x17).TstrM]*(1-(rate*0.5));
end

% 18 = t_str MS
rate = randn(1)*0.1;
% change MS by rate
for x18=find(mut_agent_loci==18)'
    [a(x18).TstrM] = [a(x18).TstrM]*(1+rate);
    % change AS by half the rate to keep proportions
    [a(x18).TstrA] = [a(x18).TstrA]*(1-(rate*0.5));
    % change PS by half the rate to keep proportions
    [a(x18).TstrP] = [a(x18).TstrP]*(1-(rate*0.5));
end
