################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱：hello_guozi@126.com

## 别看这是一个小文档，整个数据挖掘都以他作为基础
## 欲练此功，必先学习
## 什么叫注释
##########################################################################
## 1.R语言基础############################################################
##########################################################################
## 基本计算，加减乘除 +，-，*，/,>, <, = ,!=, >=,<=
3+3
100-7
4*5
22/7
355/113
3^2
log2(16)

### 比较大小
2 > 5
5 >= 3
6 < 7
5!= 6
################
## 数据的基本类型
## 常用函数class()，看数据的属性，函数的调用是用的小括号
class(2)
class(TRUE)
class(FALSE)
class("china")
class(18)
#还有一个是因子，稍后介绍

#########################################################################
## 2.数据结构############################################################
#########################################################################
## 2.1向量
##c(),rep(),seq()
## c就是combine联合的意思。rep就是replicate重复的意思，seq就是sequence序列
## 函数的参数之间需要逗号分隔
c(1,3,6)
c("TP53","ERBB2","BRCA1")

rep(1,3)
rep("A",3)
## 常用操作
rep(c("control","treat"),3)
rep(c("control","treat"),each=3)

## seq的几种用法
seq(1,3)
seq(5,10)
seq(5,10,2)
seq(1001,20000)

## 你能口算结果么？
c(rep(1,3),seq(2,5))

###########################################################################
## 变量，介绍观念
## R语言里面的数据，在最终结果之前不要频繁写出去，读进来，用Rdata,save,load
## 变量就是储存器，呼之即来，挥之则去,钩子。
cancergene <- c("TP53","ERBB2","BRCA1")
b <- c("zhangsan","lisi","wangermazi")
## 保存用save
save(cancergene,b,file = "twoinone.Rdata")

## 清空
rm(list = ls())
## 提取用load
load(file = "twoinone.Rdata")

#######
# ls,列举当前环境中所有的变量
ls()

# remove,删除当前环境中选择的变量
rm(cancergene)

# 现在只剩下变量b
### 获取元素
### 想一下获取元素的符号[]
b[1]
b[2]
b[2:3]
# 获取到的元素也可以成为新的变量
sub <- b[2:3]

## 产生随机数
sample(seq(1,100), 9)
sample(seq(1,100), 9)
# set.seed, 固定随机数，分析中用不到，教学用
set.seed(811)
sample(seq(1,100), 9)
## 把产生的随机数赋值给变量cat
set.seed(811)
cat <- sample(seq(1,100), 9)
cat 
## R语言中认识的单词都是函数
max(cat)
min(cat)
sum(cat)
mean(cat)
sum(cat)/9

### 处理na数据，什么叫na？
index <- c(1,3,4,NA,1,2)
sum(index)
sum(index,na.rm = T)
is.na(index)

#######
# sort,排序,返回排序后的值
cat
sort(cat)
## 改变顺序，参数的重要性
sort(cat,decreasing = T)

#######
# order,排序,返回的是位置
cat
sort(cat)
order(cat)
## 排序，妙用！！用获取，巧妙改变位置，很常用。
cat[order(cat)] 

## 返回逻辑值
cat==29
## 依靠逻辑值截取
cat[cat==29]

## which返回坐标位置
which(cat==29)

cat[4]
cat[which(cat==29)]

## 还可以怎么获取位置
d <- c("TP53","ERBB2","BRCA1")

## grep表示抓取，返回的是数字
grep("ERBB2",d)
## grepl,表示grep+logical，返回的是逻辑值
grepl("ERBB2",d)
## 使用逻辑值获取子集
d[grepl("ERBB2",d)]

# 此时跟 %in% 的用法一样，A %in% B 表示A是否存在于B
d

"ERBB2" %in% d

d %in% "ERBB2"

d[d %in% "ERBB2"]

## 取交集intersect(x,y),我自己很喜欢，很常用
d <- c("TP53","ERBB2","BRCA1")
e <- c("ERBB2","BRCA1","TP54")
intersect(d,e)

