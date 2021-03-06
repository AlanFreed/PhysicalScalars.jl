module PhysicalScalars

using
    MutableTypes,
    PhysicalSystemsOfUnits,
    Reexport

@reexport using PhysicalFields:
    PhysicalField,
    PhysicalScalar,
    ArrayOfPhysicalScalars,
    newPhysicalScalar,
    newArrayOfPhysicalScalars,
    get,
    set!,
    StoString

export
    # For both PhysicalScalar and ArrayOfPhysicalScalars objects:
    # type testing
    isDimensionless,
    isCGS,
    isSI,
    # type convertors
    toCGS,
    toSI,
    # copying methods
    copy,
    deepcopy,
    # For PhysicalScalar objects (not for ArrayOfPhysicalScalars objects):
    toString,
    toReal,
    # math functions
    abs,
    round,
    ceil,
    floor,
    sign,
    sin,
    cos,
    tan,
    asin,
    acos,
    atan,
    sinh,
    cosh,
    tanh,
    asinh,
    acosh,
    atanh,
    sqrt,
    cbrt,
    log,
    log2,
    log10,
    exp,
    exp2,
    exp10

#=
--------------------------------------------------------------------------------
=#

const MNumber = MutableTypes.MNumber

#=
--------------------------------------------------------------------------------
=#

# Methods for testing the kind of system of units.

function isDimensionless(s::PhysicalScalar)::Bool
    return PhysicalSystemsOfUnits.isDimensionless(s.u)
end

function isDimensionless(as::ArrayOfPhysicalScalars)::Bool
    return PhysicalSystemsOfUnits.isDimensionless(as.u)
end

function isCGS(s::PhysicalScalar)::Bool
    return PhysicalSystemsOfUnits.isCGS(s.u)
end

function isCGS(as::ArrayOfPhysicalScalars)::Bool
    return PhysicalSystemsOfUnits.isCGS(as.u)
end

function isSI(s::PhysicalScalar)::Bool
    return PhysicalSystemsOfUnits.isSI(s.u)
end

function isSI(as::ArrayOfPhysicalScalars)::Bool
    return PhysicalSystemsOfUnits.isSI(as.u)
end

# Methods for converting between systems of units.

function toCGS(s::PhysicalScalar)::PhysicalScalar
    if isCGS(s)
        return s
    elseif isSI(s)
        units = PhysicalSystemsOfUnits.CGS(s.u.m, s.u.kg, s.u.s, s.u.K)
        if s.u == PhysicalSystemsOfUnits.KELVIN
            value = s.x - 273.15
        else
            value = s.x * 100.0^s.u.m * 1000.0^s.u.kg
        end
        ps = newPhysicalScalar(units)
        set!(ps, value)
        return ps
    else
        msg = "Units of scalar s must be either CGS or SI."
        throw(ErrorException(msg))
    end
end

