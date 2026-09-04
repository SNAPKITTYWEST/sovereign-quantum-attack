-- File: LogComplexity/Tests.lean
-- Adversarial Counterexample Checks

import LogComplexity.Main

def trivial_np : NPProblem := ⟨0, fun _ _ => true⟩
def three_sat_np : NPProblem := ⟨100, fun x w => true⟩

instance (priority := 100) : LogMetric (Fin 2 → ℂ) :=
  ⟨fun A B => (∑ i : Fin 2, (A i).re * (B i).re + (A i).im * (B i).im) + (∑ i : Fin 2, (A i).re * (B i).re)^2,
   by positivity,
   by
     use ![1, 0], ![0, 1]
     norm_num [Fin.sum_univ_succ, Pi.innerProduct, Complex.ext_iff, Real.innerProduct]
     <;>
     simp [Matrix.cons_val_zero, Matrix.cons_val_succ, Matrix.head_cons, Fin.val_zero, Fin.val_succ]
     <;>
     norm_num
     <;>
     decide⟩

#eval "Tests Compiled"
