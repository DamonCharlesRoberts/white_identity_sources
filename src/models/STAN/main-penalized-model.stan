data {
    int<lower=0> N; // Number of observations
    int<lower=5> K; // Number of outcomes
    int<lower=1> D; // Number of predictors
    array[N] int<lower=1, upper=K> y; // Outcome
    matrix[N, D] x; // Matrix for predictors
}

parameters {
    vector[D] beta; // Coefficients for predictors
    ordered[K-1] Intercept; // The cutpoints of the model
    real<lower=0> lambda; // Global shrinkage parameter
    vector<lower=0>[D] tau; // Local shrinkage parameters

}

model {
    // Horseshoe prior for Coefficients
    lambda ~ cauchy(0, 1);
    tau ~ cauchy(0, 1);
    beta ~ normal(0, lambda * tau);
    
    // Specify the likelihood
    y ~ ordered_logistic(x * beta, Intercept);
}

generated quantities {
    array[N] int<lower=1, upper=K> y_rep;

    for (n in 1:N) {
        vector[K-1] cutpoints;
        for (k in 1:(K-1)) {
            cutpoints[k] = Intercept[k];
        }
        y_rep[n] = ordered_logistic_rng(x[n] * beta, cutpoints);
    }
}
