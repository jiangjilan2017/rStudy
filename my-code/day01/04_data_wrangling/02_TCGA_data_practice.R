################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱：hello_guozi@126.com

rm(list = ls())

## 数据调整实战！！：获取清洁数据，表达量绘图,相关性分析
## 最终我们会获得任何一个gene在特定癌症中的表达情况并作图
## 包含的核心步骤
## 1. 获取表达量数据
## 2. 行列转换
## 3. 添加分组信息

######################################################################
### 1.准备自己的数据
#################################
### 加载数据，假设我们手上已经获取了这部分数据，他们来自于明天的课程
### 是deseq2 经过vst标准化后的数据
rm(list = ls())
load(file = "BRCA_exprSet_vst.Rdata")
### 为了代码复用，把名称改为expr_df
expr_df <- exprSet_vst
### 选取一部分数据
test <- expr_df[1:10,1:10]
### 行名变成第一列，cbind十分好用
expr_df <- cbind(gene_id= rownames(expr_df),expr_df)
test <- expr_df[1:10,1:10]
#看一下右侧的环境变量区域，他是一个58077行1216列的数据框，你是不是不信？(不要去点开，会卡住的)
#我们有查看大数据的法宝
class(expr_df) #类型
dim(expr_df) #维度
str(expr_df) #结构

#如果不够直观，我们还有一个大法宝，截取部分数据查看
test <- expr_df[1:10,1:10]

######################################################################
### 2.注释基因
###################################
### 那些看不懂的基因名称是需要注释的
### 准备注释文件，这些步骤本次不需要运行，被注释掉
### 1.下载gtf文件
### https://gdc.cancer.gov/about-data/data-harmonization-and-generation/gdc-reference-files
### 2.下载后先解压gencode.v22.annotation.gtf.gz
### 3..读取gtf文件
### gtf1 <- rtracklayer::import('gencode.v22.annotation.gtf')
### 4.转换为数据框
### gtf_df <- as.data.frame(gtf1)
### 5.保存
### save(gtf_df,file = "gtf_df.Rdata")

### 读取gtf文件，需要一点耐心，小电脑尤甚
load(file = "gtf_df.Rdata")
test <- gtf_df[1:100,]

### 提取编码基因(当然也可以提取非编码RNA)
library(dplyr)
exprSet <- gtf_df %>% 
  ## 筛选gene,和编码指标
  dplyr::filter(type=="gene",gene_type=="protein_coding") %>%
  ## 选出基因名称，和ensemble id这两列
  dplyr::select(c(gene_name,gene_id)) %>% 
  ## 和表达量的数据交叉合并，等同于merge
  dplyr::inner_join(expr_df,by ="gene_id") %>% 
  ## 去掉多余列
  dplyr::select(-gene_id) %>% 
  ## 以下是为了删除多于的行
  ## 增加一列
  mutate(rowMean = rowMeans(.[,-1])) %>% 
  ## 排序
  arrange(desc(rowMean)) %>% 
  ## 去重
  distinct(gene_name,.keep_all = T) %>% 
  ## 删除多余列
  dplyr::select(-rowMean) 

test <- exprSet[1:10,1:10]
########################################################################
### 3.准备分类信息
#############################
#制作metadata，不要管这个单词，这一步就是区别肿瘤和正常组
#要对TCGA的id有一点了解，其中第14和15位的数字很重要
#其中01-09是tumor，也就是癌症样本；其中10-29是normal，也就是癌旁

TCGA_id <- colnames(exprSet)[-1]
table(substring(TCGA_id,14,15))

sample <- ifelse(substring(TCGA_id,14,15)=="01","Tumor","Normal")
sample <- factor(sample,levels = c("Normal","Tumor"),ordered = F)
metadata <- data.frame(TCGA_id,sample) 

table(metadata$sample)

##########################################################################
### 4.(可选)额外的分组信息：比如亚型信息，突变，免疫浸润
#除了按照正常和肿瘤分组，我们还可以用Pam50亚型分类器来给肿瘤分亚型，我已经分好了，读取数据
## 这个pam50只有乳腺癌有，其他肿瘤，自己添加本领域的分组
pam50score <- read.table("TCGA_BRCA_PAM50__pam50scores.txt",header = T)
class(pam50score)
#选取第1列和第7列,因为第7列是分类的结果
subgroup <- pam50score[,c(1,7)]
names(subgroup) <- c("TCGA_id","subgroup")

##########################################################################
### 5.数据转置
### 要实现最终效果，我们需要把他转置，即行列互换
### 转置秘诀，矩阵
### 这个是常用操作，第一列变成行名，需要熟练使用
### 还有个逆向操作，行名变成第一列
#设置行名：
rownames(exprSet) <- exprSet[,1]
#删除第一列
exprSet <- exprSet[,-1]
#看一下现在数据结构
test <- exprSet[1:10,1:10]
#行列转置
exprSet <-t(exprSet)
exprSet <-as.data.frame(exprSet)
#看一下现在数据结构
test <- exprSet[1:10,1:10]

######################################################################
### 6.添加分类信息
### 加入肿瘤和对照的信息，在metadata里面
### 准备merge 的列
exprSet <- cbind(TCGA_id=rownames(exprSet),exprSet)
test <- exprSet[1:10,1:10]
### 加入分组信息
exprSet <- merge(metadata,exprSet,by="TCGA_id")
test <- exprSet[1:10,1:10]
### 加入亚组信息
exprSet <- merge(subgroup,exprSet,by="TCGA_id")
test <- exprSet[1:10,1:10]
### 保存数据
### save(exprSet,file = "TCGA_BRCA_exprSet_plot.Rdata")

