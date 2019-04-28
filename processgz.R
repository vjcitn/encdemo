
#  X                                                          mygz  cell factor
#1 1 wgEncodeAwgTfbsHaibHepg2Cebpbsc150V0416101UniPk.narrowPeak.gz HepG2  CEBPB
#2 2  wgEncodeAwgTfbsHaibK562Cebpbsc150V0422111UniPk.narrowPeak.gz  K562  CEBPB

processgz = function(csvpath) {
 tab = read.csv(csvpath, stringsAsFactors=FALSE)
 library(rtracklayer)
 library(GenomicRanges)
 z = lapply(tab$mygz, import)
 for (i in 1:length(z)) z[[i]]$cell = tab$cell[i]
 for (i in 1:length(z)) z[[i]]$factor = tab$factor[i]
 fullGR = unlist(GRangesList(z))
 genome(fullGR) = "hg19"
 fullGR
}

