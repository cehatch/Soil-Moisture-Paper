######################################################## LOAD LIBRARIES ##################################################################
###########################################################################################################################################

###########################################################################################################################################
########################################################### LOAD DATA ####################################################################
###########################################################################################################################################

# Load Tidmarsh West data
Raw<-read.csv("file:///C:/Users/erikai94/Documents/UMass/Tidmarsh/McInnis_SM_TW_Raw.csv")    
# Load Tidmarsh East data
TE_Moisture<-read.csv("file:///C:/Users/erikai94/Documents/UMass/Tidmarsh/Tidmarsh_East_Transects_GSM.csv")    
# Assign column names
colnames(Raw)<-c("Meas_No", "Distance_(cm)", "Permittivity_(mV)", "Probe_Soil_Moisture_(%)", "Comments")      
colnames(TE_Moisture)<-c("DateTime_A" ,"Distance_A", "Probe_A", "AWC", "DateTime_H", "Distance_H", "Probe_H","Hummock", "DateTime_U" , "Distance_U", "Probe_U", "Undisturbed")

###########################################################################################################################################
########################################################### UPDATE MATRIX ####################################################################
###########################################################################################################################################

# Convert from percentage to a numerical data in the TE data
TE_Moisture[,"AWC"]<-as.numeric(sub("%", "", TE_Moisture[,"AWC"]))
TE_Moisture[,"Hummock"]<-as.numeric(sub("%", "", TE_Moisture[,"Hummock"]))
TE_Moisture[,"Undisturbed"]<-as.numeric(sub("%", "", TE_Moisture[,"Undisturbed"]))

# Update the data frame so here are rows for every distance of 10 cm              
# First, make a sequence from 0 to the maximum distance in raw data, by increments of 10
 Distances<-seq(0, Raw[nrow(Raw),"Distance_(cm)"], 10)

# Next, make new data frame with a row for every distance
MoistureData<-as.data.frame(matrix(nrow=length(Distances),ncol=ncol(Raw)))
colnames(MoistureData)<-colnames(Raw)  
MoistureData[which(Distances%in%Raw[,"Distance_(cm)"]),"Permittivity_(mV)"]<-Raw[,"Permittivity_(mV)"]
MoistureData[which(Distances%in%Raw[,"Distance_(cm)"]),"Probe_Soil_Moisture_(%)"]<-Raw[,"Probe_Soil_Moisture_(%)"] 
MoistureData[which(Distances%in%Raw[,"Distance_(cm)"]),"Comments"]<-as.character(Raw[,"Comments"])
# Only create Meas_No counts for the raw data points from the moisture probe          
MoistureData[which(!(is.na(MoistureData[,"Permittivity_(mV)"]))),"Meas_No"]<-1:length(which(!(is.na(MoistureData[,"Permittivity_(mV)"]))))
MoistureData[,"Distance_(cm)"]<-Distances
 
# Clean up data frame
# Change NA to blanks in comment column
MoistureData[which(is.na(MoistureData[,"Comments"])),"Comments"]<-""
# Change the 70200, 70300, 70400, and 70500 distances to have NA (instead of 0 mV as shown in LM's original raw data)
BadData<-which(MoistureData[,"Distance_(cm)"]==70200|MoistureData[,"Distance_(cm)"]==70300|MoistureData[,"Distance_(cm)"]==70400|MoistureData[,"Distance_(cm)"]==70500)
MoistureData[BadData,"Permittivity_(mV)"]<-NA
# Change the 64900 distance to have 100% soil moisture (1127.3  mV)
MoistureData[which(MoistureData[,"Distance_(cm)"]==5800),"Permittivity_(mV)"]<-1127.3
MoistureData[which(MoistureData[,"Distance_(cm)"]==64900),"Permittivity_(mV)"]<-1127.3

