module SignalDetectionModels

using ArgCheck
using Distributions
import Distributions: logpdf
import Distributions: loglikelihood
import Distributions: rand

export AbstractSDT
export SDT

export compute_d
export compute_c
export compute_far
export compute_hr

export plot_distributions
export plot_iso_sensitivity
export plot_iso_bias
export plot_ROC

include("models.jl")
include("ext_functions.jl")
end
