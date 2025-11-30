module SignalDetectionModels

using ArgCheck
using Distributions
import Distributions: loglikelihood
import Distributions: logpdf
import Distributions: rand

export AbstractSDT
export SDT

export compute_a
export compute_c
export compute_d
export compute_far
export compute_hr
export logpdf
export rand

export plot_distributions
export plot_iso_bias
export plot_iso_sensitivity
export plot_ROC
export plot_zROC

include("structs.jl")
include("models.jl")
include("ext_functions.jl")
end
