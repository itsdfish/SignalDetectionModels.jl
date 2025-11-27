module SignalDetectionModels

using ArgCheck
using Distributions
import Distributions: logpdf
import Distributions: loglikelihood
import Distributions: rand

export compute_d
export compute_far
export compute_hr
export SDT

include("models.jl")
end
