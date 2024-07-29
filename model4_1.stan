//comment
/*
mutiple column comment
*/

// data block
data {
  int N;
  real Y[N];
}

// inference parameter block
parameters {
  real mu;
}

//model block
model {
  for (n in 1:N) {
    Y[n] ~ normal(mu, 1);
  }
  mu ~ normal(0, 100);
}

