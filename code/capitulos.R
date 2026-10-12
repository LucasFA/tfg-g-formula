## ---- script-setup ----
set.seed(2026)

## ---- est-ate ----
est_ate <- mean(data$y[data$A == 1]) - mean(data$y[data$A == 0])

## ---- naive-lm ----
naive <- lm(Y ~ A + X, data = data)

## ----  ejemplo-confusor-g-formula ----
N <- 1000000
C <- rbinom(N, 1, 0.5)
X <- rbinom(N, 1, pmax(0.5 * C, 0.2))
Y <- rnorm(N, mean = C)
dat <- data.frame(C, X, Y)
# Si uno asumiera que no existe la variable confusora C
# y en cambio asumiera que X tiene un posible efecto causal en Y,
# calcularíamos el ATE como
mu_1 <- mean(dat$Y[dat$X == 1])
mu_0 <- mean(dat$Y[dat$X == 0])
ATE_incorrecto <- mu_1 - mu_0
mu_1
mu_0
ATE_incorrecto

# Considerando el grafo causal completo y estratificando en C,
# X <- C -> Y <- X,
mu_11 <- mean(dat$Y[dat$X == 1 & dat$C == 1])
mu_01 <- mean(dat$Y[dat$X == 0 & dat$C == 1])
ATE_C_1 <- mu_11 - mu_01
ATE_C_1

mu_10 <- mean(dat$Y[dat$X == 1 & dat$C == 0])
mu_00 <- mean(dat$Y[dat$X == 0 & dat$C == 0])
ATE_C_0 <- mu_10 - mu_00
ATE_C_0


## ----  ejemplo-modificacion-efecto ----
N <- 1000000
M <- rbinom(N, 1, 0.5)
A <- rbinom(N, 1, 0.5)
Y <- rnorm(N, mean = M * (1 + A))
dat <- data.frame(M, A, Y)

# Sin estratificar:
mu_1 <- mean(dat$Y[dat$A == 1])
mu_0 <- mean(dat$Y[dat$A == 0])
ATE_agregado <- mu_1 - mu_0
ATE_agregado

# Estratificando en M:
mu_11 <- mean(dat$Y[dat$A == 1 & dat$M == 1])
mu_01 <- mean(dat$Y[dat$A == 0 & dat$M == 1])
ATE_M_1 <- mu_11 - mu_01
ATE_M_1

mu_10 <- mean(dat$Y[dat$A == 1 & dat$M == 0])
mu_00 <- mean(dat$Y[dat$A == 0 & dat$M == 0])
ATE_M_0 <- mu_10 - mu_00
ATE_M_0

## ----  ejemplo-g-formula-parametrica ----
# X confunde (X -> A, X -> Y) y modifica el efecto de A.
# E[Y | A, X] = 1 + A + X + A * X, luego ATE = 1 + E[X] = 2
N <- 1000
X <- rnorm(N, mean = 1)
A <- rbinom(N, 1, plogis(2 * X))
Y <- rnorm(N, mean = 1 + A + X + A * X)
dat <- data.frame(X, A, Y)

g_formula <- function(dat) {
  modelo <- lm(Y ~ A + X + A * X, data = dat)
  mu_1 <- predict(modelo, newdata = transform(dat, A = 1))
  mu_0 <- predict(modelo, newdata = transform(dat, A = 0))

  mean(mu_1 - mu_0)
}
ATE_g_formula <- g_formula(dat)
ATE_g_formula

# El coeficiente de A no estima el ATE sin interacción:
coef(lm(Y ~ A + X, data = dat))
# Añadiendo las covariantes lo que obtenemos es el OR condicional a X,
# aqui sin centrar es para X = 0:
coef(lm(Y ~ A + X + A * X, data = dat))

# Intervalo de confianza por bootstrap (percentiles)
B <- 1000
ATE_boot <- replicate(B, g_formula(dat[sample(nrow(dat), replace = TRUE), ]))
quantile(ATE_boot, c(0.025, 0.975))

## ---- generar-datos ----
N <- 200
X <- rbinom(N, 1, 0.3)
A <- rbinom(N, 1, 0.5 + 0.2 * (X > 0.5))
Y <- rbinom(N, 1, plogis(-2 + 0.5 * A)) # + 0.3 * X
dat <- data.frame(X, A, Y)
