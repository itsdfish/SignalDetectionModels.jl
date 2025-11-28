# https://decidables.github.io/detectable/equations.html
@safetestset "compute_hr" begin
    @safetestset "1" begin
        using SignalDetectionModels
        using Test

        model = SDT(; d = 2.0, c = 0, σₛ = 1.0, nₙ = 100)

        hr = compute_hr(model)
        @test hr ≈ 0.841 atol = 1e-3
    end

    @safetestset "2" begin
        using SignalDetectionModels
        using Test

        model = SDT(; d = 1.5, c = 1, σₛ = 1.0, nₙ = 100)

        hr = compute_hr(model)
        @test hr ≈ 0.401 atol = 1e-3
    end

    @safetestset "3" begin
        using SignalDetectionModels
        using Test

        model = SDT(; d = 2.0, c = 0, σₛ = 1.5, nₙ = 100)

        hr = compute_hr(model)
        @test hr ≈ 0.846 atol = 1e-3
    end

    @safetestset "4" begin
        using SignalDetectionModels
        using Test

        model = SDT(; d = 1.5, c = 1, σₛ = 1.5, nₙ = 100)

        hr = compute_hr(model)
        @test hr ≈ 0.466 atol = 1e-3
    end
end

@safetestset "compute_far" begin
    @safetestset "1" begin
        using SignalDetectionModels
        using Test

        model = SDT(; d = 2.0, c = 0, σₛ = 1.0, nₙ = 100)

        far = compute_far(model)
        @test far ≈ 0.159 atol = 1e-3
    end

    @safetestset "2" begin
        using SignalDetectionModels
        using Test

        model = SDT(; d = 1.5, c = 1, σₛ = 1.0, nₙ = 100)

        far = compute_far(model)
        @test far ≈ 0.04 atol = 1e-3
    end

    @safetestset "3" begin
        using SignalDetectionModels
        using Test

        model = SDT(; d = 2.0, c = 0, σₛ = 1.5, nₙ = 100)

        far = compute_far(model)
        @test far ≈ 0.154 atol = 1e-3
    end

    @safetestset "4" begin
        using SignalDetectionModels
        using Test

        model = SDT(; d = 1.5, c = 1, σₛ = 1.5, nₙ = 100)

        far = compute_far(model)
        @test far ≈ 0.02 atol = 1e-3
    end
end

@safetestset "compute_d" begin
    using Distributions
    using SignalDetectionModels
    using Test

    for _ ∈ 1:100
        d = rand(Uniform(0, 3))
        c = rand(Uniform(-2, 2))
        σₛ = rand(Uniform(1, 2))
        model = SDT(; d, c, σₛ, nₙ = 100)

        d_test = compute_d(model)
        @test d ≈ d_test
    end
end

@safetestset "compute_c" begin
    using Distributions
    using SignalDetectionModels
    using Test

    for _ ∈ 1:100
        d = rand(Uniform(0, 3))
        c = rand(Uniform(-2, 2))
        σₛ = rand(Uniform(1, 2))
        model = SDT(; d, c, σₛ, nₙ = 100)
        c_test = compute_c(model)
        @test c ≈ c_test
    end
end

@safetestset "logpdf" begin
    using Distributions
    using Random
    using SignalDetectionModels
    using Test

    Θ = (
        d = 1.5,
        c = 0.0,
        σₛ = 1.5,
        nₙ = 100_000
    )

    Random.seed!(65)
    ds = range(0.8 * Θ.d, 1.2 * Θ.d, length = 100)
    cs = range(0.8 * Θ.c, 1.2 * Θ.c, length = 100)
    σₛs = range(0.8 * Θ.σₛ, 1.2 * Θ.σₛ, length = 100)
    ℒ = loglikelihood

    model = SDT(; Θ...)
    data = rand(model)

    LLs = map(d -> ℒ(SDT(; Θ..., d), data), ds)
    _, mi = findmax(LLs)
    @test Θ.d ≈ ds[mi] rtol = 0.02

    LLs = map(c -> ℒ(SDT(; Θ..., c), data), cs)
    _, mi = findmax(LLs)
    @test Θ.c ≈ cs[mi] rtol = 0.02

    LLs = map(σₛ -> ℒ(SDT(; Θ..., σₛ), data), σₛs)
    _, mi = findmax(LLs)
    @test Θ.σₛ ≈ σₛs[mi] rtol = 0.05
end
