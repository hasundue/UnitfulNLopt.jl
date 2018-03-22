module UnitfulNLopt

using Unitful
import Unitful: Quantity, Units
import NLopt
import NLopt: Opt

export UnitfulOpt

struct UnitfulOpt
    opt::Opt
    xunit::Units
    funit::Units
end

function UnitfulOpt(s::Symbol, N::Int, xu::Units, fu::Units)
    UnitfulOpt(Opt(s, N), xu, fu)
end

function NLopt.min_objective!(uopt::UnitfulOpt, f)
    g(x,y) = ustrip(f(x*uopt.xunit, y*uopt.funit*uopt.xunit^-1))
    NLopt.min_objective!(uopt.opt, g)
end

for f in (:equality_constraint!, :inequality_constraint!)
    @eval function NLopt.$f(uopt::UnitfulOpt, f, tol::Real)
        g(x,y) = ustrip(f(x*uopt.xunit, y*uopt.funit*uopt.xunit^-1))
        NLopt.$f(uopt.opt, g, tol)
    end
end

for f in (:optimize, :optimize!)
    @eval function NLopt.$f(uopt::UnitfulOpt, x::AbstractVector)
        fmin, xmin, res = NLopt.$f(uopt.opt, ustrip(x))
        fmin*uopt.funit, xmin*uopt.xunit, res
    end
end

for f in (:algorithm,)
    @eval function NLopt.$f(uopt::UnitfulOpt)
        NLopt.$f(uopt.opt)
    end
end

fset(f::Symbol) = Symbol(f, '!')

for f in (:ftol_rel, :xtol_rel, :maxeval, :maxtime)
    @eval function NLopt.$f(uopt::UnitfulOpt)
        NLopt.$f(uopt.opt)
    end
    @eval function NLopt.$(fset(f))(uopt::UnitfulOpt, x)
        NLopt.$(fset(f))(uopt.opt, x)
    end
end

for f in (:stopval, :ftol_abs)
    @eval function NLopt.$f(uopt::UnitfulOpt)
        NLopt.$f(uopt.opt) * uopt.funit
    end
    @eval function NLopt.$(fset(f))(uopt::UnitfulOpt, x)
        NLopt.$(fset(f))(uopt.opt, ustrip(uconvert(uopt.funit, x)))
    end
end

for f in (:xtol_abs, :lower_bounds, :upper_bounds, :initial_step)
    @eval function NLopt.$f(uopt::UnitfulOpt)
        NLopt.$f(uopt.opt) * uopt.xunit
    end
    @eval function NLopt.$(fset(f))(uopt::UnitfulOpt, x)
        NLopt.$(fset(f))(uopt.opt, ustrip(uconvert(uopt.xunit, x)))
    end
end

end # module
