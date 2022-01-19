"""
    DAMMfit(Ind_var, Resp, poro_val)

fit the DAMM model parameters to data. 

# Examples
```julia-repl
julia> Tₛ = [19.0, 22.0] # soil temperature [°C]
julia> θ = [0.35, 0.22] # soil moisture [m³ m⁻³]
julia> Rₛ = [2.2, 2.8] # respiration observation
julia> Ind_var = hcat(Tₛ, θ)
julia> p = DAMMfit(Ind_var, Rₛ, 0.4) 
  10e8
  64
  9.6e-7
  1.3e-4
  0.4
  0.02
  1.0
julia> DAMM(Ind_var, p)
  2.2
  2.8
```
"""
function DAMMfit(Ind_var, Rₛ, poro_val)
  lb = [0.0, 0.0, 0.0, 0.0] # params can't be negative
  p_ini = [1.0, 6.4, 1.0, 1.0] # initial parameters
  p_fact = (1e9, 1e1, 1e-6, 1e-4, 1.0, 1.0, 1.0) # factor of param, better fit
  DAMMfix = (x,p) -> DAMM(x, p_fact.*(p[1], p[2], p[3], p[4], poro_val, 0.02, 1.0))
  fit_bounds = curve_fit(DAMMfix, Ind_var, Rₛ, p_ini, lower=lb)
  p = fit_bounds.param # fitted param result 
  fparam = p_fact[1:4].*p # multiply them by p_fact
  params = (fparam[1], fparam[2], fparam[3], fparam[4], poro_val, 0.02, 1.0)
  return params
end
