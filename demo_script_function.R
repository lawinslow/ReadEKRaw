#Example run function
# returns list with three objects in it: (1) file header, (2), datagrams, (3) GPS data

#HEADER_LEN = 12   #  Bytes in datagram header

function_files = file.path('R', dir('R'))
sapply(function_files, source)

#fname = "/Users/Taylor/Dropbox/Acoustic files 2014/Poconos2014/lake.giles.2014.07.07.es60/.raw files/L0004-D20140707-T164500-ES60.raw"
fname = '../L0004-D20140707-T164500-ES60.raw'


ReadEKRaw = function(fname){
    fid = file(fname, open = "rb")
    HEADER_LEN = 12
    # create empty lists to store pings and GPS data
    #datatypes = c()    
    pings = list()
    GPS = list()
    
    # read header
    header = readEKRaw_ReadHeader(fid)
       
    while(TRUE){
        datagram.length = readBin(
            con      = fid,
            what 	= 'integer',
            n    	= 1,
            size 	= 4,
            signed  = TRUE,
            endian 	= "little")
        
        if(length(datagram.length) == 0){
            warning('End of file...\n')
            break;
        }
        #read the datagram header
        nextHeader = readEKRaw_ReadDgHeader(fid)    
        #dtype = nextHeader$dgType
        #datatypes =  c(datatypes, dtype)
        
        # read NME0 datagram type
        if (nextHeader$dgType == "NME0") { 
            nchar = datagram.length-HEADER_LEN
            GPSdata = readChar(fid,nchar)   
            if(substr(GPSdata, 1,6) == "$GPGGA"){
                x = parseGPGGAstring(GPSdata) # function to parse the GPSdata string, output is a list
                GPS[[length(GPS)+1]] = GPSdata 
            } 
        # read RAW0 datagram type
        }else if(nextHeader$dgType == "RAW0"){
            samples = readEKRaw_ReadSampledata(fid)
            pings[[length(pings)+1]] =  samples
            
        } else {
            seek(fid, datagram.length-HEADER_LEN, origin="current")
        }
        datagram.length2 = readBin(
            con      = fid,
            what     = 'integer',
            n    	= 1,
            size 	= 4,
            signed  = TRUE,
            endian 	= "little")
    } # end of while loop
  data = list(header = header, pings = pings, GPS = GPS)
  close(fid)
  data 
} # end of function


