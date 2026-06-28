# library(daggitty)
## --- generar-datos
library("simcausal")
# library("simDAG")
# D <- DAG.empty() +
D <- empty_dag() +
  node("X", distr = "rbern", prob = 0.3) +
  # node("X", type = "rbernouilli", p = 0.3) +
  node("A", distr = "rbern", prob = 0.5 + 0.2 * (X > 0.5)) +
  # node("A", distr = "rbernouilli", p = 0.5 + 0.2 * (X > 0.5) ) +
  node("Y", distr = "rbern", prob = plogis(-2 + 0.5 * A)) # + 0.3 * X
D <- set.DAG(D)
dat <- sim(D, n = 200)

generate_data_RCT <- function(n_samples = 1000, f_distr_x, f_distr_a, sem) {
  x <- f_distr_x(n_samples)
  a <- f_distr_a(n_samples)
  y <- sem(x, a)
}
f <- function(n) {
  rbinom(n = n, prob = 0.5, size = 1)
}
f_distr_x <- f
f_distr_a <- f
sem <- function(x, a) {
  threshold <- 0.3
  u_size <- 0.8
  u_value <- runif(1) - 0.5
  xored <- xor(x, a) - 0.5
  xored + u_size * u_value >= threshold
}
## ---- RCT ----
