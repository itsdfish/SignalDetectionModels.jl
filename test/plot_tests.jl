@safetestset "plot_distributions" begin
    using Plots
    using SignalDetectionModels
    using Test
    model = SDT(; d = 2.0, c = 1, σₛ = 1.5, nₙ = 100)
    plot_distributions(model)
    @test true
end

@safetestset "plot_ROC" begin
    using Plots
    using SignalDetectionModels
    using Test
    model = SDT(; d = 2.0, c = 1, σₛ = 1.5, nₙ = 100)
    plot_ROC(model)
    @test true
end

@safetestset "plot_zROC" begin
    using Plots
    using SignalDetectionModels
    using Test
    model = SDT(; d = 2.0, c = 1, σₛ = 1.5, nₙ = 100)
    plot_zROC(model)
    @test true
end

@safetestset "plot_iso_bias" begin
    using Plots
    using SignalDetectionModels
    using Test
    model = SDT(; d = 2.0, c = 1, σₛ = 1.5, nₙ = 100)
    plot_iso_bias(model)
    @test true
end

@safetestset "plot_iso_sensitivity" begin
    using Plots
    using SignalDetectionModels
    using Test
    model = SDT(; d = 2.0, c = 1, σₛ = 1.5, nₙ = 100)
    plot_iso_sensitivity(model)
    @test true
end