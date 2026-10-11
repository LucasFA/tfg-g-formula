## ---- regresion-rct-vs-observacional ----
# E[Y | A, X] = 1 + A + X + A * X: el efecto condicional es 1 si X = 0
# y 2 si X = 1, luego ATE = 1 + E[X] = 1.5
func_y <- function(A, X) {
  1 + A + X + A * X
}
N <- 100000
p_x <- 0.5
X <- rbinom(N, 1, p_x)
A <- rbinom(N, 1, 0.5)
Y <- rnorm(N, mean = func_y(A, X))
dat_rct <- data.frame(X, A, Y)

# Propensidad P(A = 1 | X) en el caso observacional
propens <- function(X) {
  0.5 + 0.4 * X
}
X <- rbinom(N, 1, p_x)
A <- rbinom(N, 1, propens(X))
Y <- rnorm(N, mean = func_y(A, X))
dat_obs <- data.frame(X, A, Y)

mod_rct <- lm(Y ~ A + X, data = dat_rct)
coef(mod_rct)
mod_obs <- lm(Y ~ A + X, data = dat_obs)
coef(mod_obs)

# Media ponderada de los efectos condicionales en el caso observacional,
# con pesos Var[A | X = x] * P(X = x)
x <- c(0, 1)
e_x <- propens(x)
var_a <- e_x * (1 - e_x)
prob_x <- c(1 - p_x, p_x)
w <- var_a * prob_x
sum(w * c(1, 2)) / sum(w)
