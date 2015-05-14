 
for (i in 1:length(test$pings)) {
    x = test$pings[[i]]
    for( b in 1:length(test$header$transceiver)){
        y = test$header$transceiver[[b]]
        if (y$frequency == x$frequency){
            x$gain = y$gain
            x$equivalentbeamangle = y$equivalentbeamangle
            x$sacorrectiontable = y$sacorrectiontable
            x$pulselengthtable = y$pulselengthtable
        }
    } 
    test$pings[[i]] = x
}

# ntransceivers = test$header$header$transceivercount

ntransceivers = test$header$header$transceivercount
calParms = list()
for (i in 1:(ntransceivers)){
    f = test$pings[[i]]$frequency
    G =  test$pings[[i]]$gain
    phi = test$pings[[i]]$equivalentbeamangle
    c = test$pings[[i]]$soundvelocity
    t = test$pings[[i]]$sampleinterval 
    alpha = test$pings[[i]]$absorptioncoefficient 	
    pt = test$pings[[i]]$transmitpower
    tau = test$pings[[i]]$pulselength
    dR = c * t / 2 # calculate sample thickness (in range)
    lambda =  c / f # calculate wavelength
    # calculate Sa correction
    idx = match(tau, test$pings[[i]]$pulselengthtable)
    Sac = c()    
    if (!is.na(idx) == TRUE ) {
        Sac = 2*(test$pings[[i]]$sacorrectiontable[idx])
        } else {
            Sac = 0
            warning("Sa correction table empty - Sa correction not applied....\n")
        }
    freq = paste("freq", f/1000,"kHz", sep ="") # name by common freq names (ex. freq710kHz)
    tmp = list(f = f,G = G, phi = phi,c=c, t=t, alpha= alpha, pt = pt, tau = tau, dR = dR, lambda = lambda, Sac = Sac)
    calParms[[freq]] = tmp
}








