## ---- regresion-rct-vs-observacional ----
# E[Y | A, X] = 1 + A + X + A * X: el efecto condicional es 1 si X = 0
# y 2 si X = 1, luego ATE = 1 + E[X] = 1.5
func_Y <- function(A, X) {
	1 + A + X + A * X
}
N <- 100000
X <- rbinom(N, 1, 0.5)
A <- rbinom(N, 1, 0.5)
Y <- rnorm(N, mean = func_Y(A, X))
dat_rct <- data.frame(X, A, Y)

X <- rbinom(N, 1, 0.5)
A <- rbinom(N, 1, 0.5 + 0.4 * X)
Y <- rnorm(N, mean = func_Y(A, X))
dat_obs <- data.frame(X, A, Y)

# Coeficiente de A en el modelo sin interacciones
coef(lm(Y ~ A + X, data = dat_rct))["A"]
coef(lm(Y ~ A + X, data = dat_obs))["A"]

# Media ponderada de los efectos condicionales en el caso observacional,
# con pesos Var[A | X = x] * P(X = x)
w <- c(0.5 * 0.5, 0.9 * 0.1) * 0.5
sum(w * c(1, 2)) / sum(w)
