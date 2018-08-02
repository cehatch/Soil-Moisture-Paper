% ---------------------------------
% Change Map from 2014 to 2017 in Probe Moisture
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TE_GSM_Moisture_Change.txt
load cmap_red_white_blue

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TE_GSM_Moisture_Change(:,1:2);
theta=TE_GSM_Moisture_Change(:,3);
cmap=cmap_red_white_blue;

numpoints=39;
GES=zeros(1,numpoints);
x=1;

% Soil Moisture 0 to 100%; From 0 to 6 cm depth "Theta Probe"

grav_hi_lo_theta=(100+theta)/2;

crange=0:(100/63):100;
for x=1:numpoints
[d p] = min(abs(crange - grav_hi_lo_theta(x,1)));
colval(x,:)=floor(((cmap(p,:))*255));     
end


x=1;
for x=1:numpoints
RGB=dec2hex(colval(x,:));
RR=RGB(1,:);
GG=RGB(2,:);
BB=RGB(3,:);
GE_DTScolour{x,1}=['ff',BB,GG,RR];
end

x=1;
k = kml('SoilMoisture_2017_2014_Change_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run
