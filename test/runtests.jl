module runtests

using
    MutableTypes,
    PhysicalSystemsOfUnits,
    PhysicalScalars,
    Test

const
    # Specify which methods to avoid naming clashes.
    get      = PhysicalScalars.get
    set!     = PhysicalScalars.set!
    toString = PhysicalScalars.toString

# Create three scalars and populate an array of scalars with them.
e1 = newPhysicalScalar(DYNE)
e2 = newPhysicalScalar(DYNE)
e3 = newPhysicalScalar(DYNE)
set!(e1, 1.0)
set!(e2, 2.0)
set!(e3, 3.0)
sArr = newArrayOfPhysicalScalars(3, e1)
sArr[2] = e2
sArr[3] = e3

@testset "get & set!" begin
    @test get(e1) == 1.0
    @test get(e2) == 2.0
    @test get(e3) == 3.0
end

@testset "[]" begin
    @test sArr[1] == e1
    @test sArr[2] == e2
    @test sArr[3] == e3
end

@testset "toString" begin
    @test toString(e1) == "1.0000E+00 g⋅cm/s²"
    @test toString(e2) == "2.0000E+00 g⋅cm/s²"
    @test toString(e3) == "3.0000E+00 g⋅cm/s²"
end

@testset "isDimensionless" begin
    @test PhysicalScalars.isDimensionless(e1) == false
    @test PhysicalScalars.isDimensionless(newPhysicalScalar(SI_DIMENSIONLESS)) == true
end

@testset "isCGS" begin
    @test PhysicalScalars.isCGS(newPhysicalScalar(DYNE)) == true
    @test PhysicalScalars.isCGS(newPhysicalScalar(PASCAL)) == false
    @test PhysicalScalars.isCGS(newPhysicalScalar(CGS_DIMENSIONLESS)) == true
    @test PhysicalScalars.isCGS(newPhysicalScalar(SI_DIMENSIONLESS)) == false
end

@testset "isSI" begin
    @test PhysicalScalars.isSI(newPhysicalScalar(DYNE)) == false
    @test PhysicalScalars.isSI(newPhysicalScalar(PASCAL)) == true
    @test PhysicalScalars.isSI(newPhysicalScalar(CGS_DIMENSIONLESS)) == false
    @test PhysicalScalars.isSI(newPhysicalScalar(SI_DIMENSIONLESS)) == true
end

@testset "toCGS & toSI" begin
    η = newPhysicalScalar(CGS_ENTROPY_DENSITY)
    set!(η, 1.22)
    @test toCGS(toSI(η)) == η
    σ = newPhysicalScalar(PASCAL)
    set!(σ, 1.1E+06)
    @test toSI(toCGS(σ)) == σ
end

@testset "abs" begin
    s1 = newPhysicalScalar(ERG)
    set!(s1, -1.1)
    s2 = -s1
    @test PhysicalScalars.abs(s1) == s2
    @test PhysicalScalars.abs(s2) == s2
end

@testset "x^(1//2)" begin
    s1 = newPhysicalScalar(SI_AREA)
    set!(s1, 4.0)
    s2 = newPhysicalScalar(SI_LENGTH)
    set!(s2, 2.0)
    power = MutableTypes.MRational(1 // 2)
    @test s1^power == s2
    s3 = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s3, 4.0)
    @test s3^0.5 == 2.0
end

@testset "x^(1//3)" begin
    s1 = newPhysicalScalar(SI_VOLUME)
    set!(s1, 8.0)
    s2 = newPhysicalScalar(SI_LENGTH)
    set!(s2, 2.0)
    power = MutableTypes.MRational(1 // 3)
    @test s1^power == s2
    s3 = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s3, 8.0)
    @test s3^power == 2.0
end

@testset "round" begin
    s1 = newPhysicalScalar(SI_AREA)
    s2 = newPhysicalScalar(SI_AREA)
    set!(s1, 1.45)
    set!(s2, 1.0)
    @test round(s1) == s2
end

@testset "floor" begin
    s1 = newPhysicalScalar(SI_AREA)
    s2 = newPhysicalScalar(SI_AREA)
    set!(s1, 1.45)
    set!(s2, 1.0)
    @test floor(s1) == s2
end

@testset "ceil" begin
    s1 = newPhysicalScalar(SI_AREA)
    s2 = newPhysicalScalar(SI_AREA)
    set!(s1, 1.45)
    set!(s2, 2.0)
    @test ceil(s1) == s2
end

@testset "sin & asin" begin
    s = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s, π/4)
    @test sin(s) == sin(π/4)
    @test asin(s) == asin(π/4)
end

@testset "cos & acos" begin
    s = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s, π/4)
    @test cos(s) == cos(π/4)
    @test acos(s) == acos(π/4)
end

@testset "tan & atan" begin
    s = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s, π/4)
    @test tan(s) == tan(π/4)
    @test atan(s) == atan(π/4)
    x = newPhysicalScalar(METER)
    y = newPhysicalScalar(METER)
    set!(x, 4.0)
    set!(y, π)
    @test atan(x,y) == atan(4.0,π)
end

@testset "sinh & asinh" begin
    s = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s, π)
    @test sinh(s) == sinh(π)
    @test asinh(s) == asinh(π)
end

@testset "cosh & acosh" begin
    s = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s, π)
    @test cosh(s) == cosh(π)
    @test acosh(s) == acosh(π)
end

@testset "tanh & atanh" begin
    s = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s, π/4)
    @test tanh(s) == tanh(π/4)
    @test atanh(s) == atanh(π/4)
end

@testset "log & exp" begin
    s = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s, π)
    @test log(s) == log(π)
    @test exp(s) == exp(π)
end

@testset "log2 & exp2" begin
    s = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s, π)
    @test log2(s) == log2(π)
    @test exp2(s) == exp2(π)
end

@testset "log10 & exp10" begin
    s = newPhysicalScalar(CGS_DIMENSIONLESS)
    set!(s, π)
    @test log10(s) == log10(π)
    @test exp10(s) == exp10(π)
end

end # module runtests
