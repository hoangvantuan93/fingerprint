function [] = saveFinger(pathMap, endListReal,id,filename)
if nargin == 2
[filename,pathname] = uiputfile( ...
 {'*.dat';'*.*'}, ...
 'Luu du lieu van tay','match'); 
if isequal([filename,pathname],[0,0])
 return
 else
% Construct the full path and save
file = fullfile(pathname,filename);
save(file,'endListReal','pathMap','-ASCII');
end
else
    pathMap(:,4) = id
    endListReal(:,4) = id;

    if nargin ==3
[filename,pathname] = uiputfile( ...
 {'*.dat';'*.*'}, ...
 'Luu du lieu van tay','db');
    check = 0;
    else
        file = strcat('db/',filename);
        check = 1;
    end
if check==0 & isequal([filename,pathname],[0,0])
 return
 else
% Construct the full path and save
if check ==0
file = fullfile(pathname,filename);
end
save(file,'endListReal','pathMap','-ASCII');
end
end

end
