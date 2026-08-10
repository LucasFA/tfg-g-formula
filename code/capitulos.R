## ---- script-setup ----
set.seed(2026)

## ---- est-ate ----
est_ate <- mean(data$y[data$A == 1]) - mean(data$y[data$A == 0])

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

## ----  ejemplo-confusor-g-formula ----
library("simcausal")
D <- DAG.empty() +
  node("C", distr = "rbern", p = 0.5) +
  node("X", distr = "rbern", p = max(0.5 * C, 0.2)) +
  node("Y", distr = "rnorm", mean = C)
D <- set.DAG(D)
dat <- sim(D, n = 1000000)
# Si uno asumiera que no existe la variable confusora C
# y en cambio asumiera que X tiene un posible efecto causal en Y,
# calcularíamos el ATE como
mu_1 <- mean(dat$Y[dat$X == 1])
mu_0 <- mean(dat$Y[dat$X == 0])
ATE_incorrecto <- mu_1 - mu_0
mu_1
mu_0
ATE_incorrecto

# En cambio, considerando el grafo causal completo y estratificando en C,
# X <- C -> Y <- X,
mu_11 <- mean(dat$Y[dat$X == 1 & dat$C == 1])
mu_01 <- mean(dat$Y[dat$X == 0 & dat$C == 1])
ATE_C_1 <- mu_11 - mu_01
ATE_C_1

mu_10 <- mean(dat$Y[dat$X == 1 & dat$C == 0])
mu_00 <- mean(dat$Y[dat$X == 0 & dat$C == 0])
ATE_C_0 <- mu_10 - mu_00
ATE_C_0
