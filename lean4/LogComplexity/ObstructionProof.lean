-- File: LogComplexity/ObstructionProof.lean
-- Main Theorem: Log-Complexity Dichotomy

import LogComplexity.AttackGenerator
import Mathlib.Topology.Algebra.Order.ConditionallyCompleteLattice
import Mathlib.Analysis.SpecialFunctions.Pow.Real

theorem log_complexity_dichotomy {H : Type*} [InnerProductSpace ℂ H] [Fintype H]
    (P : NPProblem) (g : LogMetric H) :
    (LCAG_Generator P g).success = true ∨ (LCAG_Generator P g).obstruction.isSome = true := by
  by_cases h : ∃ (t : ℝ), t ≤ ((LogScaleParam H : ℝ) : ℝ) ^ 3 ∧ CurvatureSingularityAt t g
  · exact Or.inr (by simp [LCAG_Generator, h]; split_ifs <;> simp_all)
  · exact Or.inl (by simp [LCAG_Generator, h]; split_ifs <;> simp_all)

theorem bgs_circumvention {H : Type*} [InnerProductSpace ℂ H] [Fintype H]
    (g : LogMetric H) :
    g.non_linearity → ¬ (∃ (O : (H →L[ℂ] H) → (H →L[ℂ] H)), ∀ (A : H →L[ℂ] H), g.metric_at (O A) (O A) = g.metric_at A A) := by
  intro h_nonlin h_oracle
  obtain ⟨A, B, h_ne⟩ := h_nonlin
  have h₁ := h_oracle A
  have h₂ := h_oracle B
  have h₃ := h_oracle (A + B)
  contradiction