## 再试试%in%，操作逻辑是判断d中的每一个元素是否存在于e
d %in% e
d[d %in% e]

## 复习：sort, order, grep,grepl, %in%
############
##第一次休息10分钟
###################################################################
###################################################################
## 删除环境变量，让心情好好地放个假
rm(list = ls())

#############
## 2.2数据框
#####################
# 如何创建数据框？
L3 <- LETTERS[1:3]
L3
sample(L3, 10)
### 随机种子set.seed，为了保证我们产生一样的随机数。
set.seed(811)
sample(L3,10)
fac <- sample(L3, 10,replace = T)
fac

factor(fac)
## 使用data.frame 创建数据框
d <- data.frame(number = seq(1,10), 
                salary = rep(seq(1,5),2), 
                facdata = fac)
######################
#加载练习数据
load(file = "01_TCGA_BRCA_exprSet.Rdata")
## 如何了解一个数据框
## 看头
head(exprSet)
head(exprSet)[,1:5]
## 看尾
tail(exprSet)
tail(exprSet)[,1:3]
## class看属性，dim看维度，str看结构
class(exprSet)
dim(exprSet)
str(exprSet)

###################################################
# 最直观test,我自己最常用的方法，获取前10行，前10列
test <- exprSet[1:10,1:10]

##############################
# 一顿操作猛如虎
# 获取第一行
test[1,]

# 获取第1列
test[,1]

## 使用$获取列
test$subgroup

# 选取第2到4行
test[2:4,]
# 选取第2到4列
test[,2:4]
# 选取第2到4行,3到5列
test[2:4,3:5]

##########################################################################
## 注意，我们可以通过位置获取，也可以通过行名和列名获取，还可以通过逻辑获取
##########################################################################
## 位置已经讲了
## 行名和列名呢？
## 其中行名获取的方法十分推荐，但是记住一点，行名不能重复
index <- rownames(test)
dd1 <- exprSet[index,]
dd2 <- exprSet[index,c("subgroup","sample","SAMD11")]

## 逻辑获取，先产生逻辑，再返回位置，再获取
test$subgroup == "Normal"
which(test$subgroup == "Normal")
test[c(3,9),]
## 可以一步完成
test[test$subgroup == "Normal",]
## 在此基础上可以再选择列
test[test$subgroup == "Normal",c(1:5)]

## 难点在于产生正确的逻辑值
## 想一下，有多少种方法可以产生逻辑值？？这个很重要
## 1.最重要的逻辑判断，如比较大小 2.函数产生，比如grepl，%in%
############################################################################
## 选行，选列，还有一个重要的函数subset
## subset，第一个数据，第二个选行(逻辑值)，第三个是列，名称
test1 <- subset(test,test$subgroup == "Normal",select =c(1:5))
test2 <- subset(test,test$subgroup == "Normal",select =c(1:12))

# 删掉第一列
test1 <- test[,-1]
# 增加一列
test1$subgroup <- test$subgroup
# 调整顺序，很常用，很常用
test2 <- test1[,c(10,seq(1,9))]
test2 <- test1[,c(10,1:9)]
## 学完了cbind，还有更简单的方法

#获取名称
colnames(test)
rownames(test)

# 修改名称
colnames(test)[3:5] <- c("GeneA","GeneB","GeneC")
rownames(test)[1:2] <-c("sampleA","sampleB")
###############################################################
###############################################################
#####第二次休息 10分钟
rm(list = ls())

# 合并
## 加载数据
load(file = "bind.Rdata")
# 按列合并cbind,顺序很重要
cbind2 <- cbind(cbindA,cbindB)
cbind2 <- cbind2[,-5]
## 如果想增加第一列，可以这样做
test <- cbind(number = seq(1,10),cbindB)

# 交叉合并 merge,这个很重要，很常用，是芯片数据探针ID转换的基础。
## merge的逻辑，很常用首先按照某个因素intersect，再rbind
cbindm <- merge(cbindA,cbindC,by="id")

