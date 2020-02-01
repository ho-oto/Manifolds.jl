
"""
    AbstractRiemannianDiffBackend

An abstract type for diff backends. See [`AbstractDiffBackend`](@ref) for an example.
"""
abstract type AbstractRiemannianDiffBackend end


"""
    r_derivative(f::AbstractCurve, x, backend::AbstractDiffBackend = rdiff_backend()

Compute the Riemannian derivative of a curve `f` at point `x` using given backend.
"""
r_derivative(::AbstractCurve, ::Any, ::AbstractRiemannianDiffBackend)


"""
    r_gradient(f::AbstractRealField, x, backend::AbstractRiemannianDiffBackend = rdiff_backend())

Compute the Riemannian gradient of a real field `f` at point `x` using given backend.
"""
r_gradient(::AbstractRealField, ::Any, ::AbstractRiemannianDiffBackend)


"""
    r_jacobian(f::AbstractMap, x, backend::AbstractRiemannianDiffBackend = rdiff_backend())

Compute the Riemannian Jacobian of a map `f` at point `x` using given backend.
"""
r_jacobian(::AbstractMap, ::Any, ::AbstractRiemannianDiffBackend)

"""
    RiemannianONBDiffBackend(adbackend::AbstractDiffBackend) <: AbstractRiemannianDiffBackend

Riemannian differentiation based on differentiation in [`ArbitraryOrthonormalBasis`](@ref)
using backend `diff_backend`.
"""
struct RiemannianONBDiffBackend{TADBackend<:AbstractDiffBackend} <:
       AbstractRiemannianDiffBackend
    diff_backend::TADBackend
end

function r_derivative(f::AbstractCurve, x, backend::AbstractRiemannianDiffBackend)
    error("r_derivative not implemented for curve $(typeof(f)), point $(typeof(x)) and " *
          "backend $(typeof(backend))")
end

function r_gradient(f::AbstractRealField, x, backend::AbstractRiemannianDiffBackend)
    error("r_gradient not implemented for field $(typeof(f)), point $(typeof(x)) and " *
          "backend $(typeof(backend))")
end

function r_jacobian(f::AbstractMap, x, backend::AbstractRiemannianDiffBackend)
    error("r_jacobian not implemented for map $(typeof(f)), point $(typeof(x)) and " *
          "backend $(typeof(backend))")
end

r_derivative(f::AbstractCurve, x) = r_derivative(f, x, rdiff_backend())

r_gradient(f::AbstractRealField, x) = r_gradient(f, x, rdiff_backend())

r_jacobian(f::AbstractMap, x) = r_jacobian(f::AbstractMap, x, rdiff_backend())


"""
    CurrentRiemannianDiffBackend(backend::AbstractRiemannianDiffBackend)

A mutable struct for storing the current Riemannian differentiation backend in a global
constant [`_current_rdiff_backend`](@ref).

# See also

[`AbstractRiemannianDiffBackend`](@ref), [`rdiff_backend`](@ref), [`rdiff_backend!`]
"""
mutable struct CurrentRiemannianDiffBackend
    backend::AbstractRiemannianDiffBackend
end

"""
    _current_rdiff_backend

The instance of [`CurrentRiemannianDiffBackend`] that stores the globally default differentiation
backend.
"""
const _current_rdiff_backend = CurrentRiemannianDiffBackend(RiemannianONBDiffBackend(diff_backend()))

"""
    rdiff_backend() -> AbstractRiemannianDiffBackend

Get the current differentiation backend.
"""
rdiff_backend() = _current_rdiff_backend.backend

"""
    rdiff_backend!(backend::AbstractRiemannianDiffBackend)

Set current backend for differentiation to `backend`.
"""
function rdiff_backend!(backend::AbstractRiemannianDiffBackend)
    _current_rdiff_backend.backend = backend
    return backend
end