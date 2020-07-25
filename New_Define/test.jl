using Pkg
Pkg.instantiate()
Pkg.activate(".")

using BenchmarkTools

struct WendlandC6
    n_neighbours::Int64
    norm_2D::Float64
    norm_3D::Float64
    function WendlandC6(n_neighbours::Int64=295)
        new(n_neighbours, 78.0/(7.0*π), 1365.0/(64.0*π))
    end
end

"""
    kernel_value_2D(kernel::WendlandC6, u::Float64, h_inv::Float64)

Evaluate WendlandC6 spline at position ``u = \frac{x}{h}``.
"""
@inline function kernel_value(kernel::WendlandC6, u::Float64, h_inv::Float64)

    @fastmath if u < 1.0
        n = kernel.norm_2D * h_inv^2
        u_m1 = (1.0 - u)
        u_m1 = u_m1 * u_m1  # (1.0 - u)^2
        u_m1 = u_m1 * u_m1  # (1.0 - u)^4
        u_m1 = u_m1 * u_m1  # (1.0 - u)^8
        u2 = u*u
        return ( u_m1 * ( 1.0 + 8u + 25u2 + 32u2*u )) * n
    else
       return 0.0
   end

end

k = WendlandC6()
@btime kernel_value(k, 0.5, 0.5)
@btime kernel_value(k, 0.5, 0.5)