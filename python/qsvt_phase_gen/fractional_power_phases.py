"""QSVT Phase Generation for Log-Complexity Attack Generator"""
import numpy as np
from numpy.polynomial.chebyshev import chebfit
from scipy.optimize import minimize, Bounds
import json

def target_func_complex(x, alpha):
    theta = np.arccos(np.clip(x, -1.0, 1.0))
    return np.exp(1j * alpha * theta)

def chebyshev_coeffs_target(alpha, degree, n_samples=2000):
    k = np.arange(n_samples)
    x_nodes = np.cos(np.pi * k / (n_samples - 1))
    y = target_func_complex(x_nodes, alpha)
    w = np.ones(n_samples)
    w[0] = 0.5
    w[-1] = 0.5
    c_re = chebfit(x_nodes, y.real, degree, w=w)
    c_im = chebfit(x_nodes, y.imag, degree, w=w)
    return c_re, c_im

def evaluate_qsvt(phases, x):
    psi_0 = np.ones_like(x, dtype=complex)
    psi_1 = np.zeros_like(x, dtype=complex)
    psi_0 *= np.exp(1j * phases[0])
    psi_1 *= np.exp(-1j * phases[0])
    sqrt_1mx2 = np.sqrt(1 - x**2 + 0j)
    for k in range(1, len(phases)):
        n0 = x * psi_0 + 1j * sqrt_1mx2 * psi_1
        n1 = 1j * sqrt_1mx2 * psi_0 + x * psi_1
        psi_0, psi_1 = n0, n1
        psi_0 *= np.exp(1j * phases[k])
        psi_1 *= np.exp(-1j * phases[k])
    return psi_0

def generate_qsvt_phases(alpha, epsilon=1e-6, max_degree=100):
    d_est = int(np.ceil(alpha + 10 * np.log(1/epsilon) / np.pi))
    d = min(max(d_est, 2), max_degree)
    if d % 2 == 1:
        d += 1
    x_eval = np.cos(np.pi * np.arange(0, 500) / 499)
    y_target = target_func_complex(x_eval, alpha)
    def loss_fn(phases):
        y_pred = evaluate_qsvt(phases, x_eval)
        w = 1.0 / (np.sqrt(1 - x_eval**2 + 1e-9))
        err = y_pred - y_target
        return np.mean(w * np.abs(err)**2)
    phi_init = np.zeros(d + 1)
    phi_init[0] = alpha * np.pi / 2
    bounds = Bounds(-np.pi, np.pi)
    res = minimize(loss_fn, phi_init, method='L-BFGS-B', bounds=bounds, options={'maxiter': 500, 'ftol': 1e-12})
    y_final = evaluate_qsvt(res.x, x_eval)
    max_err = np.max(np.abs(y_final - y_target))
    return {"phases": res.x.tolist(), "degree": d, "alpha": alpha, "max_error": float(max_err), "success": res.success}

def export_openqasm_phases(phases_data, filename="qsvt_phases.inc"):
    phases = phases_data["phases"]
    d = phases_data["degree"]
    alpha = phases_data["alpha"]
    lines = [
        f"// QSVT Phases for Fractional Power U^{alpha}",
        f"// Degree: {d}, Max Error: {phases_data['max_error']:.2e}",
        f"array[float[64], {d+1}] qsvt_phases = {{"
    ]
    for i, p in enumerate(phases):
        lines.append(f" {p:.15e},{'' if i == d else ''}")
    lines.append("};")
    with open(filename, "w") as f:
        f.write("\n".join(lines))

if __name__ == "__main__":
    result = generate_qsvt_phases(0.1, 1e-9)
    print(f"Degree: {result['degree']}, Max Error: {result['max_error']:.2e}")
    export_openqasm_phases(result)
