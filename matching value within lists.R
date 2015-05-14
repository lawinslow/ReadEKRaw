matching values within a list of lists...
b = c(1,4,5)
x = c(1,3,5)
y = c(2,4,6)
d = c(3,4,7)
z = list(b=b, x=x,y=y,d=d)
tau = 3 # value to match
# create empty vector to store match positions in 
idx = c()
for (i in 1:length(z)){
    tmp = match(tau, unlist(z[i]))
    idx = c(idx, tmp)
}
# the output, idx, is a vector of the position of the match, so you need to use the object 
# that has the first non-NA value. 
# identify the index value of the objects that match
idxvalue.list = which(!is.na(idx) == TRUE, arr.ind = TRUE)
# choose the first index position that matches the frequency needed
freqneeded = idxvalue.list[1] # this is the position of the object in the sampledata list that you should use.
#
#g = rep(seq_along(z), sapply(z, length))
#listidx = (sapply(tau, function(x) g[which(unlist(z) %in% x)]))
#freqneeded = z[[(listidx)]]
#idx= match(tau, freqneeded)