# Add benchmarking notes to comments column
MoistureData[which(MoistureData[,"Distance_(cm)"]==0*100),"Enter"]<-"Dry W"
MoistureData[which(MoistureData[,"Distance_(cm)"]==29*100),"Exit"]<-"Dry W"
MoistureData[which(MoistureData[,"Distance_(cm)"]==650*100),"Enter"]<-"Dry M"
MoistureData[which(MoistureData[,"Distance_(cm)"]==701*100),"Exit"]<-"Dry M"
MoistureData[which(MoistureData[,"Distance_(cm)"]==46.4*100),"Enter"]<-"Bog W"
MoistureData[which(MoistureData[,"Distance_(cm)"]==58*100),"Comments"]<-"Ditch"
MoistureData[which(MoistureData[,"Distance_(cm)"]==143*100),"Exit"]<-"Bog W"
MoistureData[which(MoistureData[,"Distance_(cm)"]==145*100),"Enter"]<-"Bog E"
MoistureData[which(MoistureData[,"Distance_(cm)"]==647*100),"Exit"]<-"Bog E"
MoistureData[which(MoistureData[,"Distance_(cm)"]==709*100),"Enter"]<-"Woods"
MoistureData[which(MoistureData[,"Distance_(cm)"]==777*100),"Exit"]<-"Woods"

# Add a column of Permittivity in (V)
MoistureData[,"Permittivity_(V)"]<-MoistureData[,"Permittivity_(mV)"]/1000

# Add a column for soil moisture calculated for the raw permittivity data            
a0<-1.600
a1<-8.400
MoistureData[,"All_Soil_Moisture_Calculated_(%)"]<-sapply(MoistureData[,"Permittivity_(V)"], function(x, y, z) ((1+6.175*x+6.303*x^2-73.578*x^3+183.44*x^4-184.78*x^5+68.017*x^6)-y)/z, a0, a1)

# Add linearly interpolated values between probe measurement data for distance up to 8100 cm:
# Identify which rows have data
Measured<-which(!(is.na((MoistureData[1:which(MoistureData[,"Distance_(cm)"]==8100),"Permittivity_(V)"]))))
# Identify clusters of blanks
# Take difference of each measured element and element ahead
# Can identify the start of data gaps as places where the next measured point is more than one element away
# LastMeasured represent the last element before a patch of missing data
LastMeasured<-Measured[which(diff(Measured)>1)]
# FirstMeasured represent the first element after patch of missing data
# This is the element in Measured AFTER the elements where the next data point are more than one element away
FirstMeasured<-Measured[which(diff(Measured)>1)+1]
                
# Write a for loop that linearly interpolates values in these blank clusters 
# Note that there are 36 clusters of blanks (length(FirstMeasured) = length(LastMeasured) = 36)
# Create a column in MoistureData for interpolated values
MoistureData[1:which(MoistureData[,"Distance_(cm)"]==8100),"Permittivitiy_interp_cm_(V)"]<-MoistureData[1:which(MoistureData[,"Distance_(cm)"]==8100), "Permittivity_(V)"]       
for (i in 1:36){
    MoistureData[LastMeasured[i]:FirstMeasured[i],"Permittivitiy_interp_cm_(V)"]<-seq(MoistureData[LastMeasured[i],"Permittivitiy_interp_cm_(V)"], MoistureData[FirstMeasured[i],"Permittivitiy_interp_cm_(V)"],length=length(LastMeasured[i]:FirstMeasured[i]))
    }
    
# Add a column for soil moisture calculated for the non- interpolated and the linearly interpolated permittivity columns              
a0<-1.600
a1<-8.400
MoistureData[1:which(MoistureData[,"Distance_(cm)"]==8100),"cm_Soil_Moisture_Calculated_(%)"]<-sapply(MoistureData[1:which(MoistureData[,"Distance_(cm)"]==8100),"Permittivity_(V)"], function(x, y, z) ((1+6.175*x+6.303*x^2-73.578*x^3+183.44*x^4-184.78*x^5+68.017*x^6)-y)/z, a0, a1)
MoistureData[1:which(MoistureData[,"Distance_(cm)"]==8100),"cm_Soil_Moisture_Calculated_interp_(%)"]<-sapply(MoistureData[1:which(MoistureData[,"Distance_(cm)"]==8100),"Permittivitiy_interp_cm_(V)"], function(x, y, z) ((1+6.175*x+6.303*x^2-73.578*x^3+183.44*x^4-184.78*x^5+68.017*x^6)-y)/z, a0, a1)

