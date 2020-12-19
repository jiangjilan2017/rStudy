pancorplot <- function(data=plotdf,anotate="none"){
  require(ggplot2)
  require(ggrepel)
  options(scipen = 2)
  p=ggplot(plotdf,aes(-log10(p.value),cor))+
    geom_point(data=subset(plotdf, plotdf$p.value >= 0.05),size=6,fill="grey",alpha=0.6,shape = 21,colour="black",stroke = 1.5)+
    geom_point(data=subset(plotdf, plotdf$p.value < 0.05 & plotdf$cor>=0),size=6,fill="red",alpha=0.6,shape = 21,colour="black",stroke = 1.5)+
    geom_point(data=subset(plotdf, plotdf$p.value < 0.05 & plotdf$cor< 0),size=6,fill="blue",alpha=0.6,shape = 21,colour="black",stroke = 1.5)+
    scale_y_continuous(expand = c(0,0),limits = c(-1.1,1.1),breaks = seq(-1,1,0.2))+
    scale_x_log10(limits = c(0.01, 1000),breaks = c(0.01,0.1,10,1000))+
    geom_hline(yintercept = 0,size=1.5)+
    geom_vline(xintercept = -log10(0.05),size=1.5)+
    labs(x=bquote(-log[10]~italic("P")),y="Pearson correlation (r)")+
    theme(axis.title=element_text(size=20),
          axis.text = element_text(face = "bold",size = 16),
          axis.ticks.length=unit(.4, "cm"),
          axis.ticks = element_line(colour = "black", size = 1),
          panel.background = element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.line = element_line(colour = "black"),
          panel.border = element_rect(colour = "black", fill=NA, size=1.5),
          plot.margin = margin(1, 1, 1, 1, "cm"))
  if(anotate == "none"){
    p
  }else{
    p +  geom_point(data=subset(plotdf, plotdf$type%in% anotate),
                    size=6,fill="red",shape = 21,colour="black",stroke = 2)+
      geom_label_repel(data=subset(plotdf, plotdf$type %in% anotate), 
                       aes(label=type),col="black",size=6,
                       box.padding = 10,
                       arrow=arrow(angle = 30, length = unit(0.25, "inches"),
                                   ends = "first", type = "closed"),
                       segment.size=1,
                       segment.color = "red")
  }
}