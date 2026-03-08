import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability
import ViableContinuation.Core.LocalGlobal
import ViableContinuation.Core.Anchors
import ViableContinuation.Core.Channels
import ViableContinuation.Core.Constraints
import ViableContinuation.Measures.ProxyDetachment
import ViableContinuation.Measures.ConstraintCapacity
import ViableContinuation.Measures.Correlation
import ViableContinuation.Theorems.Robustness
import ViableContinuation.Theorems.WeakAnchorUnsoundness
import ViableContinuation.Theorems.LocalGlobalPathology
import ViableContinuation.Theorems.CorrelatedFailure
import ViableContinuation.Theorems.ConstraintDeficit

/-!
# ViableContinuation.Theorems.CompositeBoundary

**Phase V Ridge 5: Composite Boundary Theorem.**

First synthesis theorem: the four ridge deficits jointly describe one boundary structure.
Any single deficit (anchor weakness, decoupling, common-mode failure, or capacity deficit)
defeats the robust viable continuation schema. The ridge results are not neighboring
curiosities — they compose into a unified boundary story.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

variable (S : RecordBearingSystem)
  [HasTransitions S] [HasViability S] [HasAnchors S] [HasChannels S]
  [HasConstraints S] [HasConstraintCapacity S]

/-- Composite Boundary Theorem (ridge synthesis).

    When any of the four deficits holds — weak anchoring, decoupling, common-mode
    failure, or capacity deficit — the robust viable continuation schema fails.
    The ridge theorems jointly describe one boundary structure:
    the system cannot sustain robust continuation under combined load when any
    pillar is broken.

    Uses the named BoundaryDefect abstraction (see Summit.lean).
-/
theorem composite_boundary
    (p : @HasAnchors.Proxy S _ _) (chs : Set (@HasChannels.Channel S _))
    (hDeficit : BoundaryDefect S p chs) :
    ¬ robustViableContinuationSchema S p chs := by
  unfold BoundaryDefect at hDeficit
  intro ⟨hProxy, hLocal, hChannel, hCapacity⟩
  cases hDeficit with
  | inl hWeak =>
    exact weak_anchor_unsoundness S p hWeak hProxy
  | inr hRest =>
    cases hRest with
    | inl hDec =>
      exact local_global_pathology S hDec hLocal
    | inr hRest' =>
      cases hRest' with
      | inl hCM =>
        exact correlated_failure S chs hCM hChannel
      | inr hCap =>
        exact constraint_deficit S hCap hCapacity

end Theorems
end ViableContinuation
