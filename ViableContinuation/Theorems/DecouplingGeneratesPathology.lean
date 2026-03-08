import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability
import ViableContinuation.Core.LocalGlobal

/-!
# ViableContinuation.Theorems.DecouplingGeneratesPathology

**Phase IV Foothill 3: Decoupling generates pathology theorem.**

Local-global decoupling yields a pathological reachable trajectory. When decoupling holds,
there exists a viable-to-pathological transition; therefore some locally available
continuation defeats trajectory viability.

This is the seed of cancer / market / politics / ecology / AGI pathology.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core

universe u

variable (S : RecordBearingSystem) [HasTransitions S] [HasViability S]

/-- Decoupling implies compatibility failure: when there exists a viable-to-pathological
    transition, local-global compatibility fails. -/
theorem decoupling_implies_not_compatible :
    LocalGlobalCompatible S → ¬ LocalGlobalDecoupled S := by
  intro hCompat ⟨s, s', hTrans, hVia, hPath⟩
  have hVia' := hCompat s s' hTrans hVia
  rw [HasViability.Pathology] at hPath
  exact hPath hVia'

/-- Decoupling yields a pathological trajectory: there exists a valid path that is
    not trajectory-viable (contains a pathological state). -/
theorem decoupling_generates_pathology
    (hDec : LocalGlobalDecoupled S) :
    ∃ π : List S.State, HasTransitions.Path S π ∧ ¬ trajectoryViable S π := by
  obtain ⟨s, s', hTrans, hVia, hPath⟩ := hDec
  use [s, s']
  constructor
  · unfold HasTransitions.Path
    exact ⟨hTrans, trivial⟩
  · intro hViaAll
    have hS' := hViaAll s' (by simp)
    rw [HasViability.Pathology] at hPath
    exact hPath hS'

end Theorems
end ViableContinuation