#############################################################################
### 7.作图测试
##前面无论出现什么结果都不要紧，清空，加载，我们开始上路
rm(list = ls())
load(file = "TCGA_BRCA_exprSet_plot.Rdata")
library(ggplot2)

#看BRCA1基因的是癌和癌旁的表达
#成功后，尝试一下 TP53，ERBB2，ESR1，修改y的值就可以
ggplot(exprSet,aes(x=sample,y=ESR1))+
  geom_boxplot()

#看BRCA1基因在亚型中的表达
ggplot(exprSet,aes(x=subgroup,y=BRCA1))+
  geom_boxplot()+
  theme_bw()+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

#试试你知道的gene，要注意这里没有非编码的gene

## 美图是个刚需，任何时候都需要，但是不用刻意去学
## 偷得浮生半日闲
exprSet$subgroup <- factor(exprSet$subgroup,levels = c("LumA","LumB","Her2","Basal","Normal"),ordered = F)
library(ggpubr)
my_comparisons <- list(
  c("Basal", "Normal"), 
  c("Her2", "Normal"),
  c("LumA", "Normal"),
  c("LumB", "Normal")
)
ggboxplot(
  exprSet, x = "subgroup", y = "FOXA1",
  color = "subgroup", palette = "jco",
  add = "jitter"
)+
  stat_compare_means(comparisons = my_comparisons, method = "t.test")
##换个基因试一下，比如MKI67，或者你自己想看的基因，这里有19439个！！

## 那么问题来了，美图如何保存呢？，比例随便你来调，plot，export。

## 还可以导出为PPT来编辑
## 加载R包
library(export)
## 导成PPT可编辑的格式
graph2ppt(file="dotplot.pptx")

########################################################################
### 8.相关性分析
### 两基因相关性作图
corr_eqn <- function(x,y,digits=2) {
  test <- cor.test(x,y,method ="spearman")
  paste(paste0("n = ",length(x)),
        paste0("r = ",round(test$estimate,digits),"(Spearman)"),
        paste0("p.value= ",round(test$p.value,digits)),
        sep = ", ")
}

ggplot(exprSet,aes(FOXA1,ESR1))+
  geom_point(col="#984ea3")+
  geom_smooth(method=lm, se=T,na.rm=T, fullrange=T,size=2,col="#fdc086")+
  geom_rug(col="#7fc97f")+
  theme_minimal()+
  labs(title = paste0(corr_eqn(exprSet$FOXA1,exprSet$ESR1)))+
  theme(plot.title = element_text(hjust = 0.5))

## 可以写成函数,方便操作
  
ggcorplot <- function(a,b){
  corr_eqn <- function(x,y,digits=2) {
    test <- cor.test(x,y,method="spearman")
    paste(paste0("n = ",length(x)),
          paste0("r = ",round(test$estimate,digits),"(Spearman)"),
          paste0("p.value= ",round(test$p.value,digits)),
          sep = ", ")
  }
  plot_df <- exprSet[,c(a,b)]
  names(plot_df) <- c("geneA","geneB")
  ggplot(plot_df,aes(geneA,geneB))+
    geom_point(col="#984ea3")+
    geom_smooth(method=lm, se=T,na.rm=T, fullrange=T,size=2,col="#fdc086")+
    geom_rug(col="#7fc97f")+
    theme_minimal()+
    xlab(paste0("Expression of ",a," (TPM)"))+
    ylab(paste0("Expression of ",b," (TPM)"))+
    labs(title = paste0(corr_eqn(plot_df$geneA,plot_df$geneB)))+
    theme(plot.title = element_text(hjust = 0.5))
}
## 测试一下
ggcorplot("FOXA1","ESR1")
ggcorplot("SAMD11","ISG15")
ggcorplot("EGFR","EPHA2")

############################################################################
###9.单基因批量相关性分析
test <- exprSet[1:10,1:10]
gene <- "ESR1"
## 写一个批量程序
batchcor <- function(data,gene){
  data <- data[,-c(1,2,3)]
  genelist <- colnames(data)
  do.call(rbind,lapply(genelist, function(x){
    dd  <- cor.test(as.numeric(data[,gene]),as.numeric(data[,x]),method="spearman")
    data.frame(gene1=gene,gene2=x,cor=dd$estimate,p.value=dd$p.value )
  }))
}
## 调用函数
dd <- batchcor(data=exprSet,gene=gene)
## 如何用?
## 单基因批量相关性分析的妙用
## https://mp.weixin.qq.com/s/TfE2koPhSkFxTWpb7TlGKA
## 又是神器！基于单基因批量相关性分析的GSEA
## https://mp.weixin.qq.com/s/sZJPW8OWaLNBiXXrs7UYFw

##################################################################
#这些简单的操作结合在一起，最终完成了一个相对复杂的事情，This is your victory!
## 重要的示范和课后练习(必须完成的家庭作业)
## 跟Nature一起学习TCGA,GTEx和CCLE数据库的使用
## https://mp.weixin.qq.com/s/_04Mx72q-jQigkCzfZ20Kw

## 还可以用ggstatsplot这个R包来做，参考下面两个帖子
## https://mp.weixin.qq.com/s/D0nSO7UxX7DVlgAP6AbDKA
## https://mp.weixin.qq.com/s/QkOSpw0_20outj4F9bFalw

########################################################################
### 那么如何写出函数呢？请听下回分解。
### 数据如果获取，期待明天的课程吧
### GSEA分析怎么做，期待明天的课程吧
### 探索单个基因的作用，期待明天的课程吧