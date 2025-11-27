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
