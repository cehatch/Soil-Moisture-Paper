% GOOGLE EARTH PLOTS of SOIL MOISTURE at TIDMARSH

% ---------------------------------
% TIDMARSH EAST Atlantic white cedars (AWC) 2017
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load AWC_Moisture_only.txt
load cmap_rainbow.mat

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=AWC_Moisture_only(:,1:2);
theta=AWC_Moisture_only(:,3);
cmap=cmap_rainbow;

numpoints=119;
GES=zeros(1,numpoints);
x=1;

% Soil Moisture 0 to 100%; From 0 to 6 cm depth "Theta Probe"

grav_hi_lo_theta=100-theta;

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
k = kml('SoilMoisture_AWC_2017_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run

% ---------------------------------
% TIDMARSH EAST MOISTURE 2014 PROBE (0-6cm)
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TE_GSM_Probe_2014.txt
load cmap_rainbow.mat

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TE_GSM_Probe_2014(:,1:2);
theta=TE_GSM_Probe_2014(:,3);
cmap=cmap_rainbow;

numpoints=44;
GES=zeros(1,numpoints);
x=1;

% Soil Moisture 0 to 100%; From 0 to 6 cm depth "Theta Probe"

grav_hi_lo_theta=100-theta;

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
k = kml('SoilMoisture_TE_2014_Probe_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run

% ---------------------------------
% TIDMARSH EAST MOISTURE 2014 GRAVIMETRIC (0-6cm)
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TE_GSM_Grav0_6cm_2014.txt
load cmap_rainbow.mat

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TE_GSM_Grav0_6cm_2014(:,1:2);
theta=TE_GSM_Grav0_6cm_2014(:,3);
cmap=cmap_rainbow;

numpoints=39;
GES=zeros(1,numpoints);
x=1;

% Soil Moisture 0 to 100%; From 0 to 6 cm depth "Gravimetric"

grav_hi_lo_theta=100-theta;

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
k = kml('SoilMoisture_TE_2014_GRAV0_6_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run

% ---------------------------------
% TIDMARSH EAST MOISTURE 2014 GRAVIMETRIC (6-12cm)
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TE_GSM_Grav6_12cm_2014.txt
load cmap_rainbow.mat

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TE_GSM_Grav6_12cm_2014(:,1:2);
theta=TE_GSM_Grav6_12cm_2014(:,3);
cmap=cmap_rainbow;

numpoints=39;
GES=zeros(1,numpoints);
x=1;

% Soil Moisture 0 to 100%; From 6 to 12 cm depth "Gravimetric"

grav_hi_lo_theta=100-theta;

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
k = kml('SoilMoisture_TE_2014_GRAV6_12_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run

% ---------------------------------
% TIDMARSH EAST MOISTURE 2017
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TE_GSM_Moisture_2017.txt
load cmap_rainbow.mat

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TE_GSM_Moisture_2017(:,1:2);
theta=TE_GSM_Moisture_2017(:,3);
cmap=cmap_rainbow;

numpoints=39;
GES=zeros(1,numpoints);
x=1;

% Soil Moisture 0 to 100%; From 0 to 6 cm depth "Theta Probe"

grav_hi_lo_theta=100-theta;

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
k = kml('SoilMoisture_TE_2017_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run

% ---------------------------------
% TIDMARSH EAST MOISTURE 2018
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TE_GSM_Moisture_2018.txt
load cmap_rainbow.mat

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TE_GSM_Moisture_2018(:,1:2);
theta=TE_GSM_Moisture_2018(:,3);
cmap=cmap_rainbow;

numpoints=36;
GES=zeros(1,numpoints);
x=1;

% Soil Moisture 0 to 100%; From 0 to 6 cm depth "Theta Probe"

grav_hi_lo_theta=100-theta;

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
k = kml('SoilMoisture_TE_2018_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run

% ---------------------------------
% TIDMARSH EAST Change Map from 2014 to 2017 in Probe Moisture
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TE_GSM_Moisture_2014_2017.txt
load cmap_red_white_blue

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TE_GSM_Moisture_2014_2017(:,1:2);
theta=TE_GSM_Moisture_2014_2017(:,3);
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

% ---------------------------------
% TIDMARSH EAST Change Map from 2014 to 2018 in Probe Moisture
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TE_GSM_Moisture_2014_2018.txt
load cmap_red_white_blue

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TE_GSM_Moisture_2014_2018(:,1:2);
theta=TE_GSM_Moisture_2014_2018(:,3);
cmap=cmap_red_white_blue;
numpoints=36;
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
k = kml('SoilMoisture_2018_2014_Change_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run

% ---------------------------------
% TIDMARSH EAST Change Map from 2017 to 2018 in Probe Moisture
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TE_GSM_Moisture_2017_2018.txt
load cmap_red_white_blue

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TE_GSM_Moisture_2017_2018(:,1:2);
theta=TE_GSM_Moisture_2017_2018(:,3);
cmap=cmap_red_white_blue;
numpoints=36;
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
k = kml('SoilMoisture_2018_2017_Change_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run



% -------------------------- TIDMARSH WEST -------------------------- %



% ---------------------------------
% Tidmarsh West 2017 Probe Moisture
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TW_GSM_Moisture_2017.txt
load cmap_rainbow.mat

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TW_GSM_Moisture_2017(:,1:2);
theta=TW_GSM_Moisture_2017(:,3);

numpoints=77;
GES=zeros(1,numpoints);
x=1;

% Soil Moisture 0 to 100%; From 0 to 6 cm depth "Theta Probe"

grav_hi_lo_theta=100-theta;

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
k = kml('SoilMoisture_TW_2017_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run

% ---------------------------------
% Tidmarsh West 2018 Probe Moisture
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TW_GSM_Moisture_2018.txt
load cmap_rainbow.mat

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TW_GSM_Moisture_2018(:,1:2);
theta=TW_GSM_Moisture_2018(:,3);

numpoints=72;
GES=zeros(1,numpoints);
x=1;

% Soil Moisture 0 to 100%; From 0 to 6 cm depth "Theta Probe"

grav_hi_lo_theta=100-theta;

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
k = kml('SoilMoisture_TW_2018_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run

% ---------------------------------
% Tidmarsh West 2018-2017 CHANGE in Probe Moisture
% ---------------------------------

cd /Users/chatch/Documents/Christine/DTS_Data/processed/Tidmarsh_Soil/
load TW_GSM_Moisture_2017_2018.txt
load cmap_red_white_blue.mat

%   ***NOTE: This file contains six points at the end of the data that 
%   are specifically located to serve as a legend.
  
LatLong=TW_GSM_Moisture_2017_2018(:,1:2);
theta=TW_GSM_Moisture_2017_2018(:,3);
cmap=cmap_red_white_blue;

numpoints=73;
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
k = kml('SoilMoisture_TW_2017_2018_GE_Map');
for x=1:numpoints;
    k.point(LatLong(x,2),LatLong(x,1),0,'name', ' ', 'iconColor',GE_DTScolour{x,1},'iconScale', 0.5);%IRGPS(x,9),IRGPS(x,10));
    hold on
   
end
k.run