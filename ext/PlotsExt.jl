module PlotsExt
using Distributions
using Plots
using SignalDetectionModels
import SignalDetectionModels: plot_distributions
import SignalDetectionModels: plot_iso_bias
import SignalDetectionModels: plot_iso_sensitivity
import SignalDetectionModels: plot_ROC

include("plot_distributions.jl")
end
