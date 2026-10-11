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
