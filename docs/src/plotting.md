
## Plot Distributions

```@example plot
using SignalDetectionModels
model = SDT(; d = 2.0, c = .50, σₛ = 1.5, nₙ = 100)
plot_distributions(model)
```

## Plot ROC

```@example plot
using SignalDetectionModels
model = SDT(; d = 2.0, c = 1, σₛ = 1, nₙ = 100)
plot_ROC(model)
```

## Plot zROC

```@example plot
using SignalDetectionModels
model = SDT(; d = 2.0, c = 1, σₛ = 1, nₙ = 100)
plot_zROC(model)
```

## Plot iso-bias

```@example plot
using SignalDetectionModels
model = SDT(; d = 2.0, c = 1, σₛ = 1.5, nₙ = 100)
plot_iso_bias(model)
```

## Plot iso-sensitivity

```@example plot
using SignalDetectionModels
model = SDT(; d = 2.0, c = 1, σₛ = 1.5, nₙ = 100)
plot_iso_sensitivity(model)
```