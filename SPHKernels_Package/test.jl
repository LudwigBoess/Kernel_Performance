using Pkg
Pkg.activate(".")
Pkg.instantiate()

using BenchmarkTools
using SPHKernels

k = WendlandC6()

@btime kernel_value_2D(k, 0.5, 0.5)
@btime kernel_value_2D(k, 0.5, 0.5)