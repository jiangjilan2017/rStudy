################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱: hello_guozi@126.com


## 学习R语言就是学习函数，
## 函数怎么用呢？
rm(list = ls())
load(file = "TCGA_ggplot.Rdata")
metadata <- data.frame(rownames(exprSet)) #转换成数据框
for (i in 1:length(metadata[,1])) {
  #substring的用法，这是元素获取
  num <- as.numeric(substring(metadata[i,1],14,15)) 
  #如果是肿瘤，就给第2列加上Tumor
  if (num %in% seq(1,9)) {metadata[i,2] <- "Tumor"} 
  #如果是正常组织，就给第2列加上Normal
  if (num %in% seq(10,29)) {metadata[i,2] <- "Normal"} 
}
names(metadata) <- c("TCGA_id","sample")

## 改写成函数

tell_me_sample <- function(TCGA_id){
  num <- as.numeric(substring(TCGA_id,14,15)) #substring的用法，这是元素获取
  if (num %in% seq(1,9)) {sample <- "Tumor"} #如果是肿瘤，就给第2列加上Tumor
  if (num %in% seq(10,29)) {sample <- "Normal"} #如果是正常组织，就给第2列加上Normal
  return(sample)
  }
## 调用函数
tell_me_sample(metadata[1,1])
tell_me_sample(metadata[3,1])


### 写一个作图的函数
rm(list = ls())
load(file = "TCGA_ggplot.Rdata")

my_comparisons <- list(
  c("LumA", "Normal"),
  c("LumB", "Normal"),
  c("Her2", "Normal"),
  c("Basal", "Normal")
)
library(ggpubr)
ggboxplot(
  exprSet, x = "subgroup", y = "ESR1",
  color = "subgroup", palette = c("#00AFBB", "#E7B800", "#FC4E07","#A687D8", "#89E4A4"),
  add = "jitter"
)+
  stat_compare_means(comparisons = my_comparisons, method = "t.test")



## 改写一下,方便调用
subgroup_plot <- function(gene){
  my_comparisons <- list(
    c("LumA", "Normal"),
    c("LumB", "Normal"),
    c("Her2", "Normal"),
    c("Basal", "Normal")
  )
  library(ggpubr)
  ggboxplot(
    exprSet, x = "subgroup", y = gene,
    color = "subgroup", palette = c("#00AFBB", "#E7B800", "#FC4E07","#A687D8", "#89E4A4"),
    add = "jitter"
  )+
    stat_compare_means(comparisons = my_comparisons, method = "t.test")
}

## "OR4F5"    "SAMD11"   "BRCA1"    "ESR1" 

subgroup_plot("SAMD11")

subgroup_plot("BRCA1")

#########################################################################
### 关于函数，这些帖子可以看一下
### 1.R语言中性价比最高的函数以及最贵的函数
### https://mp.weixin.qq.com/s/iwmb8WhvEzXBiK--xsGusA
### 2.写一个速度提升10倍的table
### https://mp.weixin.qq.com/s/47Pc0Hp8TWNcn2MkVFMPiA
### 3.8秒完成2万个基因的生存分析，人人都可以！
### https://mp.weixin.qq.com/s/o4e1HzG4zPIQoGT6-7D0ug
### 4.神奇的lapply
### https://mp.weixin.qq.com/s/l8UkSNn8OhSYnuhrSw7JfA
### 5.迷人的多参数批量函数mapply
### https://mp.weixin.qq.com/s/e7sq5eCKoPjIGk34X7f3Iw