## 1,取交集，共有的名称
index <- intersect(cbindA$id,cbindC$id)
## 2.为了能用行名来获取，要产生行名
rownames(cbindA) <- cbindA$id
rownames(cbindC) <- cbindC$id
## 3.按照行名去获取两个子集，再用cbind按列合并
cbindme <- cbind(cbindA[index,],cbindC[index,c(2:4)])

# 按行合并，rbind
rbind2 <- rbind(rbindA,rbindB)

#####################################################
rm(list = ls())
## 2.3 矩阵
ma <- matrix(c(1:4, 6, 9:15), nrow = 3)
ma
# 给他一个名字
colnames(ma) <- c("A","B","C","D")
rownames(ma) <- c("x","y","z")
ma

## 针对矩阵的一些函数
## 按照行取平均值，超级实用
rowMeans(ma)
## 按照行求和
rowSums(ma)
## 按照列取平均值
colMeans(ma)
## 按照列求和
colSums(ma)

# 性价比最高函数就是t(),使用频率特别高!!!!!!!!!!!
## 转置
ma
ma_t <-t(ma)
ma_t

#############
## as表示转换
is.data.frame(ma)
ma_df <- as.data.frame(ma)
is.data.frame(ma_df)
# as 有个系列！也很重要，用于转换数据
## 以因子来举例
a <- rep(18:21,3)
a
# 因子就是分类器
a <- factor(a)
a
# 调整顺序
aa <- factor(a,levels = c("21","18","20","19"),ordered = F)
aa
## 转换成数值
b <- as.numeric(a)
b

############################################
## 小坑一个，因子转数字需要先转换成字符串###
############################################
###         ################################
d <- as.numeric(as.character(a))
d

#################
###第三次休息
################################################################
## 字符串的操作
#加载练习数据
rm(list = ls())
load(file = "01_TCGA_BRCA_exprSet.Rdata")
#############
###分割，粘贴，计数，选取
# 获取这个表格行名的第1个，应该是"TCGA-AC-A3OD-01B-06R-A22O-07"
rownames(exprSet)[1]

### 字符串切割
# strsplit函数，切割，此时切割的比较特殊，表示切割成所有字符
dd1 <- rownames(exprSet)[1]
strsplit(dd1,split = "")
# 查看分割后的类型？
dd2 <- strsplit(dd1,split = "")
class(dd2)
# 把list破坏掉
unlist(dd2)
# 现在再看这个类型呢
class(unlist(dd2))
## 差别在哪？
dd2[1]
dd2[[1]]
unlist(dd2)[1]

### 字符串计数
## unique() 去重
unique(unlist(dd2))
# length()用来给向量计数
length(unlist(dd2))
# 实际上有个专门的函数给字符串计数，nchar()，number of characters
dd1
nchar(dd1)

### 字符串截取
# 我想把这个基因的第14,15个字符取出来
unlist(dd2)
unlist(dd2)[14:15]

# 这两个字符能不合在一起？可以的，用paste函数
paste(c("A","B"),collapse = "_")
paste(c("A","B"),collapse = "")

paste(unlist(dd2)[14:15],collapse = "")

# 而paste0直接把东西粘在一起
paste0("A","B")

## 实际上，有一个专门的函数就是用来截取字符串substring和substr
dd1
substring(dd1,14,15)
substr(dd1,14,15)
## 区别
substring(dd1,14)
substr(dd1,14)

## 字符串替换 gsub，gsub("A","B",C)，把C中的A换成B
myword <- "I love you"
gsub("I","Dady",myword)
## 可以批量
mywords <- c("I love you","I love my mom","I love my girlfriend")
gsub("I","Dady",mywords)
test <- gsub("I","Dady",mywords)
gsub("love","loves",test)
## 至此，我们讲完了所有字符串的操作
## 观点，基本上高级的功能都是低级功能的累加。
## 我们要掌握这些最基本的函数，以1当百
## 更高级别的字符串操作可以参考这个正则表达式
## https://mp.weixin.qq.com/s/ZHY5bM1NUHUSJrqPuKJ-uw
#############################################################################
## 列表，是高手常用的技能，
## 只要记住一点，获取子集的时候，是两个符号[[]]
# The vector pioneers has already been created for you
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")

