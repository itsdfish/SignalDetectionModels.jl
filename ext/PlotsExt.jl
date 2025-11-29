module PlotsExt
using Distributions
using Plots
using SignalDetectionModels
import SignalDetectionModels: plot_distributions
import SignalDetectionModels: plot_iso_bias
import SignalDetectionModels: plot_iso_sensitivity
import SignalDetectionModels: plot_ROC
import SignalDetectionModels: plot_zROC

include("plot_functions.jl")
end
