################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱: hello_guozi@126.com
################################################

## 函数是什么

## R语言里面的所有单词都是函数

max
min
head
tail
median

## 如何写函数呢？
## 结构
function.name <- function(arguments){
  computations on the arguments
  some other code
}

## 你的第一个函数
## 写一个函数，计算出x的平方加上2

yourFisrtfun <- function(x){
  x^2+2
}

## 调用函数
## 测试x=10

yourFisrtfun(10)
## 测试x=91
## 写下你的答案


## 你的第二个函数
## 传入两个参数，计算x的y次方加上1

yourSecondfun <- function(x,y){
  x^y+1
}

## 测试x=5,y=3
## 调用函数
yourSecondfun(5,3)

## 测试x=25,y=4
## 写下你的答案

## 你的第三个函数，返回两个值
## 计算乘方和乘积，同时返回
doubleget <- function(x,y){
  x^y
  x*y

}
## 测试x=2,y=3
doubleget(2,3)
## 怎么办？？使用return！！！
doubleget <- function(x,y){
  a <- x^y
  b <- x*y
  return(c(a,b))
}
doubleget(2,3)

## 课堂练习
## 1.写一个函数名字叫plusm，
## 2.功能是求两个数的平方和 ，
## 3.测试 25,26

## 复习总结