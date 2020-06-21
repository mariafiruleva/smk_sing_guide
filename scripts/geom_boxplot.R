library(ggplot2)
library(dplyr)
mtcars <- mtcars %>% mutate(am = as.factor(am))
p1 <- ggplot(mtcars, aes(x = mpg, y = hp, group = am, col = am))+
	geom_boxplot()+
	theme_bw()+
	theme(aspect.ratio = 1)
ggsave("boxplot.pdf", plot = p1)