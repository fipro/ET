        
        %% heterotrophic

        BB1=(s_up(:,1)./Aup);
        BB2=(s_up(:,2)./Aup);
        BB3=(s_up(:,3)./Aup);
        
        BB1(isnan(BB1))=0;
        BB2(isnan(BB2))=0;
        BB3(isnan(BB3))=0;
        
% new value ; not scaled
dAS = [a.TagASW]' + (BB1 - [a.TagASW]')/iparam.lscale;
dPS = [a.TagPSW]' + (BB2 - [a.TagPSW]')/iparam.lscale;
dMS = [a.TagMSW]' + (BB3 - [a.TagMSW]')/iparam.lscale;

AS=(dAS./(dAS + dPS + dMS))';
PS=(dPS./(dAS + dPS + dMS))';
MS=(dMS./(dAS + dPS + dMS))';

for x=1:nAgents
[a(x).TagASW] = AS(x);
[a(x).TagPSW] = PS(x);
[a(x).TagMSW] = MS(x);
end

%% autotrophic

CC1 = (s_fN./(s_fI+s_fN+s_fP));
CC2 = (s_fP./(s_fI+s_fN+s_fP));
CC3 = (s_fI./(s_fI+s_fN+s_fP));

CC1(isnan(CC1))=0;
CC2(isnan(CC2))=0;
CC3(isnan(CC3))=0;

dNW = [a.NW] + ( CC1 - [a.NW])/iparam.lscale;
dPW = [a.PW] + ( CC2 - [a.PW])/iparam.lscale;
dIW = [a.IW] + ( CC3 - [a.IW])/iparam.lscale;

% new value sum of one
NW = (dNW./(dNW + dPW + dIW))';
PW = (dPW./(dNW + dPW + dIW))';
IW = (dIW./(dNW + dPW + dIW))';
        
for x=1:nAgents
[a(x).NW] = NW(x);
[a(x).PW] = PW(x);
[a(x).IW] = IW(x);
end
  
