################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱：hello_guozi@126.com

## ggplot2如何起步？
## 记住1点，ggplot2有四个基本组成部分。

load("gathe_data.Rdata")

library(ggplot2)

ggplot(data=exprSet,aes(x=sample,y=ESR1))+
  geom_boxplot()

## 1.ggplot()


## 2.data
## 数据框
## 清洁数据：行是观测，列是变量，内容是数据

## 3.几何图形，geom_系列
## 
ggplot(data=exprSet,aes(x=sample,y=ESR1))+
  geom_point()

ggplot(data=exprSet,aes(x=sample,y=ESR1))+
  geom_jitter()

ggplot(data=exprSet,aes(x=sample,y=ESR1))+
  geom_boxplot()

ggplot(data=exprSet,aes(x=sample,y=ESR1))+
  geom_violin()

## 4.映射，美学属性 aes()
## 是data和geom之间的桥梁
## 定义哪些变量放在图上，可以是1个
ggplot(data=exprSet,aes(x=sample))+
  geom_bar()

## 可以是两个
ggplot(data=exprSet,aes(x=sample,y=ESR1))+
  geom_jitter()

## 可以是3个
ggplot(data=exprSet,aes(x=sample,y=ESR1,color=subgroup))+
  geom_jitter()

## 定义图形的美学属性
ggplot(data=exprSet,aes(x=sample,y=ESR1,fill=sample))+
  geom_boxplot()

## 如果图形比较复杂，可以通过加号堆料
ggplot(data=exprSet,aes(x=sample,y=ESR1,color=sample))+
  geom_boxplot()

#叠加一个点图
ggplot(data=exprSet,aes(x=sample,y=ESR1,color=sample))+
  geom_boxplot()+
  geom_jitter()
# 点可以自己定义美学属性颜色，aes()
ggplot(data=exprSet,aes(x=sample,y=ESR1,color=sample))+
  geom_boxplot()+
  geom_jitter(aes(color=subgroup))

## 好了记住这四点，就可以上路了。
## http://sape.inf.usi.ch/quick-reference/ggplot2