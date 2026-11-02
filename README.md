<div align="center">

# Learning-Ready H∞ Control for a Morphing Aircraft

**Mixed-sensitivity H∞ controllers synthesized across the morphing envelope — a data generator for learning to tune controllers.**

![MATLAB](https://img.shields.io/badge/MATLAB-0076A8?style=flat-square&logo=mathworks&logoColor=white)
![Simulink](https://img.shields.io/badge/Simulink-0076A8?style=flat-square)
![LPVTools](https://img.shields.io/badge/LPVTools-H%E2%88%9E%20synthesis-555?style=flat-square)
![Status](https://img.shields.io/badge/status-research%20prototype-orange?style=flat-square)

</div>

## Why

Hand-tuning a robust controller at every flight and morphing condition does not scale. If tuned controllers can be generated automatically across the envelope, a neural network can learn the mapping **flight condition → controller parameters** and replace the hand-built schedule. This repository is the H∞ side of that idea; the PID version was published as [Gain Scheduling Using Deep Neural Network for Morphing Aircraft](https://jihoonlee91.github.io/papers/2024-dnn-gain-scheduling-morphing-ko.html) (*JKSAS 2024*).

## How it works

```mermaid
flowchart LR
    A["GTM-based nonlinear model<br/>+ morphing configurations"] --> B["Trim & linearize<br/>per condition"]
    B --> C["Mixed-sensitivity H∞<br/>synthesis (mixsyn / hinfsyn)"]
    C --> D[("(condition, tuned controller)<br/>pairs")]
    D -.-> E["Neural-network tuner<br/>(next step)"]
```

- Aerodynamic database, nonlinear and linearized aircraft models, mass/inertia distribution
- Baseline **LQR** and **mixed-sensitivity H∞** designs, with trim and eigenvalue/mode analysis across morphing configurations
- Self-contained **nonlinear closed-loop simulation** in `nonlinearSIM/`

## Quick start

```matlab
main      % top-level entry point
example   % smaller worked example
```

<details>
<summary><b>Repository layout</b></summary>

**Aircraft model** — `aero_data.m`, `aero_model.m`, `aerodyn.m`, `aero_coeff.mat` (aero database and model); `lti_model.m`, `lin_mod.m`, `model_lon.m`, `state_eq.m`, `state_eq_lin.m`, `rigiddyn.m` (nonlinear and linearized models); `mass_dist.m`

**Controller design** — `lqr_design.m` (baseline LQR); `mixsyndesign.m` (mixed-sensitivity H∞ via LPVTools); `trim_calc.m`, `trim_cost.m`, `morphing_eig.m` (trim and mode analysis)

**Simulation** — `model.slx`, `gtm_design.slx`; `main.m`, `example.m`; `nonlinearSIM/` (self-contained nonlinear closed-loop simulation); `v8/` (earlier snapshot of the top-level scripts)

**Plotting** — `plot_aero.m`, `plot_mode.m`, `plot_result.m`, `plot_result_2.m`, `plot_step.m`, `plot_trim_lpv.m`, `plot_trimx.m`, `polezeromap.*`

`LPVToolsV1.0/` is vendored in the root, `nonlinearSIM/`, and `v8/`, since each is self-contained.

</details>

## Related publications

| | Publication |
|---|---|
| Same idea, PID | [Gain Scheduling Using Deep Neural Network for Morphing Aircraft](https://jihoonlee91.github.io/papers/2024-dnn-gain-scheduling-morphing-ko.html) — *JKSAS 2024* |
| Control across the envelope (GTM) | [Self-Scheduled LPV Control of Asymmetric Variable-Span Morphing UAV](https://jihoonlee91.github.io/papers/2023-self-scheduled-lpv-asymmetric-morphing-uav.html) — *Sensors 2023* |
| Learning-based control | [Control Design Using Policy-Gradient-Based Integral Reinforcement Learning and Extended State Observer for Morphing Aircraft](https://jihoonlee91.github.io/papers/2024-policy-gradient-irl-eso-morphing.html) — *IEEE TAES 2024* |

<sub>Part of my morphing-aircraft control research at the Seoul National University Flight Dynamics and Control Lab — more at <a href="https://jihoonlee91.github.io/">jihoonlee91.github.io</a>.</sub>
