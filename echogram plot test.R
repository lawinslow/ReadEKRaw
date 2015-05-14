# plotting the Sv
# separate the 120 and 710 data$pings into two separate list
# Input: data structure from ReadEKRaw with Sv object added using ReadEKRaw_ConvertPower


# merge the Sv vector from every data$pings of the same frequency to create a matrix for plotting

Svoutput120 = matrix(, nrow = length(data$pings[[1]]$Sv), ncol = length(data$pings))# blank matrix
Svoutput710 = matrix(, nrow = length(data$pings[[2]]$Sv), ncol = length(data$pings))

for (i in 1:length(data$pings)) {
    if (data$pings[[i]]$frequency == 120000){
        tmp = (data$pings[[i]]$Sv)
        Svoutput120[,i] = tmp 
    } else if(data$pings[[i]]$frequency == 710000) {
        tmp = (data$pings[[i]]$Sv)
        Svoutput710[,i] = tmp 
    }
}

#get rid of NA columns
Svoutput120 = Svoutput120[,!is.na(Svoutput120[1,])]
Svoutput710 = Svoutput710[,!is.na(Svoutput710[1,])]


plot_ecogram = function(data, depths, fname='ecogram.png', threshold=-35){
	
	data[data < threshold] = NA
	
	png(fname, res=300, width=2000, height=1600)
	image(z=t(data), y=depths, ylim=rev(range(depths)))
	dev.off()	

}

#plot_ecogram(Svoutput120)
plot_ecogram(Svoutput710, data$pings[[2]]$rangeCorrected, fname='710.png', threshold=-50)

plot_ecogram(Svoutput120, data$pings[[1]]$rangeCorrected, fname='120.png', threshold=-50)





