clc
clear
close all


%%
fname = 'test.bdf' ;
fid = fopen(fname,'r') ;
S = textscan(fid,'%s','Delimiter','\n');
fclose(fid) ;
S = S{1} ;

% Find the begining of the nodes numeration
idx_begin = strfind(S, '$ Nodes of the Entire Model');
idx_begin = find(not(cellfun('isempty', idx_begin)));

% Extract the node number and coordenate

ack1 = 0;
ack2 = 0;
id = 0;
for i = (idx_begin + 1):lenght(S)
    
    if ack == 0
        if strcmp( S{i}(1:5), 'GRID*' )
            id = id + 1;
            node.idx(id) = 0;
            
            S{19}
            regexp(S{19},'.\d+','Match')
            S{20}
            regexp(S{20},'.\d+','Match')
            
        end 
    end
            

    
end
%%


Str = ['Test setup: MaxDistance = 60 m, Rate = 1.000, ', ...
       'Permitted Error = 50 Operator Note:  Air Temperature=20 C, ', ...
       'Wind Speed 16.375m/s, Altitude 5km (Cloudy)'];
   
Str(strfind(Str, '=')) = [];

Key   = 'MaxDistance';
Index = strfind(Str, Key);
Value = sscanf(Str(Index(1) + length(Key):end), '%g', 1);

%%

%%Get the line number of CBEAM
idxS = strfind(S, 'GRID');
idx = find(not(cellfun('isempty', idxS)));
cbeam = S(idx(2:end))
