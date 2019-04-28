
servera = function(input, output) {
   output$gg1 = renderPlot({
     plot(1,1)
   })
}
   



server = function(input, output) {
library(GenomicRanges)
library(ggplot2)
library(ensembldb)
library(EnsDb.Hsapiens.v75)

ggsym = function (sym, resource = EnsDb.Hsapiens.v75, 
    columnsKept = c("gene_id", "tx_id"), yval = 1, arrmm = 1.5, 
    viewtype = "transcripts", ...) 
{
    exs = GenomicFeatures::exons(resource, filter = SymbolFilter(sym), 
        columns = columnsKept, ...)
    if (viewtype == "exons") 
        exs = unique(exs)
    rd = reduce(exs)
    fo = findOverlaps(rd, exs)
    gr = split(subjectHits(fo), queryHits(fo))
    pp = function(n) (seq_len(n) - 1)/n
    st = start(exs)
    en = end(exs)
    if (viewtype == "exons") {
        ys = lapply(gr, function(x) pp(length(x)))
        yvs = unlist(ys)
    }
    else if (viewtype == "transcripts") {
        tnms = exs$tx_id
        ft = factor(tnms)
        yvs = (as.numeric(ft) - 1)/length(levels(ft))
    }
    else stop("viewtype not %in% c('exons', 'transcripts')")
    newdf = data.frame(st, en, yv = yvs, sym = sym, entity=sym)
    rng = range(exs)
    df = data.frame(range = c(start(rng), end(rng)), yval = rep(yval, 
        2))
    strn = as.character(strand(exs)[1])
    ardir = ifelse(strn == "+", "last", "first")
    pl = ggplot(df, aes(x = range, y = yval)) + geom_segment(aes(x = st, 
        y = yv, xend = en, yend = yv, colour = entity), data = newdf, 
        #arrow = arrow(ends = ardir, length = unit(arrmm, "mm")), 
        size = 2.5)
    pl + xlab(as.character(GenomeInfoDb::seqnames(exs)[1]))
}
#source("ggsym.R")
if (!exists("ens75genes")) load("ens75genes.rda")
if (!exists("encsel2")) load("encsel2.rda")
  output$gg1 = renderPlot({
    encsel2 = encsel2[which(encsel2$factor == input$factor)]
    validate(need(input$gene %in% names(ens75genes), "waiting for gene symbol known to ensembl v75"))
    ee = as.data.frame(subsetByOverlaps(encsel2, ens75genes[input$gene]+input$radius))
    ee$cell = factor(ee$cell) 
    ee$yval = 1+(as.numeric(ee$cell)-1)/length(unique(ee$cell))
    ggsym(input$gene) + 
        geom_segment(aes(x=start, xend=end, y=yval, yend=yval,
              group=cell, colour=cell), data=ee, size=2.5) +
        theme(axis.text.y = element_blank(), axis.title.y=element_blank()) + 
            ylim(-.5,2) + ggtitle(sprintf("%s binding near %s", input$factor, input$gene))
    })
  observeEvent(input$stopit, {
       ans = NULL
       stopApp(returnValue=ans)
       })  
  output$design = renderPrint({
    table(encsel2$cell, encsel2$factor)
    })

}
   

