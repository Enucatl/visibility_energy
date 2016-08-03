#!/usr/bin/env Rscript

library(rhdf5)
library(argparse)
library(reshape)
library(data.table)
library(grid)
library(ggplot2)

commandline_parser = ArgumentParser(
        description="visibility") 

commandline_parser$add_argument('-f', '--file',
            type='character', nargs='+',
            help='hdf5 file with the data')
commandline_parser$add_argument('-d', '--dataset',
            type='character', nargs='?',
            default='postprocessing/visibility',
            help='dataset inside the hdf5 file'
            )

args = commandline_parser$parse_args()

read_pixels = function(filename, dataset) {
    pixels = h5read(filename, dataset, index=list(180:330, 180:330))
    pixels = as.vector(pixels)
    pixels = pixels[pixels > 0.01]
    result = as.list(quantile(pixels, probs=c(0.1, 0.5, 0.9), na.rm=TRUE))
    return(result)
}

table = fread(args$file)
table[, c("min", "median", "max") := read_pixels(file, args$dataset), by=energy]
print(table)
warnings()
plot = ggplot(table, aes(y=median, x=energy)) +
    geom_point() +
    geom_errorbar(aes(ymax=max, ymin=min)) +
    ylab("visibility") +
    xlab("voltage (kV)")
print(plot)
width = 10
height = 0.618 * width
dpi = 150
ggsave(
       file="visibility.png",
       plot=plot,
       width=width, height=height, dpi=dpi)
message("Press Return To Continue")
invisible(readLines("stdin", n=1))
