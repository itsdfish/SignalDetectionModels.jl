"""
    plot_distributions(
        model::AbstractSDT;
        far_color = RGB(99/255, 144/255, 166/255),
        hr_color = RGB(67 / 255, 97 / 255, 112 / 255),
        config...
    )

Generates a plot of a noise and signal distribution with the criterion represented as a vertical line. 

# Arguments 

- `model::AbstractSDT`: an abstract signal detection theory model 

# Keywords 

- `far_color = RGB(99/255, 144/255, 166/255)`: the color of the false alarm rate of the noise distribution 
- `hr_color = RGB(67 / 255, 97 / 255, 112 / 255)`: the color of hit rate area of the signal distribution
- `config...`: optional keyword arguments to configure plot

# Example 

```julia 
using SignalDetectionModels
model = SDT(; d = 2.0, c = .50, σₛ = 1.5, nₙ = 100)
plot_distributions(model)
```
"""
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

"""
    plot_ROC(model::AbstractSDT; config...)

Generates a plot of the receiver operating characteristic (ROC).  

# Arguments 

- `model::AbstractSDT`: an abstract signal detection theory model 

# Keywords 

- `config...`: optional keyword arguments to configure plot

# Example 

```julia 
using SignalDetectionModels
model = SDT(; d = 2.0, c = .50, σₛ = 1.5, nₙ = 100)
plot_ROC(model)
```
"""
function plot_ROC(model::AbstractSDT; config...)
    (; d, σₛ, nₙ) = model
    model_type = typeof(model).name.wrapper
    cs = range(-3, 3, length = 200)
    fars = map(c -> compute_far(model_type(; d, c, σₛ, nₙ)), cs)
    hrs = map(c -> compute_hr(model_type(; d, c, σₛ, nₙ)), cs)
    return plot(
        fars,
        hrs,
        grid = false,
        leg = false,
        lims = (0, 1),
        xlabel = "False Alarm Rate",
        ylabel = "Hit Rate",
        color = :black,
        framestyle = :box;
        config...
    )
end

"""
    plot_zROC(model::AbstractSDT; config...)

Generates a plot of the z-receiver operating characteristic (zROC).  

# Arguments 

- `model::AbstractSDT`: an abstract signal detection theory model 

# Keywords 

- `config...`: optional keyword arguments to configure plot

# Example 

```julia 
using SignalDetectionModels
model = SDT(; d = 2.0, c = .50, σₛ = 1.5, nₙ = 100)
plot_zROC(model)
```
"""
function plot_zROC(model::AbstractSDT; config...)
    (; d, σₛ, nₙ) = model
    model_type = typeof(model).name.wrapper
    cs = range(-3, 3, length = 200)
    fars = map(c -> compute_far(model_type(; d, c, σₛ, nₙ)), cs)
    zfars = quantile.(Normal(0, 1), fars)
    hrs = map(c -> compute_hr(model_type(; d, c, σₛ, nₙ)), cs)
    zhrs = quantile.(Normal(0, 1), hrs)
    return plot(
        zfars,
        zhrs,
        grid = false,
        leg = false,
        lims = (-3, 3),
        xlabel = "z(False Alarm Rate)",
        ylabel = "z(Hit Rate)",
        color = :black,
        framestyle = :box;
        config...
    )
end
