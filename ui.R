
library(GenomicRanges)
library(ggplot2)
library(ensembldb)
load("ens75genes.rda")
load("encsel2.rda")

ui = fluidPage(
 sidebarLayout(
  sidebarPanel(
   helpText("Display selected narrowPeak reports from ENCODE elements in Bioconductor AnnotationHub; see 'about' tab for more details"),
   selectInput("factor", "TF", choices=unique(encsel2$factor), selected="CEBPB"),
   textInput("gene", "gene", value="ORMDL3"),
   numericInput("radius", "radius", value=10000, min=1000, max=100000, step=5000), 
   actionButton("stopit", "stop app"), width=2
   ),
  mainPanel(tabsetPanel(id="tabs", 
   tabPanel("viz", plotOutput("gg1")),
   tabPanel("about", 
     helpText("A collection of narrowPeak.gz files were retrieved from hg19 goldenpath UCSC genome 
          browser resources, to illustrate elementary aspects of 
          cell-type-specific transcription factor binding."),
     helpText("The file URLs are obtained from the encode690 component of the TFutils package."),
     helpText("Counts of regions tabulated by cell type and TF are:"),
     verbatimTextOutput("design")
   )
  )
 )
)
)


#source("ggsym.R")
#gene = "GSDMB"
#factor = "JUN"
#radius = 50000
#encsel = encsel[which(encsel$factor == factor)]
#dd = subsetByOverlaps(encsel, ens75genes[gene]+radius)
#
#ee = as.data.frame(dd)
#ee$cell = factor(ee$cell) # as.character(cls))
#ee$yval = 1+(as.numeric(ee$cell)-1)/length(unique(ee$cell))
#ggsym(gene) + 
#        geom_segment(aes(x=start, xend=end, y=yval, yend=yval,
#              group=cell, colour=cell), data=ee, size=2.5) +
#        theme(axis.text.y = element_blank(), axis.title.y=element_blank()) + 
#            ylim(-.5,2) + ggtitle(sprintf("%s binding near %s", factor, gene))
#
