################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱：hello_guozi@126.com

### 重点掌握内容
rm(list = ls())
### 首先是dplyr这个包
################################################
### 介绍管道符号
## 不用管道符号实现四个步骤1.产生数列 2.抽样，3排序,4.选取前面
set.seed(1015)
## 1.产生序列
res <- seq(1,1000) 
## 2.抽样100
res1 <- sample(res,100) 
## 3.排序
res2 <- sort(res1) 
## 4.查看前6个
head(res2)

#### 写成一句话试试
set.seed(1015)
head(sort(sample(seq(1,1000),100)))

### 问题就是不适合阅读
### 使用管道符号来解决
set.seed(1015)
library(dplyr)
seq(1,1000) %>% sample(100) %>% sort() %>% head()

## 换一种写法
set.seed(1015)
seq(1,1000) %>% 
  sample(100) %>% 
  sort() %>% 
  head()

######################################################################
### 加载练习数据
rm(list = ls())
load(file = "probe2symbol_df.Rdata")
load(file = "exprSet.Rdata")

## 把两个数据框合在一起
## merge 函数的使用
exprSetm <- merge(exprSet,probe2symbol_df,by="probe_id")
######################################################################
## 1.inner_join
################
## inner_join 的功能跟merge一样,交叉合并
library(dplyr)
exprSeti <- inner_join(exprSet,probe2symbol_df,by="probe_id")

## 换一种写法，管道符号
exprSet1 <- exprSet %>% inner_join(probe2symbol_df,by="probe_id")

### 也可以写成
exprSet1 <- exprSet %>% 
  inner_join(probe2symbol_df,by="probe_id")

#######################################################################
## 2.select
################
## select:: 筛选列,使用位置和名称都可以

######################
### 用位置来试试
#####################
### 选择第1列
test <- exprSet1 %>% 
  select(1)
### 删掉第1列
test1 <- exprSet1 %>% 
  select(-1)
### 选择第2-4列
test2 <- exprSet1 %>% 
  select(2:4)
### 选择2,3,5,6列
test3 <- exprSet1 %>% 
  select(2,3,5,6)
### 删掉第2,3,5,6列
test4 <- exprSet1 %>% 
  select(-c(2,3,5,6))
######################
### 用名称来试试
######################
### 选择probe_id这一列
test <- exprSet1 %>% 
  select(probe_id)
### 删除probe_id这一列
exprSet2 <- exprSet1 %>% 
  select(-probe_id)
## 把symbol放到第1列,直接用数值
exprSet3 <- exprSet2 %>% 
  select(7,1,2,3,4,5,6)
## 把symbol放到第1列,可以简写
exprSet3 <- exprSet2 %>% 
  select(7,1:6)
## 把symbol放到第1列,字符串和数值混用
exprSet3 <- exprSet2 %>% 
  select(symbol,1:6)
## 介绍everything()函数
exprSet3 <- exprSet2 %>% 
  select(symbol,everything())

#######################################################################
## 3.mutate
#####################
## 现在我们要干什么呢？
## mutate增加新的列
test <- exprSet3[,-1]
newcolumn =rowMeans(exprSet3[,-1])
exprSet4 <- exprSet3 %>% 
  mutate(newcolumn =rowMeans(exprSet3[,-1]))

######################################################################
## 4.arrange 
#####################
## arrange 对行排序，默认是从小到大，
exprSet_test <- exprSet4 %>% 
  arrange(newcolumn)
## 加上desc()会变成从大到小
exprSet5 <- exprSet4 %>% 
  arrange(desc(newcolumn))

######################################################################
## 5.distinct
######################
## distinct是对行进行去重，默认保留重复中的第一个
test <- exprSet5 %>% 
  distinct(symbol)

### 添加参数保留住其他列 .keep_all = T
exprSet6 <- exprSet5 %>% 
  distinct(symbol,.keep_all = T)

### 此时可以比较去重的效果
nrow(exprSet5)
nrow(exprSet6)

## slect 删除新增加的列，过河拆桥。
exprSet7 <- exprSet6 %>% 
  select(-newcolumn)

### 这就是GEO数据库中，表达谱数据的处理。
### 包含了探针ID转换，探针去重这样必要的步骤
### 整个过程，产生了7个变量，太繁琐了。

######################################################
## 管道符号是可以联用的
exprSet8 <- exprSet %>% 
  #1.合并探针的信息
  inner_join(probe2symbol_df,by="probe_id") %>% 
  #2.去掉多余列
  select(-probe_id) %>%  
  #3.重新排列
  select(symbol,everything()) %>%  
  #4.求出平均数(这边的.代表上一步的数据，实际上是exprSet3)
  mutate(rowMean =rowMeans(.[,-1])) %>% 
  #5.把表达量的平均值按从大到小排序
  arrange(desc(rowMean)) %>% 
  #6.基因名称去重
  distinct(symbol,.keep_all = T) %>% 
  #7.删除多余列
  select(-rowMean) 

########################################################
## 6.filter
########################
## dplyr中还有一个功能是filter，用于筛选行，极其常用。
rm(list = ls())
load(file = "TCGA_exprSet_plot.Rdata")
library(dplyr)
exprSet1 <- exprSet %>% 
  filter(sample=="Tumor")

## 可以连续筛选
exprSet2 <- exprSet %>% 
  filter(sample=="Tumor") %>% 
  filter(subgroup=="LumA")

## 可以多个指标联合
exprSet2 <- exprSet %>% 
  filter(sample=="Tumor",subgroup=="LumA")

################################################################
## 总结dplyr，掌握6个函数
### filter, 按照指标筛选行，最终行减少
### distinct, 按照某一列去重行，最终行减少
### select,选择列
### mutate,增加新的列
### inner_join,交叉合并
### arrange,按照某一列的指标去按行排序，最终行数量不变，位置改变
################################################################
## 下面这个功能也需要掌握，分组批量计算
## groub_by 和summarize
## https://mp.weixin.qq.com/s/w6NdxsmetSitF19-vbbYXA