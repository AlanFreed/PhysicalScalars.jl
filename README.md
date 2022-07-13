# PhysicalScalars.jl

This module provides a type for physical scalars, overloading both math operators and functions.

To use this module you will need to add the following Julia packages to yours:

```
using Pkg
Pkg.add(url = "https://github.com/AlanFreed/MutableTypes.jl")
Pkg.add(url = "https://github.com/AlanFreed/PhysicalSystemsOfUnits.jl")
Pkg.add(url = "https://github.com/AlanFreed/PhysicalFields.jl")
Pkg.add(url = "https://github.com/AlanFreed/PhysicalScalars.jl")
```

## Re-exported from PhysicalFields.jl

Package [Reexport.jl](https://github.com/simonster/Reexport.jl), or [here](https://juliapackages.com/p/reexport), is used to export symbols from an imported package. Here `Reexport` is used to re-export part of the interface of package [PhsysicalFields.jl](https://github.com/AlanFreed/PhysicalFields.jl), effectively linking these exports so they appear to originate from within this module. Specifically, using the aliases

```
const MReal         = MutableTypes.MReal
const PhysicalUnits = PhysicalSystemsOfUnits.PhysicalSystemOfUnits
```

the following type definition for a physical scalar field is exported as

```
struct PhysicalScalar <: PhysicalField
    x::MReal            # value of the scalar in its specified system of units
    u::PhysicalUnits    # the scalar's physical units
end
```

which is a sub-type to the abstract type

```
abstract type PhysicalField end
```

Also, a type definition for an array of such scalar fields is exported as

```
struct ArrayOfPhysicalScalars
    e::UInt16           # number of entries or elements held in the array
    a::Array            # array holding values of a physical scalar
    u::PhysicalUnits    # units of this physical scalar
end
```

Constructors for these types are also re-exported here, they being

```
function newPhysicalScalar(units::PhysicalUnits)::PhysicalScalar
```

which supplies a new scalar whose value is `0` and whose physical units are those supplied by `units`, and

```
function newArrayOfPhysicalScalars(len::Integer, s₁::PhysicalScalar)::ArrayOfPhysicalScalars
```

where `s₁` is the first entry in a new array of scalars whose length is `len`. To retrieve and assign scalar values to the entries of this array, the following methods are re-exported

```
function get(y::PhysicalScalar)::Real
function set!(y::PhysicalScalar, x::Real)
```

while `Base.:(getindex)` and `Base.:(setindex!)` have been overloaded so that the bracket notation `[]` can be used to retrieve and assign scalar fields belonging to an instance of `ArrayOfPhysicalScalars`. Also, conversion to a string is provided for by the re-exported method

```
function toString(y::PhysicalScalar; format::Char='E', precision::Int=5, aligned::Bool=false)::String
```

where the keyword `format` is a character that, whenever its value is 'E' or 'e', represents the scalar in a scientific notation; otherwise, it will be represented in a fixed-point notation. Keyword `precision` specifies the number of significant digits to be represented in the string, which can accept values from the set \{3…7\}. Keyword `aligned`, when set to `true`, will add a white space in front of any non-negative scalar string representation, e.g., this could be useful when printing out a matrix of scalars; otherwise, there is no leading white space in its string representation, which is the default.

## Operators

The following operators have been overloaded so that they can handle objects of type PhysicalScalar, whenever such operations make sense, e.g., one cannot add two scalars with different units; however, one can multiply them. The overloaded logical operators include: `==`, `≠`, `≈`, `<`, `≤`, `≥` and `>`. The overloaded unary operators include: `+` and `-`. And the overloaded binary operators include: `+`, `-`, `*`, `/` and `^`.

## Methods for both PhysicalScalar and ArrayOfPhysicalScalars

The following methods can accept arguments that are objects of either type, viz., PhysicalScalar or type ArrayOfPhysicalScalars. They are self explanatory: `copy`, `deepcopy`, `isDimensionless`, `isCGS`, `isSI` and `toReal`.

## Math functions for PhysicalScalar

The following functions can handle arguments with physical dimensions: `abs`, `sqrt` or `√` (provided the unit exponents can all be evenly divided by 2), `cbrt` or `∛` (provided the unit exponents can all be evenly divided by 3), `round`, `ceil` and `floor`, all of which return instances of type `PhysicalScalar`, while functions `sign` and `atan(y,x)` (provided the rise `y` has the same units as the run `x`) return a `Real` value.

The following math functions require the scalar argument to be dimensionless: `sin`, `cos`, `tan`, `sinh`, `cosh`, `tanh`, `asin`, `acos`, `atan`, `asinh`, `acosh`, `atanh`, `log`, `log2`, `log10`, `exp`, `exp2` and `exp10`. These functions return a `Real` value.
