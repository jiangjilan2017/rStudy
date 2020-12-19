################################################
################################################
### 作者：果子
### 更新时间：2020-11-20
### 微信公众号:果子学生信
### 私人微信：guotosky
### 个人博客: https://codingsoeasy.com/
### 个人邮箱：hello_guozi@126.com

# Groups that we want to compare
my_comparisons <- list(
  c("setosa", "versicolor"), c("versicolor", "virginica"),
  c("setosa", "virginica")
)
# Create the box plot. Change colors by groups: Species
# Add jitter points and change the shape by groups
library(ggpubr)
ggboxplot(
  iris, x = "Species", y = "Sepal.Length",
  color = "Species", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
  add = "jitter"
)+
  stat_compare_means(comparisons = my_comparisons, method = "t.test")

###########################
load(file = "TCGA_steal_data.Rdata")
TCGA_steal_data$subgroup <- factor(TCGA_steal_data$subgroup,
                                   levels = c("LumA","LumB","Her2","Basal", "Normal"),ordered = F)

library(ggpubr)
my_comparisons <- list(
  c("Basal", "Normal"), 
  c("Her2", "Normal"), 
  c("LumA", "Normal"), 
  c("LumB", "Normal")
)
ggboxplot(
  TCGA_steal_data, x = "subgroup", y = "ESR1",
  color = "subgroup", palette = "jco",
  add = "jitter"
)+
  stat_compare_means(comparisons = my_comparisons, method = "t.test")
