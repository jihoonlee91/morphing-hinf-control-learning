# H-Infinity Control For Learning

Simulation program for developing a deep-neural-network-based H-infinity controller tuner.

**Content:** Uses a GTM (Generic Transport Model)-based nonlinear aircraft dynamics model together with LPVTools to design H-infinity controllers across a range of flight/morphing conditions, generating (flight condition, tuned controller) pairs as training data for a neural network that learns to predict tuned H-infinity controller parameters directly from flight condition.

Development environment: MATLAB / Simulink
