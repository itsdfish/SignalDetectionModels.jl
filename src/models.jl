"""
    compute_far(model::AbstractSDT)

Computes false alarm rate. 

# Arguments

- `model::AbstractSDT`: abstract signal detection theory model 
"""
function compute_far(model::AbstractSDT)
    (; d, c, σₛ) = model
    v1 = √((1 + σₛ^2) / 2)
    v2 = -d / (1 + σₛ) - c
    return cdf(Normal(0, 1), v1 * v2)
end

"""
    compute_hr(model::AbstractSDT)

Computes hit rate. 

# Arguments

- `model::AbstractSDT`: abstract signal detection theory model 
"""
function compute_hr(model::AbstractSDT)
    (; d, c, σₛ) = model
    v1 = √((1 + σₛ^2) / 2)
    v2 = d / (1 + σₛ) - c / σₛ
    return cdf(Normal(0, 1), v1 * v2)
end

"""
    compute_d(model::AbstractSDT)

Computes discriminability `d`. 

# Arguments

- `model::AbstractSDT`: abstract signal detection theory model 
"""
function compute_d(model::AbstractSDT)
    (; σₛ) = model
    hr = compute_hr(model)
    far = compute_far(model)
    return compute_d(hr, far, σₛ)
end

"""
    compute_d(hr::Real, far::Real, σₛ = 1.0)

Computes discriminability `d`. 

# Arguments

- `hr::Real`: hit rate 
- `far::Real`: false alarm rate 
- `σₛ = 1.0`: standard deviation of the signal distribution 

# Example 

```julia
using SignalDetectionModels
hr = .90
far = .05
compute_d(hr, far)
```
"""
function compute_d(hr::Real, far::Real, σₛ = 1.0)
    v = 1/√((1 + σₛ^2) / 2)
    dist = Normal(0, 1)
    return v * (σₛ * invlogcdf(dist, log(hr)) - invlogcdf(dist, log(far)))
end

"""
    compute_c(model::AbstractSDT)

Computes criterion `c`. 

# Arguments

- `model::AbstractSDT`: abstract signal detection theory model

# Example 

```julia
using SignalDetectionModels
model = SDT(; d = 2.0, c = 0.0, nₙ = 100)
data = compute_c(model)
```
"""
function compute_c(model::AbstractSDT)
    (; σₛ) = model
    hr = compute_hr(model)
    far = compute_far(model)
    return compute_c(hr, far, σₛ)
end

"""
    compute_c(hr::Real, far::Real, σₛ = 1.0)

Computes criterion `c`. 

# Arguments

- `hr::Real`: hit rate 
- `far::Real`: false alarm rate 
- `σₛ = 1.0`: standard deviation of the signal distribution 

# Example 

```julia
using SignalDetectionModels
hr = .90
far = .05
compute_c(hr, far)
```
"""
function compute_c(hr::Real, far::Real, σₛ = 1.0)
    v1 = 1 / √((1 + σₛ^2) / 2)
    v2 = -σₛ / (1 + σₛ)
    dist = Normal(0, 1)
    return v1 * v2 * (invlogcdf(dist, log(hr)) + invlogcdf(dist, log(far)))
end

"""
    compute_a(model::AbstractSDT)

Computes area under the curve `a`. 

# Arguments

- `model::AbstractSDT`: abstract signal detection theory model 

# Example 

```julia
using SignalDetectionModels
model = SDT(; d = 2.0, c = 0.0, nₙ = 100)
data = compute_a(model)
```
"""
function compute_a(model)
    hr = compute_hr(model)
    far = compute_far(model)
    return compute_a(hr, far)
end

"""
    compute_a(hr::Real, far::Real)

Computes area under the curve `a`. 

# Arguments

- `hr::Real`: hit rate 
- `far::Real`: false alarm rate 

# Example 

```julia
using SignalDetectionModels
hr = .90
far = .05
compute_a(hr, far)
```
"""
function compute_a(hr::Real, far::Real)
    x1 = (hr - far)^2 + abs(hr - far)
    x2 = 4 * max(hr, far) - 4 * hr * far
    return 0.5 + sign(hr - far) * (x1 / x2)
end

"""
    rand(model::AbstractSDT)

Generates simulated data from model. 

# Arguments

- `model::AbstractSDT`: abstract signal detection theory model 

# Returns 

- `data::Vector{Int}`: data vector containing the hit count and false alarm count

# Example 

```julia
using SignalDetectionModels
model = SDT(; d = 2.0, c = 0.0, nₙ = 100)
data = rand(model)
```
"""
function rand(model::AbstractSDT)
    (; nₛ, nₙ) = model
    hr = compute_hr(model)
    far = compute_far(model)
    return [rand(Binomial(nₛ, hr)), rand(Binomial(nₙ, far))]
end

"""
    logpdf(model::AbstractSDT, data::Vector{Int})

Compute log likelihood of data based on signal detection theory model.   

# Arguments

- `model::AbstractSDT`: abstract signal detection theory model 
- `data::Vector{Int}`: data vector containing the hit count and false alarm count

# Example 

```julia
using SignalDetectionModels
model = SDT(; d = 2.0, c = 0.0, nₙ = 100)
data = rand(model)
LL = logpdf(model, data)
```
"""
function logpdf(model::AbstractSDT, data::Vector{Int})
    (; nₛ, nₙ) = model
    hr = compute_hr(model)
    far = compute_far(model)
    return logpdf(Binomial(nₛ, hr), data[1]) + logpdf(Binomial(nₙ, far), data[2])
end

loglikelihood(model::AbstractSDT, data::Vector{Int}) = sum(logpdf(model, data))
