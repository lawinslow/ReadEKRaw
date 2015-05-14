# Parse GPGGA string

parseGPGGAstring = function(y) {
    time = as.POSIXct(strptime(substr(y, 8, 17), "%H%M%S", tz = "GMT")) # need to figure out how to add in correct date
    latdeg = as.numeric(substr(y, 19,20))
    latmin = as.numeric(substr(y, 21, 27))/60
    lathemi = substr(y, 29, 29)
    if (lathemi == "N") {
        lat = latdeg + latmin # decimal degrees
    } else {
        lat = -(latdeg + latmin) # decimal degrees
    }
    longdeg = as.numeric(substr(y, 31, 33))
    longmin = as.numeric(substr(y, 34, 40))/60
    longhemi = substr(y, 42, 42)
    if (longhemi == "E"){
        long = longdeg + longmin  # decimal degrees
    } else {
        long = -(longdeg + longmin)
    } 
    fixquality = substr(y, 44, 44)
    numsatellites = substr(y, 46, 47)
    altitude = as.numeric(substr(y, 53,57)) # meters
GPSdata = list(time=time, 
               lat=lat, 
               long=long, 
               fixquality = fixquality, 
               numsatellites = numsatellites, 
               altitude = altitude
               )
GPSdata
}

#parseGPGGAstring(y)

