// NoiseModel.qs
namespace QuantumLogarithmicAttack.Noise {

    open Microsoft.Quantum.Intrinsic;

    operation InjectNoise (
        register : Qubit[],
        p_depol : Double,
        p_phase : Double
    ) : Unit {
        for qubit in register {
            let r1 = RandomDouble();
            if (r1 < p_depol) {
                let r_type = RandomDouble();
                if (r_type < 1.0/3.0) { X(qubit); }
                else if (r_type < 2.0/3.0) { Y(qubit); }
                else { Z(qubit); }
            }
            let r2 = RandomDouble();
            if (r2 < p_phase) {
                Z(qubit);
            }
        }
    }

}
