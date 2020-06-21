library(ggplot2)
p1 <- ggplot(mtcars, aes(x = mpg, y = hp))+
	geom_point()+
	theme_bw()+
	theme(aspect.ratio = 1)
ggsave("hist.pdf", plot = p1)