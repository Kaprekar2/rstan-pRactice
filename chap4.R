pacman::p_load(rstan, tidyverse, ggplot2)


salary <- read.table("./data-salary.txt", header = TRUE, sep = ",")

ggplot(data = salary, aes(x = X, y = Y))+
  geom_point()+
  theme_bw()

res_lm <- lm(Y ~ X, data = salary)
summary(res_lm)

year_new <- data.frame(X=23:60)
#信頼区間
conf_95 <- predict(res_lm, year_new, interval = "confidence", level = 0.95)
#予測区間
pred_95 <- predict(res_lm, year_new, interval = "prediction", level = 0.95)

dat <- list(N = nrow(salary), X = salary$X, Y = salary$Y)
fit <- stan(file = "./model45.stan", data = dat, seed = 1234)
