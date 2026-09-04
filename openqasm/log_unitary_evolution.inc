// log_unitary_evolution.inc
// OpenQASM 3.0 Standard Library Extension for Log-Complexity Attack Generator

OPENQASM 3.0;
include "stdgates.inc";

gate frac_pauli_x(alpha, qubit) {
    rx(alpha * pi, qubit);
}

gate frac_pauli_y(alpha, qubit) {
    ry(alpha * pi, qubit);
}

gate frac_pauli_z(alpha, qubit) {
    rz(alpha * pi, qubit);
}

gate log_crz(lambda, theta, ctl, tgt) {
    crz(theta * lambda, ctl, tgt);
}

gate curvature_oracle(lambda, params[3], qreg) {
    let kappa = params[0];
    cp(4.0 * kappa * lambda, qreg[0], qreg[1]);
    rz(kappa * lambda, qreg[0]);
    rz(kappa * lambda, qreg[1]);
    cp(-2.0 * kappa * lambda, qreg[0], qreg[1]);
}

gate log_evolution_step(alpha, lambda, qubit[2] ancilla, qubit[n] sys, qubit[m] wreg) {
    frac_pauli_x(alpha * 0.5, sys[0]);
    frac_pauli_z(alpha * 0.3, sys[1]);
    curvature_oracle(lambda, [0.1, 0.0, 0.0], sys[0:1]);
}

gate LCAG_Circuit(lambda, T, M, qubit[n] sys, qubit[2] anc, qubit[m] wreg) {
    let dt = T / M;
    for i in [0 : n-1] {
        h(sys[i]);
    }
    for k in [0 : M-1] {
        let t_k = k * dt;
        let alpha_k = dt * (1.0 + 0.01 * sin(t_k * lambda));
        log_evolution_step(alpha_k, lambda, anc, sys, wreg);
    }
}
