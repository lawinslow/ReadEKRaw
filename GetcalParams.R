 
for (i in 1:length(data$pings)) {
    x = data$pings[[i]]
    for( b in 1:length(data$header$transceiver)){
        y = data$header$transceiver[[b]]
        if (y$frequency == x$frequency){
            x$gain = y$gain
            x$equivalentbeamangle = y$equivalentbeamangle
            x$sacorrectiontable = y$sacorrectiontable
            x$pulselengthtable = y$pulselengthtable
        }
    } 
    data$pings[[i]] = x
}

# ntransceivers = data$header$header$transceivercount

ntransceivers = data$header$header$transceivercount
calParms = list()
for (i in 1:(ntransceivers)){
    f = data$pings[[i]]$frequency
    G =  data$pings[[i]]$gain
    phi = data$pings[[i]]$equivalentbeamangle
    c = data$pings[[i]]$soundvelocity
    t = data$pings[[i]]$sampleinterval 
    alpha = data$pings[[i]]$absorptioncoefficient 	
    pt = data$pings[[i]]$transmitpower
    tau = data$pings[[i]]$pulselength
    dR = c * t / 2 # calculate sample thickness (in range)
    lambda =  c / f # calculate wavelength
    # calculate Sa correction
    idx = match(tau, data$pings[[i]]$pulselengthtable)
    Sac = c()    
    if (!is.na(idx) == TRUE ) {
        Sac = 2*(data$pings[[i]]$sacorrectiontable[idx])
        } else {
            Sac = 0
            warning("Sa correction table empty - Sa correction not applied....\n")
        }
    freq = paste("freq", f/1000,"kHz", sep ="") # name by common freq names (ex. freq710kHz)
    tmp = list(f = f,G = G, phi = phi,c=c, t=t, alpha= alpha, pt = pt, tau = tau, dR = dR, lambda = lambda, Sac = Sac)
    calParms[[freq]] = tmp
}








