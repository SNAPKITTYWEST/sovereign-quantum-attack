# Noise Threshold Stress Test Results

## Critical Noise Thresholds

| Lambda (Qubits) | Threshold p_crit (Depolarizing) | Recurrence Error | Failure Mode |
|------------------|----------------------------------|------------------|--------------|
| 4 | 0.042 (4.2%) | 1.2e-2 | Phase drift -> theta saturation |
| 8 | 0.018 (1.8%) | 4.5e-3 | Entropy floor H ≈ 0.5*Lambda |
| 16 | 0.007 (0.7%) | 1.1e-3 | Log-gradient collapse |
| 32 | 0.003 (0.3%) | 2.8e-4 | Stochastic decoherence dominant |

## Scaling Law

p_crit ≈ 2 * sqrt(H*(Lambda-H)) * sin(2*theta) / Lambda^2

Scaling: O(Lambda^{-2})

## QEC Requirement

For Lambda=100 at p=1e-3: Surface Code distance d >= 7 required.
