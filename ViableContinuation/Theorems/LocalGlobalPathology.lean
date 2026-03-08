import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability
import ViableContinuation.Core.LocalGlobal
import ViableContinuation.Theorems.Robustness
import ViableContinuation.Theorems.DecouplingGeneratesPathology

/-!
# ViableContinuation.Theorems.LocalGlobalPathology

**Phase V Ridge 2: Local-to-Global Pathology Theorem.**

Strengthens the decoupling foothill: when decoupling holds, **local compatibility fails
as a guide to global viability**. Local admissibility cannot guarantee viable continuation.

This is the central dynamical theorem of the framework — the counterpart to Proxy Drift
on the epistemic side. Mirrors: proxy blindness → epistemic drift; local-global decoupling
→ dynamical pathology.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core

universe u

variable (S : RecordBearingSystem) [HasTransitions S] [HasViability S]

/-- Local-to-Global Pathology Theorem (ridge).

    When decoupling holds, local admissibility does not guarantee viable continuation.
    The local-global compatibility principle fails — locally admissible transitions
    can lead to pathology.

    Composes with decoupling_generates_pathology (which yields a concrete pathological
    path): this theorem states the principle-level failure.
-/
theorem local_global_pathology
    (hDec : LocalGlobalDecoupled S) :
    ¬ localAdmissibilityGuaranteesViableContinuation S := by
  unfold localAdmissibilityGuaranteesViableContinuation
  intro hCompat
  exact decoupling_implies_not_compatible S hCompat hDec

/-- Decoupling yields both principle failure and path witness. Combines the ridge
    theorem with the foothill: decoupling implies (a) local compatibility fails and
    (b) there exists a pathological path. -/
theorem local_global_pathology_with_witness
    (hDec : LocalGlobalDecoupled S) :
    ¬ localAdmissibilityGuaranteesViableContinuation S ∧
    ∃ π : List S.State, HasTransitions.Path S π ∧ ¬ trajectoryViable S π := by
  constructor
  · exact local_global_pathology S hDec
  · exact decoupling_generates_pathology S hDec

end Theorems
end ViableContinuation
