################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱：hello_guozi@126.com

rm(list = ls())
### 给大家看一下最终的数据格式，明确一下我们的目标
load(file = "dw.Rata")

## 数据格式调整实战
## 包含的核心步骤
## 1. 获取表达量数据
## 2. 行列转换
## 3. 添加分组信息

## 行列转置
exprSet_t <- t(exprSet)
## 矩阵变成数据框
exprSet_d <- as.data.frame(exprSet_t)
## 添加分组
exprSet_g <- cbind(group=group,exprSet_d)
## 完成！！！
dd <- exprSet_g

## 单基因作图
library(ggplot2)
ggplot(data = dd,aes(x=group,y=CD36,fill=group))+
  geom_boxplot()+
  geom_point()+
  theme_bw()

## 加p值
my_comparisons <- list(
  c("treat", "con")
)
library(ggpubr)
ggplot(data = dd,aes(x=group,y=CD36,fill=group))+
  geom_boxplot()+
  geom_point()+
  theme_bw()+
  stat_compare_means(comparisons = my_comparisons, method = "t.test")

## 多基因作图
## 用pivot_longer调整数据
library(tidyr)
data <- dd %>% 
  pivot_longer(cols=-1,
               names_to= "gene",
               values_to = "expression")

## 作图
ggplot(data = data,aes(x=gene,y=expression,fill=group))+
  geom_boxplot()+
  geom_jitter()+
  theme_bw()+
  stat_compare_means(aes(group=group), label = "p.signif", method = "t.test")

## 尝试更清晰的展示
ggplot(data = data,aes(x=group,y=expression,fill=group))+
  geom_boxplot()+
  geom_jitter()+
  theme_bw()+
  facet_grid(.~gene)+
  stat_compare_means(comparisons = my_comparisons, label = "p.signif", method = "t.test")

### 参考帖子
### 墙裂推荐！统计方法如何选以及全代码作图实现
### https://mp.weixin.qq.com/s/IF4F0W2ghWRq4ILVP3T49A
### 我喜欢的gather快要被淘汰了，迎面走来了更好用的宽长转换工具
### https://mp.weixin.qq.com/s/sbc3LVv5MAkFenE1JB-rAA
