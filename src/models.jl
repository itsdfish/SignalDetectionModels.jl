abstract type AbstractSDT <: DiscreteMultivariateDistribution end

"""
    SDT{T <: Real} <: AbstractSDT

# Fields 

- `d::T`: discriminability
- `c::T`: criterion relative optimal value
- `σₛ::T`: standard deviation of noise distribution 
- `nₙ::Int`: number of noise trials
- `nₛ::Int`: number of signal trials

# Constructors 

    SDT(; d, c, σₛ = 1.0, nₙ, nₛ = nₙ)

    SDT(d, c, σₛ, nₙ, nₛ)

# References 

Stanislaw, H., & Todorov, N. (1999). Calculation of signal detection theory measures. 
Behavior research methods, instruments, & computers, 31(1), 137-149.
"""
struct SDT{T <: Real} <: AbstractSDT
    d::T
    c::T
    σₛ::T
    nₙ::Int
    nₛ::Int
    function SDT(d::T, c::T, σₛ::T, nₙ::Int, nₛ::Int) where {T <: Real}
        @argcheck σₛ ≥ 0
        @argcheck nₛ > 0
        @argcheck nₙ > 0
        return new{T}(d, c, σₛ, nₙ, nₛ)
    end
end

function SDT(d, c, σₛ, nₙ, nₛ)
    d, c, σₛ = promote(d, c, σₛ)
    return SDT(d, c, σₛ, nₙ, nₛ)
end

function SDT(; d, c, σₛ, nₙ, nₛ = nₙ)
    return SDT(d, c, σₛ, nₙ, nₛ)
end

function compute_far(model::AbstractSDT)
    (; d, c, σₛ) = model
    v1 = √((1 + σₛ^2) / 2)
    v2 = -d / (1 + σₛ) - c
    return cdf(Normal(0, 1), v1 * v2)
end

function compute_hr(model::AbstractSDT)
    (; d, c, σₛ) = model
    v1 = √((1 + σₛ^2) / 2)
    v2 = d / (1 + σₛ) - c / σₛ
    return cdf(Normal(0, 1), v1 * v2)
end

function compute_d(model::AbstractSDT)
    (; σₛ) = model
    hr = compute_hr(model)
    far = compute_far(model)
    return compute_d(hr::Real, far::Real)
end

function compute_d(hr::Real, far::Real)
    return invlogcdf(Normal(0, 1), log(hr)) - invlogcdf(Normal(0, 1), log(far))
end
function compute_c(model::AbstractSDT)
    hr = compute_hr(model)
    far = compute_far(model)
    return -(invlogcdf(Normal(0, 1), log(hr)) + invlogcdf(Normal(0, 1), log(far))) / 2
end

function compute_b(model::AbstractSDT)
    (; d, c) = model
    return c + d / 2
end

function rand(model::AbstractSDT)
    (; nₛ, nₙ) = model
    hr = compute_hr(model)
    far = compute_far(model)
    return [rand(Binomial(nₛ, hr)), rand(Binomial(nₙ, far))]
end

function logpdf(model::AbstractSDT, data::Vector{Int})
    (; n) = model
    hr = compute_hr(model)
    far = compute_far(model)
    return logpdf(Binomial(nₛ, hr), data[1]) + logpdf(Binomial(nₙ, far), data[2])
end

loglikelihood(model::AbstractSDT, data::Vector{Int}) = sum(logpdf(model, data))
