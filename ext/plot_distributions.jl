function plot_distributions(
    model::AbstractSDT;
    far_color = RGB(99/255, 144/255, 166/255),
    hr_color = RGB(67 / 255, 97 / 255, 112 / 255),
    config...
)
    (; d, σₛ) = model
    # d = (μₛ - μₙ) / √((1 - σₛ^2)/ 2)
    μₛ = d * sqrt((1 + σₛ^2) / 2)
    signal_dist = Normal(μₛ, σₛ)
    noise_dist = Normal(0, 1)
    far = compute_far(model)
    criterion = quantile(noise_dist, 1 - far)
    xmin = quantile(noise_dist, 0.001)
    xmax = quantile(signal_dist, 0.999)
    n_points = 500
    x = range(xmin, xmax, length = n_points)
    y_noise = pdf.(noise_dist, x)
    y_signal = pdf.(signal_dist, x)
    ymax = maximum([y_noise..., y_signal...]) * 1.3
    default_config = (leg = false, grid = false, ylims = (0, ymax))
    idx = x .≥ criterion
    plot(x, y_noise; default_config..., config...)
    plot!(
        x[idx],
        y_noise[idx],
        linecolor = :black,
        alpha = 0.50,
        fillrange = zero(idx),
        fc = far_color
    )

    plot!(x, y_signal; default_config..., config...)
    plot!(x[idx], y_signal[idx], alpha = 0.5, fillrange = zero(idx), fc = hr_color)

    plot!(x, y_noise, linecolor = :black)
    plot!(x, y_signal, linecolor = :black)

    return vline!([criterion], color = :black, linewidth = 1.5)
end
