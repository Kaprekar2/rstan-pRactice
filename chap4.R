pacman::p_load(rstan, tidyverse, ggplot2, ggmcmc)


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
save.image(file = "./output/result_model45.RData")

load("./output/result_model45.RData")
write.table(data.frame(summary(fit)$summary, check.names=FALSE),
            file='output/fit-summary.csv', sep=',', quote=TRUE, col.names=NA)

ggmcmc(ggs(fit, inc_warmup = TRUE, stan_include_auxiliar = TRUE),
       file = "output/fit-traceplot.pdf", plot = "traceplot")


# plotを指定せずに描くとtrace plotだけでなくサンプルから算出された密度関数や事後平均
# の推移、自己相関などが図示される

ggmcmc(ggs(fit), file='output/fit-ggmcmc.pdf')