# strsplit会返回列表
bb <- strsplit(pioneers, split = ":")

class(bb)
bb[1]
class(bb[1])

# 列表的获取[[]]
bb[[1]]
class(bb[[1]])

#################################################################################
## 循环，一定要掌握的技能
## 
primes <- c(2, 3, 5, 7, 11, 13)
# 第一种方案，按照内容循环
for (p in primes) {
  print(p)
}
# 第二种方案，按照下标循环
## 推荐这个，这个非常常用
for (i in 1:length(primes)) {
  print(primes[i])
}

# 判断，让批量更加智能
# if
gg <- c("what","is","truth")

if("Truth" %in% gg) {
  print("Truth is found")
} else {
  print("Truth is not found")
}

### 实战！！！
## TCGA_id判断是肿瘤还是正常
metadata <- data.frame(rownames(exprSet)) #转换成数据框
nrow(metadata)
for (i in 1:nrow(metadata)) {
  num <- as.numeric(substring(metadata[i,1],14,15)) #substring的用法，这是元素获取
  if (num %in% seq(1,9)) {
    metadata[i,2] <- "Tumor"
    } #如果是肿瘤，就给第2列加上Tumor
  if (num %in% seq(10,29)) {
    metadata[i,2] <- "Normal"
    } #如果是正常组织，就给第2列加上Normal
}
names(metadata) <- c("TCGA_id","sample")

################################################################################
## 上面的事情也可以用ifelse完成，这是if else 循环的简写
## 第一，先判断
index <- as.numeric(substring(rownames(exprSet),14,15)) %in% c(1:9)
## 第二，再用ifelse， 如果在1到9就是tumor，如果不在就是Normal
group <- ifelse(index,"Tumor","Normal")
## 第三，创建新的数据框
metadata1 <- data.frame(TCGA_id=rownames(exprSet),
                        sample=group)
## 殊途同归！！

### 第四次休息
########################################################################
########################################################################
#加载练习数据
rm(list = ls())
load(file = "01_TCGA_BRCA_exprSet.Rdata")
## R语言里面最贵的函数是table,大概是100万
table(exprSet$sample)
table(exprSet$subgroup)

## 给出比率
prop.table(table(exprSet$subgroup))

## 插播，ifelse 场合median搭配，快速二分类,很重要！！！
load(file = "rt.Rdata")
rt$risk <- ifelse(rt$riskScore > median(rt$riskScore),"high","low")
table(rt$risk)
prop.table(table(rt$risk))

### #介绍apply()
## apply 处理的是矩阵或者数据框的行或者列

#apply(X, MARGIN, FUN, …) 
#其中X为一个数组；MARGIN为一个向量（表示要将函数FUN应用到X的行还是列），
#若为1表示取行，为2表示取列，为c(1,2)表示行、列都计算。
ma <- exprSet[,5:9]

apply(ma, 2, mean)
colMeans(ma)

boxplot(ma)
## 插曲，如何给颜色?

## apply实战中的作用呢？
## 批量把因子转换成数值，还记得这里的坑么？
rm(list = ls())
load(file = "expreSet.Rdata")
str(expreSet)
test <- expreSet[,2]
as.numeric(test)
as.numeric(as.character(test))
## 批量操作
dd1 <- apply(expreSet,2,as.character)
dd2 <- apply(dd1,2,as.numeric)
dd3 <- as.data.frame(dd2)
str(dd3)

## 总结
## 这个是R语言的基本技能，是学习后面知识的基石。
## 一个问号不行就两个

### 课后阅读材料
### sample 的使用
### https://mp.weixin.qq.com/s/5-Brt75Gm7ZieykzDbEjbA
### t(),table(),unique()
### https://mp.weixin.qq.com/s/iwmb8WhvEzXBiK--xsGusA