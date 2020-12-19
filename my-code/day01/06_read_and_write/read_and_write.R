################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱: hello_guozi@126.com

## 这一步是链接外部数据和R语言的桥梁

## 读取csv
## 最常用的是read.table,速度最快最智能的是fread
fcsv1 = read.table(file = "B cell receptor signaling pathway.csv",sep = ",",header = T,stringsAsFactors = F)
fcsv2 = read.csv(file = "B cell receptor signaling pathway.csv")
fcsv3 = data.table::fread(file = "B cell receptor signaling pathway.csv")
class(fcsv3)
fcsv4 = data.table::fread(file = "B cell receptor signaling pathway.csv",data.table = F)
class(fcsv4)
fcsv5 <- as.data.frame(fcsv3)
class(fcsv5)

## 读取txt
platformMap1 <- read.table("platformMap.txt",sep = "\t",header = T,stringsAsFactors = F)
platformMap2 <- data.table::fread("platformMap.txt",data.table = F)

## 读取GEO数据
exprSet1 <- read.table("GSE42872_series_matrix.txt",sep = "\t",comment.char="!",stringsAsFactors=F,header=T)
exprSet2 <- data.table::fread("GSE42872_series_matrix.txt",skip = 59,data.table = F)

exprSet3 <- read.table("GSE105261_series_matrix.txt",sep = "\t",comment.char="!",stringsAsFactors=F,header=T)
exprSet4 <- read.table("GSE105261_series_matrix.txt",sep = "\t",comment.char="!",stringsAsFactors=F,header=T,fill = T)
exprSet5 <- data.table::fread("GSE105261_series_matrix.txt",skip = 62,data.table = F)

## 读取GEO平台注释信息soft文件
GPL6244_anno <-data.table::fread("GSE42872_family.soft",skip ="ID",data.table = F)

## 读取TCGA数据RNAseq data counts 文件
RNAsEQ1 <- read.table("0e30bd18-8e8b-4c52-aace-b5587c6df51a.htseq.counts",header = F,stringsAsFactors = F,sep = "\t")
RNAsEQ2 <- data.table::fread("0e30bd18-8e8b-4c52-aace-b5587c6df51a.htseq.counts",data.table = F)

## 读取json文件
metadata <- jsonlite::fromJSON("metadata.cart.2018-10-04.json")

### 读取xml文件
library("XML")
result <- xmlParse(file = "nationwidechildrens.org_clinical.TCGA-3A-A9IS.xml")
rootnode <- xmlRoot(result)  
xmldataframe <- xmlToDataFrame(rootnode[2])

## 读取TCGA甲基化文件
expr_df <- data.table::fread("jhu-usc.edu_BRCA.HumanMethylation450.9.lvl-3.TCGA-BH-A1EV-11A-24D-A138-05.gdc_hg38.txt"
                             ,data.table = F)

### 如何读取Excel??
### 总结，读取文件，fread，我看行。

############################################################
### 写出文件呢？
### 我还是坚持那句话,不要把文件写来写去，出图前请使用rdata保存
### 要写出一般是csv，便于用Excel查看
rm(list = ls())
load(file = "ego_BP_20180802.Rda")
data <- as.data.frame(ego_BP)

write.table(data,file = "ego_BP.csv",sep = ",",row.names = F)

write.csv(data,file = "ego_BP2.csv",row.names = F)

