    
function [ h ] = RealTimePlots ( a, param, selectedAgents, t )

if t == 2 ;
    
    figure ( 'color' , 'w'  , ...
    'Visible' , 'on' ,...
    'Units', 'centimeters',...
    'Position', [ 1 1 20 16 ] ,... % these are the dims to fit on an A4 page (11 x 8.5 in)
    'renderer', 'painters' ) ;

end;

for n = 1 : length (selectedAgents) ;
    
    if a(selectedAgents(n)).nr == a(selectedAgents(n)).typenr ;
        
    y = a(selectedAgents(n)).(param)(1:t) ;
   
    else 
        
        y = [] ;
        
    end;
    
    subplot (2,2,n)
    h = plot ( y, 'YDataSource','y' ) ;
    
    title(['Agent#',selectedAgents(n)])
    
    refreshdata(h,'caller')
    drawnow
   
end;

end
