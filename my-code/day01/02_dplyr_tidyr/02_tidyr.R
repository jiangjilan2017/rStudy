################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱：hello_guozi@126.com

rm(list = ls())

### 讲解tidyr
#################################################
## 1.separate:拆分列
#################################################
load(file = "expr_df.Rdata")
## 1.截取
gene_id1 <- substr(expr_df$gene_id,1,15)
head(gene_id1)

## 2.替换
gene_id2 <- gsub("\\.\\d+","",expr_df$gene_id)
head(gene_id2)

## 3.分列
library(tidyr)
library(dplyr)
### 指定切割符号
expr_df0 <- expr_df %>% 
  tidyr::separate(gene_id,into = c("gene_id","drop"),sep=".")
### 正确指定切割符号
expr_df1 <- expr_df %>% 
  tidyr::separate(gene_id,into = c("gene_id","drop"),sep="\\.")
### 删除不需要的列
expr_df2 <- expr_df %>% 
  tidyr::separate(gene_id,into = c("gene_id","drop"),sep="\\.") %>% 
  dplyr::select(-drop)

#################################################
## 2.unite:合并列
#################################################
rm(list = ls())
load(file = "test.Rdata")
exprSet <- test %>% 
  tidyr::unite(gene_id,gene_name,gene_id,gene_biotype,sep = "|") #合并信息
### 如何使用，第一个参数是最终的列名，后面接着都是需要合并的列
#################################################
## 3.pivot_longer:宽变长
## 就是减少列，增加更多的行，让这个表达数据看起来更长。
#################################################
library(tidyr)
rm(list = ls())
load("gathe_data.Rdata")

#看ESR1基因的是癌和癌旁的表达
library(ggplot2)
ggplot(exprSet,aes(x=sample,y=ESR1,fill=sample))+
  geom_boxplot()

## 加入要显示多基因呢，需要调整数据结构
### 总共就是三个参数
library(tidyr)
data <- exprSet %>% 
  pivot_longer(cols=3:6,
               names_to= "gene",
               values_to = "expression")

## 多基因亚型分析癌症和癌旁
ggplot(data,aes(x=gene,y=expression,fill=sample))+
  geom_boxplot()

## 使用分面
## 以样本为x轴,再以基因来分
ggplot(data,aes(x=sample,y=expression,fill=sample))+
  geom_boxplot()
ggplot(data,aes(x=sample,y=expression,fill=sample))+
  geom_boxplot()+
  facet_grid(.~gene)

## 以基因为x轴,再以样本来分
ggplot(data,aes(x=gene,y=expression,fill=gene))+
  geom_boxplot()
ggplot(data,aes(x=gene,y=expression,fill=gene))+
  geom_boxplot()+
  facet_grid(.~sample)

#############################################
## 如何选择列
data1 <- exprSet %>% 
  pivot_longer(cols=3:6,
               names_to= "gene",
               values_to = "expression")

data2 <- exprSet %>% 
  pivot_longer(cols=-c(1,2),
               names_to= "gene",
               values_to = "expression")

data3 <- exprSet %>% 
  pivot_longer(cols=c("BRCA1","TP53","FOXA1","ESR1"),
               names_to= "gene",
               values_to = "expression")
data4 <- exprSet %>% 
  pivot_longer(cols=-c("subgroup","sample"),
               names_to= "gene",
               values_to = "expression")

################################################
## 4.pivot_wider:长变宽
################################################
## pivot_longer的逆向操作
## 就是减少行，增加更多的列，让这个表达看起来更宽。
library(dplyr)
data_w <- data1 %>% 
  pivot_wider( names_from = gene,
               values_from = expression)

## 1.重复行的解决
data1 <- exprSet %>%
  ## 增加一列，以数字表示
  mutate(num=seq(1:nrow(.))) %>% 
  ## 再宽变长，增加行
  pivot_longer(cols=3:6,
               names_to= "gene",
               values_to = "expression")
## 2.长变宽，增加列
data_w <- data1 %>% 
  pivot_wider( names_from = gene,
               values_from = expression)

#################################################
## 一个运用pivot_longer的例子
rm(list = ls())
load(file = "BRCAmuts.Rdata")
## 明确需求是什么？
dd <- BRCAmuts %>% 
  group_by(TCGA_id,Hugo_Symbol)%>% 
  summarise(num=n())

dd1 <- dd %>% 
  pivot_wider(names_from =Hugo_Symbol,
            values_from = num) %>% 
  ungroup()

## na变为0,用is.na去判断，然后选取，赋值
dd1[is.na(dd1)] =0

## 也可以设置参数
dd2 <- dd %>% 
  pivot_wider(names_from =Hugo_Symbol,
              values_from = num,
              values_fill = list(num = 0)) %>% 
  ungroup()

## 最终可以汇总一下，形成数据处理的一套流程
dd3 <- BRCAmuts %>% 
  ### 1.group_by 联合summarise 分组统计频次
  group_by(TCGA_id,Hugo_Symbol)%>% 
  summarise(num=n()) %>% 
  ### 2.长数据变宽，获取更多的列，新增加的列是基因
  pivot_wider(names_from =Hugo_Symbol,
              values_from = num,
              values_fill = list(num = 0)) %>% 
  ### 3.去掉分组结构
  ungroup()

###########################
## tidyr 掌握四个函数
### separate, 拆分列
### unite, 合并列
### pivot_longer, 数据变长，增加行
### pivot_wider，数据变宽，增加列
### 阅读材料，课程文字档：
## https://mp.weixin.qq.com/s/sbc3LVv5MAkFenE1JB-rAA