# Get moisture data for every meter
# Create a vector for every meter (every 100 cm)
m_Distances<-seq(0, max(MoistureData[,"Distance_(cm)"]), 100) 
# Create a vector for the rows for every meter of data
m_Rows<-sapply(m_Distances, function(x) which(MoistureData[,"Distance_(cm)"]==x))
               
# Run the soil moisture calculation at the meter scale
# Get moisture data for every meter
# Create a vector for every meter (every 100 cm)
m_Distances<-seq(0, max(MoistureData[,"Distance_(cm)"]), 100) 
# Create a vector for the rows for every meter of data
m_Rows<-sapply(m_Distances, function(x) which(MoistureData[,"Distance_(cm)"]==x))
# Creat a vector of Permittivity values at the meter scale 
m_Permittivity<-MoistureData[m_Rows,"Permittivity_(V)"]    

# Add the soil moisture column to the data frame at the meter scale
a0<-1.600
a1<-8.400
MoistureData[m_Rows,"m_Soil_Moisture_Calculated_(%)"]<-sapply(m_Permittivity, function(x, y, z) ((1+6.175*x+6.303*x^2-73.578*x^3+183.44*x^4-184.78*x^5+68.017*x^6)-y)/z, a0, a1)

###########################################################################################################################################
########################################################### MAKE PLOTS ####################################################################
###########################################################################################################################################
# Set working directory to save plots to 
setwd('C:/Users/erikai94/Documents/UMass/Tidmarsh/R_Plots')

                                                              
########################################################### CREATE A PLOT WITH ALL MEASURED PROBE DATA ###########################################################
#(DISTANCE VS MOISTURE) FROM LUKE MCINNIS
pdf("Distance_Moisture_DTS_Transect.pdf", width=12, height=7)
plot(MoistureData[,"Distance_(cm)"]/100, MoistureData[,"All_Soil_Moisture_Calculated_(%)"]*100, main='Probe Soil Moisture Transect Along DTS Cable', xlab='Transect Distance (m)', ylab='Soil Moisture (%)', col='blue4', pch=19, ylim=c(0,120))
# Add dashed lines to separate regimes
lines(rep(777, length(seq(-25,150, 25))), seq(-25,150, 25), lty=5, col='black')
lines(rep(709, length(seq(-25,150, 25))), seq(-25,150, 25), lty=5, col='black')
lines(rep(647, length(seq(-25,150, 25))), seq(-25,150, 25), lty=5, col='black')
lines(rep(46.4, length(seq(-25,150, 25))), seq(-25,150, 25), lty=5, col='black')
# Add dotted lines to show where ditches are 
lines(rep(46.4, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=2)
lines(rep(144, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=3)
lines(rep(186.5, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=2)
lines(rep(253, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=3)
lines(rep(323.5, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=2)
lines(rep(370, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=2)
lines(rep(415, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=2)
lines(rep(471, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=2)
lines(rep(548.25, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=2)
lines(rep(594.5, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=2)
lines(rep(649, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='blue4', lwd=2)
# Add dotted line to show where the duckweed spring is
lines(rep(72.9, length(seq(-25,150, 25))), seq(-25,150, 25), lty=6, col='green', lwd=2)
# Add legend
legend(680,123, c("Regime Boundary", "Ditch", "Main Channel", "Spring"), col=c("black","blue4", "blue4", "green"), lty=c(5,6,6), lwd=c(2.5,2.5,3.5,2.5)) 
# Add x axis ticks
axis(side = 1, at = c(100,300,500,700))
dev.off()                                                           
                                                          
########################################################### CREATE AUTOCORRELATION PLOTS ###########################################################

# First create an autocorrelation plot for the ENTIRE TRANSECT at the METER SCALE
                                                              
 # Write a function to get the autocovariance for lags 0-20
autoCov<-function(lag, MoistureData) {
    # Calculate average soil moisture
    SM_mean<-mean(MoistureData)
    # Record number of soil moisture measurements
    n<-length(MoistureData)
    # Make empty vector for autocovariance check
    AutoCov<-vector(length=length(MoistureData)-1)                    
    for (i in (lag+1):n){
    AutoCov[i]<-(1/n*(MoistureData[i]-SM_mean)*(MoistureData[i-lag]-SM_mean))
    }
    # Calculate the autocovariance for each lag
    return(sum(AutoCov))
    }                                                                                                                   

# Start with the WOODS at the METER SCALE
# Extract only the moisture data from the woods at the meter scale
Woods_m<-MoistureData[which(MoistureData[,"Enter"]=="Woods"):which(MoistureData[,"Exit"]=="Woods"),"m_Soil_Moisture_Calculated_(%)"]                                                              
# Remove NAs from the vector of moisture values
Woods_m<-na.omit(Woods_m)                                                             
# Apply the autoCov function to the Woods_m vector                                                            
Woods_m_AC<-sapply(0:20, function(x,y) autoCov(x,y), Woods_m)    
# Calcualte the autocorrelation coefficients    
Woods_m_AC<-sapply(Woods_m_AC, function(x) x/Woods_m_AC[1])
# Calculate the 95% confidence bounds for the plot               
conf<-1.96/sqrt(length(Woods_m))
# Create an autocorrelation plot 
pdf("TW_Woods_AC_m.pdf", width=12, height=7)
plot(c(0:20), Woods_m_AC, abline(h=c(conf,-conf), lty=3), ylim=c(-1,1), main="TW Woods Autocorrelation (meter scale)", xlab='Lag', ylab='Autocorrelation',  xaxp  = c(0, 20, 20), pch=20)    
legend(15.5,1, "95% Confidence Bands", col=c("black"), lty=3, lwd=c(1)) 
dev.off()     

# Plot the WEST BOG regime at the METER SCALE
# Make sure there are no gaps in the data
anyNA(MoistureData[which(MoistureData[,"Distance_(cm)"]%in%seq(ceiling(46.4)*100, 143*100, 100)),"m_Soil_Moisture_Calculated_(%)"])
# FALSE! 
# Extract only the moisture data from the woods at the meter scale
BogW_m<-MoistureData[which(MoistureData[,"Enter"]=="Bog W"):which(MoistureData[,"Exit"]=="Bog W"),"m_Soil_Moisture_Calculated_(%)"]                                                              
# Remove NAs from the vector of moisture values
BogW_m<-na.omit(BogW_m)                                                             
# Apply the autoCov function to the BogW_m vector                                                            
BogW_m_AC<-sapply(0:20, function(x,y) autoCov(x,y), BogW_m)    
# Calcualte the autocorrelation coefficients    
BogW_m_AC<-sapply(BogW_m_AC, function(x) x/BogW_m_AC[1])
# Calculate the 95% confidence bounds for the plot               
conf<-1.96/sqrt(length(BogW_m))
# Create an autocorrelation plot 
pdf("TW_BogW_AC_m.pdf", width=12, height=7)
plot(c(0:20), BogW_m_AC, abline(h=c(conf,-conf), lty=3), ylim=c(-1,1), main="TW West Bog Autocorrelation (meter scale)", xlab='Lag', ylab='Autocorrelation',  xaxp  = c(0, 20, 20), pch=20)    
legend(15.5,1, "95% Confidence Bands", col=c("black"), lty=3, lwd=c(1)) 
dev.off()                  
                                                              
# Plot the EAST BOG regime at the METER SCALE
# Make sure there are no gaps in the data
anyNA(MoistureData[which(MoistureData[,"Distance_(cm)"]%in%seq(145*100, 647*100, 100)),"m_Soil_Moisture_Calculated_(%)"])
# FALSE! 
# Extract only the moisture data from the woods at the meter scale
BogE_m<-MoistureData[which(MoistureData[,"Enter"]=="Bog E"):which(MoistureData[,"Exit"]=="Bog E"),"m_Soil_Moisture_Calculated_(%)"]                                                              
# Remove NAs from the vector of moisture values
BogE_m<-na.omit(BogE_m)                                                             
# Apply the autoCov function to the BogE_m vector                                                            
BogE_m_AC<-sapply(0:20, function(x,y) autoCov(x,y), BogE_m)    
# Calcualte the autocorrelation coefficients    
BogE_m_AC<-sapply(BogE_m_AC, function(x) x/BogE_m_AC[1])
# Calculate the 95% confidence bounds for the plot               
conf<-1.96/sqrt(length(BogE_m))
# Create an autocorrelation plot 
pdf("TW_BogE_AC_m.pdf", width=12, height=7)
plot(c(0:20), BogE_m_AC, abline(h=c(conf,-conf), lty=3), ylim=c(-1,1), main="TW East Bog Autocorrelation (meter scale)", xlab='Lag', ylab='Autocorrelation',  xaxp  = c(0, 20, 20), pch=20)    
legend(15.5,1, "95% Confidence Bands", col=c("black"), lty=3, lwd=c(1)) 
dev.off()          

# Plot the WEST DRY regime at the METER SCALE
# This is the dry area where the DTS plow install began
# Make sure there are no gaps in the data
anyNA(MoistureData[which(MoistureData[,"Distance_(cm)"]%in%seq(0*100, 29*100, 100)),"m_Soil_Moisture_Calculated_(%)"])
# FALSE! 
# Extract only the moisture data from the woods at the meter scale
DryW_m<-MoistureData[which(MoistureData[,"Enter"]=="Dry W"):which(MoistureData[,"Exit"]=="Dry W"),"m_Soil_Moisture_Calculated_(%)"]                                                              
# Remove NAs from the vector of moisture values
DryW_m<-na.omit(DryW_m)                                                             
# Apply the autoCov function to the BogE_m vector                                                            
DryW_m_AC<-sapply(0:20, function(x,y) autoCov(x,y), DryW_m)    
# Calcualte the autocorrelation coefficients    
DryW_m_AC<-sapply(DryW_m_AC, function(x) x/DryW_m_AC[1])
# Calculate the 95% confidence bounds for the plot               
conf<-1.96/sqrt(length(DryW_m))
# Create an autocorrelation plot 
pdf("TW_DryW_AC_m.pdf", width=12, height=7)
plot(c(0:20), DryW_m_AC, abline(h=c(conf,-conf), lty=3), ylim=c(-1,1), main="TW West Dry Autocorrelation (meter scale)", xlab='Lag', ylab='Autocorrelation',  xaxp  = c(0, 20, 20), pch=20)    
legend(15.5,1, "95% Confidence Bands", col=c("black"), lty=3, lwd=c(1)) 
dev.off()          

# Plot the MIDDLE DRY regime at the METER SCALE
# This is the dry area between the woods and the start of the bog
# Make sure there are no gaps in the data
anyNA(MoistureData[which(MoistureData[,"Distance_(cm)"]%in%seq(650*100, 701*100, 100)),"m_Soil_Moisture_Calculated_(%)"])
# FALSE! 
# Extract only the moisture data from the woods at the meter scale
DryM_m<-MoistureData[which(MoistureData[,"Enter"]=="Dry M"):which(MoistureData[,"Exit"]=="Dry M"),"m_Soil_Moisture_Calculated_(%)"]                                                              
# Remove NAs from the vector of moisture values
DryM_m<-na.omit(DryM_m)                                                             
# Apply the autoCov function to the BogE_m vector                                                            
DryM_m_AC<-sapply(0:20, function(x,y) autoCov(x,y), DryM_m)    
# Calcualte the autocorrelation coefficients    
DryM_m_AC<-sapply(DryM_m_AC, function(x) x/DryM_m_AC[1])
# Calculate the 95% confidence bounds for the plot               
conf<-1.96/sqrt(length(DryM_m))
# Create an autocorrelation plot 
pdf("TW_DryM_AC_m.pdf", width=12, height=7)
plot(c(0:20), DryM_m_AC, abline(h=c(conf,-conf), lty=3), ylim=c(-1,1), main="TW Middle Dry Autocorrelation (meter scale)", xlab='Lag', ylab='Autocorrelation',  xaxp  = c(0, 20, 20), pch=20)    
legend(15.5,1, "95% Confidence Bands", col=c("black"), lty=3, lwd=c(1)) 
dev.off()  

# Plot the TIDMARSH EAST AWC moisture values
# Extract only the moisture data from the Atlantic White Cedar transect at the 20 cm scale
AWC_20cm<-TE_Moisture[,"AWC"]                                                             
# Remove NAs from the vector of moisture values
AWC_20cm<-na.omit(AWC_20cm)                                                             
# Apply the autoCov function to the AWC_m vector                                                            
AWC_20cm_AC<-sapply(0:20, function(x,y) autoCov(x,y), AWC_20cm)    
# Calcualte the autocorrelation coefficients    
AWC_20cm_AC<-sapply(AWC_20cm_AC, function(x) x/AWC_20cm_AC[1])
# Calculate the 95% confidence bounds for the plot               
conf<-1.96/sqrt(length(AWC_20cm))
# Create an autocorrelation plot 
pdf("TE_AWC_20cm_AC.pdf", width=12, height=7)
plot(c(0:20), AWC_20cm_AC, abline(h=c(conf,-conf), lty=3), ylim=c(-1,1), main="TE Atlantic White Cedar Autocorrelation (20 cm scale)", xlab='Lag', ylab='Autocorrelation',  xaxp  = c(0, 20, 20), pch=20)    
legend(15.5,1, "95% Confidence Bands", col=c("black"), lty=3, lwd=c(1)) 
dev.off()  

# Plot the TIDMARSH EAST HUMMOCK moisture values
# Extract only the moisture data from the hummock transect at the 20 cm scale
# NOTE: the distances for the hummock data transitions from every 10 cm to every 20 cm ... must account for this
# Determine the maximum and minimum distances value in the hummock data 
max_H<-max(na.omit(TE_Moisture[,"Distance_H"]))
# min_H starts at 10. We would rather start at 20 cm (+10)
min_H<-min(na.omit(TE_Moisture[,"Distance_H"]))+10
# Create a sequence from min_H to max_H separated by increments of 20 and only select values from hummock data that match those distances
Hummock_20cm<-TE_Moisture[TE_Moisture[,"Distance_H"]%in%seq(min_H, max_H, 20), "Hummock"]             
# Remove NAs from the vector of moisture values
Hummock_20cm<-na.omit(Hummock_20cm)                                                             
# Apply the autoCov function to the Hummock_m vector                                                            
Hummock_20cm_AC<-sapply(0:20, function(x,y) autoCov(x,y), Hummock_20cm)    
# Calcualte the autocorrelation coefficients    
Hummock_20cm_AC<-sapply(Hummock_20cm_AC, function(x) x/Hummock_20cm_AC[1])
# Calculate the 95% confidence bounds for the plot               
conf<-1.96/sqrt(length(Hummock_20cm))
# Create an autocorrelation plot 
pdf("TE_Hummock_20cm_AC.pdf", width=12, height=7)
plot(c(0:20), Hummock_20cm_AC, abline(h=c(conf,-conf), lty=3), ylim=c(-1,1), main="TE Hummock Autocorrelation (20 cm scale)", xlab='Lag', ylab='Autocorrelation',  xaxp  = c(0, 20, 20), pch=20)    
legend(15.5,1, "95% Confidence Bands", col=c("black"), lty=3, lwd=c(1)) 
dev.off()  

# Plot the TIDMARSH EAST UNDISTURBED moisture values
# Extract only the moisture data from the undisturbed transect at the 20 cm scale
Undisturbed_20cm<-TE_Moisture[,"Undisturbed"]                                                             
# Remove NAs from the vector of moisture values
Undisturbed_20cm<-na.omit(Undisturbed_20cm)                                                             
# Apply the autoCov function to the Hummock_m vector                                                            
Undisturbed_20cm_AC<-sapply(0:20, function(x,y) autoCov(x,y), Undisturbed_20cm)    
# Calcualte the autocorrelation coefficients    
Undisturbed_20cm_AC<-sapply(Undisturbed_20cm_AC, function(x) x/Undisturbed_20cm_AC[1])
# Calculate the 95% confidence bounds for the plot               
conf<-1.96/sqrt(length(Undisturbed_20cm))
# Create an autocorrelation plot 
pdf("TE_Undisturbed_20cm_AC.pdf", width=12, height=7)
plot(c(0:20), Undisturbed_20cm_AC, abline(h=c(conf,-conf), lty=3), ylim=c(-1,1), main="TE Undisturbed Autocorrelation (20 cm scale)", xlab='Lag', ylab='Autocorrelation',  xaxp  = c(0, 20, 20), pch=20)    
legend(15.5,1, "95% Confidence Bands", col=c("black"), lty=3, lwd=c(1)) 
dev.off()  
                  
                                                              
