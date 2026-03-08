import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Viability

/-!
# ViableContinuation.Measures.TraceCapacity

**Phase III: Trace floor / trace sufficiency.**

Sharp enough to support: ¬TraceSufficient s ⇒ diachronic correction failure.

Trace sufficiency = records at s enable discriminating viability (same records ⇒ same viability).
Diachronic correction failure = ∃ record-indistinguishable, viability-distinct states.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Measures

open ViableContinuation.Core

universe u v

variable {S : RecordBearingSystem} [HasViability S]

/-- Record-indistinguishable: s and s' have exactly the same records. -/
def recordIndistinguishable (s s' : S.State) : Prop :=
  ∀ r : S.Record, S.recordAt s r ↔ S.recordAt s' r

/-- Trace sufficient at s: records at s determine viability.
    Same records ⇒ same viability. Enables diachronic correction. -/
def TraceSufficient (s : S.State) : Prop :=
  ∀ s', recordIndistinguishable s s' → (HasViability.Viable s ↔ HasViability.Viable s')

/-- Trace floor: hasTraceFloor s means TraceSufficient s. -/
def hasTraceFloor (s : S.State) : Prop :=
  TraceSufficient s

/-- Diachronic correction failure at s: there exist record-indistinguishable states
    with different viability. The system cannot correct using records alone. -/
def diachronicCorrectionFails (s : S.State) : Prop :=
  ∃ s', recordIndistinguishable s s' ∧ (HasViability.Viable s ↔ ¬ HasViability.Viable s')

/-!
## Lemma: trace floor theorem (foothill target)

Below trace sufficiency, diachronic correction fails.
-/
theorem not_trace_sufficient_implies_diachronic_correction_fails (s : S.State) :
    ¬ TraceSufficient s → diachronicCorrectionFails s := by
  unfold TraceSufficient diachronicCorrectionFails
  intro h
  by_contra hNot
  push_neg at hNot
  apply h
  intro s' hIndist
  by_contra hDiff
  have hCases := hNot s' hIndist
  cases' hCases with hLeft hRight
  · exact absurd ⟨fun _ => hLeft.2, fun _ => hLeft.1⟩ hDiff
  · exact absurd ⟨fun h => absurd h hRight.1, fun h => absurd h hRight.2⟩ hDiff

theorem diachronic_correction_fails_implies_not_trace_sufficient (s : S.State) :
    diachronicCorrectionFails s → ¬ TraceSufficient s := by
  intro ⟨s', hIndist, hDiff⟩ hSuff
  specialize hSuff s' hIndist
  rw [hDiff] at hSuff
  tauto

theorem not_hasTraceFloor_implies_diachronic_correction_fails (s : S.State) :
    ¬ hasTraceFloor s → diachronicCorrectionFails s :=
  not_trace_sufficient_implies_diachronic_correction_fails s

end Measures
end ViableContinuation
