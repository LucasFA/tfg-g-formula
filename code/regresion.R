## ---- regresion-rct-vs-observacional ----
func_y <- function(A, X) {
  # El efecto condicional (diferencia E[Y | A = a, X], a = 1, 0) es 1 para X = 0
  # y 2 para X = 1. El ATE es por tanto 1.7 (p_x = 0.7)
  1 + A + X + A * X
}
N <- 100000
p_x <- 0.7
X <- rbinom(N, 1, p_x)
A <- rbinom(N, 1, 0.5)
Y <- rnorm(N, mean = func_y(A, X))
dat_rct <- data.frame(X, A, Y)

# Tomamos esta propensidad P(A = 1 | X)
propens_real <- function(X) {
  0.5 + 0.4 * X
}
# Propensidad estimada con los datos observacionales
propens_estim <- function(X) {
  modelo <- glm(A ~ X, family = binomial, data = dat_obs)
  predict(modelo, newdata = data.frame(X), type = "response")
}
X <- rbinom(N, 1, p_x)
A <- rbinom(N, 1, propens_real(X))
Y <- rnorm(N, mean = func_y(A, X))
dat_obs <- data.frame(X, A, Y)

mod_rct <- lm(Y ~ A + X, data = dat_rct)
coef(mod_rct)
mod_obs <- lm(Y ~ A + X, data = dat_obs)
coef(mod_obs)

## ---- regresion-ipw ----
# Diferencia de medias de Y entre tratados y controles, ponderada por w
dif_medias <- function(w) {
  trat <- dat_obs$A == 1
  media_pond <- function(trat) {
    sum(dat_obs$Y[trat] * w[trat]) / sum(w[trat])
  }
  media_pond(trat) - media_pond(!trat)
}
# IPW: ponderando por 1 / P(A = a | X) se recupera el ATE
e <- propens_estim(dat_obs$X)
w_ipw <- ifelse(dat_obs$A == 1, 1 / e, 1 / (1 - e))
dif_medias(w_ipw)

# Los coeficientes de la regresión se recuperan "desponderando":
w_reg <- w_ipw * e * (1 - e)
dif_medias(w_reg)
