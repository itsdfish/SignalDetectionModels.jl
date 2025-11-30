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
Behavior Research Methods, Instruments, & Computers, 31(1), 137-149.
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

function SDT(; d, c, σₛ = 1.0, nₙ, nₛ = nₙ)
    return SDT(d, c, σₛ, nₙ, nₛ)
end
