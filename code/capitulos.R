## ---- script-setup ----
set.seed(2026)

## ---- est-ate ----
est_ate <- mean(data$y[data$A == 1]) - mean(data$y[data$A == 0])

## ---- idk ----
x <- rnorm(100)
mean(x)

## ---- naive-lm ----
naive <- lm(Y ~ A + X, data = data)

## ---- rnorm-lst ----
mean(x)
x <- rnorm(100)
mean(x)

## ---- rnorm-mint ----
mean(x)
x <- rnorm(1000)
mean(x)
sd(x)
