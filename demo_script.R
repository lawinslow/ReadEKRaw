#Example run

HEADER_LEN = 12;    #  Bytes in datagram header

function_files = file.path('R', dir('R'))
sapply(function_files, source)

#fname = "/Users/Taylor/Dropbox/Acoustic files 2014/Poconos2014/lake.giles.2014.07.07.es60/.raw files/L0004-D20140707-T164500-ES60.raw"
fname = '../L0004-D20140707-T164500-ES60.raw'
fid = file(fname, open = "rb")

output = readEKRaw_ReadHeader(fid)
ntransceivers = length(output)
datatypes = c()
pings = list()


while(TRUE){
    datagram.length = readBin(
        con  	= fid,
        what 	= 'integer',
        n    	= 1,
        size 	= 4,
        signed  = TRUE,
        endian 	= "little")
    
    if(length(datagram.length) == 0){
        warning('End, bitches...\n')
        break;
    }
    
    nextHeader = readEKRaw_ReadDgHeader(fid)
    #cat(nextHeader$dgType, '\n')
    dtype = nextHeader$dgType
    datatypes =  c(datatypes, dtype)
    
    if (nextHeader$dgType == "NME0") { 
        nchar = datagram.length-HEADER_LEN
        GPSdata = readChar(fid,nchar)   
            if(substr(GPSdata, 1,6) == "$GPGGA"){
                x = parseGPGGAstring(GPSdata) # function to parse the GPSdata string, need to do something with output
                print(x$lat)
            } 
    
    }else if(nextHeader$dgType == "RAW0"){
        
    		# read sample data function
        samples = readEKRaw_ReadSampledata(fid)
        
        pings = c(pings, samples)
    
    } else {
        seek(fid, datagram.length-HEADER_LEN, origin="current")
    }
    
    datagram.length2 = readBin(
        con      = fid,
        what 	= 'integer',
        n    	= 1,
        size 	= 4,
        signed  = TRUE,
        endian 	= "little")
}

close(fid)