function toCGS(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
    if isCGS(as)
        return as
    elseif isSI(as)
        units = PhysicalSystemsOfUnits.CGS(as.u.m, as.u.kg, as.u.s, as.u.K)
        if as.u == PhysicalSystemsOfUnits.KELVIN
            value = as.a[1] - 273.15
        else
            value = as.a[1] * 100.0^as.u.m * 1000.0^as.u.kg
        end
        ps = newPhysicalScalar(units)
        set!(ps, value)
        pa = newArrayOfPhysicalScalars(as.e, ps)
        for i in 2:as.e
            if as.u == PhysicalSystemsOfUnits.KELVIN
                value = as.a[i] - 273.15
            else
                value = as.a[i] * 100.0^as.u.m * 1000.0^as.u.kg
            end
            ps = newPhysicalScalar(units)
            set!(ps, value)
            pa[i] = ps
        end
        return pa
    else
        msg = "Units of scalar s must be either CGS or SI."
        throw(ErrorException(msg))
    end
end

function toSI(s::PhysicalScalar)::PhysicalScalar
    if isSI(s)
        return s
    elseif isCGS(s)
        units = PhysicalSystemsOfUnits.SI(s.u.cm, s.u.g, s.u.s, s.u.C)
        if s.u == PhysicalSystemsOfUnits.CENTIGRADE
            value = s.x + 273.15
        else
            value = s.x * 100.0^(-s.u.cm) * 1000.0^(-s.u.g)
        end
        ps = newPhysicalScalar(units)
        set!(ps, value)
        return ps
    else
        msg = "Units of scalar s must be either CGS or SI."
        throw(ErrorException(msg))
    end
end

function toSI(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
    if isSI(as)
        return as
    elseif isCGS(as)
        units = PhysicalSystemsOfUnits.SI(as.u.cm, as.u.g, as.u.s, as.u.C)
        if as.u == PhysicalSystemsOfUnits.CENTIGRADE
            value = as.a[1] + 273.15
        else
            value = as.a[1] * 100.0^(-as.u.cm) * 1000.0^(-as.u.g)
        end
        ps = newPhysicalScalar(units)
        set!(ps, value)
        pa = newArrayOfPhysicalScalars(as.e, ps)
        for i in 2:as.e
            if as.u == PhysicalSystemsOfUnits.CENTIGRADE
                value = as.a[i] + 273.15
            else
                value = as.a[i] * 100.0^(-as.u.cm) * 1000.0^(-as.u.g)
            end
            ps = newPhysicalScalar(units)
            set!(ps, value)
            pa[i] = ps
        end
        return pa
    else
        msg = "Units of scalar s must be either CGS or SI."
        throw(ErrorException(msg))
    end
end

function toString(y::PhysicalScalar;
                  format::Char='E',
                  precision::Int=5,
                  aligned::Bool=false)::String
    return StoString(y; format, precision, aligned)
end

function toReal(s::PhysicalScalar)::Real
    return MutableTypes.toReal(s.x)
end

#=
--------------------------------------------------------------------------------
=#

function Base.:(copy)(s::PhysicalScalar)::PhysicalScalar
    value = copy(s.x)
    units = copy(s.u)
    return PhysicalScalar(value, units)
end

function Base.:(copy)(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
    entries = copy(as.e)
    array   = copy(as.a)
    units   = copy(as.u)
    return ArrayOfPhysicalScalars(UInt16(entries), array, units)
end

function Base.:(deepcopy)(s::PhysicalScalar)::PhysicalScalar
    value = deepcopy(s.x)
    units = deepcopy(s.u)
    return PhysicalScalar(value, units)
end

function Base.:(deepcopy)(as::ArrayOfPhysicalScalars)::ArrayOfPhysicalScalars
    entries = deepcopy(as.e)
    array   = deepcopy(as.a)
    units   = deepcopy(as.u)
    return ArrayOfPhysicalScalars(UInt16(entries), array, units)
end

#=
--------------------------------------------------------------------------------
=#

# Overloaded these operators: logical: ==, ???, ???, <, ???, ???, >
#                             unary:   +, -
#                             binary:  +, -, *, /

function Base.:(==)(y::PhysicalScalar, z::PhysicalScalar)::Bool
    if PhysicalSystemsOfUnits.isEquivalent(y.u, z.u)
        if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
            if y.x == z.x
                return true
            else
                return false
            end
        elseif isCGS(y) && isSI(z)
            w = toCGS(z)
            if y.x == w.x
                return true
            else
                return false
            end
        elseif isSI(y) && isCGS(z)
            w = toCGS(y)
            if w.x == z.x
                return true
            else
                return false
            end
        else
            msg = "Testing for == requires PhysicalScalars have CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        return false
    end
end

function Base.:(==)(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    if isDimensionless(z)
        if y == z.x
            return true
        else
            return false
        end
    else
        msg = "Testing for == requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:(==)(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    if isDimensionless(y)
        if y.x == z
            return true
        else
            return false
        end
    else
        msg = "Testing for == requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:???(y::PhysicalScalar, z::PhysicalScalar)::Bool
    if PhysicalSystemsOfUnits.isEquivalent(y.u, z.u)
        if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
            if y.x ??? z.x
                return true
            else
                return false
            end
        elseif isCGS(y) && isSI(z)
            w = toCGS(z)
            if y.x ??? w.x
                return true
            else
                return false
            end
        elseif isSI(y) && isCGS(z)
            w = toCGS(y)
            if w.x ??? z.x
                return true
            else
                return false
            end
        else
            msg = "Testing for ??? requires PhysicalScalars have CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        return false
    end
end

function Base.:???(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    if isDimensionless(z)
        if y ??? z.x
            return true
        else
            return false
        end
    else
        msg = "Testing for ??? requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:???(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    if isDimensionless(y)
        if y.x ??? z
            return true
        else
            return false
        end
    else
        msg = "Testing for ??? requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:???(y::PhysicalScalar, z::PhysicalScalar)::Bool
    equals = (y == z)
    return !equals
end

function Base.:???(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    equals = (y == z)
    return !equals
end

function Base.:???(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    equals = (y == z)
    return !equals
end

function Base.:<(y::PhysicalScalar, z::PhysicalScalar)::Bool
    if PhysicalSystemsOfUnits.isEquivalent(y.u, z.u)
        if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
            if y.x < z.x
                return true
            else
                return false
            end
        elseif isCGS(y) && isSI(z)
            w = toCGS(z)
            if y.x < w.x
                return true
            else
                return false
            end
        elseif isSI(y) && isCGS(z)
            w = toCGS(y)
            if w.x < z.x
                return true
            else
                return false
            end
        else
            msg = "Testing for < requires PhysicalScalars have CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        msg = "Testing for < requires PhysicalScalars to have equivalent units."
        throw(ErrorException(msg))
    end
end

function Base.:<(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    if isDimensionless(z)
        if y < z.x
            return true
        else
            return false
        end
    else
        msg = "Testing for < requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:<(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    if isDimensionless(y)
        if y.x < z
            return true
        else
            return false
        end
    else
        msg = "Testing for < requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:???(y::PhysicalScalar, z::PhysicalScalar)::Bool
    lessThan = (y < z)
    return !lessThan
end

function Base.:???(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    lessThan = (y < z)
    return !lessThan
end

function Base.:???(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    lessThan = (y < z)
    return !lessThan
end

function Base.:>(y::PhysicalScalar, z::PhysicalScalar)::Bool
    if PhysicalSystemsOfUnits.isEquivalent(y.u, z.u)
        if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
            if y.x > z.x
                return true
            else
                return false
            end
        elseif isCGS(y) && isSI(z)
            w = toCGS(z)
            if y.x > w.x
                return true
            else
                return false
            end
        elseif isSI(y) && isCGS(z)
            w = toCGS(y)
            if w.x > z.x
                return true
            else
                return false
            end
        else
            msg = "Testing for > requires PhysicalScalars have CGS or SI units."
            throw(ErrorException(msg))
        end
    else
        msg = "Testing for > requires PhysicalScalars to have equivalent units."
        throw(ErrorException(msg))
    end
end

function Base.:>(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    if isDimensionless(z)
        if y > z.x
            return true
        else
            return false
        end
    else
        msg = "Testing for > requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:>(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    if isDimensionless(y)
        if y.x > z
            return true
        else
            return false
        end
    else
        msg = "Testing for > requires the PhysicalScalar to be dimensionless."
        throw(ErrorException(msg))
    end
end

function Base.:???(y::PhysicalScalar, z::PhysicalScalar)::Bool
    greaterThan = (y > z)
    return !greaterThan
end

function Base.:???(y::Union{Real, MNumber}, z::PhysicalScalar)::Bool
    greaterThan = (y > z)
    return !greaterThan
end

function Base.:???(y::PhysicalScalar, z::Union{Real, MNumber})::Bool
    greaterThan = (y > z)
    return !greaterThan
end

function Base.:+(y::PhysicalScalar)::PhysicalScalar
    value = +y.x
    units = y.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:-(y::PhysicalScalar)::PhysicalScalar
    value = -y.x
    units = y.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:+(y::PhysicalScalar, z::PhysicalScalar)::PhysicalScalar
    if PhysicalSystemsOfUnits.isEquivalent(y.u, z.u)
        if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
            units = y.u
            value = y.x + z.x
        elseif isCGS(y) && isSI(z)
            w = toCGS(z)
            units = y.u
            value = y.x + w.x
        elseif isSI(y) && isCGS(z)
            w = toCGS(y)
            units = z.u
            value = w.x + z.x
        else
            msg = "Scalar addition requires units to be CGS or SI."
            throw(ErrorException(msg))
        end
    else
        msg = "Scalar addition requires scalars to have equivalent units."
        throw(ErrorException(msg))
    end
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:+(y::Union{Real, MNumber}, z::PhysicalScalar)::PhysicalScalar
    if isDimensionless(z)
        units = z.u
        value = y + z.x
    else
        msg = "Adding a number with a scalar requires the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:+(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    if isDimensionless(y)
        units = y.u
        value = y.x + z
    else
        msg = "Adding a scalar with a number requires the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:-(y::PhysicalScalar, z::PhysicalScalar)::PhysicalScalar
    if PhysicalSystemsOfUnits.isEquivalent(y.u, z.u)
        if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
            units = y.u
            value = y.x - z.x
        elseif isCGS(y) && isSI(z)
            w = toCGS(z)
            units = y.u
            value = y.x - w.x
        elseif isSI(y) && isCGS(z)
            w = toCGS(y)
            units = z.u
            value = w.x - z.x
        else
            msg = "Scalar subtraction requires units to be CGS or SI."
            throw(ErrorException(msg))
        end
    else
        msg = "Scalar subtraction requires scalars to have equivalent units."
        throw(ErrorException(msg))
    end
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:-(y::Union{Real, MNumber}, z::PhysicalScalar)::PhysicalScalar
    if isDimensionless(z)
        units = z.u
        value = y - z.x
    else
        msg = "Subtracting a number by a scalar requires the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:-(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    if isDimensionless(y)
        units = y.u
        value = y.x - z
    else
        msg = "Subtracting a scalar by a number requires the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:*(y::PhysicalScalar, z::PhysicalScalar)::PhysicalScalar
    if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
        value = y.x * z.x
        units = y.u + z.u
    elseif isCGS(y) && isSI(z)
        w = toCGS(z)
        value = y.x * w.x
        units = y.u + w.u
    elseif isSI(y) && isCGS(z)
        w = toCGS(y)
        value = w.x * z.x
        units = w.u + z.u
    else
        msg = "Scalar multiplication requires scalars have CGS or SI units."
        throw(ErrorException(msg))
    end
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:*(y::Union{Real, MNumber}, z::PhysicalScalar)::PhysicalScalar
    value = y * z.x
    units = z.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:*(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    value = y.x * z
    units = y.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:/(y::PhysicalScalar, z::PhysicalScalar)::PhysicalScalar
    if (isCGS(y) && isCGS(z)) || (isSI(y) && isSI(z))
        value = y.x / z.x
        units = y.u - z.u
    elseif isCGS(y) && isSI(z)
        w = toCGS(z)
        value = y.x / w.x
        units = y.u - w.u
    elseif isSI(y) && isCGS(z)
        w = toCGS(y)
        value = w.x / z.x
        units = w.u - z.u
    else
        msg = "Scalar division requires scalars have CGS or SI units."
        throw(ErrorException(msg))
    end
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:/(y::Union{Real, MNumber}, z::PhysicalScalar)::PhysicalScalar
    value = y / z.x
    units = -z.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:/(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    value = y.x / z
    units = y.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:^(y::PhysicalScalar, z::Union{Real, MNumber})::PhysicalScalar
    if (typeof(z) == Integer) || (typeof(z) == MutableTypes.MInteger)
        value = y.x ^ z
        if isCGS(y)
            units = PhysicalSystemsOfUnits.CGS(Int8(y.u.cm*z), Int8(y.u.g*z), Int8(y.u.s*z), Int8(y.u.C*z))
        elseif isSI(y)
            units = PhysicalSystemsOfUnits.SI(Int8(y.u.m*z), Int8(y.u.kg*z), Int8(y.u.s*z), Int8(y.u.K*z))
        else
            msg = "Scalars raised to integer powers require the scalar to have CGS or SI units."
            throw(ErrorException(msg))
        end
    elseif (typeof(z) == Rational) || (typeof(z) == MutableTypes.MRational)
        n = numerator(z)
        d = denominator(z)
        value = y.x ^ (n / d)
        if isCGS(y)
            if ((y.u.cm * n % d == 0) && (y.u.g * n % d == 0) &&
                (y.u.s * n % d == 0) && (y.u.C * n % d == 0))
                units = PhysicalSystemsOfUnits.CGS(Int8(y.u.cm*n??d), Int8(y.u.g*n??d), Int8(y.u.s*n??d), Int8(y.u.C*n??d))
            else
                msg == "Scalars raised to rational powers must produce units with integer powers."
                throw(ErrorException(msg))
            end
        elseif isSI(y)
            if ((y.u.m * n % d == 0) && (y.u.kg * n % d == 0) &&
                (y.u.s * n % d == 0) && (y.u.K * n % d == 0))
                units = PhysicalSystemsOfUnits.SI(Int8(y.u.m*n??d), Int8(y.u.kg*n??d), Int8(y.u.s*n??d), Int8(y.u.K*n??d))
            else
                msg == "Scalars raised to rational powers must produce units with integer powers."
                throw(ErrorException(msg))
            end
        else
            msg = "Scalars raised to rational powers require the scalar to have CGS or SI units."
            throw(ErrorException(msg))
        end
    elseif isDimensionless(y)
        value = y.x ^ z
        units = y.u
    else
        msg = "Scalars raised to real powers require the scalar to be dimensionless."
        throw(ErrorException(msg))
    end
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

#=
--------------------------------------------------------------------------------
=#

# Math functions

function Base.:(abs)(s::PhysicalScalar)::PhysicalScalar
    value = MutableTypes.abs(s.x)
    units = s.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:(round)(y::PhysicalScalar)::PhysicalScalar
    value = MutableTypes.round(y.x)
    units = y.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:(ceil)(y::PhysicalScalar)::PhysicalScalar
    value = MutableTypes.ceil(y.x)
    units = y.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:(floor)(y::PhysicalScalar)::PhysicalScalar
    value = MutableTypes.floor(y.x)
    units = y.u
    ps = newPhysicalScalar(units)
    set!(ps, value)
    return ps
end

function Base.:(sign)(y::PhysicalScalar)::Real
    return MutableTypes.sign(y.x)
end

function Base.:(sin)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.sin(y.x)
    else
        msg = "The argument must be dimensionless when calling sin()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(cos)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.cos(y.x)
    else
        msg = "The argument must be dimensionless when calling cos()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(tan)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.tan(y.x)
    else
        msg = "The argument must be dimensionless when calling tan()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(sinh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.sinh(y.x)
    else
        msg = "The argument must be dimensionless when calling sinh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(cosh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.cosh(y.x)
    else
        msg = "The argument must be dimensionless when calling cosh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(tanh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.tanh(y.x)
    else
        msg = "The argument must be dimensionless when calling tanh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(asin)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.asin(y.x)
    else
        msg = "The argument must be dimensionless when calling asin()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(acos)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.acos(y.x)
    else
        msg = "The argument must be dimensionless when calling acos()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atan)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.atan(y.x)
    else
        msg = "The argument must be dimensionless when calling atan()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atan)(y::PhysicalScalar, x::PhysicalScalar)::Real
    if y.u == x.u
        n = MutableTypes.atan(y.x, x.x)
    else
        msg = "The arguments must have the same type when calling atan(y, x)."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atan)(y::PhysicalScalar, x::Union{Real, MNumber})::Real
    if isDimensionless(y)
        n = MutableTypes.atan(y.x, x)
    else
        msg = "The scalar argument must dimensionless when calling atan(y, x)."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atan)(y::Union{Real, MNumber}, x::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.atan(y, x.x)
    else
        msg = "The scalar argument must dimensionless when calling atan(y, x)."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(asinh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.asinh(y.x)
    else
        msg = "The argument must be dimensionless when calling asinh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(acosh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.acosh(y.x)
    else
        msg = "The argument must be dimensionless when calling acosh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(atanh)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.atanh(y.x)
    else
        msg = "The argument must be dimensionless when calling atanh()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(log)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.log(y.x)
    else
        msg = "The argument must be dimensionless when calling log()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(log2)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.log2(y.x)
    else
        msg = "The argument must be dimensionless when calling log2()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(log10)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.log10(y.x)
    else
        msg = "The argument must be dimensionless when calling log10()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(exp)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.exp(y.x)
    else
        msg = "The argument must be dimensionless when calling exp()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(exp2)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.exp2(y.x)
    else
        msg = "The argument must be dimensionless when calling exp2()."
        throw(ErrorException(msg))
    end
    return n
end

function Base.:(exp10)(y::PhysicalScalar)::Real
    if isDimensionless(y)
        n = MutableTypes.exp10(y.x)
    else
        msg = "The argument must be dimensionless when calling exp10()."
        throw(ErrorException(msg))
    end
    return n
end

end  # module PhysicalScalars
