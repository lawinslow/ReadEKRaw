# testing convert power...
# R code
# need to set the following parameters:  
# 1. tvgCFac:   The TVG range correction factor
# for the ES/K 60 the recommended values to apply are:
#Application    			Recommended value of TVG range correction
#Sv data for echo integration 				2

#TS data for use with method 1 single		2 
#target detection operators (see Notes at URL) 

#TS data for use with method 2 single		0
#target detection operators (see Notes at URL)
# http://support.echoview.com/WebHelp/Reference/Algorithms/Echosounder/Simrad/Simrad_Time_Varied_Gain_Range_Correction.htm


# calibration parameters - need to create a list of these parameters for each frequency.
# must run the ReadEKRaw function first.
# Input: Output from ReadEKRaw function. A list of three objects called data,
# (1) File header, (2) pings, (3) GPS data. These three objects are themselves lists. 
# use the GetcalParams or SetcalParams function to pull out the calibration parameters

# adds in gain and equivalentebeam angle to every ping, matched by frequency.

for (i in 1:length(data$pings)) {
    x = data$pings[[i]]
    for( b in 1:length(data$header$transceiver)){
        y = data$header$transceiver[[b]]
        if (y$frequency == x$frequency){
            x$gain = y$gain
            x$equivalentbeamangle = y$equivalentbeamangle
        }
    } 
    data$pings[[i]] = x
}

# now you can then pull out the cal parameters all from the pings lists
# for files with multiple transceivers, each frequency alternates.
# Example: In a file with both 120 and 710 frequencies the datagrams go in the following order:
# 120, 710 , 120, 710, 120...
# so the number of transcievers should specify the first n-number of datagrams that need 
# to be read through.

#ntransceivers = data$header$header$transceivercount
#calParams = list()
for (i in 1:(length(data$pings))){
    f = data$pings[[i]]$frequency
    G =  data$pings[[i]]$gain
    phi = data$pings[[i]]$equivalentbeamangle
    cv = data$pings[[i]]$soundvelocity # this was called c in the original Matlab code
    t = data$pings[[i]]$sampleinterval 
    alpha = data$pings[[i]]$absorptioncoefficient 	
    pt = data$pings[[i]]$transmitpower
    tau = data$pings[[i]]$pulselength
    dR = cv * t / 2 # calculate sample thickness (in range)
    lambda =  cv / f # calculate wavelength
    # calculate Sa correction
    idx = match(tau, data$pings[[i]]$pulselengthtable)
    Sac = c()    
    if (!is.na(idx) == TRUE ) {
        Sac = 2*(data$pings[[i]]$sacorrectiontable[idx])
    } else {
        Sac = 0
        warning("Sa correction table empty - Sa correction not applied....\n")
    }
    tvgCFac =  2 # user specified, see notes above for guidance.
    
    #freq = paste("freq", f/1000,"kHz", sep ="") # name by common freq names (ex. 710)
    #tmp = list(f = f,G = G, phi = phi,cv=cv, t=t, alpha= alpha, pt = pt, tau = tau, dR = dR, lambda = lambda, Sac = Sac)
    #calParams[[freq]] = tmp
    
    rangeCorrected = 1:length(data$pings[[i]]$power) * dR 
    TVG = (40 * log10(rangeCorrected))
    CSv = 10 * log10((pt * (10^(G/10))^2 * lambda^2 * cv * tau * 10^(phi/10)) /  (32 * pi^2))
    data$pings[[i]]$Sv = data$pings[[i]]$power + TVG + (2 * alpha * rangeCorrected) - CSv - Sac   
}


# need to create a range vector  - see lines 39-41 above.
# need to create a rangecorrected vector - see lines 70 - 75 above.  
# seems like the range is just the number of pings...

#rangeCorrected = 1:length(data[['pings']][[i]]$power) * dR
rangeCorrected = 1:length(data$pings[[i]]$power) * dR # this needs to get created for every ping. 

#  data.pings(idx).time(nPings(idx)) = dgTime; == this comes from ReadEKRaw line 1226
# maybe you can specify this when you read in the data in th demoscript file . The number of pings is created
# as an output variable at the same time. 



# Sv = data.pings(n).power + TVG + (2 * alpha * rangeCorrected) - CSv - Sac

# make a matrix
Svoutput = matrix(, nrow = length(data$pings[[1]]$Sv), ncol = length(data$pings))# blank matrix
for (i in 1:length(data$pings)) {
    if (data$pings[[i]]$frequency == 120000){
        tmp = (data$pings[[i]]$Sv)
        Svoutput[,i] = tmp 
    }
}

image(Svoutput)
                  
                  
                  
                  
                  


