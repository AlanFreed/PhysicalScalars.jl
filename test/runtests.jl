module runtests

using
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

end # module runtests
