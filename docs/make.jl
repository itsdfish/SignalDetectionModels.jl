using Documenter
using SignalDetectionModels
using Plots

makedocs(;
    warnonly = true,
    sitename = "SignalDetectionModels",
    format = Documenter.HTML(
        assets = [
            asset(
            "https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap",
            class = :css
        )
        ],
        collapselevel = 1
    ),
    modules = [
        SignalDetectionModels,
        Base.get_extension(SignalDetectionModels, :PlotsExt)
    ],
    pages = [
        "Home" => "index.md",
        "Basic Usage" => "basic_usage.md",
        "Plotting" => "plotting.md",
        "Hierarchical Model" => "hierarchical_model.md",
        "API" => "api.md"
    ]
)

deploydocs(repo = "github.com/itsdfish/SignalDetectionModels.jl.git")
