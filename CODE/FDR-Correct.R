# 分析前准备
# 使用"ls()"函数获取当前环境中的所有变量、函数和对象的名称,然后传递给"1ist"参数
# 将"1ist"参数传递给"rm()" 函数,表示删除这些变量、函数和对象

# 因此, "rm(list=ls())"表示删除当前环境中的所有变量、函数和对象,相当于清空当前环境
rm(list=ls())
# 判断是否已经安装了"pacman"包,如果没有就安装它

if(!require("pacman"))
  install.packages("pacman", update = F, ask = F)

# 设置Bioconductor镜像地址为中国科技大学的镜像

Options(BioC_mirror = "https://mirror.ustc.edu.cn/bioc/")


# 加载"pacman"包，用于方便加载其他的包

# 使用"p_load"函数加载所需的R包

p_load(stringr, data.table, tidyverse, dplyr)

# 读取名为"all0R14.csv"的CSV文件,并将其存储在名为biof的变量中

Biof <- read.csv("allOR14.csv")

# 添加一个名为Number的新列,列中的值从1开始递增,与数据框的行数相同
Biof$Number <- seq_len(nrow(biof))

# 从biof数据框中筛选出method列值为"Inverse variance meighted"的行，储存在biof
biof_IVW <- subset(biof, method == "Inverse variance meighted")

# 从biof_IVW数据框中筛选出Number和pval两列,存储在biof_p变量中
biof_p <- subset(biof_IVW, select = c("Number", "pval"))
                 
# 按照pval列的值对biof_p数据框迹行升序排序,重新赋值给biof_p变量
biof_p <- biof_p[order(biof_p$pval), ]

# 在biof_p数据框中添加一个名为adjustP的新列,并将其初始化为NA(缺失值)
biof_p$adjustP <- NA

# 根据公式adjustP = pval*(总行数/当前行数),计算adjustP列的值
# 这里使用seq_len(nrow(biof_p))来生成从1到biof_p数据框的行数的向量
biof_p$adjustP <- biof_p$pval * (nrow(biof_p) / seq_len(nrow(biof_p)))

# 使用pmin函数将adjustP列中超过1的值设置为1

biof_p$adjustP <- pmin(biof_p$adjustP, 1)

# 将biof_p数据框中最后一行的adjustP列值设置为该行的pval列值
biof_p[nrow(biof_p), "adjustP"] <- biof_p[nrow(biof_p), "pval"]


# 将biof数据框与biof_p数据框按照Number列进行合并,合并的结果存储在biof2变量中
# 这里使用merge函数,并通过by参数指定按照Number列进行合并,all = T表示保留所有行，包括没有匹配的行
biof2 <- merge(x = biof, y = biof_p[, c("Number", "adjust")], by = "Number", all = TRUE)

# 将biof2数据框按照adjustP列进行降序排序,重新赋值给biof2变量
fwrite(biof2, "allOR_adjP.csv")

