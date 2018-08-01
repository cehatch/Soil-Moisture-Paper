######################################################## LOAD LIBRARIES ##################################################################

########################################################### LOAD DATA ####################################################################

Raw<-read.csv("file:///C:/Users/erikai94/Documents/UMass/Tidmarsh/McInnis_SM_TW_Raw.csv")    
# Assign column names
colnames(Raw)<-c("Meas_No", "Distance_(cm)", "Permittivity_(mV)", "Probe_Soil_Moisture_(%)", "Comments")      

########################################################### UPDATE MATRIX ####################################################################

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


########################################################### MAKE PLOTS ####################################################################

# Create plot with all measured data 
plot(MoistureData[,"Distance_(cm)"]/100, MoistureData[,"All_Soil_Moisture_Calculated_(%)"]*100, xlab='Transect Distance (m)', ylab='Soil Moisture (%)', col='blue4', pch=19)
# Add dashed lines to separate regimes
lines(rep(777, length(seq(-25,125, 25))), seq(-25,125, 25), lty=5, col='black')
lines(rep(709, length(seq(-25,125, 25))), seq(-25,125, 25), lty=5, col='black')
lines(rep(647, length(seq(-25,125, 25))), seq(-25,125, 25), lty=5, col='black')
lines(rep(46.4, length(seq(-25,125, 25))), seq(-25,125, 25), lty=5, col='black')
# Add dotted lines to show where ditches are 
 lines(rep(144, length(seq(-25,125, 25))), seq(-25,125, 25), lty=6, col='blue4', lwd=2)

                                                              
