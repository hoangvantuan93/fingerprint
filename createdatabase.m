function [] = createdatabase(check)
addpath('image');
a = dir('image');
k = size(a);
for k =3 : k
image=double(imread(fullfile('image/',a(k).name)));
image = 255 - double(image);

name = a(k).name(1:5);
name = strcat(name,'.dat');
if nargin == 1
id = a(k).name(1:3);
w=str2double(char(id));
end
[pathMap endListReal process2Image branchListReal] = allprocess(image);
if nargin == 1
 
saveFinger(pathMap,endListReal,w,name);
else
  file = strcat('match/',name);
  save(file,'endListReal','pathMap','-ASCII');
end
end
end