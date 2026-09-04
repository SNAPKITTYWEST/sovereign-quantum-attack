// EntropyAmplification.qs
namespace QuantumLogarithmicAttack {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;

    operation EntropyAmplificationStep (
        nQubits : Int,
        register : Qubit[],
        targetProjector : (Qubit[] => Unit is Adj + Ctl),
        hCurrent : Double,
        thetaCurrent : Double
    ) : (Double, Double) {
        let lambda = IntAsDouble(nQubits);
        let sqrtTerm = Sqrt(hCurrent * (lambda - hCurrent));
        let deltaH = -2.0 / lambda * sqrtTerm * Sin(2.0 * thetaCurrent);
        let deltaTheta = 1.0 / lambda * sqrtTerm * Cos(2.0 * thetaCurrent);
        let hNext = hCurrent + deltaH;
        let thetaNext = thetaCurrent + deltaTheta;
        return (hNext, thetaNext);
    }

    operation EntropyAmplificationAlgorithm (
        nQubits : Int,
        statePrep : (Qubit[] => Unit is Adj + Ctl),
        targetProjector : (Qubit[] => Unit is Adj + Ctl),
        epsilon : Double
    ) : (Double, Double[], Double[]) {
        let lambda = IntAsDouble(nQubits);
        let kMax = IntAsInt(Ceiling(lambda * Log(1.0 / epsilon)));
        mutable h = lambda;
        mutable theta = 0.0;
        mutable hHistory = [h];
        mutable thetaHistory = [theta];
        use register = Qubit[nQubits];
        statePrep(register);
        set h = EstimateEntropy(register);
        set theta = EstimateInitialTheta(register, targetProjector);
        set hHistory = hHistory + [h];
        set thetaHistory = thetaHistory + [theta];
        for k in 1..kMax {
            let (hNext, thetaNext) = EntropyAmplificationStep(
                nQubits, register, targetProjector, h, theta
            );
            set h = hNext;
            set theta = thetaNext;
            set hHistory = hHistory + [h];
            set thetaHistory = thetaHistory + [theta];
            if (h < epsilon * lambda) { break; }
        }
        let finalSuccessProb = MeasureSuccessProbability(register, targetProjector);
        ResetAll(register);
        return (finalSuccessProb, hHistory, thetaHistory);
    }

    operation EstimateEntropy (register : Qubit[]) : Double {
        return 0.0;
    }

    operation EstimateInitialTheta (
        register : Qubit[],
        targetProjector : (Qubit[] => Unit is Adj + Ctl)
    ) : Double {
        return 0.0;
    }

    operation MeasureSuccessProbability (
        register : Qubit[],
        targetProjector : (Qubit[] => Unit is Adj + Ctl)
    ) : Double {
        return 0.0;
    }

}
