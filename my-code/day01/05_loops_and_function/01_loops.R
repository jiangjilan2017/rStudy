################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱: hello_guozi@126.com

## 利用循环判断癌和癌旁组织
load(file = "TCGA_ggplot.Rdata")
metadata <- data.frame(rownames(exprSet)) #转换成数据框
for (i in 1:length(metadata[,1])) {
  #substring的用法，这是元素获取
  num <- as.numeric(substring(metadata[i,1],14,15)) 
  #如果是肿瘤，就给第2列加上Tumor
  if (num %in% seq(1,9)) {metadata[i,2] = "Tumor"} 
  #如果是正常组织，就给第2列加上Normal
  if (num %in% seq(10,29)) {metadata[i,2] = "Normal"} 
}
names(metadata) <- c("TCGA_id","sample")


## 如果一件事情需要重复三次以上，要使用循环，这是程序员的尊严
## 用好for循环的秘诀只有一个，清晰地定义一次操作的具体流程
## 原始文件在rawdata
## 首先把所有数据读入在一个文件夹中

### 创建新的文件夹
dir.create("data_in_one")

##################################################################
### 写for循环的技巧, 搞一个特例

dirname = dir("rawdata/")[1]
## 1.要查看的单个文件夹的绝对路径
mydir = paste0(getwd(),"/rawdata/",dirname)
## 2.找到对应文件夹中的文件并提取名称，pattern表示模式，可以是正则表达式
file = list.files(mydir,pattern = "*.counts*")
## 3.当前文件的绝对路径是
myfile = paste0(mydir,"/",file)
## 4.复制这个文件到目的文件夹
file.copy(from=myfile,to="data_in_one")  

### for 循环批量运行
for (dirname in dir("rawdata/")){  
  ## 1.要查看的单个文件夹的绝对路径
  mydir = paste0(getwd(),"/rawdata/",dirname)
  ## 2.找到对应文件夹中的文件并提取名称，pattern表示模式，可以是正则表达式
  file = list.files(mydir,pattern = "*.counts*")
  ## 3.当前文件的绝对路径是
  myfile = paste0(mydir,"/",file)
  ## 4.复制这个文件到目的文件夹
  file.copy(from=myfile,to="data_in_one")  
}




