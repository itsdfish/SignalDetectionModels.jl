# Overview

## Create Model 

```@example basic
using SignalDetectionModels
model = SDT(; d = 2.0, c = 0.0, nₙ = 100)
```

## Generate Data 

```@example basic
data = rand(model)
```

## Log Likelihood 

```@example basic
LL = logpdf(model, data)
```
