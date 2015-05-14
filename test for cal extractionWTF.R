# test pulling out header parameters
ntransceivers = length(header)
params1 = NULL 
for (i in 1:(ntransceivers)) { 
    f = header$transceiver[[i]]$frequency
    G =  header$transceiver[[i]]$gain
    phi = header$transceiver[[i]]$equivalentbeamangle
    #freq = as.character(f)
    tmp = list(f = f, G = G, phi = phi)
    params1 = list(freq1 = params1, freq2= tmp)
}


# try 

f = header$transceiver[[1]]$frequency
G =  header$transceiver[[1]]$gain
phi = header$transceiver[[1]]$equivalentbeamangle
#freq = as.character(f)
freq1 = list(f = f, G = G, phi = phi)

f = header$transceiver[[2]]$frequency
G =  header$transceiver[[2]]$gain
phi = header$transceiver[[2]]$equivalentbeamangle
freq2 = list(f = f, G = G, phi = phi)

params1 = list(freq1 = freq1, freq2 = freq2)


x = list(a = 1, b= 2)
y = list(c = 3, d= 4)
z = list(x=x,y=y)
