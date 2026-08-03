## ---  ejemplo-confusor ---
library("simcausal")
D <- DAG.empty() +
  node("C", distr = "rbern", p = 0.5) +
  node("X", distr = "rbern", p = max(C / 2, 0.2)) +
  node("Y", distr = "rnorm", mean = C)
D <- set.DAG(D)
dat <- sim(D, n = 1000)
# Si uno asumiera que no existe la variable confusora C
# y en cambio asumiera que X tiene un efecto causal en Y,
# calcularíamos el ATE como
mu_1 <- mean(dat$Y[dat$X == 1])
mu_0 <- mean(dat$Y[dat$X == 0])
ATE_incorrecto <- mu_1 - mu_0

# En cambio, considerando el grafo causal completo
# X <- C -> Y <- X,
# obtenemos
# mu_1_corr <- mean(dat$Y[dat$X == 1 && dat$Y])
