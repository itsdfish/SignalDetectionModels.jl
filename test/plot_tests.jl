@safetestset "plot_distributions" begin
    using Plots
    using SignalDetectionModels
    using Test
    model = SDT(; d = 2.0, c = 1, σₛ = 1.5, nₙ = 100)
    plot_distributions(model)
    @test true
end
