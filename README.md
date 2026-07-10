# H-Infinity Control For Learning

Simulation program for developing a deep-neural-network-based H-infinity controller tuner for a morphing aircraft.

## Approach

Uses a GTM (Generic Transport Model)-based nonlinear aircraft dynamics model together with the LPVTools toolbox to design mixed-sensitivity H-infinity controllers across a range of flight/morphing conditions. Sweeping these conditions produces a set of (flight condition, tuned H-infinity controller) pairs, which is intended as training data for a neural network that predicts tuned controller parameters directly from flight condition — the same "learn the scheduling instead of hand-tuning it" idea as [`morphing-dl-gain-scheduler`](https://github.com/jihoonlee91/morphing-dl-gain-scheduler), applied here to H-infinity control rather than LQR-style gain scheduling.

## Repository Structure

**Aircraft model**
- `aero_data.m`, `aero_model.m`, `aerodyn.m`, `aero_coeff.mat`: aerodynamic database and model
- `lti_model.m`, `lin_mod.m`, `model_lon.m`, `state_eq.m`, `state_eq_lin.m`, `rigiddyn.m`: nonlinear and linearized aircraft models
- `mass_dist.m`: mass/inertia distribution

**Controller design**
- `lqr_design.m`: baseline LQR controller design
- `mixsyndesign.m`: mixed-sensitivity H-infinity synthesis (`hinfsyn`/`mixsyn` via LPVTools)
- `trim_calc.m`, `trim_cost.m`, `morphing_eig.m`: trim computation and eigenvalue/mode analysis across morphing configurations

**Simulation**
- `model.slx`, `gtm_design.slx`: Simulink models
- `main.m`, `example.m`: entry points
- `nonlinearSIM/`: a self-contained nonlinear closed-loop simulation (own copy of the model, `main.m`, and LPVTools)
- `v8/`: an earlier internal snapshot of the top-level scripts, kept as-is rather than merged

**Plotting**
- `plot_aero.m`, `plot_mode.m`, `plot_result.m`, `plot_result_2.m`, `plot_step.m`, `plot_trim_lpv.m`, `plot_trimx.m`, `polezeromap.m`/`.fig`/`.pdf`

Note: `LPVToolsV1.0/` (the LPVTools toolbox) is vendored three times — at the repository root, inside `nonlinearSIM/`, and inside `v8/` — since each is a self-contained subproject with its own copy of the dependency.

Development environment: MATLAB / Simulink
