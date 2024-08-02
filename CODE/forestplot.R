setwd("working directory")

# install.packages("forestplot")       
library("forestplot")               
rm(list = ls())

rs_forest <- read.csv('Reading drawing data.csv', header = FALSE) 

tiff('Drawing.tiff', height = 100, width = 4500, res = 300)

fp <- forestplot(labeltext = as.matrix(rs_forest[,1:7]),
           mean = rs_forest$V8,  
           lower = rs_forest$V9,
           upper = rs_forest$V10,
           is.summary = c(T,F,F,F,F,F,F,F,F,F,F,F),
           xticks = c(0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4),
           
           zero = 1,       
           boxsize = 0.2, 
           
           lineheight = unit(8,'mm'),  
           colgap = unit(4,'mm'),   
           lwd.zero = 2,
           lwd.ci = 2,
           col = fpColors(box = "#227700", 
                          summary = "#227700", 
                          lines = "#0000FF",
                          zero = "#FF3333"),
           xlab = "OR",
           lwd.xaxis = 2,
           lty.ci = "solid",
           graph.pos = 8,
           new_page = TRUE,
           xlog = TRUE)

