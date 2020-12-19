################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱：hello_guozi@126.com

rm(list = ls())
library(ggplot2)
library(clusterProfiler)
load(file = "EGG_20190106.Rda")
## 定制一个图片
if(T){
  x = EGG
  ## 内置的函数可以转换为数据框
  df = data.frame(x)
  dd =x@result
  ## 计算富集分数
  dd$richFactor =dd$Count / as.numeric(sub("/\\d+", "", dd$BgRatio))
  ## 提取p值小于0.05 的
  dd <- dd[dd$p.adjust < 0.05,]
  
  library(ggplot2)
  ## 正式画图
  ggplot(dd,aes(richFactor,forcats::fct_reorder(Description, richFactor))) + 
    ## 画横线
    geom_segment(aes(xend=0, yend = Description)) +
    ## 画点
    geom_point(aes(color=p.adjust, size = Count)) +
    ## 调整颜色的区间,begin越大，整体颜色越明艳
    scale_color_viridis_c(begin = 0.3, end = 1) +
    ## 调整泡泡的大小
    scale_size_continuous(range=c(2, 10)) +
    theme_bw() + 
    xlab("Rich factor") +
    ylab(NULL) + 
    ggtitle("")
}

## 加载R包
library(export)
## 导成PPT可编辑的格式
graph2ppt(file="dotplot.pptx")

## 导成AI可以编辑的状态
graph2eps(file="dotplot2.eps")
