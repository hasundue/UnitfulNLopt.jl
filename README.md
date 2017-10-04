# UnitfulNLopt

This package enables NLopt to handle the Quantity types implemented in [Unitful.jl](https://github.com/ajkeller34/Unitful.jl).

Note that this package has limited functionalities and is not well-tested so far.

## Usage

You initialize an optimization by defining UnitfulOpt object with information on units with variables and function values instead of defining Opt object:

```julia
opt = UnitfulOpt(:LN_SBPLX, N, unit(1u"m"), NoUnits)
min_objective!(opt, f)
```

In this case, the variables of the target function f have m (meter) as their units and function values have no units. After that you can use the same functions as NLopt:

```julia
ftol_rel!(opt, 1e-6)
xtol_abs!(opt, 1u"nm")
maxeval!(opt, 100)
...
fmin, xmin, res = optimize(opt, x₀)
```

Currently, the following functions and commands are supported:

- optimize
- min_objective
- algorithm
- stopval
- ftol_rel
- ftol_abs
- xtol_rel
- xtol_abs
- maxeval
- maxtime
- initial_step
