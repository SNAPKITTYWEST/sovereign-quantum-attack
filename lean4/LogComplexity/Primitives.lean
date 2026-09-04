-- File: LogComplexity/Primitives.lean
-- Core mathematical primitives for Log-Unitary Complexity Theory

import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Complex.Basic
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.LinearAlgebra.Matrix.Exponential
import Mathlib.Analysis.SpecialFunctions.Log
import Mathlib.Analysis.NormedSpace.Basic

open Complex

def LogScaleParam {H : Type*} [Fintype H] [InnerProductSpace ℂ H] : ℝ :=
  Real.logb 2 (Fintype.card H : ℝ)

structure LogUnitaryGen (H : Type*) [InnerProductSpace ℂ H] [Fintype H] where
  val : H →L[ℂ] H
  is_skew_hermitian : val† = -val

structure TPMap (H : Type*) [InnerProductSpace ℂ H] [Fintype H] where
  kraus_ops : Finset (H →L[ℂ] H)
  completeness : (∑ i in kraus_ops, i† * i) = 1

structure LogMetric (H : Type*) [InnerProductSpace ℂ H] [Fintype H] where
  metric_at : (H →L[ℂ] H) → (H →L[ℂ] H) → ℝ
  positivity : ∀ (A : H →L[ℂ] H), 0 ≤ metric_at A A
  non_linearity : ∃ (A B : H →L[ℂ] H), metric_at (A + B) (A + B) ≠ metric_at A A + metric_at B B
